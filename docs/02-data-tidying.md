``` r
# Data Tidying ------------------------------------------------------------

library(tidyverse)

# Compute rate per 10k
table1 |> 
  mutate(rate = cases / population * 100)
```

```         
## # A tibble: 6 × 5
##   country      year  cases population    rate
##   <chr>       <dbl>  <dbl>      <dbl>   <dbl>
## 1 Afghanistan  1999    745   19987071 0.00373
## 2 Afghanistan  2000   2666   20595360 0.0129 
## 3 Brazil       1999  37737  172006362 0.0219 
## 4 Brazil       2000  80488  174504898 0.0461 
## 5 China        1999 212258 1272915272 0.0167 
## 6 China        2000 213766 1280428583 0.0167
```

``` r
# Compute cases per year
table1 |> 
  mutate(total_cases = sum(cases))
```

```         
## # A tibble: 6 × 5
##   country      year  cases population total_cases
##   <chr>       <dbl>  <dbl>      <dbl>       <dbl>
## 1 Afghanistan  1999    745   19987071      547660
## 2 Afghanistan  2000   2666   20595360      547660
## 3 Brazil       1999  37737  172006362      547660
## 4 Brazil       2000  80488  174504898      547660
## 5 China        1999 212258 1272915272      547660
## 6 China        2000 213766 1280428583      547660
```

``` r
ggplot(table1, aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000))
```

![plot of chunk unnamed-chunk-1](figure/data-tidying-1.png)

``` r
# Lengthening Data --------------------------------------------------------

# Data in column names

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank"
  )
```

```         
## # A tibble: 24,092 × 5
##    artist track                   date.entered week   rank
##    <chr>  <chr>                   <date>       <chr> <dbl>
##  1 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk1      87
##  2 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk2      82
##  3 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk3      72
##  4 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk4      77
##  5 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk5      87
##  6 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk6      94
##  7 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk7      99
##  8 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk8      NA
##  9 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk9      NA
## 10 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk10     NA
## # ℹ 24,082 more rows
```

``` r
billboard |> 
  pivot_longer(
    cols = !c(artist, track, date.entered), 
    names_to = "week", 
    values_to = "rank"
  )
```

```         
## # A tibble: 24,092 × 5
##    artist track                   date.entered week   rank
##    <chr>  <chr>                   <date>       <chr> <dbl>
##  1 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk1      87
##  2 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk2      82
##  3 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk3      72
##  4 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk4      77
##  5 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk5      87
##  6 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk6      94
##  7 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk7      99
##  8 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk8      NA
##  9 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk9      NA
## 10 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk10     NA
## # ℹ 24,082 more rows
```

``` r
# Drop na

billboard |> 
  pivot_longer(
    cols = starts_with("wk"), 
    names_to = "week", 
    values_to = "rank", 
    values_drop_na = TRUE
  )
```

```         
## # A tibble: 5,307 × 5
##    artist  track                   date.entered week   rank
##    <chr>   <chr>                   <date>       <chr> <dbl>
##  1 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk1      87
##  2 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk2      82
##  3 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk3      72
##  4 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk4      77
##  5 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk5      87
##  6 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk6      94
##  7 2 Pac   Baby Don't Cry (Keep... 2000-02-26   wk7      99
##  8 2Ge+her The Hardest Part Of ... 2000-09-02   wk1      91
##  9 2Ge+her The Hardest Part Of ... 2000-09-02   wk2      87
## 10 2Ge+her The Hardest Part Of ... 2000-09-02   wk3      92
## # ℹ 5,297 more rows
```

``` r
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
```

```         
## # A tibble: 5,307 × 5
##    artist  track                   date.entered  week  rank
##    <chr>   <chr>                   <date>       <dbl> <dbl>
##  1 2 Pac   Baby Don't Cry (Keep... 2000-02-26       1    87
##  2 2 Pac   Baby Don't Cry (Keep... 2000-02-26       2    82
##  3 2 Pac   Baby Don't Cry (Keep... 2000-02-26       3    72
##  4 2 Pac   Baby Don't Cry (Keep... 2000-02-26       4    77
##  5 2 Pac   Baby Don't Cry (Keep... 2000-02-26       5    87
##  6 2 Pac   Baby Don't Cry (Keep... 2000-02-26       6    94
##  7 2 Pac   Baby Don't Cry (Keep... 2000-02-26       7    99
##  8 2Ge+her The Hardest Part Of ... 2000-09-02       1    91
##  9 2Ge+her The Hardest Part Of ... 2000-09-02       2    87
## 10 2Ge+her The Hardest Part Of ... 2000-09-02       3    92
## # ℹ 5,297 more rows
```

