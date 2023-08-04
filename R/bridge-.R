#' Remove data and specifications for a given fleet number
#' @param inputs A list returned from [r4ss::SS_read()].
#' @examples
#' bridge_remove_fleet(inputs,fleet_number = 2, "models/2023/base/bridging")
#' @noRd
bridge_remove_fleet <- function(inputs,
                                fleet_number,
                                dir_out) {
  renumber_vector <- function(x, bad = fleet_number) {
    ifelse(x < bad, x, x - 1)
  }
  fs::dir_create(dir_out)
  fleet_type <- inputs[["dat"]][["fleetinfo"]][["type"]][fleet_number]
  inputs[["dat"]][["fleetinfo"]] <- inputs[["dat"]][[
    "fleetinfo"]][-fleet_number, ]
  inputs[["dat"]][["Nfleets"]] <- NROW(inputs[["dat"]][["fleetinfo"]])
  inputs[["dat"]][["surveytiming"]] <- NULL
  inputs[["dat"]][["units_of_catch"]] <- NULL
  inputs[["dat"]][["catch"]] <- dplyr::filter(
    inputs[["dat"]][["catch"]],
    fleet != fleet_number
  ) |>
    dplyr::mutate(
      fleet = renumber_vector(fleet)
    )
  inputs[["dat"]][["CPUE"]] <- dplyr::filter(
    inputs[["dat"]][["CPUE"]],
    index != fleet_number
  ) |>
    dplyr::mutate(
      index = renumber_vector(index)
    )
  inputs[["dat"]][["CPUEinfo"]] <- dplyr::filter(
    inputs[["dat"]][["CPUEinfo"]],
    Fleet != fleet_number
  ) |>
    dplyr::mutate(
      Fleet = renumber_vector(Fleet)
    )

  if (fleet_type == 1) {
    inputs[["dat"]][["N_discard_fleets"]] <- inputs[["dat"]][[
      "N_discard_fleets"]] - 1
    inputs[["dat"]][["discard_fleet_info"]] <- inputs[["dat"]][[
      "discard_fleet_info"]][-fleet_number, ] |>
      dplyr::mutate(
        Fleet = renumber_vector(Fleet)
      )
    inputs[["dat"]][["discard_data"]] <- dplyr::filter(
      inputs[["dat"]][["discard_data"]],
      Flt != fleet_number
    ) |>
      dplyr::mutate(
        Flt = renumber_vector(Flt)
      )
  }
  if (inputs[["dat"]][["use_meanbodywt"]]) {
    inputs[["dat"]][["meanbodywt"]] <- dplyr::filter(
      inputs[["dat"]][["meanbodywt"]],
      Fleet != fleet_number
    ) |>
    dplyr::mutate(
      Fleet = renumber_vector(Fleet)
    )
  }
  inputs[["dat"]][["len_info"]] <- inputs[["dat"]][["len_info"]][
    -fleet_number, 
  ]
  inputs[["dat"]][["lencomp"]] <- dplyr::filter(
    inputs[["dat"]][["lencomp"]],
    FltSvy != fleet_number
  ) |>
    dplyr::mutate(
      FltSvy = renumber_vector(FltSvy)
    )
  inputs[["dat"]][["age_info"]] <- inputs[["dat"]][["age_info"]][
    -fleet_number, 
  ]
  inputs[["dat"]][["agecomp"]] <- dplyr::filter(
    inputs[["dat"]][["agecomp"]],
    FltSvy != fleet_number
  ) |>
    dplyr::mutate(
      FltSvy = renumber_vector(FltSvy)
    )
  inputs[["ctl"]][["Q_options"]] <- dplyr::filter(
    inputs[["ctl"]][["Q_options"]],
    fleet != fleet_number
  ) |>
    dplyr::mutate(
      fleet = renumber_vector(fleet)
    )
  inputs[["ctl"]][["Q_parms"]] <- dplyr::filter(
    inputs[["ctl"]][["Q_parms"]],
    !grepl(
      paste0("\\(", fleet_number, "\\)"),
      rownames(inputs[["ctl"]][["Q_parms"]])
    )
  )
  inputs[["ctl"]][["Q_parms_tv"]] <- dplyr::filter(
    inputs[["ctl"]][["Q_parms_tv"]],
    !grepl(
      paste0("\\(", fleet_number, "\\)"),
      rownames(inputs[["ctl"]][["Q_parms_tv"]])
    )
  )
  inputs[["ctl"]][["size_selex_types"]] <- inputs[["ctl"]][[
    "size_selex_types"]][-fleet_number, ]
  inputs[["ctl"]][["size_selex_parms"]] <- inputs[["ctl"]][[
    "size_selex_parms"]] |>
    dplyr::filter(
      !grepl(
        paste0("\\(", fleet_number, "\\)"),
        rownames(inputs[["ctl"]][["size_selex_parms"]])
      )
    )
  inputs[["ctl"]][["size_selex_parms_tv"]] <- inputs[["ctl"]][[
    "size_selex_parms_tv"]] |>
    dplyr::filter(
      !grepl(
        paste0("\\(", fleet_number, "\\)"),
        rownames(inputs[["ctl"]][["size_selex_parms_tv"]])
      )
    )
  inputs[["ctl"]][["age_selex_types"]] <- inputs[["ctl"]][[
    "age_selex_types"]][-fleet_number, ]
  inputs[["ctl"]][["age_selex_parms"]] <- inputs[["ctl"]][[
    "age_selex_parms"]] |>
    dplyr::filter(
      !grepl(
        paste0("\\(", fleet_number, "\\)"),
        rownames(inputs[["ctl"]][["age_selex_parms"]])
      )
    )
  inputs[["ctl"]][["age_selex_parms_tv"]] <- inputs[["ctl"]][[
    "age_selex_parms_tv"]] |>
    dplyr::filter(
      !grepl(
        paste0("\\(", fleet_number, "\\)"),
        rownames(inputs[["ctl"]][["age_selex_parms_tv"]])
      )
    )
  inputs[["ctl"]][["Variance_adjustment_list"]] <- dplyr::filter(
    inputs[["ctl"]][["Variance_adjustment_list"]],
    Fleet != fleet_number
  ) |>
    dplyr::mutate(
      Fleet = renumber_vector(Fleet)
    )

  if (!is.null(dir_out)) {
    r4ss::SS_write(
      inputlist = inputs,
      dir = dir_out,
      overwrite = TRUE,
      verbose = FALSE
    )
  }
  return(inputs)
}
#' Remove catches that occur before the start year of the model.
#'
#' Remove early catches, which might be in the data file because of a change in
#' the start year. But, do not remove catches with a year of -999 because those
#' are equilibrium catches.
#' @param inputs A list returned from [r4ss::SS_read()].
#' @noRd
bridge_remove_early_catch <- function(inputs,
                                      dir_out) {
  inputs[["dat"]][["catch"]] <- inputs[["dat"]][["catch"]] |>
    dplyr::filter(
      year >= inputs[["dat"]][["styr"]] | year == -999
    )

  if (!is.null(dir_out)) {
    r4ss::SS_write(
      inputlist = inputs,
      dir = dir_out,
      overwrite = TRUE,
      verbose = FALSE
    )
  }
  return(inputs)
}

