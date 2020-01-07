---
title: "Intro_R"
output: 
  html_document:
    keep_md: true
    theme: cosmo
    highlight: tango
    toc: true
    toc_float: true
    toc_depth: 5
    df_print: kable
---




```r
# packages we may need 
library(tidyverse)
```

# Data Structure
## Accessing data inside a data frame
Let's create a data frame called `basket` that contains different kinds of fruits and veggies. 

```r
basket <- data.frame(fruits = sample(stringr::fruit, 5), # randomly selecting 5 fruits
                     veggies = c("carrots", "broccoli", "celery", "pepper", "peas"), # 5 kinds of veggies
                     fruit_quantity = c(3, 2, 5, 4, 5), # number of veggies
                     veggie_quantity = c(1, 4, 2, 2, 10)) # number of veggies

# I'm going to save this dataset as my randomly-sampled fruits will be different from yours
# write_csv(basket, here::here("dataset", "basket.csv"))
```

### Indexing
We can use a square bracket (i.e., []) to access an element inside a data frame by its location or column names. 

#### By location

```
data.frame[i, j] 
```
The first element (i.e., *i*) corresponds to the row, and the second (i.e., *j*) corresponds to the column. 

| |col j1 |col j2|col j3|
|:-:|:-:|:-:|:-:|
|row i1|[1, 1]|[1, 2]|[1, 3]|
|row i2|[2, 1]|[2, 2]|[2, 3]|
|row i3|[3, 1]|[3, 2]|[3, 3]|


```r
basket
```

<div class="kable-table">

fruits         veggies     fruit_quantity   veggie_quantity
-------------  ---------  ---------------  ----------------
banana         carrots                  3                 1
tangerine      broccoli                 2                 4
date           celery                   5                 2
canary melon   pepper                   4                 2
blackcurrant   peas                     5                10

</div>

##### Single elements
For example, we can access the second element in the 2nd column like this:

```r
basket[2, # 2nd row
       2] # 2nd column
```

```
## [1] broccoli
## Levels: broccoli carrots celery peas pepper
```

##### Multiple elements
We can access multiple elements by using a vector (`c()`) inside a bracket, or `:`sign. 


```r
basket[c(1, 3), # elements in the first and third rows
       c(2, 3)] # first element in the second row & third element in the third row
```

<div class="kable-table">

     veggies    fruit_quantity
---  --------  ---------------
1    carrots                 3
3    celery                  5

</div>

```r
basket[c(1, 3), 
       2:3] # same as c(2, 3)
```

<div class="kable-table">

     veggies    fruit_quantity
---  --------  ---------------
1    carrots                 3
3    celery                  5

</div>

##### Negative index

We can use **negative index** to exclude elements. 


```r
basket[-2, -1] # excluding elements in the 2nd row & 1st column
```

<div class="kable-table">

     veggies    fruit_quantity   veggie_quantity
---  --------  ---------------  ----------------
1    carrots                 3                 1
3    celery                  5                 2
4    pepper                  4                 2
5    peas                    5                10

</div>

```r
basket[-2, 2:3] # excluding elements in the 2nd row & including elements in the 2nd & 3rd columns
```

<div class="kable-table">

     veggies    fruit_quantity
---  --------  ---------------
1    carrots                 3
3    celery                  5
4    pepper                  4
5    peas                    5

</div>



#### By column name
We can also use column names. All the codes below will access information stored in the *fruit* column. 


```r
basket[ , "fruits"]
```

```
## [1] banana       tangerine    date         canary melon blackcurrant
## Levels: banana blackcurrant canary melon date tangerine
```

```r
basket[["fruits"]]
```

```
## [1] banana       tangerine    date         canary melon blackcurrant
## Levels: banana blackcurrant canary melon date tangerine
```

We use the dollar sign (i.e., `$`) to specify a column. 

```r
basket$fruits
```

```
## [1] banana       tangerine    date         canary melon blackcurrant
## Levels: banana blackcurrant canary melon date tangerine
```

Try pressing the *Tab* key after typing the `dollar sign`.  

#### By conditions
We can also select elements conditionally; that is, we can specify what element we want. 
R will evaluate the statement and return only those elements that meet the specified condition. 

##### Mathematical Annotations  
Conditional statements follow the same operations:  

|syntax|meaning|example|  
|:--:|:--|:--|  
|`==`|equal to|x == y|  
|`!=`|not equal to|x != y|  
|`>`|greater than|x > y|
|`<`|less than|x < y|
|`>=`|greater than or equal to|x >= y|
|`<=`|less than or equal to|x <= y|

You can have multiple conditions by using the following operators:

|syntax|meaning|example|
|:--:|:--|:--|
|`|`|or|x == 1 `|` x == 2|
|`&`|and|x == 1 & y == 2|
|`%in%`|testing multiple elements|x %in% c(1, 2)|

A reference list for the operators can be found [here](https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/plotmath.html) or [R Cookbook Table 2.1](https://rc2e.com/SomeBasics.html#tab:precedence).  

For example, let's say I only want a specific veggie, carrots: 

```r
basket$veggies[basket$veggies == "carrots"] # within the fruit column, element named "pear"
```

```
## [1] carrots
## Levels: broccoli carrots celery peas pepper
```

Or, the broccoli and celery:

```r
# using OR (`|`)
basket$veggies[basket$veggies == "broccoli" | basket$veggies == "celery"]
```

```
## [1] broccoli celery  
## Levels: broccoli carrots celery peas pepper
```

```r
# using %in%
basket$veggies[basket$veggies %in% c("broccoli", "celery")]
```

```
## [1] broccoli celery  
## Levels: broccoli carrots celery peas pepper
```

Or, a fruit whose quantity exceeds 3. 

```r
basket$fruits[basket$fruit_quantity > 3] 
```

```
## [1] date         canary melon blackcurrant
## Levels: banana blackcurrant canary melon date tangerine
```

#### **Exercise 1** {.tabset .tabset-fade .tabset-pills}
##### Question    
Find all the fruits and veggies whose names do not start with the letter "c".


```r
# your answer here
```

##### Answer   

```r
# read-in saved basket dataset for the example
(basket <- readr::read_csv(here::here("dataset", "basket.csv")))
```

<div class="kable-table">

fruits       veggies     fruit_quantity   veggie_quantity
-----------  ---------  ---------------  ----------------
rock melon   carrots                  3                 1
cloudberry   broccoli                 2                 4
guava        celery                   5                 2
grapefruit   pepper                   4                 2
lychee       peas                     5                10

</div>

```r
# Finding the names of fruits and veggies whose names do not start with "c" using the startsWith() function. 
basket[!startsWith(basket$fruits, "c"), "fruits"]
```

<div class="kable-table">

|fruits     |
|:----------|
|rock melon |
|guava      |
|grapefruit |
|lychee     |

</div>

```r
basket[!startsWith(basket$veggies, "c"), "veggies"]
```

<div class="kable-table">

|veggies  |
|:--------|
|broccoli |
|pepper   |
|peas     |

</div>


# Data Manipulation   
For the exercises, we will use an example dataset, starwars. 

```r
# import the example dataset
starwars <- dplyr::starwars

# I am going to mess up the data for our exercises; Run this code for extra challenge. 
library(tidyverse)
starwars <- starwars %>% 
  mutate_at(vars("height"), as.character) %>%  # height is now a character variable
  mutate(hair_color = replace(hair_color, is.na(hair_color), 999)) %>% 
  mutate(gender = case_when( 
    gender == "female" ~ 0,
    gender == "male" ~ 1,
    gender == "hermaphrodite" ~ 2,
    gender == "none" ~ 3,
    TRUE ~ NA_real_))
```

## 1) Data Preparation  
Before analyzing your data, make sure your data is *clean*. 

Data preparation can involve:   
1) making sure your variables have the correct class attributes 
  - e.g., a numeric variable not coded as character variable
  
2) observations are correctly coded
  - e.g., a question with the 7-point Likert-type scale ranging from 1 to 7 (and not 5 - 11).
  
3) checking missing data


Let's first inspect our dataset using `glimpse()` function from the `tibble` package. 

```r
tibble::glimpse(starwars)
```

```
## Observations: 87
## Variables: 13
## $ name       <chr> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "L…
## $ height     <chr> "172", "167", "96", "202", "150", "178", "165", "97",…
## $ mass       <dbl> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 84.…
## $ hair_color <chr> "blond", "999", "999", "none", "brown", "brown, grey"…
## $ skin_color <chr> "fair", "gold", "white, blue", "white", "light", "lig…
## $ eye_color  <chr> "blue", "yellow", "red", "yellow", "brown", "blue", "…
## $ birth_year <dbl> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0, …
## $ gender     <dbl> 1, NA, NA, 1, 0, 1, 0, NA, 1, 1, 1, 1, 1, 1, 1, 2, 1,…
## $ homeworld  <chr> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alderaa…
## $ species    <chr> "Human", "Droid", "Droid", "Human", "Human", "Human",…
## $ films      <list> [<"Revenge of the Sith", "Return of the Jedi", "The …
## $ vehicles   <list> [<"Snowspeeder", "Imperial Speeder Bike">, <>, <>, <…
## $ starships  <list> [<"X-wing", "Imperial shuttle">, <>, <>, "TIE Advanc…
```