``` r
billboard_longer |> 
  ggplot(aes(week, rank, group = track)) +
  geom_line(alpha=0.25) +
  scale_y_reverse()
```

![plot of chunk unnamed-chunk-1](figure/data-tidying-2.png)

``` r
# Many variables in column names

colnames(who2)
```

```         
##  [1] "country"    "year"       "sp_m_014"   "sp_m_1524"  "sp_m_2534"  "sp_m_3544" 
##  [7] "sp_m_4554"  "sp_m_5564"  "sp_m_65"    "sp_f_014"   "sp_f_1524"  "sp_f_2534" 
## [13] "sp_f_3544"  "sp_f_4554"  "sp_f_5564"  "sp_f_65"    "sn_m_014"   "sn_m_1524" 
## [19] "sn_m_2534"  "sn_m_3544"  "sn_m_4554"  "sn_m_5564"  "sn_m_65"    "sn_f_014"  
## [25] "sn_f_1524"  "sn_f_2534"  "sn_f_3544"  "sn_f_4554"  "sn_f_5564"  "sn_f_65"   
## [31] "ep_m_014"   "ep_m_1524"  "ep_m_2534"  "ep_m_3544"  "ep_m_4554"  "ep_m_5564" 
## [37] "ep_m_65"    "ep_f_014"   "ep_f_1524"  "ep_f_2534"  "ep_f_3544"  "ep_f_4554" 
## [43] "ep_f_5564"  "ep_f_65"    "rel_m_014"  "rel_m_1524" "rel_m_2534" "rel_m_3544"
## [49] "rel_m_4554" "rel_m_5564" "rel_m_65"   "rel_f_014"  "rel_f_1524" "rel_f_2534"
## [55] "rel_f_3544" "rel_f_4554" "rel_f_5564" "rel_f_65"
```

``` r
who2 |> pivot_longer(
  cols = !(country:year),
  names_to = c("diagonsis", "gender", "age"),
  names_sep = "_",
  values_to = "count",
  values_drop_na = TRUE
)
```

```         
## # A tibble: 76,046 × 6
##    country      year diagonsis gender age   count
##    <chr>       <dbl> <chr>     <chr>  <chr> <dbl>
##  1 Afghanistan  1997 sp        m      014       0
##  2 Afghanistan  1997 sp        m      1524     10
##  3 Afghanistan  1997 sp        m      2534      6
##  4 Afghanistan  1997 sp        m      3544      3
##  5 Afghanistan  1997 sp        m      4554      5
##  6 Afghanistan  1997 sp        m      5564      2
##  7 Afghanistan  1997 sp        m      65        0
##  8 Afghanistan  1997 sp        f      014       5
##  9 Afghanistan  1997 sp        f      1524     38
## 10 Afghanistan  1997 sp        f      2534     36
## # ℹ 76,036 more rows
```

``` r
# Data and variable names in the column headers

household |> 
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"),
    names_sep = "_",
    values_drop_na = TRUE
  )
```

```         
## # A tibble: 9 × 4
##   family child  dob        name  
##    <int> <chr>  <date>     <chr> 
## 1      1 child1 1998-11-26 Susan 
## 2      1 child2 2000-01-29 Jose  
## 3      2 child1 1996-06-22 Mark  
## 4      3 child1 2002-07-11 Sam   
## 5      3 child2 2004-04-05 Seth  
## 6      4 child1 2004-10-10 Craig 
## 7      4 child2 2009-08-27 Khai  
## 8      5 child1 2000-12-05 Parker
## 9      5 child2 2005-02-28 Gracie
```

``` r
# Widening Data -----------------------------------------------------------

cms_patient_experience |> 
  distinct(measure_cd, measure_title)
```

