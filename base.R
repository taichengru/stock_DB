library(pool)
library(lubridate)

pool <- dbPool(
  drv = RMySQL::MySQL(),
  dbname = "stock",
  host = "localhost",
  username = "root",
  password = "tgedft14582"
)

df <- readxl::read_excel("data/基本面.xlsx")
df <- df[, -1]
names(df) <- c("stock_id", "time", "NOI", "operating_cost",
               "operating_profit", "operating_expenses", "OGAEN", "NPBT",
               "EPS", "ROA", "ROE", "operating_margin", 
               "NPMBT", "EOS_PE", "EOS_PB", "EOS_PSR", "tobinsQ")

df$time <- ym(df$time) |> stringr::str_replace_all("-", "/")

dbWriteTable(pool, "BasicAnalysis", df, overwrite = FALSE, append = TRUE, row.names = F)

# dbRemoveTable(pool, "basicanalysis")
