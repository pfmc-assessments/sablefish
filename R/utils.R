bind_compositions <- function(x) {
  stopifnot(inherits(x, "list"))
  good_names <- colnames(x[[1]])
  one_data_frame <- purrr::map_dfr(x, \(y) setNames(y, good_names))
  old_names <- colnames(one_data_frame)
  new_names <- gsub("^[UMF]([0-9]+)\\.*[0-9]*$", "U\\1", old_names)
  no_dots <- gsub("\\.{3}[0-9]+$", "", new_names)
  colnames(one_data_frame) <- no_dots
  return(one_data_frame)
}
