
# Data Tidying ------------------------------------------------------------

library(tidyverse)

# Compute rate per 10k
table1 |> 
  mutate(rate = cases / population * 100)

# Compute cases per year
table1 |> 
  mutate(total_cases = sum(cases))

ggplot(table1, aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000))



# Lengthening Data --------------------------------------------------------

# Data in column names

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank"
  )

billboard |> 
  pivot_longer(
    cols = !c(artist, track, date.entered), 
    names_to = "week", 
    values_to = "rank"
  )


# Drop na

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank", 
    values_drop_na = TRUE
  )

# Parsing number from mixed string
billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(week = parse_number(week))
billboard_longer
billboard_longer |> 
  ggplot(aes(week, rank, group = track)) +
  geom_line(alpha=0.25) +
  scale_y_reverse()

# Many variables in column names

colnames(who2)
who2 |> pivot_longer(
  cols = !(country:year),
  names_to = c("diagonsis", "gender", "age"),
  names_sep = "_",
  values_to = "count",
  values_drop_na = TRUE
)

# Data and variable names in the column headers

household |> 
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"),
    names_sep = "_",
    values_drop_na = TRUE
  )


# Widening Data -----------------------------------------------------------

cms_patient_experience |> 
  distinct(measure_cd, measure_title)
cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )
cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

# Explaining pivot-wide

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115, 
  "A",        "bp2",    120,
  "A",        "bp3",    105
)
df
df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )
df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "A",        "bp1",    102,
  "A",        "bp2",    120,
  "B",        "bp1",    140, 
  "B",        "bp2",    115
)
df |> 
  summarise(
    n = n(),
    .by = c(id, measurement)
  ) |> 
  filter(n >1)

df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)





