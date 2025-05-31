###
# Visualize relative absolute bias and coverage as line plots
###

plot_bias_coverage_fun <- function(eval_results) {
  df <- eval_results[["bias/coverage"]]

  df_long <- df |> tidyr::pivot_longer(cols=c(coverage, abs_relative_bias), names_to="metric", values_to="value")

  plt <- ggplot2::ggplot(df_long, ggplot2::aes(x=n, y=value, color=metric)) +
    ggplot2::geom_point() +
    ggplot2::geom_line() +
    ggplot2::theme_minimal()
  return(plt)
}

