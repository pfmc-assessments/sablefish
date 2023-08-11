
#' Bridging
#' to do:
#' * maybe move these user_ objects to package objects

###############################################################################
# User input is needed here, also change in assessment/00a.Rmd
###############################################################################
user_model_bridged <- fs::path("models", "2021", "base", "base")
user_model_current <- fs::path("models", "2023", "DiscardVariance", "base")
# End year of the data that you want included in the model
user_end_year <- 2022
# Number of parallel sessions you want for diagnostics
n_workers <- 3

diagnostic_settings <- nwfscDiag::get_settings(
  settings = list(
    oldctlfile = "control.ss_new",
    base_name = basename(user_model_current),
    run = c("jitter", "profile", "retro"),
    profile_details = tibble::tribble(
      ~parameters,             ~low,  ~high, ~step_size,~param_space,
      "NatM_uniform_Fem_GP_1",  0.05,  0.09,  0.005,     "real",
      "NatM_uniform_Mal_GP_1",  0.05,  0.09,  0.005,     "real",
               "SR_BH_steep",   0.25,  1.00,  0.075,     "real",
                 "SR_LN(R0)",   9.00, 11.00,  0.20,      "real",
    ),
    prior_like = 1,
    verbose = FALSE,
    exe = "ss3",
    show_in_console = FALSE
  )
)

###############################################################################
# Work with the directories
###############################################################################
stopifnot(basename(here::here()) == "sablefish")
model_dir <- fs::path(here::here(), user_model_current)
bridging_dir <- fs::path(here::here(), dirname(user_model_current), "bridging")
sensitivity_dir <- fs::path(
  here::here(),
  dirname(user_model_current),
  "sensitivities"
)
data_dir <- fs::path(here::here(), "data-processed")
fs::dir_create(model_dir)
fs::dir_create(bridging_dir)
fs::dir_create(sensitivity_dir)
model_ss3_path <- r4ss::get_ss3_exe(dir = model_dir)
# model_ss3_path <- fs::path(dir = model_dir, "ss3")

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

###############################################################################
# Fix the poorly informed selectivity parameters
###############################################################################
bridge_output <- bridge_fix_parameters(
  inputs = bridge_output,
  dir_out = fs::path(bridging_dir, "13_FixRetention")
)

