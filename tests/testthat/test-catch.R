test_that("washington landings are what Theresa emailed in 2023", {
  skip_on_ci()
  # The following data were emailed to Kelli Johnson from Theresa Tsou (WDFW)
  # as a summary of WA landings across all gear types to fact check the info
  # stored in PacFIN
  dir_theresa <- fs::path(
    fs::path_package("sablefish"),
    "data-raw",
    "20230616_TheresaTsou"
  )
  washington <- read.csv(file = fs::path(dir_theresa, "Book1.csv"))
  comparison <- data_catch_commercial %>%
    dplyr::group_by(year) %>%
    dplyr::filter(AGENCY_CODE == "W", year < 2022) %>%
    dplyr::summarize(pacfin_mt = sum(catch_mt)) %>%
    dplyr::left_join(y = washington, by = c(year = "Year")) %>%
    dplyr::mutate(diff = pacfin_mt - MT) %>%
    dplyr::arrange(abs(diff)) %>%
    dplyr::select(-RoundPound)
  write.csv(
    x = comparison,
    file = fs::path(dir_theresa, "WA_differences.csv"),
    row.names = FALSE
  )
  # Theresa's landings that do not have any of area 58 removed
  expect_equal(
    object = comparison %>%
      dplyr::filter(year %in% 1981:1982) %>%
      dplyr::pull(diff),
    expected = c(324, 894),
    tolerance = 0.02
  )
  # Theresa was fine with all of these remaining differences
  # that were less than 175 metric tons
  expect_true(
    object = comparison %>%
      dplyr::filter(year > 1982) %>%
      dplyr::mutate(diff = abs(diff) < 175) %>%
      dplyr::pull(diff) %>%
      all()
  )
  # to do: write a check for treaty PARTICIPATION_GROUP_CODE landings
  #        in 2022, which were 535.3 metric tons
})

test_that("oregon landings are what Ali emailed in 2023", {
  # to do:
  # * write the test!
  # * check examples to see if I can just load the data once
  skip_on_ci()
  expect_true(FALSE)
})
