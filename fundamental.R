library(RMySQL)
library(tidyverse)

mysqlconnection <- dbConnect(RMySQL::MySQL(),
                             dbname='stock',
                             host='localhost',
                             port=3306,
                             user='root',
                             password='tgedft14582') 


Query <- "
CREATE TABLE FundamentalAnalysis
(stock_code	        VARCHAR(100),
 time	    TIMESTAMP,
 FIS     	      INT,
 ICS		      INT,
 PTS		  INT,	
 f_increase	            INT,
 f_decrease		    	    INT,
 sl_increase              INT,
 sl_decrease              INT,
 fi_rate        FLOAT,
 ic_rate              FLOAT,
 pt_rate              FLOAT,
 ct_rate     FLOAT,
 ns_rate          FLOAT,
 fs_rate         FLOAT,
 lcs_rate          FLOAT,
 pts_rate  FLOAT,
 ds_rate  FLOAT,
 dsp_rate  INT,
 f_balance  INT,
 sl_balance  INT
);
"
dbSendQuery(mysqlconnection, Query) 

df <-  readxl::read_excel("data/公司籌碼面.xlsx")

map(seq_len(NROW(df)),
    function(i) {
      sql_qry <- "insert into fundamentalanalysis (stock_code, time, FIS, ICS, PTS, f_increase, f_decrease, sl_increase,
                                                    sl_decrease, fi_rate, ic_rate, pt_rate, ct_rate, ns_rate, fs_rate, lcs_rate, 
                                                    pts_rate, ds_rate, dsp_rate, f_balance, sl_balance) VALUES"
      sql_qry <- paste0(sql_qry, paste(sprintf("('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s',
                                                 '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')",
                                               df$證期會代碼[i], df$年月日[i], df$`外資買賣超(張)`[i], df$`投信買賣超(張)`[i], 
                                               df$`自營買賣超(張)`[i], df$`融資增加(張)`[i], df$`融資減少(張)`[i], df$`融券增加(張)`[i], 
                                               df$`融券減少(張)`[i], df$外資成交比重[i], df$投信成交比重[i], df$自營成交比重[i], 
                                               df$信用交易比重[i], df$一般現股成交比重[i], df$`外資總持股率_不含董監%`[i], df$`投信持股率％`[i], 
                                               df$`自營持股率％`[i], df$`董監持股％`[i], df$`董監質押％`[i], df$`融資餘額(千元)`[i], df$`融券餘額(千元)`[i]), collapse = ","))
      dbSendQuery(mysqlconnection, sql_qry) 
    },.progress = T
)
