library(tidyverse)
library(repurrrsive)
library(jsonlite)


# Lists -------------------------------------------------------------------

x1 <- list(1:4, "a", TRUE)
x1

x2 <- list(a = 1:2, b = 1:3, c = 1:4)
x2

str(x1)
str(x2)

## Hierarchy

x3 <- list(list(1, 2), list(3, 4))
str(x3)

### Difference to c()

x4 <- c(list(1,2), list(3,4))
str(x4)

### Working with deeply nested lists

x5 <- list(1, list(2, list(3, list(4, list(5)))))
str(x5)
View(x5)

### List columns
df <- tibble(
  x = 1:2,
  y = c("a", "b"),
  z = list(list(1,2), list(3, 4, 5))
)
df
df |> filter(x == 1)


# Unnesting ---------------------------------------------------------------

df1 <- tribble(
  ~x, ~y,
  1, list(a = 11, b = 12),
  2, list(a = 21, b = 22),
  3, list(a = 31, b = 32)
)
df1
dftest <- tibble(
  x = c(1, 2, 3),
  y = list(list(a = 11, b = 12),list(a = 21, b = 22),list(a = 31, b = 32))
)
dftest
df1[1] == dftest[1]


df2 <- tribble(
  ~x, ~y,
  1, list(11, 12, 13),
  2, list(21),
  3, list(31, 32),
)

## unnest_wider() for named lists
df1 |> 
  unnest_wider(y)
df1 |> 
  unnest_wider(y, names_sep = "_")

## unnest_longer() for unnamed lists
df2 |> 
  unnest_longer(y)

## use keep_empty = TRUE to avoid dropping rows
df6 <- tribble(
  ~x, ~y,
  "a", list(1, 2),
  "b", list(3),
  "c", list()
)
df6 |> unnest_longer(y)
df6 |> unnest_longer(y, keep_empty = TRUE)

### Inconsistent types
df4 <- tribble(
  ~x, ~y,
  "a", list(1),
  "b", list("a", TRUE, 5)
)
df4 |> unnest_longer(y)


# Case studies ------------------------------------------------------------

## Very wide data
repos <- tibble(json = gh_repos)
repos

# This tibble contains 6 rows, one row for each child of gh_repos. Each 
# row contains a unnamed list with either 26 or 30 rows. 

repos |> unnest_longer(json)
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json)

repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  names() |> 
  head(10)

repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description)

# This produces an error due to conflict in id columns
# repos |> 
#   unnest_longer(json) |> 
#   unnest_wider(json) |> 
#   select(id, full_name, owner, description) |> 
#   unnest_wider(owner)
repos |> 
  unnest_longer(json) |> 
  unnest_wider(json) |> 
  select(id, full_name, owner, description) |> 
  unnest_wider(owner, names_sep = "_")

## Relational Data

chars <- tibble(json = got_chars)
chars

characters <- chars |> 
  unnest_wider(json) |> 
  select(id, name, gender, culture, born, died, alive)
characters

chars |> 
  unnest_wider(json) |> 
  select(id, where(is.list))

chars |> 
  unnest_wider(json) |> 
  select(id, titles) |> 
  unnest_longer(titles)
titles <- chars |> 
  unnest_wider(json) |> 
  select(id, titles) |> 
  unnest_longer(titles) |> 
  filter(titles != "") |> 
  rename(title = titles)
titles

## Deeply nested

gmaps_cities
gmaps_cities |> 
  unnest_wider(json)

gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results)

locations <- gmaps_cities |> 
  unnest_wider(json) |> 
  select(-status) |> 
  unnest_longer(results) |>
  unnest_wider(results)
locations
# There are a few different places we could go from here. 
# We might want to determine the exact location of the match, 
# which is stored in the geometry list-column:

locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry)

# unnest lat and lon from location
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |>
  unnest_wider(location)

# unnest bounds
locations |> 
  select(city, formatted_address, geometry) |> 
  unnest_wider(geometry) |>
  select(!location:viewport) |> 
  unnest_wider(bounds) |> 
  rename(ne = northeast, sw = southwest) |> 
  unnest_wider(c(ne, sw), names_sep = "_")

# hoist()
locations |> 
  select(city, formatted_address, geometry) |> 
  hoist(
    geometry,
    ne_lat = c("bounds", "northeast", "lat"),
    sw_lat = c("bounds", "southwest", "lat"),
    ne_lng = c("bounds", "northeast", "lng"),
    sw_lng = c("bounds", "southwest", "lng"),
  )
  

# JSON --------------------------------------------------------------------

# jsonlite
gh_users_json()
gh_users2 <- read_json(gh_users_json())
identical(gh_users, gh_users2)

str(parse_json('1'))
str(parse_json('[1, 2, 3]'))
str(parse_json('{"x": [1, 2, 3]}'))

json <- '[
  {"name": "John", "age": 34},
  {"name": "Susan", "age": 27}
]'
tibble(json = parse_json(json)) |> 
  unnest_wider(json)
json <- '{
  "status": "OK", 
  "results": [
    {"name": "John", "age": 34},
    {"name": "Susan", "age": 27}
 ]
}
'
df <- tibble(json = list(parse_json(json)))
df
df |> 
  unnest_wider(json) |> 
  unnest_longer(results) |> 
  unnest_wider(results)

# or...
df <- tibble(results = parse_json(json)$results)
df
df |> unnest_wider(results)
