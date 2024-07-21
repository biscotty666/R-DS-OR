

```r
library(DBI)
library(dbplyr)
library(tidyverse)
```

```
## ── Attaching core tidyverse packages ────────────────────────────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.4     ✔ readr     2.1.5
## ✔ forcats   1.0.0     ✔ stringr   1.5.1
## ✔ ggplot2   3.5.0     ✔ tibble    3.2.1
## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
## ✔ purrr     1.0.2     
## ── Conflicts ──────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::ident()  masks dbplyr::ident()
## ✖ dplyr::lag()    masks stats::lag()
## ✖ dplyr::sql()    masks dbplyr::sql()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

```r
# Connecting and Basics ---------------------------------------------------

con <- dbConnect(duckdb::duckdb(),
  dbdir = "data/duckdb"
)
```

```
## Warning in file(con, "w"): cannot open file 'data/duckdb': No such file or directory
```

```
## Error in file(con, "w"): cannot open the connection
```

```r
dbWriteTable(con, "mpg", ggplot2::mpg, overwrite = TRUE)
```

```
## Error in h(simpleError(msg, call)): error in evaluating the argument 'conn' in selecting a method for function 'dbWriteTable': object 'con' not found
```

```r
# dbDisconnect(con, shutdown = TRUE)
# con <- dbConnect(duckdb::duckdb(),
#   dbdir = "data/duckdb"
# )
dbWriteTable(con, "diamonds", ggplot2::diamonds, overwrite = TRUE)
```

```
## Error in h(simpleError(msg, call)): error in evaluating the argument 'conn' in selecting a method for function 'dbWriteTable': object 'con' not found
```

```r
dbListTables(con)
```

```
## Error in h(simpleError(msg, call)): error in evaluating the argument 'conn' in selecting a method for function 'dbListTables': object 'con' not found
```

```r
con |>
  dbReadTable("diamonds") |>
  as_tibble()
```

```
## Error in h(simpleError(msg, call)): error in evaluating the argument 'conn' in selecting a method for function 'dbReadTable': object 'con' not found
```

```r
sql <- "
  SELECT carat, cut, clarity, color, price
  FROM diamonds
  WHERE price > 15000
"
as_tibble(dbGetQuery(con, sql))
```

```
## Error in h(simpleError(msg, call)): error in evaluating the argument 'conn' in selecting a method for function 'dbGetQuery': object 'con' not found
```

```r
# dbplyr basics -----------------------------------------------------------

diamonds_db <- tbl(con, "diamonds")
```

```
## Error in eval(expr, envir, enclos): object 'con' not found
```

```r
diamonds_db
```

```
## Error in eval(expr, envir, enclos): object 'diamonds_db' not found
```

```r
big_diamonds_db <- diamonds_db |> 
  filter(price > 15000) |> 
  select(carat:clarity, price)
```

```
## Error in eval(expr, envir, enclos): object 'diamonds_db' not found
```

```r
big_diamonds_db
```

```
## Error in eval(expr, envir, enclos): object 'big_diamonds_db' not found
```

```r
big_diamonds_db |> 
  show_query()
```

```
## Error in eval(expr, envir, enclos): object 'big_diamonds_db' not found
```

```r
big_diamonds <- big_diamonds_db |> 
  collect()
```

```
## Error in eval(expr, envir, enclos): object 'big_diamonds_db' not found
```

```r
big_diamonds
```

```
## Error in eval(expr, envir, enclos): object 'big_diamonds' not found
```

```r
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
```

```
## Error in h(simpleError(msg, call)): error in evaluating the argument 'conn' in selecting a method for function 'dbListTables': object 'con' not found
```

```r
flights <- tbl(con, "flights")
```

```
## Error in eval(expr, envir, enclos): object 'con' not found
```

```r
planes <- tbl(con, "planes")
```

```
## Error in eval(expr, envir, enclos): object 'con' not found
```

```r
flights |> show_query()
```

```
## Error in eval(expr, envir, enclos): object 'flights' not found
```

```r
flights |> 
  filter(dest == "IAH") |> 
  arrange(dep_delay) |> 
  show_query()
```

```
## Error in eval(expr, envir, enclos): object 'flights' not found
```

```r
dbDisconnect(con, shutdown=TRUE)
```

```
## Error in h(simpleError(msg, call)): error in evaluating the argument 'conn' in selecting a method for function 'dbDisconnect': object 'con' not found
```

```r
#
```

