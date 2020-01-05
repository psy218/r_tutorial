# you can either create a new object called your_age
your_age = 2020 - 1991
ifelse(test = my_sex == "female", 
       yes = 84 - your_age, 
       no = 80 - your_age) 

# Or, change the argument inside the ifelse function.
ifelse(test = my_sex == "female", 
       yes = 84 - 29, 
       no = 80 - 29) 