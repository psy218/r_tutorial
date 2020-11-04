#' This is the r-script that complements [Practical R](practical_r.Rmd)
#' *Contents* (i.e., lines that start with a pound sign, `#`) correspond to the tutorial above
#' Run *r codes* (i.e., lines that do not start with a pound sign) by putting your cursor on top of the line you want to run and,
#' a) press `Run` button on the right-hand corner, or
#' b) use the keyboard shortcut: command + enter (mac) or ctrl + enter (window)
#' Test your knowledge with *exercises* 

#### Tidyverse ####
#' [Tidyverse](https://www.tidyverse.org/) is a collection of R packages that facilitate data manipulation and exploration (cf. [a blog post on not using Tidyverse](https://blog.ephorie.de/why-i-dont-use-the-tidyverse)). 
#' 
#' Let's load tidyverse, and see what packages are included. 
library(tidyverse)


# a) core packages -------------------------------------
#' These are select core packages that are included in Tidyverse:   
#' 1. [ggplot2](https://r4ds.had.co.nz/data-visualisation.html) for data visualization   
#' 2. [dplyr](https://dplyr.tidyverse.org/) for data manipulation   
#' 3. [tidyr](https://r4ds.had.co.nz/tidy-data.html) for tidying data  
#' 4. [readr](https://r4ds.had.co.nz/data-import.html) for data import & export   
#' 5. [tibble](https://r4ds.had.co.nz/tibbles.html) for handling data frames   
#' 6. [purrr](https://r4ds.had.co.nz/iteration.html) for iterative programming  
#' 7. [forcats](https://r4ds.had.co.nz/factors.html) for manipulating factors (i.e., categorical variables)  

#' *Note* the packages under `tidyverse_conflicts()`; these are tidyverse functions that have the same names as other functions from different packages (e.g., base R).  

#' Use `package_name::function` to prevent errors from conflicting packages. For example, we can specifically call on `select()` function from `dplyr` package like this:     
# dplyr::select()

 
## b) data for excercises -------------------------------------
#' For data manipulation exercises, we will use two example datasets:
#' b1) starwars from `dplyr` package, and   
# load a dataset 
data(starwars)

#' b2) data with participant's demographic data (i.e., age, gender) and responses to BFI-10 (Rammstedt & John, 2007).  
#' 
#' Data codebook here:  
#' 
#' |variable name|description|variable name|description|
#' |:-|:-:|:-|:-:|
#' |pid|participant id| | |
#' |age|participant age (in years)| | |
#' |gender|participant gender|BFI_6|is outgoing, sociable|
#' |BFI_1|is reserved|BFI_7|tends to find fault with others|
#' |BFI_2|is generally trusting|BFI_8|does a thorough job|
#' |BFI_3|tends to be lazy|BFI_9|gets nervous easily|
#' |BFI_4|is relaxed|BFI_10|has an active imagination|
#' |BFI_5|has few artistic interests|BFI_11|handles stress well|
#' 
#' 
#' *Note*. BFI items are scored on 1 - 5 Likert scale; "BFI_1", "BFI_3", "BFI_4", and "BFI_5" are reverse-keyed. 

ocean_data <- readr::read_csv("https://raw.githubusercontent.com/psy218/r_tutorial/master/dataset/example_data.csv")


## c) piping (%>%) -------------------------------------
#' Base R and tidyverse R take different approaches to performing multiple functions.
#' Tidyverse R uses a pipe operator (`%>%`), which losely translates to "*then*"  
#' 
#' The pipe operator (`%>%`) becomes handy when you...   
#' 1. have many interim steps     
#' For example, when we want to run a regression with mean-centered variables   

starwars %>% 
  group_by(gender) %>% # step 1) mean centering height around gender
  mutate(height_mc = height - mean(height, na.rm = T)) %>% 
  lm(mass ~ height_mc, # step 2) then run a regression model using the mean-centered height
     data = .) %>% 
  summary # step 3) see the summary table


#' 2. do not wish to save the output (e.g., exploratory data analysis)  
#' For example, when we want to summarize our data and plot the summary data without saving it.

