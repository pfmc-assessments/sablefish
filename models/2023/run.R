
#' Bridging
#' to do:
#' * maybe move these user_ objects to package objects

###############################################################################
# User input is needed here
###############################################################################
user_model_bridged <- fs::path("models", "2021", "base", "base")
user_model_current <- fs::path("models", "2023", "base", "base")
# End year of the data that you want included in the model
user_end_year <- 2022

###############################################################################
# Work with the directories
###############################################################################
stopifnot(basename(here::here()) == "sablefish")
model_dir <- fs::path(here::here(), user_model_current)
bridging_dir <- fs::path(here::here(), dirname(user_model_current), "bridging")
data_dir <- fs::path(here::here(), "data-processed")
fs::dir_create(model_dir)
fs::dir_create(bridging_dir)
model_ss3_path <- r4ss::get_ss3_exe(dir = model_dir)

###############################################################################
# Clean up the model files
###############################################################################
bridge_output <- bridge_remove_fleet(
  inputs = r4ss::SS_read(fs::path(here::here(), user_model_bridged)),
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
  exe = model_ss3_path,
  skipfinished = FALSE,
  extras = "-nohess",
  verbose = FALSE
)
stopifnot(check == "ran model")

###############################################################################
# Change catch data
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
    file = fs::path(data_dir, "data_commercial_catch.csv")
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
    file = fs::path(data_dir, "data_commercial_catch.csv")
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
  dir_out = fs::path(bridging_dir, "03_NewCatches")
)

###############################################################################
# Change survey index data
###############################################################################
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    file = fs::path(data_dir, "data_survey_index.csv")
  ) |>
    dplyr::filter(area == "coastwide") |>
    dplyr::select(year, obs = est, se_log = se) |>
    dplyr::mutate(seas = 7, index = 7, .after = "year"),
  dir_out = fs::path(bridging_dir, "04_RecentSurveyIndex"),
  matched = NULL,
  type = "CPUE",
  vars_by = c("year", "index"),
  vars_arrange = c("index", "year", "seas")
)

###############################################################################
# Change composition data
###############################################################################
recent_composition <- utils::read.csv(
  file = fs::path(data_dir, "wcgbt_length_composition.csv"),
  colClasses = "numeric"
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = recent_composition,
  dir_out = fs::path(bridging_dir, "05_UnsexedLengthsAsUnsexed"),
  matched = TRUE
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = recent_composition,
  dir_out = fs::path(bridging_dir, "06_RecentSurveyLengths"),
  matched = FALSE
)

bridge_output <- bridge_update_data(
  inputs = bridge_output,
  # CAAL and marginal ages for wcgbt
  x = bind_compositions(list(
    utils::read.csv(
      file = fs::path(data_dir, "wcgbt_caal.csv"),
      colClasses = "numeric"
    ),
    utils::read.csv(
      file = fs::path(data_dir, "wcgbt_age_composition.csv")
    ) |>
      dplyr::mutate(fleet = -1 * fleet)
  )),
  dir_out = fs::path(bridging_dir, "07_RecentSurveyConditionals"),
  matched = NULL,
  type = "agecomp",
  vars_by = c("Yr", "Seas", "FltSvy", "Part", "Lbin_lo", "Lbin_hi"),
  vars_arrange = c(
    eval(formals(bridge_update_data)$vars_arrange),
    "Lbin_lo", "Lbin_hi"
  )
)
bridge_output <- tune(
  dir_in = fs::path(bridging_dir, "07_RecentSurveyConditionals"),
  dir_out = fs::path(bridging_dir, "08_TuneWithCompositionData"),
  steps = 1:3,
  executable = model_ss3_path
)

###############################################################################
# Change environmental index data
###############################################################################
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    file = fs::path(data_dir, "data_env_index.csv")
  ),
  dir_out = fs::path(bridging_dir, "09_EnvIndex"),
  matched = NULL,
  type = "CPUE",
  vars_by = c("year", "index"),
  # It would be nice to use evaluation to allow
  # c(abs(index), year, seas) but there is not time to figure it out
  vars_arrange = c("index", "year", "seas")
)

