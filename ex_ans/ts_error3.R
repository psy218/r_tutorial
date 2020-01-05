library(dplyr)

starwars[starwars$height < 100 | 
           starwars$height == 200, ] # a new statement
