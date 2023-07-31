
#' Bridging
#' to do:
#' * maybe move these user_ objects to package objects
user_model_bridged <- fs::path("models", "2021", "base", "base")
user_model_current <- fs::path("models", "2023", "base", "base")
user_end_year <- 2022

bridging_dir <- fs::path(dirname(user_model_current), "bridging")
fs::dir_create(user_model_current)
fs::dir_create(bridging_dir)
model_ss3_path <- r4ss::get_ss3_exe(dir = user_model_current)

###############################################################################
# Clean up the model files
###############################################################################
bridge_output <- bridge_remove_fleet(
  inputs = r4ss::SS_read(user_model_bridged),
  fleet_number = 2,
  dir_out = NULL
)
bridge_output <- bridge_remove_early_catch(
  inputs = bridge_output,
  dir_out = NULL
)
bridge_output <- bridge_fix_starter(
  inputs = bridge_output,
  dir_out = fs::path(bridging_dir, "00_CleanUpModelFiles")
)
# Run the model without estimation to get the new names
check <- r4ss::run(
  dir = fs::path(bridging_dir, "00_CleanUpModelFiles"),
  exe = fs::path(here::here(), model_ss3_path),
  skipfinished = FALSE,
  extras = "-nohess",
  verbose = FALSE
)
stopifnot(check == "ran model")

###############################################################################
# Change data
###############################################################################
bridge_output <- r4ss::SS_read(
    fs::path(bridging_dir, "00_CleanUpModelFiles"),
    ss_new = TRUE
  )
bridge_output <- bridge_update_data(
  # Read in .ss_new files because of updated fleet names
  inputs = bridge_output,
  # Add at-sea catches to old catches
  x = bridge_output[["dat"]][["catch"]] |>
    dplyr::filter(fleet == 2) |>
    dplyr::left_join(
      y = data_commercial_catch |>
        dplyr::filter(AGENCY_CODE == "at-sea"),
      by = c("year")
    ) |>
    dplyr::rowwise() |>
    dplyr::mutate(
      catch_mt = ifelse(is.na(catch_mt), 0, catch_mt),
      catch = sum(catch + catch_mt, na.rm = TRUE),
      catch_se = catch_se,
      .after = "fleet"
    ) |>
    dplyr::select(colnames(bridge_output[["dat"]][["catch"]])) |>
    as.data.frame(),
  dir_out = fs::path(bridging_dir, "01_IncludeAt-seaCatches"),
  type = "catch",
  matched = TRUE,
  vars_by = c("year", "seas", "fleet"),
  vars_arrange = c("fleet", "year", "seas")
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    file = fs::path("data-processed", "data_commercial_catch.csv")
  ),
  dir_out = fs::path(bridging_dir, "02_UpdateCatches"),
  type = "catch",
  matched = TRUE,
  vars_by = c("year", "seas", "fleet"),
  vars_arrange = c("fleet", "year", "seas")
)
bridge_output <- bridge_end_year(
  inputs = bridge_output,
  catch = utils::read.csv(
    file = fs::path("data-processed", "data_commercial_catch.csv")
  ) |>
    dplyr::filter(year <= user_end_year),
  forecast_catch = data.frame(
    Year = rep(c(2023, 2024), times = 2),
    Seas = 1,
    Fleet = rep(1:2, each = 2),
    Catch = c(
      6369, 5838,
      2749, 2521
    )
  ),
  dir_out = fs::path(bridging_dir, "03_IncludeRecentCatches")
)

bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    file = fs::path("data-processed", "data_survey_index.csv")
  ) |>
    dplyr::filter(area == "coastwide") |>
    dplyr::select(year, obs = est, se_log = se) |>
    dplyr::mutate(seas = 7, index = 7, .after = "year"),
  dir_out = fs::path(bridging_dir, "04_UpdateIndex"),
  matched = NULL,
  type = "CPUE",
  vars_by = c("year", "index"),
  vars_arrange = c("index", "year", "seas")
)
recent_composition <- utils::read.csv(
  file = fs::path("data-processed", "wcgbt_length_composition.csv"),
  colClasses = "numeric"
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = recent_composition,
  dir_out = fs::path(bridging_dir, "05_UnsexedAsUnsexed"),
  matched = TRUE
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = recent_composition,
  dir_out = fs::path(bridging_dir, "06_IncludeRecentSurveyLengths"),
  matched = FALSE
)

