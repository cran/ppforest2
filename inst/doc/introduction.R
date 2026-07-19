## ----setup, include = FALSE---------------------------------------------------
# Cap OpenMP to 2 threads so forest training in this vignette never uses more
# than two cores when the vignette is rebuilt under R CMD check (CRAN policy).
Sys.setenv(OMP_NUM_THREADS = "2")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5
)

## ----tree---------------------------------------------------------------------
library(ppforest2)

tree <- pptr(Species ~ ., data = iris, seed = 0)
tree

## ----tree-summary-------------------------------------------------------------
summary(tree)

## ----tree-predict-------------------------------------------------------------
preds <- predict(tree, iris)
table(predicted = preds, actual = iris$Species)

## ----forest-------------------------------------------------------------------
forest <- pprf(Species ~ ., data = iris, size = 100, n_vars = 2, seed = 0)
summary(forest)

## ----forest-predict-----------------------------------------------------------
probs <- predict(forest, iris[1:5, ], type = "prob")
probs

## ----plot-structure, eval = requireNamespace("ggplot2", quietly = TRUE)-------
# Tree structure with projected data histograms at each node
plot(tree, type = "structure")

## ----plot-importance, eval = requireNamespace("ggplot2", quietly = TRUE)------
# Variable importance bar chart
plot(tree, type = "importance")

## ----plot-projection, eval = requireNamespace("ggplot2", quietly = TRUE)------
# Data projected onto the first split's projection vector
plot(tree, type = "projection")

## ----plot-boundaries, eval = requireNamespace("ggplot2", quietly = TRUE)------
# Decision boundaries for two selected variables
plot(tree, type = "boundaries")

## ----plot-forest, eval = requireNamespace("ggplot2", quietly = TRUE)----------
plot(forest)

## ----plot-forest-tree, eval = requireNamespace("ggplot2", quietly = TRUE)-----
plot(forest, type = "structure", tree_index = 1)

## ----pda----------------------------------------------------------------------
tree_pda <- pptr(Species ~ ., data = iris, lambda = 0.5, seed = 0)
summary(tree_pda)

## ----strategies---------------------------------------------------------------
# These two calls produce identical results:
forest_shortcut <- pprf(Species ~ ., data = iris, size = 10, lambda = 0.5, n_vars = 2, seed = 0)

forest_explicit <- pprf(Species ~ ., data = iris, size = 10, pp = pp_pda(0.5), vars = vars_uniform(n_vars = 2), seed = 0)

all.equal(predict(forest_shortcut, iris), predict(forest_explicit, iris))

## ----strategies-parsnip, eval = requireNamespace("parsnip", quietly = TRUE)----
library(parsnip)

spec <- pp_rand_forest(trees = 10) |>
  set_engine("ppforest2", pp = pp_pda(0.5), vars = vars_uniform(n_vars = 2)) |>
  set_mode("classification")

fit <- spec |> fit(Species ~ ., data = iris)
predict(fit, iris[1:5, ])

## ----parsnip, eval = requireNamespace("parsnip", quietly = TRUE)--------------
library(parsnip)

# Single tree
spec <- pp_tree(penalty = 0.5) |>
  set_engine("ppforest2") |>
  set_mode("classification")

fit <- spec |> fit(Species ~ ., data = iris)
predict(fit, iris[1:5, ])

## ----parsnip-forest, eval = requireNamespace("parsnip", quietly = TRUE)-------
# Random forest
spec <- pp_rand_forest(trees = 50, mtry = 2, penalty = 0.5) |>
  set_engine("ppforest2") |>
  set_mode("classification")

fit <- spec |> fit(Species ~ ., data = iris)
predict(fit, iris[1:5, ], type = "prob")