###############################################################################
# Decrease the input standard deviation for discard rates
###############################################################################
bridge_output[["dat"]][["discard_data"]] <- bridge_output[["dat"]][[
  "discard_data"]] |>
  dplyr::mutate(
    Std_in = ifelse(
      test = (Flt == 2 & Yr %in% utils::read.csv(
    fs::path(data_dir, "data_commercial_discard_rates.csv")
  )[["year"]]),
      0.05,
      Std_in
  )
)
r4ss::SS_write(
  bridge_output,
  fs::path(bridging_dir, "14_LowerInputSdDiscardRates"),
  overwrite = TRUE
)
bridge_output <- tune(
  dir_in = fs::path(bridging_dir, "14_LowerInputSdDiscardRates"),
  dir_out = model_dir,
  steps = 1:3,
  hessian = FALSE,
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
# Summarize the output from bridging
###############################################################################
# Split bridging into groups
bridging_groups <- purrr::map(
  c(
    "previous|catch",
    "previous|survey|sex|condi|comp|env",
    "\\sbase$|discard|Retention"
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
ignore <- purrr::pmap(
  .l = list(
    models = bridging_groups,
    filenameprefix = paste0(seq_along(bridging_groups), "-"),
    legendlabels = purrr::map(
      .x = bridging_groups,
      .f = \(x) report_model_names(names(model_paths_bridging))[x]
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

###############################################################################
# Run diagnostics
###############################################################################
helper_run_diagnostics <- function(type, settings, dir) {
  settings[["run"]] <- type
  nwfscDiag::run_diagnostics(
    mydir = dir,
    model_settings = settings
  )
}
future::plan(future::multisession, workers = n_workers)
furrr::future_map(
  .x = c("jitter", "profile", "retro"),
  .f = helper_run_diagnostics,
  settings = diagnostic_settings,
  dir = fs::path(here::here(), dirname(user_model_current))
)

##############################################################################
# Sensitivities
###############################################################################

# Turn on added variance for WCGBTS
model_inputs <- r4ss::copy_SS_inputs(
  dir.old = fs::path(here::here(), user_model_current),
  dir.new = fs::path(sensitivity_dir, "TurnOnAddedVarianceForRecentSurvey"),
  overwrite = TRUE,
  verbose = FALSE
)
r4ss::SS_changepars(
  dir = fs::path(sensitivity_dir, "TurnOnAddedVarianceForRecentSurvey"),
  newctlfile = "control.ss",
  ctlfile = "control.ss",
  strings = "Q_extraSD_NWCBO(7)",
  newvals = 0.05,
  estimate = TRUE,
  verbose = FALSE
)

# Use marginal instead of CAAL for WCGBTS
ignore <- r4ss::copy_SS_inputs(
  dir.old = fs::path(here::here(), user_model_current),
  dir.new = fs::path(sensitivity_dir, "UseMarginalAges"),
  overwrite = TRUE,
  verbose = FALSE
)
model_inputs <- r4ss::SS_read(fs::path(sensitivity_dir, "UseMarginalAges"))
model_inputs[["dat"]][["agecomp"]] <- model_inputs[["dat"]][["agecomp"]] |> 
  dplyr::mutate(
    FltSvy = ifelse(Lbin_lo == -1, abs(FltSvy), -1 * FltSvy)
  ) |>
  dplyr::filter(
    Lbin_lo == -1
  )
r4ss::SS_write(
  model_inputs,
  dir = fs::path(sensitivity_dir, "UseMarginalAges"),
  overwrite = TRUE
)
r4ss::tune_comps(
  replist = NULL,
  fleets = "all",
  option = "Francis",
  digits = 6,
  write = TRUE,
  niters_tuning = 1,
  init_run = TRUE,
  dir = fs::path(sensitivity_dir, "UseMarginalAges"),
  exe = model_ss3_path,
  verbose = FALSE
)

# Use Bayesian method for environmental index
data_env_index_bayesian <- read.csv(
  fs::path(
    here::here(),
    "data-raw",
    "Sea-level-index-5-trendDFA-DF1.csv"
  )
) |>
  dplyr::mutate(
    inverse_index = -1 * sl_mean_index,
    # This se calculation is hand-wavy and was not previously used in 2021
    # Nick doesn't know how to export the SE from the Bayesian analysis
    # but it was available in 2021
    se_calc = (cl95_upp - cl95_low) / (1.92 * 2)
  ) |>
  calc_env(index = "inverse_index", se = "se_calc") |>
  dplyr::mutate(seas = 5, index = 3, .after = "year")

bridge_update_data(
  inputs = r4ss::SS_read(
    dir = fs::path(here::here(), user_model_current),
    verbose = FALSE
  ),
  x = data_env_index_bayesian,
  dir_out = fs::path(sensitivity_dir, "BayesianIndex"),
  matched = NULL,
  type = "CPUE",
  vars_by = c("year", "index"),
  vars_arrange = c("index", "year", "seas")
)

# Non-centered recruitment deviations
model_inputs <- r4ss::SS_read(fs::path(here::here(), user_model_current))
model_inputs[["ctl"]][["do_recdev"]] <- 2
r4ss::SS_write(
  inputlist = model_inputs,
  dir = fs::path(sensitivity_dir, "NonCenteredRecruitmentDeviations"),
  overwrite = TRUE
)

# Fix all parameters with high estimates of uncertainty
ignore <- r4ss::copy_SS_inputs(
  use_ss_new = TRUE,
  dir.old = fs::path(here::here(), user_model_current),
  dir.new = fs::path(sensitivity_dir, "FixParametersWithHighVariance"),
  overwrite = TRUE,
  verbose = FALSE
)
strings <- r4ss::SS_output(
    fs::path(here::here(), user_model_current),
    verbose = FALSE,
    printstats = FALSE
  )[["parameters"]] |>
    dplyr::filter(Parm_StDev > 100) |>
    dplyr::pull(Label)
r4ss::SS_changepars(
  dir = fs::path(sensitivity_dir, "FixParametersWithHighVariance"),
  ctlfile = "control.ss",
  newctlfile = "control.ss",
  estimate = rep(FALSE, length(strings)),
  strings = strings,
  verbose = FALSE
)

# Free up the fixed retention and selectivity parameters from bridging
model_inputs <- r4ss::copy_SS_inputs(
  dir.old = fs::path(here::here(), user_model_current),
  dir.new = fs::path(sensitivity_dir, "EstimateParametersFixedInBridging"),
  overwrite = TRUE,
  verbose = FALSE
)
r4ss::SS_changepars(
  ctlfile = "control.ss",
  dir = fs::path(sensitivity_dir, "EstimateParametersFixedInBridging"),
  newctlfile = "control.ss",
  estimate = rep(TRUE, 2),
  strings = c(
    "AgeSel_P_4_TWL(2)_BLK5repl_2011",
    "SizeSel_PRet_1_FIX(1)_BLK2repl_2019"
  )
)

# Fix M selectivity parameters for relative difference between Females and
# Males at young age, P2
model_inputs <- r4ss::copy_SS_inputs(
  dir.old = fs::path(here::here(), user_model_current),
  dir.new = fs::path(sensitivity_dir, "FixMaleP2Parameters"),
  overwrite = TRUE,
  verbose = FALSE
)
r4ss::SS_changepars(
  ctlfile = "control.ss",
  dir = fs::path(sensitivity_dir, "FixMaleP2Parameters"),
  newctlfile = "shit.ss",
  estimate = rep(FALSE, 2),
  newvals = rep(0, 2),
  strings = c(
    "AgeSel_PMale_2_FIX(1)",
    "AgeSel_PMale_2_AKSHLF(4)"
  )
)

# Data weighting using harmonic-mean approach
bridge_output <- tune(
  dir_in = fs::path(here::here(), user_model_current),
  dir_out = fs::path(sensitivity_dir, "TuneWithHarmonicMean"),
  steps = 1,
  type = "MI",
  executable = model_ss3_path
)

# Turn on added variance for WCGBTS
model_inputs <- r4ss::copy_SS_inputs(
  dir.old = fs::path(here::here(), user_model_current),
  dir.new = fs::path(sensitivity_dir, "SingleNaturalMortality"),
  use_ss_new = TRUE,
  overwrite = TRUE,
  verbose = FALSE
)
r4ss::SS_changepars(
  dir = fs::path(sensitivity_dir, "SingleNaturalMortality"),
  newctlfile = "control.ss",
  ctlfile = "control.ss",
  strings = "NatM_uniform_Mal_GP_1",
  newvals = 0,
  newlos = 0,
  estimate = FALSE,
  verbose = FALSE
)

# asymptotic selectivity for 
model_inputs <- r4ss::copy_SS_inputs(
  dir.old = fs::path(here::here(), user_model_current),
  dir.new = fs::path(sensitivity_dir, "AsymptoticSelectivityForRecentSurvey"),
  overwrite = TRUE,
  verbose = FALSE,
  use_ss_new = TRUE
)
r4ss::SS_changepars(
  dir = fs::path(sensitivity_dir, "AsymptoticSelectivityForRecentSurvey"),
  ctlfile = "control.ss",
  newctlfile = "control.ss",
  strings = c(
    "Age_DblN_peak_NWCBO(7)",
    "Age_DblN_top_logit_NWCBO(7)",
    "Age_DblN_ascend_se_NWCBO(7)",
    "Age_DblN_descend_se_NWCBO(7)",
    "Age_DblN_start_logit_NWCBO(7)",
    "Age_DblN_end_logit_NWCBO(7)"
  ),
  newlos = c(0.01, -20, -20, -10, -5, -5),
  newvals = c(0.0805035, -4, -8.44983, 3.59814, -4, 4.99),
  newhis = c(5, 5, 10, 10, 5, 5),
  newphs = c(4, -4, 4, 4, -4, -4)
)

###############################################################################
# Run the sensitivities in parallel
###############################################################################
model_paths_sensitivity <- c(
  "Current Base" = fs::path(here::here(), user_model_current),
  fs::dir_ls(sensitivity_dir, type = "dir")
)
# Run all the models that have not previously been ran
furrr::future_map(
  model_paths_sensitivity,
  .f = r4ss::run,
  exe = model_ss3_path,
  extras = "-nohess",
  skipfinished = TRUE,
  verbose = FALSE
)

###############################################################################
# Summarize the output from sensitivities
###############################################################################
# Split bridging into groups
# to do: make this a model object so it is available in the assessment
sensitivity_groups <- purrr::map(
  c(
    "\\sbase$|index|estimate|parameter",
    "\\sbase$|recruitment|added",
    "\\sbase$|mortality|marginal|tune|asymp"
  ),
  .f = \(x) grep(
    pattern = x,
    x = names(model_paths_sensitivity),
    ignore.case = TRUE
  )
)
stopifnot(
  length(unique(unlist(sensitivity_groups))) ==
  length(model_paths_sensitivity)
)
sensitivity_summary <- r4ss::SSsummarize(
  biglist = purrr::map(
    model_paths_sensitivity,
    .f = \(x) r4ss::SS_output(
      x,
      verbose = FALSE,
      printstats = FALSE,
      wtfile = FALSE
    )
  ),
  verbose = FALSE
)
data <- r4ss::SStableComparisons(
  sensitivity_summary,
  modelnames = report_model_names(sensitivity_summary[["modelnames"]]),
  # go to R/utils-local to edit these variables
  names = report_parameter_names(sensitivity_summary[["endyrs"]][1] + 1),
  likenames = report_likelihood_names(),
  verbose = FALSE,
  csv = TRUE,
  csvdir = sensitivity_dir,
  csvfile = "sensitivity_table.csv"
)
ignore <- purrr::pmap(
  .l = list(
    models = sensitivity_groups,
    filenameprefix = paste0(seq_along(sensitivity_groups), "-"),
    legendlabels = purrr::map(
      .x = sensitivity_groups,
      .f = \(x) report_model_names(model_paths_sensitivity)[x]
    )
  ),
  .f = r4ss::SSplotComparisons,
  summaryoutput = sensitivity_summary,
  plotdir = sensitivity_dir,
  print = TRUE,
  plot = FALSE,
  png = TRUE,
  uncertainty = 1,
  subplots = c(2, 4, 5, 7, 9, 11, 13, 14),
  legendloc = "topleft"
)

###############################################################################
# Close all the connections
###############################################################################

future::plan(future::sequential)