You can get the names of the variables by running `names()` or `colnames()`. 

```r
names(starwars)
```

```
##  [1] "name"       "height"     "mass"       "hair_color" "skin_color"
##  [6] "eye_color"  "birth_year" "gender"     "homeworld"  "species"   
## [11] "films"      "vehicles"   "starships"
```

```r
colnames(starwars)
```

```
##  [1] "name"       "height"     "mass"       "hair_color" "skin_color"
##  [6] "eye_color"  "birth_year" "gender"     "homeworld"  "species"   
## [11] "films"      "vehicles"   "starships"
```

### Class attribute  
Make sure your variables have the correct data types. 

#### Numeric variables  
Make sure our continuous variables (i.e., height and mass) are numeric. 

```r
is.numeric(starwars$height)
```

```
## [1] FALSE
```

```r
is.numeric(starwars$mass)
```

```
## [1] TRUE
```

Height variable is not numeirc; convert it to a numeric variable. 

```r
starwars$height <- as.numeric(starwars$height)
```


#### Factors
Categorical variables can have a special class attribute as **factors**. You can specify the levels of factors and specify whether these levels are ordered (i.e., levels are sorted into an increasing order) or unordered. 

For example, let's look at the gender variable in our starwars dataset. We can look at the frequency table by using the `table()` function. 

```r
table(starwars$gender)
```

```
## 
##  0  1  2  3 
## 19 62  1  2
```
There are 4 levels associated with the gender variable:
|level|label|
|:--|:--:|
|0|female|
|1|male|
|2|hermaphrodite|
|3|none|

Let's check if this variable is a factor. 

```r
is.factor(starwars$gender)
```

```
## [1] FALSE
```
It isn't. 

When we plot using gender as is, gender is treated as a continuous numeric variable like so:

```r
ggplot(subset(starwars, mass < 1000), 
       aes(x = height, 
           y = mass, 
           colour = gender)) +
  geom_point() +
  theme_bw()
```

![](intro_R_files/figure-html/unnamed-chunk-20-1.png)<!-- -->


We can convert the gender variable using the `factor()` function.

```r
starwars$gender <- factor(starwars$gender, 
                          levels = c(0:3), # numeric values representing the levels
                          labels = c("female", "male","hermaphrodite", "none"), # corresponding lables for each of the numeric value
                          ordered = FALSE) # change this to TRUE if you want it ordered
```

When we convert our gender variable into a factor, we will see the relationship between height and weight for the four gender groups. 

```r
ggplot(subset(starwars, mass < 1000), 
       aes(x = height, 
           y = mass, 
           colour = gender)) +
  geom_point() + 
  theme_bw()
```

![](intro_R_files/figure-html/unnamed-chunk-22-1.png)<!-- -->


### Missing data 
In R, missing values are coded as `NA`.


Let's look at characters whose height is missing by running a logical statement, `is.na()`.

```r
head(starwars[is.na(starwars$height)==TRUE, ])
```

<div class="kable-table">

name              height   mass  hair_color   skin_color   eye_color    birth_year  gender   homeworld   species   films                vehicles       starships           
---------------  -------  -----  -----------  -----------  ----------  -----------  -------  ----------  --------  -------------------  -------------  --------------------
Arvel Crynyd          NA     NA  brown        fair         brown                NA  male     NA          Human     Return of the Jedi   character(0)   A-wing              
Finn                  NA     NA  black        dark         dark                 NA  male     NA          Human     The Force Awakens    character(0)   character(0)        
Rey                   NA     NA  brown        light        hazel                NA  female   NA          Human     The Force Awakens    character(0)   character(0)        
Poe Dameron           NA     NA  brown        light        brown                NA  male     NA          Human     The Force Awakens    character(0)   T-70 X-wing fighter 
BB8                   NA     NA  none         none         black                NA  none     NA          Droid     The Force Awakens    character(0)   character(0)        
Captain Phasma        NA     NA  unknown      unknown      unknown              NA  female   NA          NA        The Force Awakens    character(0)   character(0)        

</div>


We can isolate observations with non-missing height data by negating `is.na()` statement with `!` symbol.

```r
head(starwars[!is.na(starwars$height)==TRUE, ])
```

<div class="kable-table">

