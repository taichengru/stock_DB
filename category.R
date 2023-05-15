library(RMySQL)
library(tidyverse)
library(googlesheets4)

Query <- "
CREATE TABLE Category
(tej_id   VARCHAR(4),
tej_name VARCHAR(100),
PRIMARY KEY (tej_id));
"

mysqlconnection <- dbConnect(RMySQL::MySQL(),
                             dbname='stock',
                             host='localhost',
                             port=3306,
                             user='root',
                             password='tgedft14582') 

dbSendQuery(mysqlconnection, Query)

df <- read_sheet("https://docs.google.com/spreadsheets/d/1iuCatoQIGL7PC5RaX-Z3a6yToDILNu9ArmGMwoe78eM/edit#gid=1416020401", sheet = 2)
df <- df |> 
  drop_na() |> 
  select(c(1,2))

map(seq_len(NROW(df)),
    function(i) {
      sql_qry <- "insert into Category (tej_id, tej_name) VALUES"
      sql_qry <- paste0(sql_qry, paste(sprintf("('%s', '%s')",
                                               df$TEJ編號[i], df$`TEJ類股名稱(TSE產業別)`[i]), collapse = ","))
      dbSendQuery(mysqlconnection, sql_qry) 
    },.progress = T
)
