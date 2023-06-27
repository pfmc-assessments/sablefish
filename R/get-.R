#' Retrieve data from web-based resources
#'
#' @name get_data
#' @param name A string providing the relevant population or species name.
#'   The vector must be of length one.
#' @param password A string providing the relevant password for the database if
#'   one is needed. The default is missing and the function will just work if a
#'   password is not needed. Else, the function will fail if the user does not
#'   provide a valid password.
#' @inheritParams load_data
#' @return
#' `TRUE` is invisibly returned if the function is successful. Otherwise, an
#' error message is printed to the screen if the function is not successful.
#' Relevant files will be saved to the disk in the `data-raw` folder.
NULL
#' @rdname get_data
#' @export
get_data_commercial <- function(name = "SABL",
                                password,
                                directory = here::here()) {
  assertthat::assert_that(is.character(name))
  assertthat::assert_that(length(name) == 1)
  assertthat::assert_that(is.character(password))
  assertthat::assert_that(length(password) == 1)
  directory_raw <- fs::path(directory, "data-raw")
  fs::dir_create(directory_raw)

  PacFIN.Utilities::PullBDS.PacFIN(
    pacfin_species_code = name,
    savedir = directory_raw,
    verbose = TRUE,
    password = password
  )
  PacFIN.Utilities::PullCatch.PacFIN(
    pacfin_species_code = name,
    savedir = directory_raw,
    verbose = TRUE,
    password = password
  )
  return(invisible(TRUE))
}
#' @rdname get_data
#' @export
get_data_survey <- function(name = "sablefish",
                            directory = here::here()) {
  assertthat::assert_that(is.character(name))
  assertthat::assert_that(length(name) == 1)
  directory_raw <- fs::path(directory, "data-raw")
  fs::dir_create(directory_raw)

  surveys <- c(
    "Triennial",
    "AFSC.Slope",
    "NWFSC.Slope",
    "NWFSC.Shelf",
    "NWFSC.Combo"
  )
  purrr::map(
    .x = surveys[-4],
    .f = ~ nwfscSurvey::PullBio.fn(
      Name = name,
      SurveyName = .x,
      SaveFile = TRUE,
      Dir = directory_raw,
      verbose = TRUE
    )
  )
  purrr::map(
    .x = surveys,
    .f = ~ nwfscSurvey::PullCatch.fn(
      Name = name,
      SurveyName = .x,
      SaveFile = TRUE,
      Dir = directory_raw,
      verbose = TRUE
    )
  )
  return(invisible(TRUE))
}