name              height   mass  hair_color    skin_color    eye_color    birth_year  gender   homeworld   species   films                                                                                                                                                        vehicles                                    starships                       
---------------  -------  -----  ------------  ------------  ----------  -----------  -------  ----------  --------  -----------------------------------------------------------------------------------------------------------------------------------------------------------  ------------------------------------------  --------------------------------
Luke Skywalker       172     77  blond         fair          blue               19.0  male     Tatooine    Human     c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")                                                 c("Snowspeeder", "Imperial Speeder Bike")   c("X-wing", "Imperial shuttle") 
C-3PO                167     75  999           gold          yellow            112.0  NA       Tatooine    Droid     c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope")                        character(0)                                character(0)                    
R2-D2                 96     32  999           white, blue   red                33.0  NA       Naboo       Droid     c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")   character(0)                                character(0)                    
Darth Vader          202    136  none          white         yellow             41.9  male     Tatooine    Human     c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope")                                                                      character(0)                                TIE Advanced x1                 
Leia Organa          150     49  brown         light         brown              19.0  female   Alderaan    Human     c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")                                                 Imperial Speeder Bike                       character(0)                    
Owen Lars            178    120  brown, grey   light         blue               52.0  male     Tatooine    Human     c("Attack of the Clones", "Revenge of the Sith", "A New Hope")                                                                                               character(0)                                character(0)                    

</div>


Let's check the total missing values for each variable by running `colSums()` function. 

```r
colSums(is.na(starwars))
```

```
##       name     height       mass hair_color skin_color  eye_color 
##          0          6         28          0          0          0 
## birth_year     gender  homeworld    species      films   vehicles 
##         44          3         10          5          0          0 
##  starships 
##          0
```


#### Recode NA
For datasets that use different coding for missing values (e.g., 999), we can convert it to `NA`. In our dataset, missing values for `hair_color` variable are coded as 999; let's recode this variable. 

```r
starwars$hair_color[starwars$hair_color == 999] <- NA
```

#### Dealing with NA  
Some functions (e.g., `mean()`, `median()`) give you an error when the dataset contains missing values. 

```r
mean(starwars$mass)
```

```
## [1] NA
```

Some functions allow you to specify how NA should be treated with the `na.rm` argument. When you specify `na.rm = TRUE`, missing values (`na`) will be removed (`rm`). 

```r
mean(starwars$mass, na.rm = TRUE)
```

```
## [1] 97.31186
```

Alternatively, we can remove any rows that contain missing values using `na.omit()` or `na.exclude()` function.

```r
mean(na.omit(starwars$mass))
```

```
## [1] 97.31186
```

```r
mean(na.exclude(starwars$mass))
```

```
## [1] 97.31186
```


## 2) Data Summary
### Descriptive statistics  
Let's get descriptive statistics of our data. 
Most often used functions are listed below:

```r
mean(x, na.rm = T) # mean
median(x, na.rm = T) # median
sd(x, na.rm = T) # standard deviation
range(x, na.rm = T) # min and max values
```


### Conditional summary
We can use the indexing techniques to compute summary statistics for the subgroups that meet the qualifications. 

For example, we can compute average height of those whose hair colour is brown. 

```r
mean(starwars[starwars$hair_color == "brown", ]$height, na.rm = T)
```

```
## [1] 175.2667
```

Characters with brown hair are tad taller than the average height of all the characters, 174.36. 

#### **Exercise 2** {.tabset .tabset-fade .tabset-pills}
##### Question
Within the starwars dataset, find the names of the character whose height falls between the 5th and 95th quantiles. 


```r
# your answer here
```

##### Answer  


```r
# step 1: Find column names
names(starwars)
```

```
##  [1] "name"       "height"     "mass"       "hair_color" "skin_color"
##  [6] "eye_color"  "birth_year" "gender"     "homeworld"  "species"   
## [11] "films"      "vehicles"   "starships"
```

```r
# step 2: specify what information I want to get: character names
starwars$name
```

