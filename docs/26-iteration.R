# Iteration ---------------------------------------------------------------

library(tidyverse)


# Modifying multiple columns ----------------------------------------------

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

## Compute the median of every column

df |> summarise(
  n = n(),
  across(a:d, median),
)

## Selecting columns
df <- tibble(
  grp = sample(2, 10, replace = TRUE),
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df |>
  group_by(grp) |>
  summarise(across(everything(), median))

## Function argument

rnorm_na <- function(n, n_na, mean = 0, sd = 1) {
  sample(c(rnorm(n - n_na, mean = mean, sd = sd), rep(NA, n_na)))
}
df_miss <- tibble(
  a = rnorm_na(5, 1),
  b = rnorm_na(5, 1),
  c = rnorm_na(5, 2),
  d = rnorm(5)
)
df_miss |>
  summarise(
    across(a:d, median),
    n = n()
  )
df_miss |>
  summarise(
    across(a:d, \(x) median(x, na.rm = TRUE)),
    n = n()
  )
df_miss |>
  summarize(
    across(a:d, list(
      median = \(x) median(x, na.rm = TRUE),
      n_miss = \(x) sum(is.na(x))
    )),
    n = n()
  )

## Column names
df_miss |>
  summarize(
    across(
      a:d,
      list(
        median = \(x) median(x, na.rm = TRUE),
        n_miss = \(x) sum(is.na(x))
      ),
      .names = "{.fn}_{.col}"
    ),
    n = n()
  )
df_miss |> 
  mutate(
    across(a:d, \(x) coalesce(x, 0))
  )
df_miss |> 
  mutate(
    across(a:d, \(x) coalesce(x, 0),
           .names = "{.col}_na_zero")
  )

## Filtering

df_miss |> filter(if_any(a:d, is.na))
df_miss |> filter(if_all(a:d, is.na))

## across() in functions

### Expand all date columns to year, month and day









