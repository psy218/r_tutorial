#' This is the r-script that complements [Basic R](tutorial_draft.Rmd)
#' *Contents* (i.e., lines that start with a pound sign, `#`) correspond to the tutorial above
#' Run *r codes* (i.e., lines that do not start with a pound sign) by putting your cursor on top of the line you want to run and,
#' a) press `Run` button on the right-hand corner, or
#' b) use the keyboard shortcut: command + enter (mac) or ctrl + enter (window)
#' Test your knowledge with *exercises* 

#################### RStudio & R Environment ####################

## Packages ------------------------------------------------------------
#' Packages can be thought as softwares or applications (e.g., Microsoft Word, Chrome) that your default R may not be equipped with. 
#' We download these applications with `install.packages()` function. Let's install a package called `readr`, which makes importing data into R easier & faster.   
install.packages("readr")

#' Once we have the package installed, we now have to load the package to our current R environment with `library()` function. 
library(readr)

#' Although you have to install a package only ONCE, you have to load the pakcage every time you start a new R session.  

#' In prepration of the tutorial, please install Tidyverse.
install.packages("tidyverse")

#' In addition to Tidyverse, these are some packages that I often use:
#' (delete the pound sign in the code below if you want to install these packages)
# select_packages = c("here", "psych", "e1071", "corrr", "car", "emmeans", "lme4", "lmerTest", "lavaan")
# install.packages(select_packages)

#' Different packages may include different functions that have the same name, which will confuse R. 
#' When you get an error that a function cannot be found, explicitly specify what package includes the function you are referring to by using `package_name::function`. 
package_function_is_from::some_function(x)


#################### R basic building block  ####################
#' R syntax
#' R grammar is made up of 4 parts: 1) **object**, 2) **function**, 3) **argument**, and 4) **variables**.
#' Baking an apple pie as an example, an *apple pie* is an object, a *knife* is a function (from a package), and a *recipe* is an argument (e.g., ingredient) and variables (e.g., 3 apples). 

## 1) Functions ------------------------------------------------------------
#' We can perform basic arithmetic in R using the same mathematical operators 
#' |`+`| plus    |
#' |`-`| minus   |
#' |`*`| multiply|
#' |`/`| divide  |

1 + 1

#' These are functions for common calculations that are useful for **descriptive statistics**:
#' ```
mean(x)
median(x)
mode(x)
sd(x)
var(x)
sqrt(x)
abs(x)
#' ```

#' Try finding a square root of 25 in your console:
sqrt(25)


#' We can also conduct statistical analyses using built-in functions 
#' ```
cor(x, y)
cov(x, y)
t.test(x, y)
#' ```

#' **Exercise 1** 
#' 
#### Ex1) Question ####
#' 
#' Calculate your age by subtracting your birth year from 2020. 
#' 
#' ### Answer (write your code below)




## ----- answer -----
2020 - 1991




## 2) Object -------------------------------------------------------------------

#' R is an ephemeral being; it does things that you tell it to, but its output won’t be automatically saved. As such, you need to save the output (e.g., computing results or dataset) into something called **objects**, which will appear in the Environment pane.

#' To inspect objects availalbe in your local workspace, check the Environment panel, or run the following code:
ls()

#' To create an object, you have to use the assignment operators of either `<-` or `=`. 
#' Let’s try saving the output of the previous calculation as an object. 
#' You can give it any name, but make sure the name contains no space (e.g., “my age”) and is unique (no two objects should have the same name unless you want to overwrite the first object). 

#' Let's save the previous calculation, save the output as "my_age"
#' TODO: Change 1991 to your birth year.  

my_age <- 2020 - 1991
my_age = 2020 - 1991 

#' Review what's stored in the object by calling on the name of the object. 
my_age


#' *Note*. Any word that are not in quotations will be treated as an object. 


#' Objects can contain more than 1 value in the forms of **vectors** or **data frames**. 
#### 2a) Vectors ####
#' Vectors can be created by using `c()`: a function that combines multiple values.  
#' Be sure the variables are separated by a comma, `,`. 
c(1, 3, 7, 10)

#' TODO: ask people around you for their ages and birth months, and create two separate vectors for their ages and birth months.

