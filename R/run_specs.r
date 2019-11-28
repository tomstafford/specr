#' Run specification curve analysis
#'
#' This is the central function of the package. It can be used to run the specification curve analyses. It takes the data frame and vectors for analytical choices related to the dependent variable, the independent variable, the type of models that should be estimated, the set of covariates that should be included (none, each individually, and all together), as well as a named list of potential subsets. It returns a "result frame" which includes relevant statistics for each model as well as the analytical choices as factorial variables.
#'
#' @param df a data frame that includes all relevant variables
#' @param y a vector of the dependent variables
#' @param x a vevtor of the dependent variables
#' @param model a vector of the type of models that should be estimated.
#' @param controls a vector of the control variables that should be included. Defaults to none.
#' @param subsets a list that includes named vectors
#'
#' @return
#' @export
#'
#' @examples
#' # run specification curve analysis
#' run_specs(df = example_data,
#'           y = "y1",
#'           x = c("x1", "x2"),
#'           model = c("lm", "glm"))
#'
run_specs <- function(df, y, x, model, controls = NULL, subsets = NULL) {

  # dependencies
  require(dplyr)
  require(purrr)

  specs <- setup_specs(y = y, x = x, model = model, controls = controls)

  if (!is.null(subsets)) {

  subsets = map(subsets, as.character)

  # Create subsets and full data set, but no combination
  df_list <- create_subsets(df, subsets)
  df_list[[length(df_list)+1]] <- df %>% mutate(filter = "all")

  if (length(subsets) > 1) {

  suppressMessages({
  df_comb <- subsets %>%
    cross %>%
    map(~ create_subsets(subsets = .x, df = df) %>%
          map(~select(.x, -filter)) %>%
          reduce(inner_join) %>%
          mutate(filter = paste(names(.x), .x, collapse = " & ", sep = " = ")))

  df_all <- append(df_list, df_comb)
  })

  } else {

  df_all <- df_list

  }

  map_df(df_all, ~ run_spec(specs, .x) %>%
           mutate(subset = unique(.x$filter)))

  } else {

  run_spec(specs, df) %>%
    mutate(subset = "all")

  }

}
