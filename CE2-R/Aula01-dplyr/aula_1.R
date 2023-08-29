# install.packages("dplyr")
library(dplyr)

tbl <- data.frame(color = c("blue", "black", "blue", "blue", "black"),
                 value = 1:5)

filter(tbl, color == "blue")
filter(tbl, value %in% c(1,4))

select(tbl, color)
select(tbl, -color)

tbl <- data.frame(color = c(4, 1, 5, 3, 2), value = 1:5)
arrange(tbl, color)
arrange(tbl, desc(color))

tbl <- data.frame(color = c("blue", "black", "blue", "blue", "black"),
                  value = 1:5)
mutate(tbl, 
       double = 2 * value, 
       error = mean(tbl$value) - value, 
       sqrError = error^2)

summarise(tbl, total = sum(value))
summarise(mutate(tbl, 
       double = 2 * value, 
       error = mean(tbl$value) - value, 
       sqrError = error^2), 
       var = sum(sqrError) / length(tbl$value),
       sd = sqrt(var)
       )

###################################################

x <- data.frame(name = c("Jhon", "Paul", "George", "Ringo", "Stuart", "Pete"),
                instruments = c("guitar", "bass", "guitar", "drums", "bass", "drums"))

y <- data.frame(name = c("Jhon", "Paul", "George", "Ringo", "Brian"),
                band = c("TRUE", "TRUE", "TRUE", "TRUE", "FALSE"))

left_join(x, y, by = "name")
right_join(x, y, by = "name")
inner_join(x, y, by = "name")

# DE ACORDO COM A PROF TEM JEITOS MELHORES DE FAZER JOIN
# DE acordo com a RAquel seriam o merge!!! e reduce!!!

####################################################

# aux <- group_by(tbl, color)
# summarise(aux, total=sum(value))

# Piping no R
group_by(tbl, color) %>% summarise(total=sum(value))

summarise(group_by(tbl, color), total=sum(value))