age <- c(29, 24, 21, 26) # an object named `age`, which is a vector that contains 4 values 
birth_month <- c(6, 11, 10, 9)

#' You can perform simple arithmetics on the vectors. 
c(1, 3) + c(0.25, -2) # add two vectors

#' Try adding two vectors that differ in their lengths. How many values did you get?
c(1, 3) + c(0.25, -2, 10)

#' perform multiplication on an object named `age`, which is a vector containing 4 values
age * 3 

#' ##### **Exercise 2** 

#### Ex2) Question ####
#' Compute the average age of the students whose ages are as follows:
#' 28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26. 
#' `NA` denotes a missing value
#' 
#' ###### Your answer (write your code below). 




## ---- answer ----------
students_age <- c(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26)

# use a function, `mean,` on a vector containing ages (i.e., student_age)
# you need to tell R to ignore any missing values (i.e., `NA`) in the vector from computation with this argument: `na.rm = TRUE`; `na.rm` stands for missing value (`na`) remove (`rm`), and `TRUE` (or `FALSE`) specifies whether missing values should be removed

mean(students_age, na.rm = TRUE) 

# NOT this:
mean(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26) # this will give you 28, because it only uses the first element.
# Nor this:
mean(c(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26)) # you have to say na. rm = TRUE 

#### 2b) Data frames ####
#' A data set is a type of an object that contains multiple vectors organized in columns and rows. 
#' Let's create a data set containing age and birth month using `data.frame(vector1, vector2, vector3)` function.

# create a data frame with age and birth month
birth_data <- data.frame(age, birth_month)

# look into the new data frame (named `birth_data`)
birth_data

#' The two vectors are now organized in columns, each row representing an observation. 
#' 
#' We can add a column to our existing matrix by using `cbind()`.
#' For example, create a new vector containing the biological sex of the same people you asked for age and birth month:

sex <- c("male", "female", "female", "male")

#' And column-bind the new vector
cbind(birth_data, # data set we want to append the new vector to
      sex) # new vector
#' you need to "update" your object (birth_data) if you want to keep the column 

birth_data <-  cbind(birth_data, 
                     sex)

#' or add a row by using, `rbind()`
rbind(birth_data, # data set we want to append the new vector
      c(22, 10, "female")) # new vecotr 

#' If we look at the data frame birth_data, you will notice that there is no new column named sex or a new row containing data from a 22-year-old female who was born in Oct. 
birth_data

#' This is because we didn’t store the output of these operations (i.e., adding a new column and a new row) into anything.
#' You need to “update” your data frame (birth_data), if you want to keep a new column and row by overwriting birth_data
#' overwriting the data frame with a new column, sex
birth_data <- cbind(birth_data, sex)

#' overwriting the data frame with a new row
# birth_data <- rbind(birth_data, c(22, 10, "female"))


#' Like vectors, we can perform arithmatic operations on the datasets.
#' **Exercise**
#### Ex3) Question ####
#' Using the birth_data, a) compute the birth year by subtracting `age` from 2020, and b) append it to the dataset. 

#' ###### Your answer (write your code below)






## ---- answer ----------
# find the year of birth by subtracting age stored in the `birth_data` from 2020,
# and store it in a vector named `birth_year`
birth_year = 2020 - as.numeric(birth_data$age)

# append the `birth_year` column to birth_data
cbind(birth_data, birth_year = c(2020 - age))



#################### Working with data ####################
## 1) Data import  ----------------------------------
#' Because we can only work on objects that exist in the environment, we need to **import** any external files into RStudio.  
#' #' Many data sets you would come across would be stored as a .csv file. 
#' Let's review 3 ways you can import a csv file into our global environment.  

## a) Point-and-click  
#' We can use `Import Dataset` option under the Environment tab
#' You would click on `From Text` option; I prefer `From Text (readr)` as it is more efficient & flexible. 

## b) Using R functions    

#' Or, we can use `read.csv()` or `read_csv()` function to read in the data set saved as a `.csv` file. 
#' You need to provide a path to the folder that contains your data set, and save it as a new object. 
dataset <- read.csv("./dataset/data.csv") # base
dataset <- readr::read_csv("./dataset/data.csv") # readr package

