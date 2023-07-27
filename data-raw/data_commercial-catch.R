# Data from Oregon reconstruction (in 2019 files) because
# PacFIN 1981--1986 Oregon data is not used
data_commercial_catch_oregon_reconstruction <- data.frame(matrix(
  ncol = 3, byrow = TRUE,
  data = c(
    # 379.61, 1241.05, 1112.62, # 1980
    700.64, 277.17, 1365.59,
    641.24, 1456.91, 2991.54,
    551.43, 1317.83, 2773.15,
    226.82, 1828.37, 2782.85,
    514.39, 1898.58, 2859.74,
    1078.71, 1424.00, 2151.96
  )
)) |>
  dplyr::mutate(
    X1 = X1 + X2,
    AGENCY_CODE = "O",
    year = 1981:1986
  ) |>
  dplyr::select(-X2) |>
  dplyr::rename(FIX = X1, TWL = X3) |>
  tidyr::pivot_longer(
    values_to = "catch_mt",
    cols = c(FIX, TWL),
    names_to = "PACFIN_GROUP_GEAR_CODE"
  )

data_commercial_catch_at_sea_hake <- utils::read.csv(
  fs::path("data-raw", "data_catch_norpac.csv")
) |>
  dplyr::mutate(
    AGENCY_CODE = "at-sea",
    PACFIN_GROUP_GEAR_CODE = "TWL"
  )

data_commercial_catch <- fs::dir_ls("data-raw", regex = "PacFIN\\..+Comp") |>
  purrr::map_df(
    .f = function(x) {load(x); return(catch.pacfin)}
  ) |>
  # Fixes to raw data
  dplyr::filter(
    !(LANDING_YEAR < 1987 & AGENCY_CODE == "O")
  # 2019 and 2021 removed Oregon coast ("OC") data if present
  #   INPFC_AREA_TYPE_CODE %in% c("CP","MT","EK","CL","VN","UI")
  ) |>
  # Attribute 50% (per OH) of landings in CATCH_AREA_CODE 58 to Canada
  dplyr::mutate(
    ROUND_WEIGHT_MTONS = dplyr::case_when(
      CATCH_AREA_CODE == 58 ~ ROUND_WEIGHT_MTONS * 0.5,
      TRUE ~ ROUND_WEIGHT_MTONS
    )
  ) |>
  dplyr::group_by(
    LANDING_YEAR,
    AGENCY_CODE,
    PACFIN_GROUP_GEAR_CODE
  ) |>
  # Pre-2019 assessment, "POT" was its own fleet
  dplyr::mutate(
    PACFIN_GROUP_GEAR_CODE = dplyr::case_when(
      PACFIN_GROUP_GEAR_CODE %in% c("TLS", "HKL", "POT") ~ "FIX",
      TRUE ~ "TWL"
    )
  ) |>
  # Make sure to use round weight rather than LANDED_WEIGHT_MTONS
  dplyr::summarize(
    catch_mt = sum(ROUND_WEIGHT_MTONS)
  ) |>
  dplyr::rename(year = "LANDING_YEAR") |>
  dplyr::full_join(
    y = data_commercial_catch_oregon_reconstruction,
    by = colnames(data_commercial_catch)
  ) |>
  dplyr::full_join(
    y = data_commercial_catch_at_sea_hake,
    by = c("year", "AGENCY_CODE", "PACFIN_GROUP_GEAR_CODE", catch_mt = "catch")
  )

data_commercial_catch |>
  dplyr::group_by(year, PACFIN_GROUP_GEAR_CODE) |>
  dplyr::summarise(catch = round(sum(catch_mt), digits = 4)) |>
  dplyr::arrange(PACFIN_GROUP_GEAR_CODE, year) |>
  dplyr::rename(fleet = PACFIN_GROUP_GEAR_CODE) |>
  dplyr::mutate(
    seas = 1,
    fleet = recode_fleet(fleet),
    .after = year
  ) |>
  dplyr::mutate(catch_se = 0.01, .after = catch) |>
  utils::write.csv(
    file = fs::path("data-processed", "data_commercial_catch.csv"),
    row.names = FALSE
  )

usethis::use_data(
  data_commercial_catch,
  overwrite = TRUE
)
