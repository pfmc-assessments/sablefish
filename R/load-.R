#' Load data saved in `data-raw`
#'
#' It is assumed that only the best files will be saved in `data-raw` such that
#' searching for something like `"PacFIN_SABL"` will only come up with two
#' files, one containing catch and the other containing biological data. So,
#' old outdated data should **NOT** be saved in `data-raw`.
#'
#' @name load_data
#' @param directory The path to the assessment package of interest. The default
#'   uses [here::here()] to locate the appropriate directory but you can set it
#'   to whatever directory you want as long as that directory contains
#'   `data-raw`.
#' @return
#' All `load_data_*()` functions return a data frame.
#' @examples
#' \dontrun{
#' data_catch_survey <- load_data_catch_survey()
#' data_catch_commercial <- load_data_catch_commercial()
#' }
NULL
#' @rdname load_data
#' @export
load_data_catch <- function(directory = here::here()) {
  # to do:
  # * integrate survey catches into returned data frame
  #   need to fix the column names so they are equivalent
  # * create a function to load recreational catches
  cli::cli_alert("Currently, load_data_catch() only loads commercial catches.")
  commercial <- load_data_catch_commercial()
  recreational <- data.frame()
  survey <- load_data_catch_survey()
  return(
    dplyr::bind_rows(
      commercial = commercial,
      recreational = recreational
    )
  )
}
#' @rdname load_data
#' @export
load_data_catch_commercial <- function(directory = here::here()) {
  # Read in the comprehensive fish ticket data
  file_commercial_catch <- fs::dir_ls(
    fs::path(directory, "data-raw"),
    regex = "PacFIN\\..+Comp"
  )
  stopifnot(length(file_commercial_catch) == 1)
  load(file_commercial_catch)

  commercial <- catch.pacfin %>%
    # Fixes to raw data
    # 2019 and 2021 removed Oregon coast ("OC") data if present
    # dplyr::filter(
    #   INPFC_AREA_TYPE_CODE %in% c("CP","MT","EK","CL","VN","UI")
    # ) %>%
    # Attribute 50% (per OH) of landings in CATCH_AREA_CODE 58 to Canada
    dplyr::mutate(
      ROUND_WEIGHT_MTONS = dplyr::case_when(
        CATCH_AREA_CODE == 58 ~ ROUND_WEIGHT_MTONS * 0.5,
        TRUE ~ ROUND_WEIGHT_MTONS
      )
    ) %>%
    dplyr::group_by(
      LANDING_YEAR,
      AGENCY_CODE,
      PACFIN_GROUP_GEAR_CODE
    ) %>%
    # Pre-2019 assessment, "POT" was its own fleet
    dplyr::mutate(
      PACFIN_GROUP_GEAR_CODE = dplyr::case_when(
        PACFIN_GROUP_GEAR_CODE %in% c("TLS", "HKL", "POT") ~ "FIX",
        TRUE ~ "TWL"
      )
    ) %>%
    # Make sure to use round weight rather than LANDED_WEIGHT_MTONS
    dplyr::summarize(
      catch_mt = sum(ROUND_WEIGHT_MTONS)
    ) %>%
    dplyr::rename(year = "LANDING_YEAR")
  return(commercial)
}
#' @rdname load_data
#' @export
load_data_catch_survey <- function(directory = here::here()) {
  files <- fs::dir_ls(
    path = fs::path(directory, "data-raw"),
    regexp = "Catch"
  )
  out <- purrr::map(
    .x = files,
    .f = function(y) {
      load(y)
      return(invisible(Out))
    }
  )
  names(out) <- purrr::map_chr(
    .x = files,
    .f = ~ gsub(pattern = "^.*__|_[0-9-]+\\.rda|_", "", .x)
  )
  out_data_frame <- dplyr::bind_rows(
    out,
    .id = "source"
  )
  return(out)
}