#' @details # End Year
#' Changes the following values to `end_year`, which is the last year of
#' catches in `x`:
#' * End year in data file
#' * Last year of main recruitment deviations
#' * Last year of full bias adjustment
#' @param forecast_catch A data frame with four following columns but column
#'   names will not be checked, it is just assumed that the data is in the
#'   correct order:
#'   * Year
#'   * Seas
#'   * Fleet, and
#'   * `Catch or F`.
#' @noRd
bridge_end_year <- function(inputs,
                            catch,
                            forecast_catch,
                            dir_out) {
  fs::dir_create(dir_out)
  old_end_year <- inputs[["dat"]][["endyr"]]
  inputs <- bridge_update_data(
    inputs = inputs,
    x = catch,
    dir_out = NULL,
    type = "catch",
    match = NULL,
    vars_by = c("year", "seas", "fleet"),
    vars_arrange = c("fleet", "year", "seas")
  )
  new_end_year <- dplyr::pull(catch, year) |>
    max()
  inputs[["dat"]][["endyr"]] <- new_end_year
  inputs[["ctl"]][["MainRdevYrLast"]] <- new_end_year
  inputs[["ctl"]][["last_yr_fullbias_adj"]] <- new_end_year
  inputs[["fore"]][["Bmark_years"]][-c(1:2)] <- new_end_year
  inputs[["fore"]][["Flimitfraction_m"]][, "Year"] <- inputs[["fore"]][[
    "Flimitfraction_m"]][, "Year"] + new_end_year - old_end_year
  inputs[["fore"]][["FirstYear_for_caps_and_allocations"]] <- new_end_year + 5
  inputs[["fore"]][["ForeCatch"]] <- forecast_catch

  # Deal with the terminal year time blocks and remove unused blocks
  change_terminal <- function(x, from, to) {
    x_length <- length(x)
    x[x_length] <- ifelse(x[x_length] == from, to, x[x_length])
    return(x)
  }
  inputs[["ctl"]][["Block_Design"]] <- purrr::map(
    bridge_output[["ctl"]][["Block_Design"]],
    .f = change_terminal,
    from = old_end_year,
    to = new_end_year
  )
  used_blocks <- purrr::map(
    inputs[["ctl"]][grep(names(inputs[["ctl"]]), pattern = "_parms$")],
    "Block"
  ) |> unlist() |> unique()
  used_blocks <- used_blocks[which(used_blocks != 0)]
  inputs[["ctl"]][["Block_Design"]] <- inputs[["ctl"]][[
    "Block_Design"
  ]][used_blocks]
  inputs[["ctl"]][["N_Block_Designs"]] <- length(used_blocks)
  inputs[["ctl"]][["blocks_per_pattern"]] <- inputs[["ctl"]][[
    "blocks_per_pattern"
  ]][used_blocks]

  if (!is.null(dir_out)) {
    r4ss::SS_write(
      inputlist = inputs,
      dir = dir_out,
      overwrite = TRUE,
      verbose = FALSE
    )
  }
  return(invisible(inputs))
}