###############################################################################
# Change discard data
###############################################################################
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    fs::path(data_dir, "data_commercial_discard_composition.csv")
  ),
  dir_out = fs::path(bridging_dir, "10_DiscardLengths"),
  matched = NULL,
  type = "lencomp",
  vars_by = c("Yr", "FltSvy", "Part")
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    fs::path(data_dir, "data_commercial_discard_weight.csv")
  ),
  dir_out = fs::path(bridging_dir, "11_DiscardWeights"),
  matched = NULL,
  type = "meanbodywt",
  vars_by = c("Year", "Fleet", "Partition", "Type"),
  vars_arrange = c("Fleet", "Type", "Partition", "Year", "Seas")
)
bridge_output <- bridge_update_data(
  inputs = bridge_output,
  x = utils::read.csv(
    fs::path(data_dir, "data_commercial_discard_rates.csv")
  ),
  dir_out = fs::path(bridging_dir, "12_DiscardRates"),
  matched = NULL,
  type = "discard_data",
  vars_by = c("Yr", "Flt"),
  vars_arrange = c("Flt", "Yr", "Seas")
)

bridge_output <- tune(
  dir_in = fs::path(bridging_dir, "12_DiscardRates"),
  dir_out = fs::path(bridging_dir, "13_TuneDiscards"),
  steps = 1:2,
  executable = model_ss3_path
)

###############################################################################
# Fix the poorly informed selectivity parameters
###############################################################################
bridge_output <- bridge_fix_parameters(
  inputs = bridge_output,
  dir_out = fs::path(bridging_dir, "14_FixRetention")
)
bridge_output <- tune(
  dir_in = fs::path(bridging_dir, "14_FixRetention"),
  dir_out = model_dir,
  steps = 1:3,
  executable = model_ss3_path
)
bridge_output <- tune(
  dir_in = model_dir,
  dir_out = model_dir,
  steps = 1,
  iterations = 1,
  executable = model_ss3_path,
  use_new = TRUE
)

###############################################################################
# Run the bridging models from base to base
###############################################################################
model_paths_bridging <- c(
  "Previous Base" = fs::path(here::here(), user_model_bridged),
  fs::dir_ls(bridging_dir, type = "dir", pattern = "^[0-9]"),
  "Current Base" = model_dir
)
# Run all the models that have not previously been ran, where some models
# needed the hessian to move onto the next step so we will just leave those
# as is.
purrr::map(
  model_paths_bridging,
  .f = r4ss::run,
  exe = model_ss3_path,
  extras = "-nohess",
  skipfinished = TRUE,
  verbose = FALSE
)

###############################################################################
# Summarize the output
###############################################################################
# Split bridging into groups
bridging_groups <- purrr::map(
  c(
    "previous|catch",
    "previous|survey|sex|condi|comp|env",
    "base$|discard|fix"
  ),
  .f = \(x) grep(
    pattern = x,
    x = names(model_paths_bridging),
    ignore.case = TRUE
  )
)
bridge_summary <- r4ss::SSsummarize(
  biglist = purrr::map(
    model_paths_bridging,
    .f = \(x) r4ss::SS_output(
      x,
      verbose = FALSE,
      printstats = FALSE,
      wtfile = FALSE
    )
  ),
  verbose = FALSE
)
xx <- function(y) {
  gsub(
    "_",
    "",
    ifelse(grepl(" ", y), y, gsub("([A-Z])", " \\1", basename(y)))
  )
}
ignore <- purrr::pmap(
  .l = list(
    models = bridging_groups,
    filenameprefix = paste0(seq_along(bridging_groups), "-"),
    legendlabels = purrr::map(
      .x = bridging_groups,
      .f = \(x) gsub(
        "_",
        "",
        ifelse(
          test = grepl(" ", names(model_paths_bridging)[x]),
          yes = names(model_paths_bridging)[x],
          no = gsub("(A-Z])", " \\1", basename(names(model_paths_bridging)[x]))
        )
      )
    )
  ),
  .f = r4ss::SSplotComparisons,
  summaryoutput = bridge_summary,
  plotdir = bridging_dir,
  print = TRUE,
  plot = FALSE,
  png = TRUE,
  subplots = c(1, 3, 5, 7, 9, 11, 13, 14),
  legendloc = "bottomleft"
)
