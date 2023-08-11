library(RMySQL)
library(LexisPlotR)
library(tidyverse)
library(lubridate)
library(ggplot2)

conn = dbConnect(RMySQL::MySQL(),
                 dbname='demog',
                 host='127.0.0.1',
                 port=6603,
                 user='root',
                 password='root')

dbListTables(conn)
dbClearResult(dbListResults(conn)[[1]])

lexis_rn <-
  dbGetQuery(conn, "select * from lexis_rn")
lexis_nasc_rn <-
  dbGetQuery(conn, "select * from aux_dnrn_count")

lexis_ba <-
  dbGetQuery(conn, "select * from lexis_ba")
lexis_nasc_ba <-
  dbGetQuery(conn, "select * from aux_dnba_count")

for (i in c("lexis_ba", "lexis_nasc_ba", "lexis_rn", "lexis_nasc_rn"))
{
  write.csv2(get(i), str_c("D:\\Repos\\Demografia\\CSV\\", i, ".csv"), row.name = TRUE)
}

lexis_grid( year_start = 2000, year_end = 2022, 
            age_start = 0, age_end = 5) +
  annotate(              # Anotações nos gráficos
    "text",
    x     = as.Date(lexis_ba$ANOCORR) ,
    y     = lexis_ba$ANOSCORR + 0.1,
    label = lexis_ba$COUNT,
    size  = 3
  ) + 
  annotate(              # Anotações nos gráficos
    "text",
    x     = as.Date(lexis_nasc_ba$ANOCORR) + 20 ,
    y     = 0.13,
    label = lexis_nasc_ba$CONT,
    size  = 3,
    colour= "red"
  ) + 
  labs( x = "Ano", y = "Idade", title = "Diagram de Lexis de nascidos vivos e mortes por idade por ano de 2000 a 2021") + 
  theme(plot.margin = margin(t = 10, r = 15, b = 10, l = 10, unit = "pt"))  
  
lexis_grid( year_start = 2000, year_end = 2022, 
            age_start = 0, age_end = 5) +
  annotate(              # Anotações nos gráficos
    "text",
    x     = as.Date(lexis_rn$ANOCORR) ,
    y     = lexis_rn$ANOSCORR + 0.1,
    label = lexis_rn$COUNT,
    size  = 3.2
  ) +
  annotate(              # Anotações nos gráficos
    "text",
    x     = as.Date(lexis_nasc_rn$ANOCORR) + 20 ,
    y     = 0.13,
    label = lexis_nasc_rn$CONT,
    size  = 3,
    colour= "blueviolet") +
    labs( x = "Ano", y = "Idade", title = "Diagrama de Lexis de nascimentos e óbitos de 2000 a 2021 do Rio Grande do Norte") + 
    theme(plot.margin = margin(t = 10, r = 15, b = 10, l = 10, unit = "pt"))  


sum(filter(lexis_rn, lexis_rn$COORTE <= 2016 & lexis_rn$COORTE >= 2000)$COUNT)


obitos_rn = 15132
nasc_rn = 845745
rate_rn = obitos_rn / nasc_rn

obitos_ba = 83088
nasc_ba = 3987801
rate_ba = obitos_ba / nasc_ba


