#' Table of likelihoods by source
#'
#' A {kableExtra} table for inclusion in a document of the likelihoods for each
#' data source in your model.
#'
#' @param model A list from [r4ss::SS_output()].
#' @param caption A character string for the caption.
#' @param label A character string that will be used to specify the label.
#'   Underscores are not allowed.
#' @author Ian G. Taylor
#' @return
#' A {kableExtra} table with two columns, Label and Total.
#' @export
table_likelihoods <- function(model,
                              caption = "Likelihood components by source.",
                              label = "likelihoods") {
  model[["likelihoods_used"]] |>
    tibble::rownames_to_column() |>
    dplyr::mutate(
     rowname = purrr::map_chr(
      stringr::str_split(rowname, pattern = "_"),
      .f = \(x) edit_string(paste(x, collapse = " "))
     ) |> stringr::str_to_sentence(),
     values = sprintf("%5.2f", values)
    ) |>
    dplyr::select(Label = rowname, Total = values) |>
    sa4ss::table_format(
      longtable = FALSE,
      caption = caption,
      label = label,
      align = "lr"
    )
}
