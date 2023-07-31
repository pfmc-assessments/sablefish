#' @param steps Integers 1 through 3. Step three is not working.
#' @noRd
tune <- function(dir_in,
                 dir_out,
                 executable,
                 steps = 1:2,
                 iterations = 3) {
  # Run the model to facilitate tuning
  if (!fs::file_exists(fs::path(dir_in, "Report.sso"))) {
    check <- r4ss::run(
      dir = dir_in,
      exe = executable,
      skipfinished = FALSE,
      verbose = FALSE
    )
    stopifnot(check == "ran model")
  }

  # Write the files to a new directory
  fs::dir_copy(
    dir_in,
    dir_out,
    overwrite = TRUE
  )

  inputs <- r4ss::SS_read(dir_out)

  # Tune the length composition data
  if (1 %in% steps) {
    r4ss::tune_comps(
      replist = r4ss::SS_output(dir_out, verbose = FALSE, printstats = FALSE),
      option = "Francis",
      niters_tuning = iterations,
      init_run = FALSE,
      dir = dir_out,
      exe = executable,
      verbose = FALSE
    )
    inputs <- r4ss::SS_read(dir_out, ss_new = TRUE)
  }

  # Tune the discard data
  if (2 %in% steps) {
    report <- r4ss::SS_output(
      dir = dir_out,
      verbose = FALSE,
      printstats = FALSE
    )
    inputs <- r4ss::SS_read(dir_out, ss_new = TRUE)
    new <- dplyr::bind_rows(
      report[["discard_tuning_info"]] |>
        dplyr::select(type, fleet, added),
      report[["mnwgt_tuning_info"]] |>
        dplyr::select(type, fleet, added)
    )
    colnames(new) <- colnames(inputs[["ctl"]][["Variance_adjustment_list"]])
    inputs[["ctl"]][["Variance_adjustment_list"]] <- dplyr::full_join(
      inputs[["ctl"]][["Variance_adjustment_list"]],
      new,
      by = c("Data_type", "Fleet")
    ) |>
      dplyr::rowwise() |>
      dplyr::mutate(
        Value.x = ifelse(is.na(Value.x), 0, Value.x),
        Value.x = sum(Value.x, Value.y, na.rm = TRUE),
        Value.x = ifelse(Value.x < 0, 0, Value.x)
      ) |>
      dplyr::select(-Value.y) |>
      dplyr::rename(Value = "Value.x") |>
      dplyr::arrange(Data_type, Fleet)
  }

  # Tune the bias adjustment ramp
  # This does not really work because of 
  if (3 %in% steps) {
    # DO NOT update the intial year
    bias_ramp <- r4ss::SS_fitbiasramp(
      r4ss::SS_output(
        dir = dir_out,
        verbose = FALSE,
        printstats = FALSE
      ),
      plot = FALSE,
      print = TRUE
    )
    inputs <- r4ss::SS_read(dir_out, ss_new = TRUE)
    inputs[["ctl"]][["first_yr_fullbias_adj"]] <- bias_ramp[["newbias"]][[
      "par"]][2]
    inputs[["ctl"]][["last_yr_fullbias_adj"]] <- bias_ramp[["newbias"]][[
      "par"]][3]
    inputs[["ctl"]][["first_recent_yr_nobias_adj"]] <- bias_ramp[["newbias"]][[
      "par"]][4]
    inputs[["ctl"]][["max_bias_adj"]] <- bias_ramp[["newbias"]][[
      "par"]][5]
  }

  r4ss::SS_write(inputs, dir = dir_out, overwrite = TRUE)
  return(invisible(inputs))
}