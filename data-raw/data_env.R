data_env_index <- read.csv(
  fs::path(
    here::here(),
    "data-raw",
    "MARSS_SSH_DFA_DF1_Index_4Kelli-SablefishAssessment.csv"
  )
) |>
  calc_env(index = "index", se = "SE") |>
  dplyr::mutate(seas = 5, index = 3, .after = "year")

utils::write.csv(
  file = fs::path("data-processed", "data_env_index.csv"),
  data_env_index,
  row.names = FALSE
)