starwars %>% 
  # subsetting columns to graph: sex, height, and mass
  select(sex, height:mass) %>% 
  pivot_longer(cols = -sex, 
               names_to = c("dimension"),
               values_to = "value",
               values_drop_na = T) %>% 
  drop_na(sex) %>% 
  # plot mean and errorbars around the mean
  ggplot(aes(x = sex, 
             y = value, 
             fill = dimension)) +
  stat_summary(fun.y = mean, 
               geom = "bar", 
               position = position_dodge(.8),
               width = .8) +
  stat_summary(fun.data = mean_sdl, # mean +/- constant*sd
               fun.args = list(mult = 1), # constant (1sd)
               geom = "errorbar", 
               width = 0.25, position = position_dodge(.8)) +
  xlab("Sex of Starwars Character") + 
  ylab("Average Measurement") +
  scale_fill_manual("",
                    labels = c("height", "mass"),
                    values = c("#D55E00", "#999999")) +
  theme_bw()


#' As an example, let's calculate the average height of female Starwars characters.

#' Base R   
#' In order to perform multiple functions using base R, we perform them sequentially or nest multiple functions. 

## # sequential operations
## female_height_only <- starwars[starwars$gender=="female", ]$height # subset data
## mean(female_height_only, na.rm = T) # calculate mean of the subset
## 
## # nesting subset function inside mean
## colMeans(subset(starwars, # subsetting the data frame
##                 subset = gender == "female", # based on the condition
##                 select = "height"), # column of interest
##          na.rm = T) # then perform mean on the subsetted data


#' tidyverse R    
#' tidyverse uses a pipe (`%>%`) to perform multiple functions sequentially without creating an object. 
## starwars %>% # take the starwars dataset
##   subset(subset = gender == "female", select = "height") %>% # subset the data
##   colMeans(na.rm = T) # calculate the mean


## d) tidy dot  -------------------------------------
#' When you use the pipe operator, you can refer to the output from a previous operation with a `.`. For example, when we fit a linear model with a starwars dataset, we can *forward* the dataset straight into the subsequent operation with a `dot` like this:    

starwars %>% 
  lm(mass ~ height, 
     data = .)

# e) *dplyr* verbs ----------------------------------------------- 

#' There are [5 dplyr functions](https://dplyr.tidyverse.org/) that are useful for data manipulation. 
#' 
#' |verb|function|example|
#' |:-|:-|:-|
#' |[`select()`](#select)|choose variables by (column) names|`select(starwars, height, mass)`|
#' |[`filter()`](#filter)|choose observations by (conditional) values|`filter(starwars, gender == "none")`|
#' |[`mutate()`](#mutate)|transform or create new variables|`mutate(starwars, BMI = $weight/height^2$)`|
#' |[`summarize()`](#summarize)|summarize variables|`summarize(starwars, mean_height = mean(height, na.rm = T))`|
#' |`arrange()`|order variables|`arrange(starwars, height, desc(mass))`|
#' 
#### Data Manipulation ####
#' Subsetting data with `select()` & `filter()`  

## a) `select()` columns  -------------------------------
#' Like the square bracket `data[, "column_name"]`, the dollar sign `data$column_name`, and `subset(data, select = column_name)` function, `select(x)` allows you to extract elements by column name(s). 

#' Base R
starwars[ ,c("height", "mass")]

#' Tidyverse R
starwars %>% 
  select(height, mass) 

#' We can also select *out* a column with a minus sign (i.e., `-`). For example, we can keep all columns but the `name` column like this:  
starwars %>% 
  select(-name)

#' We can select multiple columns that share a prefix with `num_range()`.   
#' This is useful when you have multiple items for a scale that start with the same prefix. For example, if you have 10 items for BFI measure that follow the same naming pattern of BFI_number (e.g., BFI_1, BFI_2), you can provide the prefix followed by the item numbers: `num_range("BFI_", 1:10)`  

ocean_data %>% 
  select(num_range("BFI_", 1:10))

#' #### conditional selection 
#' You can combine `select()` function with conditional statements such as `starts_with()`. 
#' 
#' For example, if we want to find all the columns whose names begin with the letter *s*, we can nest the conditional statement, `starts_with("s")` inside the `select()` function. 

starwars %>% 
  select(starts_with("s")) 

#' These are some useful conditional statements you can use with `select()`:   
#' 
#' |condition|function|
#' |:-|:-|
#' |`starts_with("x")`|column names that begin with "x"|
#' |`ends_with("x")`|column names that end with "x"|
#' |`contains("x")`|column names that contain "x"|
#' |`num_range("x", 1:3)`|columns that match `x1`, `x2`, and `x3`|
#' |`everything()`|select all columns; useful for rearranging|
#' |`one_of(c("height", "mass"))`|select one of `height` or `mass`|
#' 