#' @details # Defaults
#' The parameter defaults are for length-composition data but this function
#' can essentially be used to replace information in any data frame stored
#' in a list that was returned from [r4ss::SS_read()]. Thus, `CPUE` data is
#' viable here as well. You will just need to change the `vars` and `type`.
#' @param inputs Output from [r4ss::SS_read()].
#' @param x A data frame of composition data. The column names can be whatever
#'   you want them to be but they must be in the same order as the data frame
#'   that is currently in `inputs`. No checking is done, they are just
#'   replaced.
#' @param dir_out The directory that you want to write the new inputs to. This
#'   can be a relative or absolute path. The directory will be created using
#'   [fs::dir_create()]. If `NULL`, then nothing is written to the disk. This
#'   can be helpful when you just want to see what the new inputs will be by
#'   looking at the returned object.
#' @param matched A logical. The default, `FALSE`, will insert all rows of `x`
#'   into the appropriate section of the data file. Where, `TRUE` leads to only
#'   the matched values in `x` being inserted into the data file. That is, if
#'   `x` contains years that are new and not in `inputs`, then those new years
#'   will not be entered into the data file. This is helpful when you just want
#'   to update old data. If you want to update old values and insert new
#'   values, use the default of `FALSE`. If the value is `NULL`, then the
#'   section of the code is ignored and `x` is used as is without any
#'   filtering.
#' @param type The name of the section within `inputs[["dat"]][[type]]` that
#'   you want to manipulate. The default is the first entry in the function
#'   call below, i.e., "lencomp".
#' @param vars_by A vector of strings to use in the `by` argument of all
#'   `dplyr::*_join()` calls. The default is for length-composition information
#'   when you do not care about Gender, i.e., you want to replace composition
#'   data even if the Gender column doesn't match. This was helpful for
#'   switching between models when a previous model used Gender = 3 but the new
#'   model uses both Gender = 3 and Gender = 0. If you are working with age-
#'   composition data, think about adding
#'   `c("Gender", "Ageerr", "Lbin_lo", "Lbin_hi")` to the defaults.
#' @param vars_arrange A vector of strings to use in [dplyr::arrange()] to
#'   order the rows.
#' @return
#' A list, structured the same as `inputs` is returned invisibly. A side effect
#' is that this same list is used to create input files that are saved to the
#' disk if `dir_out` is not `NULL`.
#' @author Kelli F. Johnson
#' @noRd
bridge_update_data <- function(inputs,
                               x,
                               dir_out,
                               matched = FALSE,
                               type = "lencomp",
                               vars_by = c("Yr", "Seas", "FltSvy", "Part"),
                               vars_arrange = c(
                                 "FltSvy", "Part", "Gender", "Yr"
                               )) {
  fs::dir_create(dir_out)
  stopifnot(type %in% names(inputs[["dat"]]))
  stopifnot(length(type) == 1)
  stopifnot(inherits(inputs[["dat"]][[type]], "data.frame"))
  colnames(x) <- colnames(inputs[["dat"]][[type]])

  data_new <-   if (is.null(matched)) {
    x
  } else {
    do.call(
      if (matched) {
        dplyr::semi_join # rows from x with match in y
      } else {
        dplyr::anti_join # rows from x without match in y
      },
      args = list(
        x = x,
        y = inputs[["dat"]][[type]],
        by = vars_by
      )
    )
  }

  inputs[["dat"]][[type]] <- dplyr::bind_rows(
    x = data_new,
    y = dplyr::anti_join(
      x = inputs[["dat"]][[type]],
      y = data_new,
      by = vars_by
    )
  ) |>
    dplyr::arrange(dplyr::across(dplyr::all_of(vars_arrange))) |>
    as.data.frame()

  if (!is.null(dir_out)) {
    r4ss::SS_write(
      inputlist = inputs,
      dir = dir_out,
      overwrite = TRUE,
      verbose = FALSE
    )
  }
  return(invisible(inputs))
}

