report_parameter_names <- function(years) {
  c(
    "SR_LN(R0)",
    "SSB_Virgin",
    glue::glue("SSB_{years}"),
    glue::glue("Bratio_{years}"),
    "Dead_Catch_SPR",
    "SR_BH_steep",
    "NatM_uniform_Fem_GP_1",
    "L_at_Amin_Fem_GP_1",
    "L_at_Amax_Fem_GP_1",
    "VonBert_K_Fem_GP_1",
    "young_Fem_GP_1",
    "old_Fem_GP_1",
    "NatM_uniform_Mal_GP_1",
    "L_at_Amin_Mal_GP_1",
    "L_at_Amax_Mal_GP_1", 
    "VonBert_K_Mal_GP_1",
    "young_Mal_GP_1",
    "old_Mal_GP_1"
  )
}

report_likelihood_names <- function() {
  c(
    "TOTAL",
    "Survey",
    "Discard",
    "Length_comp",
    "Age_comp",
    "Recruitment",
    "Forecast_",
    "priors",
    "Parm_devs"
  )
}

report_model_names <- function(x) {
  basename(x) |>
    # Separate numeric from UpperCamelCase
    gsub(pattern = "^([0-9]+)_", replacement = "\\1 ") |>
    # Separate UpperCamelCase into Title Case
    gsub(pattern = "([a-z])([A-Z])", replacement =  "\\1 \\2") |>
    gsub(pattern = "base", replacement =  "Base") |>
    gsub(pattern = "Current\\s*[Bb]ase", replacement =  "Base")
}
