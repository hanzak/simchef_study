###
# Non linear model with binary and continuous confounders
###

simple_dgp_fun <- function(n=1000){
  ## Taken from https://www.khstats.com/blog/tmle/tutorial-pt2 and modified to
  ## include potential outcome and true ATE.
  W1 <- rbinom(n, size=1, prob=0.2) # binary confounder
  W2 <- rbinom(n, size=1, prob=0.5) # binary confounder
  W3 <- round(runif(n, min=2, max=7)) # continuous confounder
  W4 <- round(runif(n, min=0, max=4)) # continuous confounder

  pY1 <- plogis(-1 + 1 - 0.1*W1 + 0.2*W2 + 0.3*W3 - 0.1*W4 + sin(0.1*W2*W4))
  pY0 <- plogis(-1 + 0 - 0.1*W1 + 0.2*W2 + 0.3*W3 - 0.1*W4 + sin(0.1*W2*W4))
  Y1 <- rbinom(n, size=1, prob=pY1)
  Y0 <- rbinom(n, size=1, prob=pY0)

  true_ATE <- mean(pY1 - pY0)

  pA <- plogis(-0.2 + 0.2*W2 + log(0.1*W3) + 0.3*W4 + 0.2*W1*W4)
  A <- rbinom(n, size=1, prob=pA)

  pY <- plogis(-1 + A - 0.1*W1 + 0.2*W2 + 0.3*W3 - 0.1*W4 + sin(0.1*W2*W4))
  Y <- rbinom(n, size=1, prob=pY)

  X <- as.data.frame(cbind(A, W1, W2, W3, W4))

  return(list(
    X=X,
    Y=Y,
    true_ATE=true_ATE))
}
