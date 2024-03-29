library(tidyverse)
library(arrow)
library(dbplyr, warn.conflicts = FALSE)
library(duckdb)

# curl::multi_download(
#   "https://r4ds.s3.us-west-2.amazonaws.com/seattle-library-checkouts.csv",
#   "data/seattle-library-checkouts.csv",
#   resume = TRUE
# )

seattle_csv <- open_dataset(
  sources = "data/seattle-library-checkouts.csv",
  col_types = schema(ISBN = string()),
  format = "csv"
)
# 
# seattle_csv
# seattle_csv |> glimpse()
# 
# seattle_csv |> 
#   group_by(CheckoutYear) |>
#   summarise(Checkouts = sum(Checkouts)) |> 
#   arrange(CheckoutYear) |> 
#   collect()

pq_path <- "data/seattle-library-checkouts"

# seattle_csv |> 
#   group_by(CheckoutYear) |> 
#   write_dataset(path = pq_path, format="parquet")

tibble(
  files = list.files(pq_path, recursive = TRUE),
  size_MB = file.size(file.path(pq_path, files)) / 1024^2
)

seattle_pq <- open_dataset(pq_path)

query <- seattle_pq |> 
  filter(CheckoutYear >= 2018, MaterialType == "BOOK") |> 
  group_by(CheckoutYear, CheckoutMonth) |>
  summarise(TotalCheckouts = sum(Checkouts)) |> 
  arrange(CheckoutYear, CheckoutMonth)
query
query |> collect()

seattle_csv |> 
  filter(CheckoutYear == 2021, MaterialType == "BOOK") |>
  group_by(CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutMonth)) |>
  collect() |> 
  system.time()

seattle_pq |> 
  filter(CheckoutYear == 2021, MaterialType == "BOOK") |>
  group_by(CheckoutMonth) |>
  summarize(TotalCheckouts = sum(Checkouts)) |>
  arrange(desc(CheckoutMonth)) |>
  collect() |> 
  system.time()

seattle_pq |>
  to_duckdb() |> 
  filter(CheckoutYear >= 2018, MaterialType == "BOOK") |> 
  group_by(CheckoutYear) |> 
  summarise(TotalCheckouts = sum(Checkouts)) |> 
  arrange(desc(CheckoutYear)) |> 
  collect()