```
##  [1] "Luke Skywalker"        "C-3PO"                
##  [3] "R2-D2"                 "Darth Vader"          
##  [5] "Leia Organa"           "Owen Lars"            
##  [7] "Beru Whitesun lars"    "R5-D4"                
##  [9] "Biggs Darklighter"     "Obi-Wan Kenobi"       
## [11] "Anakin Skywalker"      "Wilhuff Tarkin"       
## [13] "Chewbacca"             "Han Solo"             
## [15] "Greedo"                "Jabba Desilijic Tiure"
## [17] "Wedge Antilles"        "Jek Tono Porkins"     
## [19] "Yoda"                  "Palpatine"            
## [21] "Boba Fett"             "IG-88"                
## [23] "Bossk"                 "Lando Calrissian"     
## [25] "Lobot"                 "Ackbar"               
## [27] "Mon Mothma"            "Arvel Crynyd"         
## [29] "Wicket Systri Warrick" "Nien Nunb"            
## [31] "Qui-Gon Jinn"          "Nute Gunray"          
## [33] "Finis Valorum"         "Jar Jar Binks"        
## [35] "Roos Tarpals"          "Rugor Nass"           
## [37] "Ric Olié"              "Watto"                
## [39] "Sebulba"               "Quarsh Panaka"        
## [41] "Shmi Skywalker"        "Darth Maul"           
## [43] "Bib Fortuna"           "Ayla Secura"          
## [45] "Dud Bolt"              "Gasgano"              
## [47] "Ben Quadinaros"        "Mace Windu"           
## [49] "Ki-Adi-Mundi"          "Kit Fisto"            
## [51] "Eeth Koth"             "Adi Gallia"           
## [53] "Saesee Tiin"           "Yarael Poof"          
## [55] "Plo Koon"              "Mas Amedda"           
## [57] "Gregar Typho"          "Cordé"                
## [59] "Cliegg Lars"           "Poggle the Lesser"    
## [61] "Luminara Unduli"       "Barriss Offee"        
## [63] "Dormé"                 "Dooku"                
## [65] "Bail Prestor Organa"   "Jango Fett"           
## [67] "Zam Wesell"            "Dexter Jettster"      
## [69] "Lama Su"               "Taun We"              
## [71] "Jocasta Nu"            "Ratts Tyerell"        
## [73] "R4-P17"                "Wat Tambor"           
## [75] "San Hill"              "Shaak Ti"             
## [77] "Grievous"              "Tarfful"              
## [79] "Raymus Antilles"       "Sly Moore"            
## [81] "Tion Medon"            "Finn"                 
## [83] "Rey"                   "Poe Dameron"          
## [85] "BB8"                   "Captain Phasma"       
## [87] "Padmé Amidala"
```

```r
# step 3: specify the condition
starwars$height > quantile(starwars$height, 0.05, na.rm = T) # height above the 5th quantile
```

```
##  [1]  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [12]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE
## [23]  TRUE  TRUE  TRUE  TRUE  TRUE    NA FALSE  TRUE  TRUE  TRUE  TRUE
## [34]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [45] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [56]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [67]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE
## [78]  TRUE  TRUE  TRUE  TRUE    NA    NA    NA    NA    NA  TRUE
```

```r
starwars$height < quantile(starwars$height, 0.95, na.rm = T) # height below the 95th quantile
```

```
##  [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [12]  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [23]  TRUE  TRUE  TRUE  TRUE  TRUE    NA  TRUE  TRUE  TRUE  TRUE  TRUE
## [34]  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [45]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
## [56]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [67]  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [78] FALSE  TRUE  TRUE  TRUE    NA    NA    NA    NA    NA  TRUE
```

```r
# step 4: combine them! 
starwars$name[(starwars$height > quantile(starwars$height, 0.05, na.rm = T)) & 
                (starwars$height < quantile(starwars$height, 0.95, na.rm = T))]
```

```
##  [1] "Luke Skywalker"        "C-3PO"                
##  [3] "Darth Vader"           "Leia Organa"          
##  [5] "Owen Lars"             "Beru Whitesun lars"   
##  [7] "R5-D4"                 "Biggs Darklighter"    
##  [9] "Obi-Wan Kenobi"        "Anakin Skywalker"     
## [11] "Wilhuff Tarkin"        "Han Solo"             
## [13] "Greedo"                "Jabba Desilijic Tiure"
## [15] "Wedge Antilles"        "Jek Tono Porkins"     
## [17] "Palpatine"             "Boba Fett"            
## [19] "IG-88"                 "Bossk"                
## [21] "Lando Calrissian"      "Lobot"                
## [23] "Ackbar"                "Mon Mothma"           
## [25] NA                      "Nien Nunb"            
## [27] "Qui-Gon Jinn"          "Nute Gunray"          
## [29] "Finis Valorum"         "Jar Jar Binks"        
## [31] "Rugor Nass"            "Ric Olié"             
## [33] "Watto"                 "Sebulba"              
## [35] "Quarsh Panaka"         "Shmi Skywalker"       
## [37] "Darth Maul"            "Bib Fortuna"          
## [39] "Ayla Secura"           "Gasgano"              
## [41] "Ben Quadinaros"        "Mace Windu"           
## [43] "Ki-Adi-Mundi"          "Kit Fisto"            
## [45] "Eeth Koth"             "Adi Gallia"           
## [47] "Saesee Tiin"           "Plo Koon"             
## [49] "Mas Amedda"            "Gregar Typho"         
## [51] "Cordé"                 "Cliegg Lars"          
## [53] "Poggle the Lesser"     "Luminara Unduli"      
## [55] "Barriss Offee"         "Dormé"                
## [57] "Dooku"                 "Bail Prestor Organa"  
## [59] "Jango Fett"            "Zam Wesell"           
## [61] "Dexter Jettster"       "Taun We"              
## [63] "Jocasta Nu"            "Wat Tambor"           
## [65] "San Hill"              "Shaak Ti"             
## [67] "Grievous"              "Raymus Antilles"      
## [69] "Sly Moore"             "Tion Medon"           
## [71] NA                      NA                     
## [73] NA                      NA                     
## [75] NA                      "Padmé Amidala"
```