bridge_output <- bridge_update_data(
  inputs = bridge_output,
  # CAAL and marginal ages for wcgbt
  x = bind_compositions(list(
    utils::read.csv(
      file = fs::path("data-processed", "wcgbt_caal.csv"),
      colClasses = "numeric"
    ),
    utils::read.csv(
      file = fs::path("data-processed", "wcgbt_age_composition.csv")
    ) |>
      dplyr::mutate(fleet = -1 * fleet)
  )),
  dir_out = fs::path(bridging_dir, "07_IncludeRecentConditionals"),
  matched = NULL,
  type = "agecomp",
  vars_by = c("Yr", "Seas", "FltSvy", "Part", "Lbin_lo", "Lbin_hi"),
  vars_arrange = c(
    eval(formals(bridge_update_data)$vars_arrange),
    "Lbin_lo", "Lbin_hi"
  )
)
bridge_output <- tune(
  dir_in = fs::path(bridging_dir, "07_IncludeRecentConditionals"),
  dir_out = fs::path(bridging_dir, "08_TuneWithCompositionData"),
  steps = 1:2,
  executable = fs::path(here::here(), model_ss3_path)
)

bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    file = fs::path("data-processed", "data_env_index.csv")
  ),
  dir_out = fs::path(bridging_dir, "09_UpdateEnv"),
  matched = NULL,
  type = "CPUE",
  vars_by = c("year", "index"),
  # It would be nice to use evaluation to allow
  # c(abs(index), year, seas) but there is not time to figure it out
  vars_arrange = c("index", "year", "seas")
)

bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    fs::path("data-processed", "data_commercial_discard_composition.csv")
  ),
  dir_out = fs::path(bridging_dir, "10_UpdateDiscardLengths"),
  matched = NULL,
  type = "lencomp",
  vars_by = c("Yr", "FltSvy", "Part")
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    fs::path("data-processed", "data_commercial_discard_weight.csv")
  ),
  dir_out = fs::path(bridging_dir, "11_UpdateDiscardWeights"),
  matched = NULL,
  type = "meanbodywt",
  vars_by = c("Year", "Fleet", "Partition", "Type"),
  vars_arrange = c("Fleet", "Type", "Partition", "Year", "Seas")
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    fs::path("data-processed", "data_commercial_discard_rates.csv")
  ),
  dir_out = fs::path(bridging_dir, "12_UpdateDiscardRates"),
  matched = NULL,
  type = "discard_data",
  vars_by = c("Yr", "Flt"),
  vars_arrange = c("Flt", "Yr", "Seas")
)

bridge_output <- tune(
  dir_in = fs::path(bridging_dir, "12_UpdateDiscardRates"),
  dir_out = fs::path(bridging_dir, "13_FinalTune"),
  steps = 1:2,
 fs::path(here::here(), model_ss3_path)
)

###############################################################################
# Run the models
###############################################################################
model_paths_bridging <- c(
  user_model_bridged,
  fs::dir_ls(fs::path(bridging_dir), type = "dir")
)
purrr::map(
  model_paths_bridging[-c(1)],
  .f = r4ss::run,
  exe = fs::path(here::here(), model_ss3_path),
  extras = "-nohess",
  skipfinished = TRUE,
  # skipfinished = FALSE,
  verbose = FALSE
)
big_list <- purrr::map(
  model_paths_bridging,
  r4ss::SS_output,
  verbose = FALSE,
  printstats = FALSE,
  wtfile = NULL
)
big_summarize <- r4ss::SSsummarize(big_list, verbose = FALSE)
r4ss::SSplotComparisons(
  big_summarize,
  plotdir = bridging_dir,
  print = FALSE,
  png = TRUE,
  # xlim = c(2015, 2023),
  legendlabels = gsub("_", "", gsub("([A-Z])", " \\1", basename(model_paths_bridging)))
)
