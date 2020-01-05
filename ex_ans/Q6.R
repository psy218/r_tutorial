# step 1: Find column names
names(starwars)

# step 2: specify what information I want to get: character names
starwars$name

# step 3: specify the condition
starwars$height > quantile(starwars$height, 0.05, na.rm = T) # height above the 5th quantile
starwars$height < quantile(starwars$height, 0.95, na.rm = T) # height below the 95th quantile

# step 4: combine them! 
starwars$name[(starwars$height > quantile(starwars$height, 0.05, na.rm = T)) & 
                (starwars$height < quantile(starwars$height, 0.95, na.rm = T))]