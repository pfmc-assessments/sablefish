#' Search for information on {r4ss} figures using grep
#'
#' Search through a directory "location" for figures and compile information
#' about each returned png file into a data frame. Information stored in the
#' data frame will be helpful for adding a figure to your document.
#'
#' @author Kelli F. Johnson
#' @seealso 
#' * [sa4ss::add_figure()]
#' * [cat()] for printing information to the screen
figure_information <- function(regex,
                               location = fs::path(model_location, "plots")) {
  # Search through the directory to find all png files related to the grep
  data_file_names <- tibble::as_tibble_col(
    column_name = "filein",
    fs::dir_ls(location, regex = regex)
  )
  stopifnot(all(fs::path_ext(data_file_names[["filein"]]) == "png"))

  # Start filling out information
  data <- data_file_names |>
    dplyr::mutate(
      base = basename(filein),
      fleet_number = file_to_fleet_number(base),
      fleet_text = recode_fleet_text(fleet_number),
      partition = ifelse(
        test = grepl("bodywt|discard_data", base),
        yes = 1,
        no = gsub(".+mkt([0-9])[\\._a-zA-Z0-9]+", "\\1", filein)
      ),
      partition_text = recode_partition_text(partition),
      fit = grepl("fit", base),
      type = dplyr::case_when(
        grepl("comp_age", base) ~ "age",
        grepl("comp_len", base) ~ "length",
        grepl("condAAL", base) ~ "conditional",
        grepl("gstage", base) ~ "age",
        grepl("bodywt", base) ~ "body weight",
        grepl("discard_data", base) ~ "discard rate",
        TRUE ~ NA_character_
      )
    ) |>
    dplyr::group_by(paste(fleet_number, partition), fit, type) |>
    dplyr::mutate(
      group_row = dplyr::row_number(),
      base_short = file_to_type(base),
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      label = paste(base_short, fleet_number, partition, group_row, sep = "-"),
      label_lag = ifelse(group_row == 1, "", dplyr::lag(label))
    ) |>
    dplyr::rowwise() |>
    dplyr::mutate(
      # If the figure is not the first in a series, add ref to prev. fig.
      caption_end = ifelse(
        test = group_row != 1,
        paste0(" Continued from Figure \\@ref(fig:", label_lag, ")."),
        ""
      ),
      # Use the filename to get the beginning of the caption
      caption_beginning = file_to_text(base),
      caption_end = glue::glue(
        "{fleet_text} from the {partition_text} catch.{caption_end}"
      ),
      caption = paste(caption_beginning, caption_end),
      fig_label = glue::glue("fig:{label}"),
      label_text = sa4ss::report_ref_label(fig_label)
    ) |>
    dplyr::arrange(
      type,
      # Because we want discard data to come after landed data
      # 0 is whole catch, 2 is just landed, 1 is discarded
      factor(partition, levels = c(0, 2, 1)),
      fleet_number
    ) |>
    dplyr::group_by(
      type, fit, partition
    ) |>
    dplyr::mutate(
      label_text_group = sa4ss::report_ref_label(fig_label)
    ) |>
    dplyr::group_by(fleet_number, .add = TRUE) |>
    dplyr::mutate(
      label_text_group_fleet = sa4ss::report_ref_label(fig_label)
    ) |>
    dplyr::ungroup() |>
    dplyr::select(
      filein, label, caption,
      type, fit, fleet_number, partition,
      label_text, label_text_group, label_text_group_fleet
    )
  return(data)
}

#' Guess the best beginning part of a caption given a file name
#'
#' Take a file name for a png file, or just the base of the file name, made
#' using {r4ss} and guess what the beginning of the caption should be.
#' [dplyr::case_when()] is used in combination with [grepl()] to work through
#' the potential options.
#'
#' @param x A vector of strings. The strings can be a full file path or just
#'   the base name of the files. The paths do not have to be valid, in fact
#'   they do not have to be paths at all for the function to work.
#'
#' @author Kelli F. Johnson
#' @seealso
#' * [figure_information()]
#' @return
#' A vector of strings the same length as `x`. Often this vector is pasted
#' together with additional information to formulate captions for figures.
#' Note that the returned strings are basically a phrase with no trailing
#' space at the end of the phrase.
#' @examples 
#' file_to_text("comp_lendat_flt")
#' file_to_text("comp_agedat_flt")
#' file_to_text(c("comp_agedat_flt", "comp_agedat_flt"))
file_to_text <- function(x) {
  dplyr::case_when(
    # Composition data
    grepl("comp_lendat_flt", x) ~
      "Annual length-composition data for the",
    grepl("comp_agedat_flt", x) ~
      "Annual age-composition data for the",
    grepl("comp_gstagedat_bub", x) ~
      "Annual female, male, and unsexed (red, blue, and black, respectively) age-composition data that were excluded from the model fitting process for the",
    grepl("condAALdat_bub", x) ~
      "Annual female, male, and unsexed (red, blue, and black, respectively) conditional age-at-length data for the",
    # Composition fits
    grepl("comp_lenfit_flt", x) ~
      "Fits to the female, male, and unsexed (red, blue, and green, respectively) length-composition data for the",
    grepl("comp_agefit_flt", x) ~
      "Fits to the female, male, and unsexed (red, blue, and green, respectively) age-composition data for the",
    grepl("comp_gstagefit", x) ~
      "Fits to the annual female, male, and unsexed (red, blue, and green, respectively) age-composition data that were excluded from the model fitting process for the",
    grepl("comp_lenfit_resid", x) ~
      "Pearson residuals, where closed and open bubbles indicate the observed value was greater or less than the expected, respectively, of length-composition data for the",
    grepl("comp_agefit_resid", x) ~
      "Pearson residuals, where closed and open bubbles indicate the observed value was greater or less than the expected, respectively, of age-composition data for the",
      # to do: what does the blue line mean?
    grepl("Andre", x) ~
      "Year-specific conditional age-at-length data with 1.64 standard errors of the mean (left) and standard deviation (Stdev) at age with 90 percent interval from a chi-square distribution for the standard deviation of mean age (right) from the",
    # Body weight
    grepl("bodywt_data", x) ~
      "Annual \\glsentrylong{wcgop} mean weights for the",
    grepl("bodywt_fit", x) ~
      "Fits to the mean body weight data for the",
    grepl("discard_data", x) ~
      "Annual \\glsentrylong{wcgop} discard rates for the"
  )
}

file_to_type <- function(x) {
  x |>
  gsub(pattern = "_flt[0-9]+|mkt[0-3]", replacement = "") |>
  gsub(pattern = "_bubflt[0-9]+_", replacement = "_bub_") |>
  gsub(pattern = "_plotsflt[0-9]", replacement = "") |>
  gsub(pattern = "_flt[A-Za-z]+\\.png", replacement = "") |>
  gsub(pattern = "flt[0-9]+\\.png", replacement = "") |>
  gsub(pattern = "_data[A-Za-z]+\\.png", replacement = "") |>
  # Must be next to last
  gsub(pattern = "_page[0-9]+|\\.png", replacement = "") |>
  # Must be last
  gsub(pattern = "_", replacement = "-")
}

file_to_fleet_number <- function(x) {
  strings <- ifelse(
    test = grepl(".+[daflt]{3,4}([a-zA-Z]+)\\.png", x),
    yes = recode_fleet(gsub(".+[daflt]{3,4}([a-zA-Z]+)\\.png", "\\1", x)),
    no = gsub(".+[flt]{3}([0-9]+).+", "\\1", x)
  )
  out <- type.convert(strings, "numeric", as.is = TRUE)
  return(out)
}
