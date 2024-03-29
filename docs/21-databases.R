library(DBI)
library(dbplyr)
library(tidyverse)


# Connecting and Basics ---------------------------------------------------

con <- dbConnect(duckdb::duckdb(),
  dbdir = "data/duckdb"
)

dbWriteTable(con, "mpg", ggplot2::mpg, overwrite = TRUE)
# dbDisconnect(con, shutdown = TRUE)
# con <- dbConnect(duckdb::duckdb(),
#   dbdir = "data/duckdb"
# )
dbWriteTable(con, "diamonds", ggplot2::diamonds, overwrite = TRUE)
dbListTables(con)
con |>
  dbReadTable("diamonds") |>
  as_tibble()

sql <- "
  SELECT carat, cut, clarity, color, price
  FROM diamonds
  WHERE price > 15000
"
as_tibble(dbGetQuery(con, sql))


# dbplyr basics -----------------------------------------------------------

diamonds_db <- tbl(con, "diamonds")
diamonds_db

big_diamonds_db <- diamonds_db |> 
  filter(price > 15000) |> 
  select(carat:clarity, price)

big_diamonds_db

big_diamonds_db |> 
  show_query()

big_diamonds <- big_diamonds_db |> 
  collect()
big_diamonds

# There are two other common ways to interact with a database. First, many corporate databases are very large so you need some hierarchy to keep all the tables organized. In that case you might need to supply a schema, or a catalog and a schema, in order to pick the table you’re interested in:
#
# diamonds_db <- tbl(con, in_schema("sales", "diamonds"))
# diamonds_db <- tbl(con, in_catalog("north_america", "sales", "diamonds"))
#
# Other times you might want to use your own SQL query as a starting point:
#
# diamonds_db <- tbl(con, sql("SELECT * FROM diamonds"))


# SQL ---------------------------------------------------------------------

dbplyr::copy_nycflights13(con)
flights <- tbl(con, "flights")
planes <- tbl(con, "planes")

flights |> show_query()

flights |> 
  filter(dest == "IAH") |> 
  arrange(dep_delay) |> 
  show_query()




dbDisconnect(con, shutdown=TRUE)
#

