figure_information <- function(regex,
                               location = fs::path(model_location, "plots")) {
  data <- tibble::as_tibble_col(
    column_name = "filein",
    fs::dir_ls(location, regex = regex)
  ) |>
    dplyr::mutate(
      base = basename(filein),
      fleet_number = as.numeric(ifelse(
        grepl("flt[a-zA-Z]+\\.png$", base),
        recode_fleet(gsub(".+flt([A-Za-z]+)\\.png", "\\1", base)),
        gsub(".+flt([0-9]+).+", "\\1", base)
      )),
      fleet_text = recode_fleet_text(fleet_number),
      partition = gsub(".+mkt([0-9])[\\._a-zA-Z0-9]+", "\\1", filein),
      partition = ifelse(grepl("bodywt", base), 1, partition),
      partition_text = recode_partition_text(partition),
      identifier = paste(fleet_number, partition),
      duplicated = duplicated(identifier),
      fit = grepl("fit", base),
      type = dplyr::case_when(
        grepl("comp_age", base) ~ "age",
        grepl("comp_len", base) ~ "length",
        grepl("condAAL", base) ~ "conditional",
        grepl("gstage", base) ~ "age",
        grepl("bodywt", base) ~ "body weight",
        TRUE ~ NA_character_
      )
    ) |>
    dplyr::group_by(identifier, fit, type) |>
    dplyr::mutate(
      group_row = dplyr::row_number(),
      name_short = gsub(
        "_", "-",
        gsub("_flt[0-9]+|mkt[0-3]|_page[0-9]+|\\.png", "", base)
      ),
      label = paste(name_short, fleet_number, partition, group_row, sep = "-"),
      caption_helper = dplyr::case_when(
        # Composition data
        grepl("comp_lendat_flt", base) ~
          "Annual length-composition data for the",
        grepl("comp_agedat_flt", base) ~
          "Annual age-composition data for the",
        grepl("comp_gstagedat_bub", base) ~
          "Annual female, male, and unsexed (red, blue, and black, respectively) age-composition data that were excluded from the model fitting process for the",
        grepl("condAALdat_bub", base) ~
          "Annual female, male, and unsexed (red, blue, and black, respectively) conditional age-at-length data for the",
        # Composition fits
        grepl("comp_lenfit_flt", base) ~
          "Fits to the female, male, and unsexed (red, blue, and green, respectively) length-composition data for the",
        grepl("comp_agefit_flt", base) ~
          "Fits to the female, male, and unsexed (red, blue, and green, respectively) age-composition data for the",
        grepl("comp_gstagefit", base) ~
          "Fits to the annual female, male, and unsexed (red, blue, and green, respectively) age-composition data that were excluded from the model fitting process for the",
        grepl("comp_lenfit_resid", base) ~
          "Pearson residuals, where closed and open bubbles indicate the observed value was greater or less than the expected, respectively, of length-composition data for the",
        grepl("comp_agefit_resid", base) ~
          "Pearson residuals, where closed and open bubbles indicate the observed value was greater or less than the expected, respectively, of age-composition data for the",
          # to do: what does the blue line mean?
        grepl("Andre", base) ~
          "Year-specific conditional age-at-length data with 1.64 standard errors of the mean (left) and standard deviation (Stdev) at age with 90 percent interval from a chi-square distribution for the standard deviation of mean age (right) from the",
        # Body weight fit
        grepl("bodywt_fit", base) ~
          "Fits to the mean body weight data for the"
      )
    ) |>
    dplyr::ungroup() |>
    dplyr::mutate(
      label_lag = ifelse(group_row == 1, "", dplyr::lag(label))
    ) |>
    dplyr::rowwise() |>
    dplyr::mutate(
      ref_helper = paste0(
        "Continued from Figure \\@ref(fig:", label_lag, ")."
      ),
      caption_middle = glue::glue(
        "{fleet_text} from the {partition_text} catch."
      ),
      of_helper = ifelse(
        group_row != 1,
        ref_helper,
        ""
      ),
      caption = paste(caption_helper, caption_middle, of_helper),
      # Get rid of terminal space after ending full stop because
      # sa4ss::add_figure() might do something weird with that
      caption = gsub("\\. $", "", caption)
    ) |>
    dplyr::arrange(type, factor(partition, levels = c(0, 2, 1)), fleet_number) |>
    dplyr::ungroup()
  return(data)
}
