###
# Evaluates absolute relative bias and coverage of the ATE
###
library(dplyr)

bias_coverage_fun <- function(fit_results){
  out <- fit_results |>
    dplyr::group_by(n) |>
    dplyr::summarise(
      abs_relative_bias = mean(abs((estimated_ATE - true_ATE)/true_ATE)),
      coverage = mean((true_ATE >= ci_low) & (true_ATE <= ci_high)),
    )

  return(data.frame(
    n=unique(fit_results$n),
    abs_relative_bias=out$abs_relative_bias,
    coverage=out$coverage)
  )
}
