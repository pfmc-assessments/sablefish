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
    x %in% c("triennial", "tri") ~ "4",
    x %in% c("akslp", "afsc.slope", "aslope") ~ "5",
    x %in% c("nwslp", "nwfsc.slope", "nslope") ~ "6",
    x %in% c("nwfsc.combo", "wcgbt") ~ "7",
    TRUE ~ NA_character_
  ) |>
  as.numeric()
}
