recode_Project <- function(x, gls = FALSE) {
  out <- dplyr::case_match(
    .x = x,
    "AFSC.Slope" ~ "aslope",
    "NWFSC.Combo" ~ "wcgbt",
    "NWFSC.Shelf" ~ "nshelf",
    "NWFSC.Slope" ~ "nslope",
    "Triennial" ~ "tri",
    .default = NA_character_
  )
  if (gls) {
    out <- glue::glue("\\glsentryshort{{s-{out}}}")
  }
  return(out)
}

recode_fleet <- function(x) {
  x <- tolower(as.character(x))
  dplyr::case_when(
    x %in% c("fix", "pot", "hkl", "tls") ~ "1",
    x == c("twl") ~ "2",
    x %in% c("env") ~ "3",
    x %in% c("akshlf", "triennial", "tri") ~ "4",
    x %in% c("akslp", "afsc.slope", "aslope") ~ "5",
    x %in% c("nwslp", "nwfsc.slope", "nslope") ~ "6",
    x %in% c("nwcbo", "nwfsc.combo", "wcgbt") ~ "7",
    TRUE ~ NA_character_
  ) |>
  as.numeric()
}

recode_fleet_text <- function(x) {
  stopifnot(inherits(x, "numeric"))
  dplyr::case_when(
    x == 1 ~ "fixed-gear fleet",
    x == 2 ~ "trawl fleet",
    x == 3 ~ "environmental survey",
    x == 4 ~ "\\glsentryshort{s-tri}",
    x == 5 ~ "\\glsentryshort{s-aslope}",
    x == 6 ~ "\\glsentryshort{s-nslope}",
    x == 7 ~ "\\glsentryshort{s-wcgbt}"
  )
}

recode_partition_text <- function(x) {
  dplyr::case_when(
    x == 0 ~ "whole",
    x == 1 ~ "discarded",
    x == 2 ~ "retained"
  )
}
