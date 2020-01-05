# step 1: what are the names of the columns?
c(paste("day", 1:5, sep =""))

# step 2: select columns you want to compute an average for
height_weight[ , c(paste("day", 1:5, sep =""))]

# step 3: compute means for each participant (i.e., row-wise)
rowMeans(height_weight[ , c(paste("day", 1:5, sep =""))], na.rm = T)

## NOT this:
# functions that work for vectors may not work for data frames. 
mean(height_weight[ , c(paste("day", 1:5, sep =""))], na.rm = T) 

## NOT this:
# this will compute the average of daily apple consumption across the 6 participants
colMeans(height_weight[ , c(paste("day", 1:5, sep =""))], na.rm = T) 

# NOT this:
# this will remove the entire row that contains missing value. 
rowMeans(na.omit(height_weight[ , c(paste("day", 1:5, sep =""))])) # 