#' #### renaming with `select()`
#' You can rename column names by providing a new name followed by an equal sign and the original name inside the select function: `select(new_name = original_name)`.      
# renaming films to `movie` and reorganize columns such that name and species come before all other columns
starwars %>% 
  select(name, species, # columns to be placed first
         movie = films, # renaming films to movie
         everything())  # reorganizing columns 

## b) `filter()` observations ---------------------------------------
#' 
#' Like the conditional statement inside a square bracket `[]`, `filter()` allows you to extract elements that meet specified conditions.   

#' Base R
starwars[c(starwars$mass<1000 & starwars$height > 100), ]

#' tidyverse R
starwars %>% 
  filter(mass < 1000, height > 100)
 
#' #### conditional filtering  
#' Like `select()`, you can add more specification inside the `filter()` function with logical operators (e.g., `==`), and `between()` or `is.na()` statements. 
#' For example, you can choose starwars characters that have `mass` data by using a `is.na()` function, but negated with `!`. <aside>an exclamanation mark before a function negates it; `!function()`</aside>
starwars %>% 
  filter(!is.na(mass)) # choosing observations that do NOT have missing data for mass 


### **Exercise 1** --------------
#' Let's subset our starwars data set using multiple conditions. 
#' 
#' #### Question
#' Find the names (`name`) and gender (`gender`) of human characters (i.e., `species == Human`) who are between 23 to 35 years of age (i.e., `birth_year`)and do not have blue eyes (i.e., `eye_colour`). 

#### Your answer (write your code below)







# EX1) Answer  --------------
starwars %>% 
  filter(species == "Human", # human 
         eye_color != "blue", # eye color not blue
         between(birth_year, left = 23, right = 35)) %>% # age falling between 23 and 35
  select(name, gender) # just choosing the name column



#### Summarize data with `mutate()` and `summarize()` ####

## c) `mutate()` variables {#mutate} -------------- 
#' `mutate()` creates a new variable by operating on our dataset. 
#' We do so by providing a name of a new (or existing) column name followed by an equal sign and operations: `mutate(column_name = operation(old_column))`. Operations can be a simple arithmatic (e.g., adding two columns together), or a function (e.g., averaging multiple columns with `mean()` function).    

#' Base R
## # using `within()`
within(starwars,
       {bmi = 703 * mass/(height^2)})

## # Or, writing directly inside
starwars$bmi = 703 * starwars$mass/(starwars$height^2)

#' tidyverse R
starwars %>% 
  mutate(bmi = 703 * mass/(height^2)) %>% 
  select(name, height, mass, bmi) 


#' These are some functions you can use with `mutate()`:   
#' 1) Conditionally operate on a column with `ifelse()` 
#' run `?ifelse()`, or check Ex 5 in the basic tutorial for `ifelse()` function   
starwars %>% 
  mutate(skin_color = ifelse(skin_color == "pale", 
                             yes = "ghostly",
                             no = skin_color))


#' 2) Code a certain value as missing (i.e., `NA`) with `na_if()` by providing the column name followed by the value that should be coded as missing (e.g., -99): `na_if(column_name, -99)`  
starwars %>%
  select(name, eye_color) %>%
  mutate(eye_color = na_if(eye_color, # column to recode
                           "unknown")) # value to be converted to a missing value  


#' #### conditional mutation ------
#' **mutate_at()**   
#' We can conditionally mutate our datasets based on variable names (`mutate_at()`) and/or specific conditions (`mutate_if()`). 

#' `mutate_at()` takes two additional arguments: 1) names of the column(s) you want to mutate (`.vars`), and 2) function(s) to mutate with (`.funs`): 

data %>%
  mutate_at(.vars = c("column_name1", "column_name2", "column_name3"), # column names
            .funs = list(min, max, mean, sd), # multiple functions to be applied on those columns
            na.rm = TRUE) # specification for the functions above; removing missing values

 
#' You can also combine conditional [select()](#conditional_select) statements inside `mutate_at()`, nested in `vars()`.

# `starts_with()`
data %>%
  mutate_at(vars(starts_with("BFI_")), ~function(.))


#' **mutate_if()** -------
#' `mutate_if()` requires a conditional statement (`.predicate`), instead of variable names. 

# data %>% 
#    mutate_if(.predicate = conditional_statement,
#              .funs = list(min, max))

#' The conditional statements can be a type of variables (e.g., `is.numeric`; `is.double`; `is.character`), which is useful for iterating through columns of the same type. 
#' For example, you may have to convert varialbes that are numeric to whole numbers. You can do this with `mutate_if()`:      

starwars %>%
  mutate_if(is.double, # if a variable is double (numeric)
            as.integer) # convert it to whole numbers


