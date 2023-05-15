library(RMySQL)
library(tidyverse)

Query <- "
CREATE TABLE stockprice
(stock_code		VARCHAR(4),
 time			TIMESTAMP,
 Open_price		FLOAT,
 high_price		FLOAT,
 low_price		FLOAT,	
 closing_price	FLOAT,
 volume			INTEGER,
 return_rate	FLOAT);
"
dbSendQuery(mysqlconnection, Query) 


df <- read.csv("data/TEJ.csv", encoding = "UTF16")
mysqlconnection <- dbConnect(RMySQL::MySQL(),
                             dbname='stock',
                             host='localhost',
                             port=3306,
                             user='root',
                             password='tgedft14582') 

map(seq_len(NROW(df)),
    function(i) {
      sql_qry <- "insert into stockprice (stock_code, time, Open_price, high_price, low_price, closing_price, volume, return_rate) VALUES"
      sql_qry <- paste0(sql_qry, paste(sprintf("('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')",
                                               df$證券代碼[i], df$年月日[i], df$開盤價.元.[i], df$最高價.元.[i], df$最低價.元.[i],
                                               df$收盤價.元.[i], df$成交量.千股.[i], df$報酬率.[i]), collapse = ","))
        dbSendQuery(mysqlconnection, sql_qry) 
    },.progress = T
  )
