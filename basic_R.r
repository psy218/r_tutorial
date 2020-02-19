#################### RStudio & R Environment ####################
## Packages ------------------------------------------------------------
#' Packages can be thought as softwares or applications (e.g., Microsoft Word, Chrome) that your default R may not be equipped with. 
#' We download these applications with `install.packages()` function. Let's install a package called `readr`, which makes importing data into R easier & faster.   
install.packages("readr")

#' Once we have the package installed, we now have to load the package to our current R environment with `library()` function. 
library(readr)

#' Although you have to install a package only ONCE, you have to load the pakcage every time you start a new R session.  

#' Different packages may include different functions that have the same name, which will confuse R. 
#' When you get an error that a function cannot be found, explicitly specify what package includes the function you are referring to by using `package_name::function`. 
package_function_is_from::some_function(x)


#################### R basic building block  ####################
#' 
## 1) Functions ------------------------------------------------------------
#' We can perform basic arithmetic in R using the same mathematical operators 
#' |`+`| plus    |
#' |`-`| minus   |
#' |`*`| multiply|
#' |`/`| divide  |

1 + 1

#' We can apply functions for common calculations, such as mean, median, and standard deviations.
#' ```
mean(x)
median(x)
mode(x)
sd(x)
var(x)
sqrt(x)
abs(x)
#' ```

#' We can also conduct statistical tests using built-in functions 
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
#' You can save the output of the previous calculation into an **object**. 
#' You can give it any name, but make sure there is no space (e.g., "my age") and unique (no two objects should have the same name unless you want to overwrite the first object). 
#' Any word that are not in quotations will be treated as an object. 
#' 
#' To create an object, you have to use the assignment operators of either `<-` or `=`. 
#' Let's save the previous calculation, save the output as "my_age"
#' TODO: Change 1991 to your birth year.  

my_age <- 2020 - 1991
my_age = 2020 - 1991 

#' Review what's stored in the object by calling on the name of the object. 
my_age


#' Objects are things saved in your current environment. To inspect objects availalbe in your local workspace, check the Environment panel, or run `ls()`.
ls()

#' ### Multiple values
#' Objects can contain more than 1 value in the forms of **vectors** or **data frames**. 
#' 

#### Vectors ####
#' Vectors can be created by using `c()`: a function that combines multiple values.  
#' Be sure the variables are separated by a comma, `,`. 
#' TODO: ask people around you for their ages and birth month, and create two separate vectors for their ages and birth months.

age <- c(29, 24, 21, 26)
birth_month <- c(6, 11, 10, 9)

#' You can perform simple arithmetics on the vectors. 

c(1, 3) + c(0.25, -2)
age * 3

#' ##### **Exercise 2** 

#### Ex2) Question ####
#' Compute the average age of the students whose ages are as follows:
#' 28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26. 
#' 
#' ###### Your answer (write your code below). 

mean(x)




## ---- answer ----------
students_age <- c(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26)

mean(students_age)

mean(c(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26),
     na.rm = TRUE)

mean(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26)

#### Data set ####
#' A data set is a type of an object that contains multiple vectors organized in columns and rows. 
#' Let's create a data set containing age and birth month using `data.frame(vector1, vector2, vector3)` function.

birth_data <- data.frame(age, birth_month)
birth_data

#' The two vectors are now organized in columns, each row representing an observation. 
#' 
#' We can add a column to our existing matrix by using `cbind()`.
#' For example, create a new vector containing the biological sex of the same people you asked for age and birth month:

sex <- c("man", "woman", "woman", "intersex")

#' And column-bind the new vector
cbind(birth_data, # data set we want to append the new vector to
      sex) # new vector
#' you need to "update" your object (birth_data) if you want to keep the column 

birth_data <-  cbind(birth_data, 
                     sex)

#' or add a row by using, `rbind()`
rbind(birth_data, # data set we want to append the new vector
      c(22, 10, "woman")) # new vecotr 




#' Like vectors, we can perform arithmatic operations on the datasets.
#' ##### **Exercise 4** 

#### Ex3) Question ####
#' Using the birth_data, a) compute the birth year by subtracting `age` from 2020, and b) append it to the dataset. 

#' ###### Your answer (write your code below)






## ---- answer ----------
cbind(birth_data, 
      brith_year = c(2020 - age))


#################### Working with data ####################
## 1) Data import  ----------------------------------
#' Because we can only work on objects that exist in the environment, we need to **import** any external files into RStudio.  
#' #' Many data sets you would come across would be stored as a .csv file. 
#' Let's review 3 ways you can import a csv file into our global environment.  

## a) Point-and-click  
#' We can use `Import Dataset` option under the Environment tab
#' You would click on `From Text` option; I prefer `(reader)` as it is more efficient & flexible. 

## b) Using R function  

#' Or, we can use `read.csv()` or `read_csv()` function to read in the data set saved as a `.csv` file. 
#' You need to provide a path to the folder that contains your data set, and save it as a new object. 
dataset <- read.csv("./dataset/data.csv") # base
dataset <- readr::read_csv("./dataset/data.csv") # readr package

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



#### c) By conditions ####
#' We can also select elements conditionally; that is, we can specify the condition by which an element must satisfy. 
#' R will evaluate the logical statement that specifies the condition, and return only those elements that meet the specified condition. 
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

#' then apply it to the data set you want the statement to be applied to
birth_data[birth_data$age > 24, ] 

#' alternatively, you can use `subset(x, subset, select)` function. 
subset(x = birth_data, # object / dataset you want to subset
       subset = age > 24) # logical statement for the condition you want 

#' **Exercise**
#### Ex4) Question ####
#' Find the age of those who were either born in the summer (i.e., July ~ Oct) OR a man. 
#### Your answer (write your code below)






#### answer -----------------
#' step 1. Define the logical statements. 
birth_data$birth_month %in% c(7:10)
birth_data$sex == "man"

#' step 2. Combine the two statements with the correct operator, `|`.
birth_data$birth_month %in% c(7:10) | birth_data$sex == "man"

#'. step 3. Specify what information you want: age. 
birth_data$age

#' step 4. combine all the above!
birth_data$age[birth_data$birth_month %in% c(7:10)]

#' OR,
birth_data[birth_data$birth_month %in% c(7:10) | birth_data$sex == "man", "age"]

#' OR,
subset(x = birth_data, 
       subset = birth_month %in% c(7:10)|sex == "age",
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
birth_data$yr_remaining = ifelse(test = birth_data$sex == "men",
                                 yes = 80 - birth_data$age,
                                 no = 84 -  birth_data$age)

birth_data



## 3) Class attributes ---------------------------------------------------
#' Variables can have different class attributes. They can be
#' numeric
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