##### item-scoring with `mutate_at()` #####      
#' `mutate_at()` is useufl for scoring measures with multiple items saved across columns.  
#' 
#' Let's reverse score BFI items 1, 3, 4, and 5, and create aggregate scores of OCEAN. 
#' Step 1: Selectively reverse score items that are reverse-keyed: BFI_1, 3:5

ocean_data %>% 
  mutate_at(c("BFI_1", "BFI_3", "BFI_4", "BFI_5"), # select reverse-keyed items
            # vars(num_range("BFI_", c(1, 3:5))), 
            ~(6 - .)) # reverse-score the selected columns (as indicated by the tidy dot) 


#' Step 2: Reverse score items (without saving) and calculate an aggregate score  

ocean_data %>% 
  # reverse code items first 
  mutate_at(vars(num_range("BFI_", c(1, 3:5))), 
            ~(6 - .)) %>% 
  # then create a new variable to store aggregate scores
  mutate(extraversion = rowMeans(cbind(BFI_1, BFI_6), na.rm = T), 
         conscientiousness = rowMeans(cbind(BFI_3, BFI_8), na.rm = T),
         neuroticism = rowMeans(cbind(BFI_4, BFI_9, BFI_11), na.rm = T),
         agreableness = rowMeans(cbind(BFI_2, BFI_7), na.rm = T),
         openness = rowMeans(cbind(BFI_5, BFI_10), na.rm = T),
         .after = gender) # place them after gender


## d) `summarize()` data --------------------------------
#' 
#' Without creating a new variable with `mutate()`, we can create a summary of our data using `summarize()` function with a similar formula: `variable_name = operation(column_name)`. 

#' For example, let's look at average height and mass with their standard deviations using `mean()` and `sd()` functions.   

starwars %>% 
  summarize(height_mean = mean(height, na.rm = T),
            height_sd = sd(height, na.rm = T),
            mass_mean = mean(mass, na.rm = T),
            mass_sd = sd(mass, na.rm = T))


# alternatively, you can use `summarize_at()` if you are feeling terse
starwars %>% 
  summarise_at(vars(height, mass), # variables we want to apply functions on
               list(~mean(., na.rm = T), # first function 
                    ~sd(., na.rm = T))) # second function


#' #### summary functions  -----------
#' You can use the following functions with `summary()`. 

#' |name|function|
#' |:-|:-|
#' |`n()`|# of observations or row |
#' |`n_distinct()`|# of *unique* observations or a given column |
#' |`mean(x)`|average of x |
#' |`sd(x)`|standard deviation of x |
#' |`min(x)`|minimum value of x |
#' |`max(x)`|maximum value of x |
#' |`sum(is.na(x))`|# of missing observations|
#' 

starwars %>% 
  summarize(height_n = n(),
            unique_sex = n_distinct(sex),
            height_mean = mean(height, na.rm = T),
            height_sd = sd(height, na.rm = T),
            height_min = min(height, na.rm = T),
            height_max = max(height, na.rm = T),
            height_na = sum(is.na(height)))

#' Check for more useful summary functions with `?summarize()` 

#' #### selective summary --------------------
#' Like [conditional mutatation](#conditional_mutate), `summarize()` function can be applied selective at specific variables (`summarize_at()`) or variables of a specific type (`summarize_if()`).  
#' 
#' 
#' You can selectively apply the same functions to multiple variables using `summarize_at()`:  
starwars %>% 
  summarize_at(.vars = vars("height", "mass"), # specify which variables  
               .funs = list(~mean(., na.rm = T), # list of functions you want to apply
                    ~sd(., na.rm = T),
                    ~min(., na.rm = T),
                    ~max(., na.rm = T),
                    ~sum(is.na(.)))) %>% 
  pivot_longer(cols = everything(), # (optional) to make the summary table easier to read  
               names_to = c(".value", "test"),
               names_sep = "_")


#' `summarize_if()` is useful for data inspection of similar variable types (e.g., numeric/double):   
starwars %>% 
  summarise_if(is.numeric, # the type of variable that makes sense to compute descriptive stats.  
               list(mean = mean, sd = sd, # functions for the descriptive stats: mean, sd, & range 
                    min = min, max = max),
               na.rm = T) %>% # additional specification for those functions: removing missing values  
  # (optional) organization to make the table easier to read  
  pivot_longer(cols = everything(), 
               names_to = c(".value", "test"),
               names_pattern = "(.*)_(mean|sd|min|max)")


