library(foreign)
library(stringr)
library(purrr)
library(lubridate)
library(LexisPlotR)
library(tidyverse)
library(ggthemes)
library(kableExtra)
library(cohortBuilder)

# Set home directory
setwd("/home/tepe/UnB/Demografia/trabalho-1/BA/")

# Import files 
files <- list.files(
  path="./dbf", 
  pattern=".dbf", 
  full.names=TRUE, 
  recursive=FALSE
  )

dnNames <- c()
doNames <- c()

dnList <- list()
doList <- list()

for (i in 1:length(files))
{
  name <- tools::file_path_sans_ext(basename(files[i]))
  print(name)
  df <- read.dbf(files[i])
  
  if (str_detect(name, "dn"))
  {
    dnList[[length(dnList) + 1]] <- df
    dnNames[length(dnNames) + 1] <- name
  }
  else 
  {  
    doList[[length(doList) + 1]] <- df
    doNames[length(doNames) + 1] <- name
  }
  
  rm(df)
}

names(dnList) <- dnNames
names(doList) <- doNames


### letra A
# contagem de nascidos vivos
count <- map_vec(dnList, ~ nrow(.x))

# contagem de obitos

# map_vec(doba2000["IDADE"], ~ str_sub(.x, 1, 1))
# condition <- (as.integer(str_sub(doba2000[,"IDADE"], 1, 1)) < 4) 
# condition <- condition & !(as.integer(str_sub(doba2000[,"IDADE"], 1, 1)) > 4)
# condition <- condition | ((as.integer(str_sub(doba2000[,"IDADE"], 1, 1)) < 4) & (as.integer(str_sub(doba2000[,"IDADE"], 2, 3)) <= 5) ) 
# length(doba2000[condition,"IDADE"])


# obt <- as.Date(doba2000[,"DTOBITO"], "%d%m%Y")
# nasc <- as.Date(doba2000[,"DTNASC"], "%d%m%Y")

# aux <- as.integer(floor(difftime(obt, nasc, units = c("days")) / 365) )
# hist(aux[which(aux <= 5)])

# doba2000[str_sub(doba2000[,"IDADE"], 1, 1) == "5", c("DTNASC", "DTOBITO", "IDADE")]

# sum(is.na(doba2000[,"DTNASC"]))


aux <- doba2021[!is.na(doba2021$DTNASC),]
aux <- aux[which(aux$TIPOBITO == "2"),]

get_col_obitos <- function (name) 
{
  aux <- get(name)[!is.na(get(name)$DTNASC),]

  num_name <- str_remove(name, "doba")
  aux <- aux[which(aux$TIPOBITO == "2"),]
  
  aux$DTNASC[which(is.na(dmy(aux$DTNASC)))]
  aux$DTNASC <- dmy(aux$DTNASC)
  aux$DTOBITO <- dmy(aux$DTOBITO)
  aux <- aux[!is.na(aux$DTNASC),]
  aux <- aux[!is.na(aux$DTOBITO),]
  
  aux$DTNASC <- as_date(aux$DTNASC)
  aux$DTOBITO <- as_date(aux$DTOBITO)
  ages <- interval(aux$DTNASC, aux$DTOBITO) %/% years(1)
  #t <- cbind(table(ages[which(ages <= 5)]))
  t <- cbind(table(ages))
  
  aux <- as.data.frame(t)
  colnames(aux) <- c(num_name)
  return(aux)
}



get_dtobito_idade <- function(name)
{
  aux <- get(name)
  aux <- aux[which(aux$TIPOBITO == "2"),]
  aux <- aux %>% select(c(DTOBITO,DTNASC))
  
  aux$DTNASC <- dmy(aux$DTNASC)
  aux$DTNASC <- as_date(aux$DTNASC)
  aux$DTNASC <- floor_date(aux$DTNASC, unit="year")
  
  aux$DTOBITO <- dmy(aux$DTOBITO)
  aux$DTOBITO <- as_date(aux$DTOBITO)
  aux$DTOBITO <- floor_date(aux$DTOBITO, unit="year")
  
  aux <- as.data.frame(table(aux))
  
  aux$DTOBITO <- as_date(aux$DTOBITO)
  aux$DTNASC <- as_date(aux$DTNASC)
  
  aux$IDADEMORTE <- interval(aux$DTNASC, aux$DTOBITO) %/% years(1)
  
  aux <- aux %>% filter(IDADEMORTE >= 0 & IDADEMORTE <= 5)
  
  # aux <- aux %>% select(-c(DTNASC))
  
  return(aux)
}

get_dtobito_idade_05 <- function(name)
{
  aux <- get_dtobito_idade(name) 
  return(aux)
}

