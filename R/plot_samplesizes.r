#' Plot sample sizes
#'
#' @param df a data frame containing the choices and results of each specification (resulting from \code{run_specs}).
#' @param desc logical value indicating whether the curve should the arranged in a descending order. Defaults to FALSE.
#'
#' @return
#' @export
#'
#' @examples
plot_samplesizes <- function(df, desc = FALSE) {

  df %>%
    format_results(desc = desc) %>%
    ggplot(aes(x = specifications,
               y = obs)) +
    geom_bar(stat = "identity",
             fill = "grey",
             size = .2) +
    theme_minimal() +
    theme(
      axis.line = element_line("black", size = .5),
      legend.position = "none",
      panel.spacing = unit(.75, "lines"),
      axis.text = element_text(colour = "black")) +
    labs(x = "", y = "")
}