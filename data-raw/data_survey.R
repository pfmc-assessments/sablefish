get_data_survey()

data_survey_catch <- fs::dir_ls("data-raw", regex = "Catch_") |>
  purrr::map_df(
    .f = function(x) {load(x); return(Out)}
  ) |>
  dplyr::select(-Tow, -Common_name)

data_survey_bio <- fs::dir_ls("data-raw", regex = "Bio_") |>
  purrr::map_df(
    .f = function(x) {
      load(x)
      if (inherits(Data, "list")) {
        Data <- dplyr::bind_rows(Data)
      }
      return(Data)
    }
  ) |>
  dplyr::select(-Common_name, -Ageing_Lab, -Oto_id, -Width_cm)

usethis::use_data(
  data_survey_catch,
  data_survey_bio,
  overwrite = TRUE
)
