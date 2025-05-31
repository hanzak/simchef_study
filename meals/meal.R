# load required libraries
library(simChef)
library(future)
library(here)
library(progressr)

# set up parallelization
n_workers <- availableCores() - 1
plan(multisession, workers = n_workers)

# define the data-generating object
source(here("R/dgp/simple_dgp.R"))
simple_dgp <- create_dgp(
  .dgp_fun = simple_dgp_fun,
  .name = "Simple dgp",
)

# define the method object
source(here("R/method/tmle.R"))
tmle <- create_method(
  .method_fun = tmle_fun,
  .name = "TMLE ATE estimation"
)

# define the evaluator object
source(here("R/eval/bias_coverage.R"))
bias_coverage <- create_evaluator(
  .eval_fun = bias_coverage_fun,
  .name = "bias/coverage"
)

# define the visualizer object
source(here("R/viz/plot_bias_coverage.R"))
plot_bias_coverage <- create_visualizer(
  .viz_fun = plot_bias_coverage_fun,
  .name = "Plot bias/coverage"
)

# meal prep
experiment <- create_experiment(name = "TMLE of the ATE experiment") |>
  add_dgp(simple_dgp) |>
  add_method(tmle) |>
  add_evaluator(bias_coverage) |>
  add_visualizer(plot_bias_coverage) |>
  add_vary_across(
    .dgp = "Simple dgp",
    n=c(100, 250, 500, 750, 1000)
  )

# Document and describe the simulation experiment in text
init_docs(experiment)

# add progress bar
handlers("rstudio")

# put it in the oven
results <- with_progress(
  run_experiment(experiment, n_reps = 100, save = TRUE)
)

# Render documentation
render_docs(experiment)