#' @details
#' * Begin annual SD report in the start year found in the data file by using a
#'   -1 in the starter file.
#' * End the annual SD report in the last forecast year by using -2 in the
#'   starter file.
#' * Turn on prior likelihoods.
#' * Decrease convergence criterion to 1e-03 from 1e-05.
#' @inheritParams bridge_update_data
#' @noRd
bridge_fix_starter <- function(inputs,
                               dir_out) {
  fs::dir_create(dir_out)
  inputs[["start"]][["minyr_sdreport"]] <- -1
  inputs[["start"]][["maxyr_sdreport"]] <- -2
  inputs[["start"]][["prior_like"]] <- 1
  inputs[["start"]][["converge_criterion"]] <- 1e-03

  if (!is.null(dir_out)) {
    r4ss::SS_write(
      inputlist = inputs,
      dir = dir_out,
      overwrite = TRUE,
      verbose = FALSE
    )
  }
  return(invisible(inputs))
}

bridge_fix_parameters <- function(inputs,
                                  dir_out) {
  fs::dir_create(dir_out)
  inputs[["ctl"]][["SR_parms"]][
    grepl("SR_LN", row.names(inputs[["ctl"]][["SR_parms"]])),
    c("INIT", "PRIOR")
  ] <- 10.5
  # Fix retention parameter at lower bound
  inputs[["ctl"]][["size_selex_parms_tv"]][
    grepl(
      "Ret.+1_FIX.+_2019",
      row.names(inputs[["ctl"]][["size_selex_parms_tv"]])
    ),
    "PHASE"
  ] <- -1 * inputs[["ctl"]][["size_selex_parms_tv"]][
    grepl(
      "Ret.+1_FIX.+_2019",
      row.names(inputs[["ctl"]][["size_selex_parms_tv"]])
    ),
    "PHASE"
  ]
  # Fix descending age-based tv selectivity at upper bound
  inputs[["ctl"]][["age_selex_parms_tv"]][
    grepl("TWL.+2011", row.names(inputs[["ctl"]][["age_selex_parms_tv"]])),
    "PHASE"
  ] <- -1 * inputs[["ctl"]][["age_selex_parms_tv"]][
    grepl("TWL.+2011", row.names(inputs[["ctl"]][["age_selex_parms_tv"]])),
    "PHASE"
  ]
  # Change initial value from -9.73241 to get parameter off of the bound
  inputs[["ctl"]][["age_selex_parms_tv"]][
    grepl(
      "ascend.+FIX.+2011|3_FIX.+2011",
      row.names(inputs[["ctl"]][["age_selex_parms_tv"]])
    ),
    "INIT"
  ] <- -1.50000

  if (!is.null(dir_out)) {
    r4ss::SS_write(
      inputlist = inputs,
      dir = dir_out,
      overwrite = TRUE,
      verbose = FALSE
    )
  }
  return(invisible(inputs))
}