#### **Exercise 3** {.tabset .tabset-fade .tabset-pills}
##### Question
For each of the gender group, find the means and stadnard deviations of their height. 

##### Answer  

```r
with(starwars, tapply(X = height, 
                      INDEX = gender, mean, na.rm = T))
```

```
##        female          male hermaphrodite          none 
##      165.4706      179.2373      175.0000      200.0000
```



## 3) Data Transformation    

Let's use an example data with participant's demographic data (i.e., age, gender) and responses to BFI-10 (Rammstedt & John, 2007)  

Data codebook here:

|variable name|description|variable name|description|
|:-|:-:|:-|:-:|
|pid|participant id| | |
|age|participant age (in years)| | |
|gender|participant gender|BFI_6|is outgoing, sociable|
|BFI_1|is reserved|BFI_7|tends to find fault with others|
|BFI_2|is generally trusting|BFI_8|does a thorough job|
|BFI_3|tends to be lazy|BFI_9|gets nervous easily|
|BFI_4|is relaxed|BFI_10|has an active imagination|
|BFI_5|has few artistic interests|BFI_11|handles stress well|


*Note*. "BFI_1", "BFI_3", "BFI_4", and "BFI_5" are reverse-keyed. 


```r
# example_data <- readr::read_csv(here::here("dataset", "example_data.csv"))
example_data <- readr::read_csv("https://raw.githubusercontent.com/psy218/r_tutorial/master/dataset/example_data.csv")
```

### Scoring variable
Many functions operate column-wise.  

For example, let's see what happens when we apply `mean(x)` function to conscientiousness items of BFI (i.e., BFI_3 and BFI_8) within the example dataset.  

```r
mean(c(example_data$BFI_3, example_data$BFI_8), na.rm = TRUE)
```

```
## [1] 4.020313
```
This returns a single value, the average of everyone's scores on BFI_3 and BFI_8. 

When we need to create an aggregate score for each observation (e.g., participant, row), we need to use the functions that operate row-wise (vs. column-wise): e.g., `rowMeans(x)`, `rowSums(x)`.   

We can use `rowMeans(x)` function to create an average of conscientiousness items for each participant.  

```r
rowMeans(cbind(example_data$BFI_3, example_data$BFI_8), na.rm = TRUE)
```