#### conditional manipulation with `group_by()` #### 
#' When we want to mutate or create a summary for different groups (e.g., gender), we can combine `mutate()` and `summarize()` with `group_by()` function.  
#' 
#' We provide a dataset, then provide a grouping variable inside `group_by()` (e.g., "sex"; `group_by(sex)`) to divide the dataset based on the grouping variable (i.e., sex), and mutate or summarize separately for these groups.    
#' 
#' For example, we can calculate average height and mass for each sex group.  
starwars %>% 
  group_by(sex) %>% # grouping our data based on gender
  summarise_at(c("height", "mass"), 
               list(mean = mean, sd = sd),
               na.rm = TRUE) 

#' `group_by()` is also useful when we want to mean-centre variables.   
ocean_data %>% 
  # this is just another way of computing aggregate scores; see item-scoring under `mutate_at()`   
  rowwise() %>% # tell R to do this for every row  
  mutate(BFI_1 = 6 - BFI_1, # reverse score BFI_1
         extraversion = mean(c_across(c("BFI_1", "BFI_6")))) %>% # create an extraversion score
  group_by(gender) %>%  # group data by gender  
  mutate(extraversion_gm = mean(extraversion, na.rm = T), # mean extraversion for women and men  
         # subtract individual extraversion score from average extraversion of women and men  
         extraversion_gmc = extraversion - extraversion_gm, 
         .after = extraversion) %>%  # where we want these columns to appear 
  # ungroup() data so the subsequent operations won't be applied separately to different groups  
  ungroup() 

 
#### **Exercise 2** ####
#' ##### Question  
#' 1) Create an aggregate score of `neuroticism` for each participant by 
#' a) inspecting neuroticism items (i.e., BFI_4, BFI_9 BFI_11),    
#' b) reverse-coding BFI_4, and BFI_11, and   
#' c) averaging neuroticm items (i.e., BFI_4, BFI_9, and BFI_11).   
#' 
#' 2) Create a descriptive table of the neuroticism variable with its mean and standard deviations, separately for men and women (avaiable gender groups in the dataset).  
#' 
#' 3) Run a linear regression analysis with extraversion as neuroticism as an outcome variable and gender, age, and their interaction terms as predictors.  

#### Your answer (write your code below)













##### Ex2) Answer --------------
#' 1) item-scoring for neuroticism  
#' step 1: inspect neuroticism items: BFI_4, BFI_9, BFI_11
#' 1a) descriptive statistics for plausibility  
ocean_data %>% 
  summarize_at(vars(num_range("BFI_", c(4, 9, 11))), # select nueoriticism items
               list(min = min, max = max, # range
                    mean = mean, sd = sd, # mean & sd
                    skew = e1071::skewness, kurt = e1071::kurtosis), # skewness & kurtosis  
               na.rm = T) %>% 
  # optional: table organization to make it easier to read  
  pivot_longer(cols = everything(),
               names_to = c("BFI_item", "stat"),
               values_to = "value",
               names_pattern = "BFI_(4|9|11)_(.*)") %>% 
  spread(stat, value)

#' 1b) internal reliability of the scores  
#' `psych()` package is useful for inspecting internal reliability   
#' its `alpha()` function has an additional `check.keys` argument, which inspects any reverse-keyed items
ocean_data %>% 
  # first choose items for a single scale: i.e., nueoriticm items
  dplyr::select(num_range("BFI_", c(4, 9, 11))) %>% 
  # see internal reliability  
  psych::alpha(check.keys = TRUE)

#' steps 2 & d: reverse score items and create an aggregate score
#' Make sure you save these aggregate scores by overwritting an existing dataset (or create a new one)  
ocean_data = ocean_data %>% 
  # reverse-score items and save them as new variables: BFI_(x)_rs
  mutate(across(num_range("BFI_", c(4, 11)), list(rs = ~{6 - .}))) %>% 
  # create an aggregate score using reverse-scored items and BFI_9
  mutate(neuroticism = rowMeans(cbind(BFI_4_rs, BFI_9, BFI_11_rs), na.rm = T)) 


#' 2) Descriptive tables for women and men   
ocean_data %>% 
  group_by(gender) %>% # this will allow us to calcualte the group mean when we use mean function
  summarize_at("neuroticism", 
               list(mean = mean,
                    sd = sd),
               na.rm = T)

#' 3) Linear regression with neuroticism as an outcome and 
#' gender, age, and their interaction as predictors

ocean_data %>% 
  lm(neuroticism ~ gender + age + gender:age,
     data = .) %>% 
  summary


