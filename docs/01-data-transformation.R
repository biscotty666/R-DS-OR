library(nycflights13)
library(tidyverse)
flights
glimpse(flights)

flights |>
  filter(dest == "IAH") |>
  group_by(year, month, day) |>
  summarise(
    arr_delay = mean(arr_delay, na.rm = TRUE)
  )

# Flights that departed January 1

flights |>
  filter(month == 1, day == 1)

flights |>
  filter(month == 1 & day == 1)

flights |>
  arrange(desc(arr_delay))

flights |>
  distinct(origin, dest)

flights |>
  distinct(origin, dest, .keep_all = TRUE)

flights |>
  count(origin, dest, sort = TRUE)

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )

## ADD NEW VARIABLES AT THE LEFT

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 4
  )

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

flights |>
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time * 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )


# select all columns that are characters

flights |>
  select(where(is.character))

flights |>
  select(tail_num = tailnum)

# Rename columns

flights |>
  rename(tail_num = tailnum)


# Move columns to front

flights |>
  relocate(arr_time, day)

flights |>
  relocate(dep_time:arr_time, .before = year)

## Groups

flights |>
  group_by(month) |>
  summarise(
    avg_delay = mean(dep_delay)
  )


flights |>
  group_by(month) |>
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE)
  )

# --- function n() returns number of rows in each group

flights |>
  group_by(month) |>
  summarise(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

# --- slice_head, slice_tail, slice_min, slice_max, slice_sample

flights |>
  group_by(dest) |>
  slice_max(arr_delay, n = 1) |>
  relocate(dest)

flights |>
  group_by(dest) |>
  slice_max(arr_delay, n = 2) |>
  relocate(dest, origin)

flights |>
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  )
batters <- Lahman::Batting
glimpse(batters)
batters |>
  slice_sample(n = 12)

batters <- Lahman::Batting |>
  group_by(playerID) |>
  summarise(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )
batters
batters |>
  filter(n > 100) |>
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 0.1) +
  geom_smooth(se = FALSE)