aux <- get_dtobito_idade("doba2000")
View(table(aux))
ob_idade = data.frame()

for (n in doNames)
{
  ob_idade <- rbind(ob_idade, get_dtobito_idade_05(n))
}

ob_idade <- table(ob_idade)

tab <- as.data.frame(table(aux))
tab$DTOBITO <- as_date(tab$DTOBITO)
tab$IDADEMORTE <- as.integer(as.character(tab$IDADEMORTE))

View(tab)

get_col_obitos <- function (name) 
{
  aux <- get(name)[!is.na(get(name)$DTNASC),]
  
  num_name <- str_remove(name, "doba")
  aux <- aux[which(aux$TIPOBITO == "2"),]
  
  aux$DTNASC[which(is.na(dmy(aux$DTNASC)))]
  aux$DTNASC <- dmy(aux$DTNASC)
  aux$DTOBITO <- dmy(aux$DTOBITO)
  aux <- aux[!is.na(aux$DTNASC),]
  aux <- aux[!is.na(aux$DTOBITO),]
  
  aux$DTNASC <- as_date(aux$DTNASC)
  aux$DTOBITO <- as_date(aux$DTOBITO)
  ages <- interval(aux$DTNASC, aux$DTOBITO) %/% years(1)
  #t <- cbind(table(ages[which(ages <= 5)]))
  t <- cbind(table(ages))
  
  aux <- as.data.frame(t)
  colnames(aux) <- c(num_name)
  return(aux)
}



library("dplyr")

obitos <- data.frame(idades = c(seq(0, 6)))
for (n in doNames)
{
  # obitos$idades <- row.names(obitos)
  aux <- get_col_obitos(n)
  aux$idades <- as.numeric(row.names(aux))
  
  obitos <- merge(obitos, aux, by="idades", all = TRUE)
  # obitos <- obitos %>% select(-c(idades))
}

obitos_05 <- obitos[which(obitos$idades >= 0 & obitos$idades <= 5),]
rownames(obitos_05) <- obitos_05$idades
obitos_05 <- obitos_05 %>% select(-c(idades))


get_lexis_info <- function(name) {
  aux <- get(name)
  aux <- aux[which(aux$TIPOBITO == "2"),]
  aux <- aux %>% select(c(DTOBITO,DTNASC))
  
  aux$DTNASC <- dmy(aux$DTNASC)
  aux$DTNASC <- as_date(aux$DTNASC)
  aux$DTOBITO <- dmy(aux$DTOBITO)
  aux$DTOBITO <- as_date(aux$DTOBITO)
  
  aux$IDADEMORTE <- interval(aux$DTNASC, aux$DTOBITO) %/% years(1)
  
  aux <- aux %>% filter(IDADEMORTE >= 0 & IDADEMORTE < 5)
  
  aux$DTNASC <- floor_date(aux$DTNASC, unit="year")
  aux$DTOBITO <- floor_date(aux$DTOBITO, unit="year")
  
  aux <- as.data.frame(table(aux))
  
  aux$DTNASC <- as_date(aux$DTNASC)
  aux$DTOBITO <- as_date(aux$DTOBITO)
  aux$IDADEMORTE <- as.numeric(as.character(aux$IDADEMORTE))
  
  aux <- aux %>% filter(aux$Freq != 0)
  aux$IDADEMORTE <- as.numeric(aux$IDADEMORTE)
  
  for(i in 1:nrow(aux)) 
  {
    if (interval(aux$DTNASC[i], aux$DTOBITO[i]) %/% years(1) != aux$IDADEMORTE[i])
    {
      aux$IDADEMORTE[i] <- aux$IDADEMORTE[i] + 0.75
      aux$DTOBITO[i] <- aux$DTOBITO[i] %m+% months(3)    
    }
    else
    {
      aux$IDADEMORTE[i] <- aux$IDADEMORTE[i] + 0.25
      aux$DTOBITO[i] <- aux$DTOBITO[i] %m+% months(9)
    }
  }
  aux <- aux %>% select(-c(DTNASC))
  return(aux)
}


lexis <- data.frame()
for(name in doNames)
{
  lexis <- rbind(lexis, get_lexis_info(name))
}

lexis_grid( year_start = 2000, year_end = 2022, 
  age_start = 0, age_end = 5) +
annotate(              # Anotações nos gráficos
  "text",
  x     = lexis$DTOBITO ,
  y     = lexis$IDADEMORTE ,
  label = lexis$Freq,
  size  = 3
)
 


aux <- doList
aux <- sapply(names(aux),function(x) aux[[x]] %>% select(c(DTOBITO, DTNASC, IDADE)), simplify = FALSE, USE.NAMES = TRUE)
