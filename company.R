library(RMySQL)
library(tidyverse)

mysqlconnection <- dbConnect(RMySQL::MySQL(),
                             dbname='stock',
                             host='localhost',
                             port=3306,
                             user='root',
                             password='tgedft14582') 

Query <- "
CREATE TABLE Company
(stock_id	        VARCHAR(100),
 category_id	    VARCHAR(100),
 ISIN     	      VARCHAR(100),
 chairman		      VARCHAR(100),
 company_name		  VARCHAR(100),	
 mail	            VARCHAR(100),
 url		    	    VARCHAR(100),
 tel              VARCHAR(100),
 fax              VARCHAR(100),
 spokesman        VARCHAR(100),
 PIC              VARCHAR(100),
 DOE              VARCHAR(100),
 listing_date     VARCHAR(100),
 cn_name          VARCHAR(100),
 eng_name         VARCHAR(100),
 address          VARCHAR(100),
 accounting_firm  VARCHAR(100),
 PRIMARY KEY (stock_id));
"
dbSendQuery(mysqlconnection, Query)

df <-  readxl::read_excel("data/公司基本資料.xlsx")

map(seq_len(NROW(df)),
    function(i) {
      sql_qry <- "insert into Company (stock_id, category_id, ISIN, chairman, company_name, mail, url, tel,
                                          fax, spokesman, PIC, DOE, listing_date, cn_name, eng_name, address, accounting_firm) VALUES"
      sql_qry <- paste0(sql_qry, paste(sprintf("('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')",
                                               df$證期會代碼[i], df$`TSE 產業別`[i], df$國際證券編號[i], df$董事長[i], 
                                               df$公司中文全稱[i], df$電子信箱[i], df$網址[i], df$電話[i], 
                                               df$傳真[i], df$發言人[i], df$`實收資本額(元)`[i], df$設立日期[i], 
                                               df$最近上市日[i], df$公司中文簡稱[i], df$公司英文簡稱[i], df$公司中文地址[i], 
                                               df$會計師事務所[i]), collapse = ","))
      dbSendQuery(mysqlconnection, sql_qry) 
    },.progress = T
)

