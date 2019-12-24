#### R syntax ####
# 1. objects
## a) variables

apple = "apple" # string variable
fruit_category <- TRUE # logical variable 

## b) vectors
three_fruit <- sample(stringr::fruit, 3) # what fruits did you get?

factor(three_fruit) # factorize your three-fruit object

fruit_quantity <- c(3, 2, 5)

## c) dataset
basket <- data.frame(fruits = sample(stringr::fruit, 3), 
                     veggies = c("carrots", "broccoli", "celery"),
                     quantity = c(3, 2, 5)) 

### mathematical operations with your objects ###
sum(fruit_quantity) # how many number of fruits in total? 

# TODO: find the total number of days before fruits expired. 
fruit_weight <- c(8, 20, "10 lbs")

### accessing things inside a dataset ###
# by column
basket[ , "fruits"]
basket$fruits
basket[["fruits"]]

# by row
basket[c(1, 3), ]
basket[-1, ] # everything except for the first row

# by row & column
basket[1, "fruits"] # the first row of the fruit column
basket$fruits[basket$fruits=="pear"] # within the fruit column, element named "pear"
basket$fruits[basket$fruits %in% c("apple", "strawberry")]

basket$fruits[basket$quantity > 3] # fruit(s) whose number exceeds 3

#### Project Environment ####
# 1. Get your locations of your working directory and library
# where is your working space?
getwd()
install.packages("here")
here::here()

# where are your packages being saved?
.libPaths()
# check what packages are loaded in your current working space
search()


#### Data importation ####
df <- readr::read_csv(here::here("dataset", "exampledata.csv"))

# Inspect data 
psych::describe(df)

df %>% 
  dplyr::select(cols1:cols10) 