```         
## # A tibble: 6 × 2
##   measure_cd   measure_title                                                         
##   <chr>        <chr>                                                                 
## 1 CAHPS_GRP_1  CAHPS for MIPS SSM: Getting Timely Care, Appointments, and Information
## 2 CAHPS_GRP_2  CAHPS for MIPS SSM: How Well Providers Communicate                    
## 3 CAHPS_GRP_3  CAHPS for MIPS SSM: Patient's Rating of Provider                      
## 4 CAHPS_GRP_5  CAHPS for MIPS SSM: Health Promotion and Education                    
## 5 CAHPS_GRP_8  CAHPS for MIPS SSM: Courteous and Helpful Office Staff                
## 6 CAHPS_GRP_12 CAHPS for MIPS SSM: Stewardship of Patient Resources
```

``` r
cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )
```

```         
## # A tibble: 500 × 9
##    org_pac_id org_nm    measure_title CAHPS_GRP_1 CAHPS_GRP_2 CAHPS_GRP_3 CAHPS_GRP_5
##    <chr>      <chr>     <chr>               <dbl>       <dbl>       <dbl>       <dbl>
##  1 0446157747 USC CARE… CAHPS for MI…          63          NA          NA          NA
##  2 0446157747 USC CARE… CAHPS for MI…          NA          87          NA          NA
##  3 0446157747 USC CARE… CAHPS for MI…          NA          NA          86          NA
##  4 0446157747 USC CARE… CAHPS for MI…          NA          NA          NA          57
##  5 0446157747 USC CARE… CAHPS for MI…          NA          NA          NA          NA
##  6 0446157747 USC CARE… CAHPS for MI…          NA          NA          NA          NA
##  7 0446162697 ASSOCIAT… CAHPS for MI…          59          NA          NA          NA
##  8 0446162697 ASSOCIAT… CAHPS for MI…          NA          85          NA          NA
##  9 0446162697 ASSOCIAT… CAHPS for MI…          NA          NA          83          NA
## 10 0446162697 ASSOCIAT… CAHPS for MI…          NA          NA          NA          63
## # ℹ 490 more rows
## # ℹ 2 more variables: CAHPS_GRP_8 <dbl>, CAHPS_GRP_12 <dbl>
```

``` r
cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )
```

```         
## # A tibble: 95 × 8
##    org_pac_id org_nm      CAHPS_GRP_1 CAHPS_GRP_2 CAHPS_GRP_3 CAHPS_GRP_5 CAHPS_GRP_8
##    <chr>      <chr>             <dbl>       <dbl>       <dbl>       <dbl>       <dbl>
##  1 0446157747 USC CARE M…          63          87          86          57          85
##  2 0446162697 ASSOCIATIO…          59          85          83          63          88
##  3 0547164295 BEAVER MED…          49          NA          75          44          73
##  4 0749333730 CAPE PHYSI…          67          84          85          65          82
##  5 0840104360 ALLIANCE P…          66          87          87          64          87
##  6 0840109864 REX HOSPIT…          73          87          84          67          91
##  7 0840513552 SCL HEALTH…          58          83          76          58          78
##  8 0941545784 GRITMAN ME…          46          86          81          54          NA
##  9 1052612785 COMMUNITY …          65          84          80          58          87
## 10 1254237779 OUR LADY O…          61          NA          NA          65          NA
## # ℹ 85 more rows
## # ℹ 1 more variable: CAHPS_GRP_12 <dbl>
```

``` r
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
```

```         
## # A tibble: 5 × 3
##   id    measurement value
##   <chr> <chr>       <dbl>
## 1 A     bp1           100
## 2 B     bp1           140
## 3 B     bp2           115
## 4 A     bp2           120
## 5 A     bp3           105
```

``` r
df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )
```

```         
## # A tibble: 2 × 4
##   id      bp1   bp2   bp3
##   <chr> <dbl> <dbl> <dbl>
## 1 A       100   120   105
## 2 B       140   115    NA
```

``` r
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
```

```         
## # A tibble: 1 × 3
##   id    measurement     n
##   <chr> <chr>       <int>
## 1 A     bp1             2
```

``` r
df |> 
  group_by(id, measurement) |> 
  summarize(n = n(), .groups = "drop") |> 
  filter(n > 1)
```

```         
## # A tibble: 1 × 3
##   id    measurement     n
##   <chr> <chr>       <int>
## 1 A     bp1             2
```
