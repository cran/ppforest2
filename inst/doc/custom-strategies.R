## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----inspect------------------------------------------------------------------
library(ppforest2)

pp_pda(0.5)
vars_uniform(n_vars = 2)
cutpoint_mean_of_means()

## ----eval = FALSE-------------------------------------------------------------
# #' My custom projection pursuit strategy.
# #'
# #' @param alpha A tuning parameter.
# #' @return A \code{pp_strategy} object.
# #' @export
# pp_my_method <- function(alpha = 1.0) {
#   if (!is.numeric(alpha) || length(alpha) != 1)
#     stop("`alpha` must be a single number.")
# 
#   structure(
#     list(name = "my_method", display_name = "My method", alpha = alpha),
#     class = "pp_strategy"
#   )
# }

## ----eval = FALSE-------------------------------------------------------------
# # Single tree
# tree <- pptr(Species ~ ., data = iris, pp = pp_my_method(alpha = 0.5))
# 
# # Forest
# forest <- pprf(Species ~ ., data = iris, pp = pp_my_method(alpha = 0.5), vars = vars_uniform(n_vars = 2))
# 
# # Summary shows the strategy
# summary(tree)

