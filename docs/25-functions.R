
# Functions ---------------------------------------------------------------

library(tidyverse)
library(nycflights13)


# Vector functions --------------------------------------------------------

df <- tibble(
  a = rnorm(5),
  b = rnorm(5),
  c = rnorm(5),
  d = rnorm(5),
)

df |> 
  mutate(
    a = (a - min(a, na.rm = TRUE)) /
      (max(a, na.rm = TRUE) - min(a, na.rm = TRUE)),
    b = (b - min(b, na.rm = TRUE)) /
      (max(b, na.rm = TRUE) - min(b, na.rm = TRUE)),
    c = (c - min(c, na.rm = TRUE)) /
      (max(c, na.rm = TRUE) - min(c, na.rm = TRUE)),
    d = (d - min(d, na.rm = TRUE)) /
      (max(d, na.rm = TRUE) - min(d, na.rm = TRUE)),
  )

rescale01 <- function(x) {
  (x - min(x, na.rm = TRUE)) /
    (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
}
rescale01(c(-10, 0, 10))
rescale01(c(1, 2, 3, NA, 5))

df |> mutate(
  a = rescale01(a),
  b = rescale01(b),
  c = rescale01(c),
  d = rescale01(d)
)

## Improvement

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
x <- c(1:10, Inf)
rescale01(x)

# Exclude infinite values
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(x)



# Mutate functions --------------------------------------------------------

## Calculating a z-score

z_score <- function(x) {
  (x - mean(x, na.rm = TRUE)) / sd(x, na.rm = TRUE)
}

## Ensure all values lie in a given range

clamp <- function(x, min, max) {
  case_when(
    x < min ~ min,
    x > max ~ max,
    .default = x
  )
}
clamp(1:10, min = 3, max = 7)

## Capitalize first letter

first_upper <- function(x) {
  str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
  x
}
first_upper("hello")

## Remove dollar signs, percents and commas from around a number
clean_number <- function(x) {
  is_pct <- str_detect(x, "%")
  num <- x |> 
    str_remove_all("%") |> 
    str_remove_all(",") |> 
    str_remove_all(fixed("$")) |> 
    as.numeric()
  if_else(is_pct, num / 100, num)
}
clean_number("$12,300")
clean_number("45%")


# Summary functions -------------------------------------------------------

## Coefficient of variation

cv <- function(x, na.rm = FALSE) {
  sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)
}
cv(runif(100, min = 0, max = 50))
cv(runif(100, min = 0, max = 500))

## Mean absolute percentage error

mape <- function(actual, predicted) {
  sum(abs((actual - predicted) / actual)) / length(actual)
}


# Data frame functions ----------------------------------------------------

## Indirection and tidy evaluation

grouped_mean <- function(df, group_var, mean_var) {
  df |> 
    group_by({{group_var}}) |> 
    summarise(mean({{mean_var}}))
}

diamonds |> grouped_mean(cut, carat)

## Basic summary
summary6 <- function(data, var) {
  data |> summarise(
    min = min({{ var }}, na.rm = TRUE),
    meam = mean({{ var }}, na.rm = TRUE),
    median = median({{ var }}, na.rm = TRUE),
    max = max({{ var }}, na.rm = TRUE),
    n = n(),
    n_miss = sum(is.na({{ var }})),
    .groups = "drop"
  )
}

diamonds |> summary6(carat)

# (Whenever you wrap summarize() in a helper, we think it’s good practice
# to set .groups = "drop" to both avoid the message and leave the data in 
# an ungrouped state.)

diamonds |> 
  group_by(cut) |> 
  summary6(carat)

diamonds |> 
  group_by(cut) |> 
  summary6(log10(carat))

count_prop <- function(df, var, sort = FALSE) {
  df |>
    count({{ var }}, sort = sort) |>
    mutate(prop = n / sum(n))
}

diamonds |> count_prop(clarity)

## pick()

count_missing <- function(df, group_vars, x_var) {
  df |> 
    group_by({{ group_vars }}) |> 
    summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}

subset_flights <- function(rows, cols) {
  flights |> 
    filter({{ rows }}) |> 
    select(time_hour, carrier, flight, {{ cols }})
}

count_missing <- function(df, group_vars, x_var) {
  df |> 
    group_by(pick({{ group_vars }})) |> 
    summarize(
      n_miss = sum(is.na({{ x_var }})),
      .groups = "drop"
    )
}


flights |> 
  count_missing(c(year, month, day), dep_time)

## 2-d table of counts
count_wide <- function(data, rows, cols) {
  data |> 
    count(pick(c({{ rows }}, {{ cols }}))) |> 
    pivot_wider(
      names_from = {{ cols }}, 
      values_from = n,
      names_sort = TRUE,
      values_fill = 0
    )
}
diamonds |> count_wide(c(clarity, color), cut)


# Plot functions ----------------------------------------------------------

histogram <- function(df, var, binwidth = NULL) {
  df |> 
    ggplot(aes(x = {{ var }})) + 
    geom_histogram(binwidth = binwidth)
}

diamonds |> histogram(carat, 0.1)

linearity_check <- function(df, x, y) {
  df |> 
    ggplot(aes(x = {{ x }}, y = {{ y }})) +
    geom_point() +
    geom_smooth(method = "loess", formula = y ~ x, 
                color = "red", se = FALSE) +
    geom_smooth(method = "lm", formula = y ~ x, 
                color = "blue", se = FALSE) 
}
starwars |> 
  filter(mass < 1000) |> 
  linearity_check(mass, height)








