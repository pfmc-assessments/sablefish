text_likelihoods_used <- function(model) {
  components_string <- model[["likelihoods_used"]] |>
    tibble::rownames_to_column() |>
    dplyr::filter(values != 0, rowname != "TOTAL") |>
    dplyr::pull(rowname) |>
    tolower() |>
    strsplit(split = "_") |>
    purrr::map_chr(.f = \(x) glue::glue_collapse(x = x, sep = " ")) |>
    edit_string() |>
    glue::glue_collapse(sep = ", ", last = ", and ")
  return(components_string)
}

edit_string <- function(x,
                        survey = "indices") {
  x |>
  tolower() |>
  gsub(pattern = "\\bcomp\\b", replacement = "composition") |>
  gsub(pattern = "\\bdevs\\b", replacement = "deviations") |>
  gsub(pattern = "\\beq\\b", replacement = "equilibrium") |>
  gsub(pattern = "\\bequil\\b", replacement = "equilibrium") |>
  gsub(pattern = "\\biniteq\\b", replacement = "initial equilibrium") |>
  gsub(pattern = "\\bparm\\b", replacement = "parameter") |>
  gsub(pattern = "\\bpen\\b", replacement = "penalty") |>
  gsub(pattern = "\\bsurvey\\b", replacement = survey) |>
  gsub(pattern = "\\bwt\\b", replacement = "weight") |>
  gsub(pattern = "natm_uniform_fem_gp_1", replacement = "female natural mortality") |>
  gsub(pattern = "natm_uniform_mal_gp_1", replacement = "male natural mortality") |>
  gsub(pattern = "sr_bh_steep", replacement = "steepness") |>
  gsub(pattern = "sr_ln\\(r0\\)", replacement = "natural log of unfished recruitment")
}
