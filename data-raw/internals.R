library(nwfscSurvey)
authors <- gsub(
  " <.+",
  "",
  eval(parse(text = packageDescription("sablefish")$`Authors@R`))
)
common_name <- "sablefish"
latin_name <- "Anoplopoma fimbria"
len_bins <- seq(18, 90, by = 2)
age_bins <- 0:50
assessment_dir <- fs::path("assessment")
table_dir <- fs::path(assessment_dir, "52tables")
figure_dir <- fs::path(assessment_dir, "53figures")

# Create stratification areas from the SA3 file, which is in {nwfscSurvey}
# same as 2011 assessment, also used for 2019
strata <- nwfscSurvey::CreateStrataDF.fn(
  names = paste(
    sep = "_",
    rep(times = 4, c("55m-183m", "183m-549m", "549m-900m", "900m-1280m")),
    rep(each = 4, c("32-34.5", "34.5-40.5", "40.5-45", "45-49"))
  ),
  depths.shallow = rep(times = 4, x = c(55, 183, 549, 900)),
  depths.deep = rep(times = 4, x = c(183, 549, 900, 1280)),
  lats.south = rep(each = 4, x = c(32, 34.5, 40.5, 45)),
  lats.north = rep(each = 4, x = c(34.5, 40.5, 45, 49))
)

usethis::use_data(
  age_bins,
  assessment_dir,
  authors,
  common_name,
  figure_dir,
  latin_name,
  len_bins,
  strata,
  table_dir,
  internal = TRUE,
  overwrite = TRUE
)