```
##   [1] 3.5 2.0 5.0 4.0 3.0 3.5 4.5 4.0 5.0 3.0 4.5 3.0 5.0 3.0 3.5 4.0 4.5
##  [18] 4.5 2.0 5.0 5.0 4.5 4.0 3.0 3.0 4.0 4.5 2.5 3.5 4.0 2.5 2.0 5.0 3.5
##  [35] 3.0 4.0 5.0 4.5 5.0 4.0 4.5 5.0 4.5 4.5 5.0 4.5 2.5 4.5 5.0 4.5 4.0
##  [52] 3.5 4.5 5.0 5.0 3.0 4.5 4.0 4.5 4.0 3.5 5.0 5.0 5.0 4.0 5.0 4.5 5.0
##  [69] 3.5 2.5 4.5 3.0 4.5 5.0 4.5 5.0 4.5 5.0 5.0 2.5 4.5 4.0 5.0 5.0 4.0
##  [86] 4.0 2.5 4.5 3.5 4.0 5.0 5.0 5.0 5.0 3.5 5.0 3.0 5.0 2.5 4.0 3.5 3.5
## [103] 5.0 2.5 4.0 5.0 3.5 3.5 5.0 4.5 5.0 3.5 3.0 5.0 4.0 4.0 3.5 4.0 5.0
## [120] 3.5 5.0 3.0 4.5 3.0 4.5 5.0 5.0 4.0 3.5 5.0 5.0 4.0 4.5 4.0 4.5 5.0
## [137] 4.0 4.0 4.5 4.0 2.5 3.0 5.0 3.5 4.0 4.5 3.0 4.0 5.0 4.5 4.0 5.0 4.0
## [154] 5.0 3.0 3.5 4.5 2.5 5.0 5.0 3.0 4.5 4.0 4.5 5.0 3.0 2.5 3.0 5.0 5.0
## [171] 2.5 4.0 5.0 3.0 4.0 3.0 4.5 4.0 5.0 3.5 4.5 5.0 4.5 5.0 5.0 3.0 5.0
## [188] 5.0 2.0 2.5 4.5 3.0 5.0 3.0 5.0 5.0 4.0 5.0 4.0 5.0 4.0 5.0 5.0 2.0
## [205] 4.0 5.0 4.5 4.0 4.0 5.0 3.0 5.0 5.0 3.5 4.0 4.5 5.0 3.5 5.0 5.0 4.5
## [222] 4.5 4.5 3.5 3.5 4.0 4.0 4.5 3.5 4.5 4.0 4.0 3.0 3.5 2.5 4.5 4.5 3.5
## [239] 3.0 3.0 5.0 4.5 4.5 5.0 3.5 5.0 2.0 4.0 5.0 3.5 4.0 5.0 4.5 3.0 2.5
## [256] 4.0 3.0 4.5 5.0 5.0 4.0 4.5 4.5 3.5 4.5 4.0 4.0 5.0 4.5 3.5 5.0 3.0
## [273] 2.5 4.0 5.0 2.0 3.5 2.5 3.5 2.0 3.5 3.0 4.5 3.0 3.0 2.5 3.5 4.0 5.0
## [290] 4.0 3.0 4.0 3.0 3.0 1.5 4.5 3.0 5.0 4.0 5.0 5.0 5.0 3.0 2.5 3.5 2.5
## [307] 5.0 5.0 5.0 5.0 1.0 4.0 3.0 3.5 4.0 3.0 3.0 3.5 3.0 5.0
```

For the operations that do not have separate row-wise functions, we can use `apply(x)` function to specify that we want to apply the function row-wise.   
Specifically, we first define the data we are applying our functions (i.e., `X = `), indicate what function we want to apply (i.e., `FUN = `), and whether we want to apply our function row-wise (i.e., `1`) or column-wise(`2`) in the `MARGIN = ` argument. 

```r
args(apply)
```

```
## function (X, MARGIN, FUN, ...) 
## NULL
```

So instead of using `rowMeans(x)`, the following will yield the same:   

```r
apply(cbind(example_data$BFI_3, example_data$BFI_8), 1, mean, na.rm = T)
```

```
##   [1] 3.5 2.0 5.0 4.0 3.0 3.5 4.5 4.0 5.0 3.0 4.5 3.0 5.0 3.0 3.5 4.0 4.5
##  [18] 4.5 2.0 5.0 5.0 4.5 4.0 3.0 3.0 4.0 4.5 2.5 3.5 4.0 2.5 2.0 5.0 3.5
##  [35] 3.0 4.0 5.0 4.5 5.0 4.0 4.5 5.0 4.5 4.5 5.0 4.5 2.5 4.5 5.0 4.5 4.0
##  [52] 3.5 4.5 5.0 5.0 3.0 4.5 4.0 4.5 4.0 3.5 5.0 5.0 5.0 4.0 5.0 4.5 5.0
##  [69] 3.5 2.5 4.5 3.0 4.5 5.0 4.5 5.0 4.5 5.0 5.0 2.5 4.5 4.0 5.0 5.0 4.0
##  [86] 4.0 2.5 4.5 3.5 4.0 5.0 5.0 5.0 5.0 3.5 5.0 3.0 5.0 2.5 4.0 3.5 3.5
## [103] 5.0 2.5 4.0 5.0 3.5 3.5 5.0 4.5 5.0 3.5 3.0 5.0 4.0 4.0 3.5 4.0 5.0
## [120] 3.5 5.0 3.0 4.5 3.0 4.5 5.0 5.0 4.0 3.5 5.0 5.0 4.0 4.5 4.0 4.5 5.0
## [137] 4.0 4.0 4.5 4.0 2.5 3.0 5.0 3.5 4.0 4.5 3.0 4.0 5.0 4.5 4.0 5.0 4.0
## [154] 5.0 3.0 3.5 4.5 2.5 5.0 5.0 3.0 4.5 4.0 4.5 5.0 3.0 2.5 3.0 5.0 5.0
## [171] 2.5 4.0 5.0 3.0 4.0 3.0 4.5 4.0 5.0 3.5 4.5 5.0 4.5 5.0 5.0 3.0 5.0
## [188] 5.0 2.0 2.5 4.5 3.0 5.0 3.0 5.0 5.0 4.0 5.0 4.0 5.0 4.0 5.0 5.0 2.0
## [205] 4.0 5.0 4.5 4.0 4.0 5.0 3.0 5.0 5.0 3.5 4.0 4.5 5.0 3.5 5.0 5.0 4.5
## [222] 4.5 4.5 3.5 3.5 4.0 4.0 4.5 3.5 4.5 4.0 4.0 3.0 3.5 2.5 4.5 4.5 3.5
## [239] 3.0 3.0 5.0 4.5 4.5 5.0 3.5 5.0 2.0 4.0 5.0 3.5 4.0 5.0 4.5 3.0 2.5
## [256] 4.0 3.0 4.5 5.0 5.0 4.0 4.5 4.5 3.5 4.5 4.0 4.0 5.0 4.5 3.5 5.0 3.0
## [273] 2.5 4.0 5.0 2.0 3.5 2.5 3.5 2.0 3.5 3.0 4.5 3.0 3.0 2.5 3.5 4.0 5.0
## [290] 4.0 3.0 4.0 3.0 3.0 1.5 4.5 3.0 5.0 4.0 5.0 5.0 5.0 3.0 2.5 3.5 2.5
## [307] 5.0 5.0 5.0 5.0 1.0 4.0 3.0 3.5 4.0 3.0 3.0 3.5 3.0 5.0
```


