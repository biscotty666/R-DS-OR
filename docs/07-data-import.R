library(tidyverse)

# students <- read_csv("https://pos.it/r4ds-students-csv")
students <- read_csv("data/students.csv")

# It seems 
students <- read_csv("data/students.csv", na = c("N/A", ""))

students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

# CLEAN NAMES
students |> janitor::clean_names()

students |> 
  janitor::clean_names() |> 
  mutate(meal_plan = factor(meal_plan))

students |> 
  janitor::clean_names() |> 
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )


# Problems ----------------------------------------------------------------

read_csv("
  logical,numeric,date,string
  TRUE,1,2021-01-15,abc
  false,4.5,2021-02-15,def
  T,Inf,2021-02-16,ghi
")
simple_csv <- "
  x
  10
  .
  20
  30"
df <- read_csv(
  simple_csv,
  col_types = list(x = col_double())
)
problems(df)
df <- read_csv(
  simple_csv,
  col_types = list(x = col_double()),
  na = "."
)

another_csv <- "
x,y,z
1,2,3"
read_csv(another_csv,
         col_types = cols(.default = col_character()))


# READING MULTIPLE FILES

sales_files <- c(
  "data/01-sales.csv",
  "data/02-sales.csv",
  "data/03-sales.csv"
)
read_csv(sales_files, id = "file")

sales_files <- list.files("data", pattern = "sales\\.csv$",
           full.names = TRUE)
read_csv(sales_files, id = "file")
sales <- read_csv(sales_files, id = "file")
write_csv(sales, "data/sales.csv")


# Data Formats ------------------------------------------------------------

# R Binary format
write_rds(sales, "data/sales.rds")

# Parquet
library(arrow)
write_parquet(sales, "data/sales.parquet")






