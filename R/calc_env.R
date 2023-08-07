#' Calculate input values for Stock Synthesis from a Dynamic Factor Analysis
#'
#' @param x A data frame, often provided by Nick Tolimieri.
#' @param index A string specifying the column name for the variable of
#'   interest.
#' @param se A string specifying the column name for the standard error.
#' @param sigma_r A real number specifying the variability around recruitment
#'   deviations used in the Stock Synthesis model. This was 1.0 in 2019 and
#'   2021 for sablefish even though the input value for the stock assessment
#'   was 1.4 because Melissa Haltuch decided that the index was independent
#'   from the input value of recruitment deviations used in the assessment and
#'   that the values should not be corrected by it. Especially given the fact
#'   that recruitment variability might be tuned and thus end up being a
#'   different value than what was used to create the input data. Thus, the
#'   default is 1.0, which leads to no correction.
#' @return
#' A data frame with three columns, year, obs, se_log.
#' @examples
#' \dontrun{
#' calc_env(read.csv(
#'   fs::path(
#'     here::here(),
#'     "data-raw",
#'     "MARSS_SSH_DFA_DF1_Index_4Kelli-SablefishAssessment.csv"
#'   )
#' ), "index", "SE") |> head()
#' calc_env(read.csv(
#'   fs::path(
#'     here::here(),
#'     "data-raw",
#'     "Dynamic_Factors_and_SE_1925-2020_VariMaxRotated.csv"
#'   )
#' ), "DF1", "DF1SE") |> head()
#' calc_env(read.csv(
#'   fs::path(
#'     here::here(),
#'     "data-raw",
#'     "SSH_Index_Bayes_DF1_1925-2020.csv"
#'   )
#' ) |> dplyr::mutate(year = 1925:2020),
#'   "DF1_mean",
#'   "u.SE"
#' ) |> head()
#' calc_env(read.csv(
#'   fs::path(
#'     here::here(),
#'     "data-raw",
#'     "ROTATED_DYNAMIC_FACTORS_Q2_SSH_working_2019.csv"
#'   )
#' ), "DF1", "DF1SE") |> head()
#' }
calc_env <- function(x, index, se, sigma_r = 1.0) {
  year_column <- grep("y[ea]*r", colnames(x), ignore.case = TRUE, value = TRUE)
  x |>
    dplyr::rename(year = year_column, index = index, se = se) |>
    dplyr::mutate(
      ts_average = mean(index),
      ts_sd = sd(index),
      var = se * se,
      z_scored = -1 * (((index - ts_average) / ts_sd) * sigma_r),
      z_var = var * (sigma_r / ts_sd)^2,
      z_se = sqrt(z_var)
    ) |>
    dplyr::select(year, obs = z_scored, se_log = z_se)
}