### Reverse-coding
We can reverse-code variables by creating a custom function with two arguments: the maximum value of our scale (`max`) and the variable we want to reverse code (`x`).

```r
# I will name it `reverse_x()`
reverse_x <- function(max, x) {
  (max + 1) - x
}
```

Step 1: Find which items need to be reverse-coded, and store the name into an object.

```r
reverse_keyed_items = paste("BFI", c(1, 3, 4, 5), sep = "_")
```

Step 2: Reverse-code the variables

```r
reverse_coded_bfi <- apply(example_data[ ,reverse_keyed_items], 2, reverse_x, max = 5)
```

Step 3: Merge it into the dataset

```r
reversed_data <- cbind(reverse_coded_bfi, # reverse-coded variables
                       example_data[ -which(names(example_data) %in% reverse_keyed_items)] # original dataset minus items that need to be reverse-coded
) 

head(reversed_data)
```

<div class="kable-table">

 BFI_1   BFI_3   BFI_4   BFI_5   pid   age  gender    BFI_2   BFI_6   BFI_7   BFI_8   BFI_9   BFI_10   BFI_11
------  ------  ------  ------  ----  ----  -------  ------  ------  ------  ------  ------  -------  -------
     4       3       3       2     1    32  female        4       2       2       4       3        4        4
     4       4       5       4     2    31  female        5       4       2       2       4        5        1
     1       1       1       1     3    29  female        1       5       1       5       1        5        5
     2       2       3       4     4    33  female        4       4       3       4       3        3        2
     3       4       5       3     5    29  male          4       3       2       4       3        3        1
     4       3       4       3     6    31  female        5       5       1       4       4        4        2

</div>

Or, just do it at one-go. 

```r
reverse_data <- cbind(apply(example_data[ ,paste("BFI", c(1, 3, 4, 5), sep = "_")], 
                            2, reverse_x, max = 5),
                      example_data[ -which(names(example_data) %in% 
                                             paste("BFI", c(1, 3, 4, 5), sep = "_"))]) 
```




#### **Exercise 4** {.tabset .tabset-fade .tabset-pills}

##### Question
Create 1) an aggregate score of `extraversion` for each participant by averaging reverse-coded BFI_1 and BFI_6 and 2) mean-center extraversion score on gender. 

##### Answer

```r
#' Step 1a: Reverse-code BFI_1 using `reverse_x()`
#' Step 1b: Create an aggregate score for extroversion using `rowMeans()`

example_data$extraversion <- rowMeans(cbind(reverse_x(5, example_data$BFI_1), # reverse code BFI_1
                                            example_data$BFI_6), # then column-bind with BFI_6
                                      na.rm = T) # compute an average

#' Step 2: Find the average extraversion scores for male and female participants, and save the result as an object (`group_mean`)
group_mean <- with(example_data, tapply(X = extraversion, 
                                        INDEX = gender, mean, na.rm = T))

#' Step 3: Calculate mean-centred extraversion score (`extraversion_gc`) by subtracting extraversion score from average extraversion scores (`extraversion`) of men (`group_mean["male"]`) and women (`group_mean["female"]`)
example_data <- within(example_data, {
  extraversion_gc = ifelse(test = gender == "male", 
                           yes = extraversion - group_mean["male"], 
                           no = extraversion - group_mean["female"])
})
```