#' The example above uses an absolute path: the full address for the file location. I’d recommend using a relative path, which uses your current “working directory” (where your R is doing stuff) as a base camp and locate files relative to that base camp.
#' `here` function from `here` package makes that easier; you only need to specify folder names from your current working directory.
getwd() # run this code to get your current working directory
dataset <- readr::read_csv(here::here("dataset",  # name of the folder that contains the data file
                                      "data.csv")) # name of the data file

## c) `file.choose()`  
#' We can use `file.choose()` function inside `read_csv()`, if we are unsure about the path to the file.  

dataset <- readr::read_csv(file.choose())

## 2) Acceessing elements inside data set ----------------------------------

#' We can use a square bracket (i.e., []) to access an element inside a data frame by its location or column names. 

#### a) By location ####

#' data.frame[i, j] 

#' The first element (i.e., *i*) corresponds to the row, and the second (i.e., *j*) corresponds to the column. 
#' For example, we can access the second element in the 2nd column like this:
birth_data[2, # 2nd row
           2] # 2nd column


#' We can access multiple elements by using a vector (`c()`) inside a bracket, or `:`sign. 
birth_data[c(1, 3), # elements in the first and third rows
           c(2, 3)] # first element in the second row & third element in the third row

birth_data[c(1, 3), 
           2:3] # same as c(2, 3)


#### b) By column name ####
#' We can also use column names. All the codes below will access information stored in the *sex* column. 
birth_data[ , "sex"]

birth_data[["sex"]]

#' We use the dollar sign (i.e., `$`) to specify a column. 
birth_data$sex

#' The dollar sign comes handy when you want to create a new column inside an existing dataset. For example, instead of using  cbind(), I can do the following:

birth_data$names = c("su", "dj_power", "kool_kid", "mc_nano")

#' We now have a new column, `names`, in the birth_data.
birth_data

#### c) By conditions ####
#' We can also select elements conditionally; that is, we can specify the condition by which an element must satisfy. R will evaluate the statement and return only those elements (or columns) that meet the specified condition.
#' We can do this by using a square bracket, like how we accessed elements by location. We place the condition inside the square bracket on which the condition to be evaluated: [i, ] for rows; [, j] for columns.
# dataset[condition, ]  # subsetting rows that meet the condition
# dataset[ , condition] # subsetting columns that meet the condition

#' You can also have different conditions for rows (row_condition) and columns (column_condition)
# dataset[row_condition, column_condition] 

#' Mathematical Annotations
#' 
#'         Conditional statements use these operators:  
#'         |`==`|equal to                 |`x == y`|  
#'         |`!=`|not equal to             |`x != y`|  
#'         | `>`|greater than             |`x > y `|
#'         | `<`|less than                |`x < y `|
#'         |`>=`|greater than or equal to |`x >= y`|
#'         |`<=`|less than or equal to    |`x <= y`|
#'         
#'         You can have multiple conditions by using the following operators:
#'         |`|`    |or                       |`x == 1 | x == 2`|
#'         |`&`    |and                      |`x == 1 & y == 2`|
#'         |`%in%` |testing multiple elements|`x %in% c(1, 2)` |
#'         
                                                             
#' For example, let's say I only want people (i.e., observations; rows) who are older than 24 years of age.
#' You should first construct a logical statement: i.e., older than 24.
birth_data$age > 24 
#' Each row of the age column inside birth_data will be evaluated on the logical statement to be TRUE or FALSE, and the logical values (TRUE/ FALSE) will be used to subset the rows that are TRUE. The rows that meet our condition (i.e., age > 24) are the first and the last rows, which corresponds to the logical values returned from our logical statement
#' Place the logical statement inside a square bracket, and apply that to the dataset you want to subset:
birth_data[birth_data$age > 24, ] 
#' Notice that I left j inside the bracket [i, j] empty; this denotes every column that meets the condition specified in i (i.e., birth_data$age > 24).
# If you only want a specific column (i.e., age column) and the rows that meet the condition (i.e., age > 24), you need to add a conditional statement for the column (i.e., providing the name of the column, “age”) in the place of j.
birth_data[birth_data$age > 24, "age"]

