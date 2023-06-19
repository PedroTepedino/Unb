library(foreign)

setwd("/home/tepe/UnB/Demografia/trabalho-1/")

aux <- read.dbf("AL/dbf/dnal2000.dbf")

write.csv(aux, file="./AL/csv/dnal2000.csv")

csv <- read.csv('AL/csv/dnal2000.csv')
