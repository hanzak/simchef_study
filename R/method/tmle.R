###
# TMLE method function to estimate the ATE and get CI.
###
tmle_fun <- function(X, Y, true_ATE) {
  A <- X |> dplyr::pull(A)
  W <- X |> dplyr::select(!A)

  outcome_superLearner <- tmleR::SuperLearner$new(X=X, Y=Y)
  propensity_superLearner <- tmleR::SuperLearner$new(X=W, Y=A)

  outcome_superLearner$learn()
  propensity_superLearner$learn()

  tmle <- tmleR::TMLE$new(
    W_A=X,
    Y=Y,
    outcome_superLearner=outcome_superLearner,
    propensity_superLearner=propensity_superLearner
  )

  out <- tmle$compute_ATE()
  estimated_ATE <- out$estimated_ATE
  ci_low <- out$ci_low
  ci_high <- out$ci_high
  return(list(estimated_ATE=estimated_ATE, ci_low=ci_low, ci_high=ci_high, true_ATE=true_ATE))
}