#' alternatively, you can use `subset(x, subset, select)` function. 
subset(x = birth_data, # object / dataset you want to subset
       subset = age > 24) # logical statement for the condition you want 

#' Specify the select argument, if you want a subset of columns. Repeating the example above:
subset(x = birth_data, 
       subset = age > 24, # a conditional statement for the row (*i*) = age > 24
       select = "age") # conditional statement for the column (*j*) = name of the column you want to select  

#' **Exercise**
#### Ex4) Question ####
#' Find the age of those who were either born in the summer (i.e., July ~ Oct) OR male. 
#### Your answer (write your code below)






#### answer -----------------
#' step 1. Construct logical statements. 
#' statement 1: born in the summer (i.e., July ~ Oct)
birth_data$birth_month %in% c(7:10) 
#' statement 2: male
birth_data$sex == "male"

#' step 2. Combine the two statements with the correct operator, `|` (i.e., or).
birth_data$birth_month %in% c(7:10) | birth_data$sex == "male"

#'. step 3. Specify the column you want: age. 
birth_data$age

#' step 4. combine all of the above!
birth_data[birth_data$birth_month %in% c(7:10) | birth_data$sex == "male", "age"]

#' Or, use the `subset()` function
subset(x = birth_data, 
       subset = birth_month %in% c(7:10)| sex == "male",
       select = age)


#' **Exercise**

#### Ex5) Question ####
#' Life expectancies for male and female Canadians are different (i.e., 80 and 84, respectively. 
#' [Statistics Canada](https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310038901). 
#' Let's find out how long we have left to live by subtracting `age` from 80 for men and 84 for women. 

#' Use `ifelse(test, yes, no)` function.  
#' For example, 
ifelse(test = birth_data$age > 19, # logical statement that specifies the condition 
       yes = "can drink", # for those that meet the condition
       no = "cannot drink") # for those who do not meet the condition


#' #### Your answer (write your code below)









## ---- answer ---------
birth_data$yr_remaining = ifelse(test = birth_data$sex == "male",
                                 yes = 80 - birth_data$age,
                                 no = 84 -  birth_data$age)

birth_data



## 3) Class attributes ---------------------------------------------------
#' Variables can have different class attributes. They can be
#' numeric; or double
typeof(1)
#' integer (whole number)
typeof(2L)
#' character (string)
typeof("a")
#' logical (TRUE/FALSE)
typeof(TRUE)

#' One thing to note is that variables in a vector must have the same class attributes.
#' For example, let's create a vector `x` with values of different class attributes.
x <- c(1, 3, 5, 7, # numeric
        "a", # character
        TRUE) # logical

#' When we inspect class attribute of this vector, it forces all the variables to have the same data type.
typeof(x)

#' Inspect the vector below:
c(1, 2, 3, TRUE, FALSE)


#' Class attirubtes of a variable will determine whether you can apply certain functions and the accuracy of calculation.

#' As an example, let's compute an average age in our dataset using `mean(x)` function. 

mean(birth_data$age)


#' Hypothetically, if some of the age data contains character strings...

birth_data$age[1] <- paste(birth_data$age[1], "years") # messing up one observation by adding "years old" to a numeric variable, age.

# let's review what our data looks like. 
birth_data

#' we can no longer use the `mean()` function...
mean(birth_data$age)

#' This is because the age column now got converted into a character vector  

typeof(birth_data$age)

## Conversion ------------------------------------------------------------
#' When we need to convert a variable from one class to another, we use `as.class` family of function:   
   
   #' |`as.numeric()`   |convert to numeric  |
   #' |`as.character()` |convert to character|
   #' |`as.logical()`   |convert to logical  |
   #' |`as.factor()`    |convert to factor   |
   
#' Let's convert our age variable into numeric

birth_data$age <- gsub("[a-z]", "",birth_data$age) # first I am going to get rid of "years" 

#' we will use `as.numeric()` to convert our age variable, which is a character variable, to numeric.  
birth_data$age <- as.numeric(birth_data$age)


#' We can now perform `mean()` function again! 
mean(birth_data$age)