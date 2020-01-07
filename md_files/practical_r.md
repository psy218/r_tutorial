---
title: "Practical R"
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




# Tidyverse  
[Tidyverse](https://www.tidyverse.org/) is a collection of R packages that facilitate data manipulation and exploration (cf. [a blog post on not using Tidyverse](https://blog.ephorie.de/why-i-dont-use-the-tidyverse)). 

Let's load tidyverse, and see what packages are included. 

```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✔ ggplot2 3.2.1     ✔ purrr   0.3.3
## ✔ tibble  2.1.3     ✔ dplyr   0.8.3
## ✔ tidyr   1.0.0     ✔ stringr 1.4.0
## ✔ readr   1.3.1     ✔ forcats 0.4.0
```

```
## ── Conflicts ────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

These are select core packages that are included in Tidyverse.   
1. [ggplot2](https://r4ds.had.co.nz/data-visualisation.html)   
2. [dplyr](https://dplyr.tidyverse.org/)   
3. [tidyr](https://r4ds.had.co.nz/tidy-data.html)   
4. [readr](https://r4ds.had.co.nz/data-import.html)   
5. [tibble](https://r4ds.had.co.nz/tibbles.html)   
6. [purrr](https://r4ds.had.co.nz/iteration.html)   
7. [forcats](https://r4ds.had.co.nz/factors.html)   


Note the packages under `tidyverse_conflicts()`; these are tidyverse functions that have the same name as other functions from different packages (e.g., base R).  

For data manipulation exercises, we will use an example dataset, starwars from `dplyr` package. 


```r
data(starwars)
```

Let's first inspect our dataset using `glimpse()`.  

```r
glimpse(starwars)
```

```
## Observations: 87
## Variables: 13
## $ name       <chr> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "L…
## $ height     <int> 172, 167, 96, 202, 150, 178, 165, 97, 183, 182, 188, …
## $ mass       <dbl> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 84.…
## $ hair_color <chr> "blond", NA, NA, "none", "brown", "brown, grey", "bro…
## $ skin_color <chr> "fair", "gold", "white, blue", "white", "light", "lig…
## $ eye_color  <chr> "blue", "yellow", "red", "yellow", "brown", "blue", "…
## $ birth_year <dbl> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0, …
## $ gender     <chr> "male", NA, NA, "male", "female", "male", "female", N…
## $ homeworld  <chr> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alderaa…
## $ species    <chr> "Human", "Droid", "Droid", "Human", "Human", "Human",…
## $ films      <list> [<"Revenge of the Sith", "Return of the Jedi", "The …
## $ vehicles   <list> [<"Snowspeeder", "Imperial Speeder Bike">, <>, <>, <…
## $ starships  <list> [<"X-wing", "Imperial shuttle">, <>, <>, "TIE Advanc…
```

## **piping** (%>%) 
Base R and tidyverse R take different approaches to perform multiple functions.
Tidyverse R uses the pipe operator (`%>%`), which losely translates as "*then*"  

The pipe operator (`%>%`) becomes handy when you...   

1. have many interim steps     
For example, when we want to run a regression with mean-centered variables   

```r
starwars %>% 
  group_by(gender) %>% # step 1) mean centering height around gender
  mutate(height_mc = height - mean(height, na.rm = T)) %>% 
  lm(mass ~ height_mc, # step 2) then run a regression model using the mean-centered height
     data = .) %>% 
  summary # step 3) see the summary table
```

```
## 
## Call:
## lm(formula = mass ~ height_mc, data = .)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
##  -58.0  -38.7  -19.8  -15.3 1260.6 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)   97.401     22.116    4.40 0.000047 ***
## height_mc      0.572      0.675    0.85      0.4    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 170 on 57 degrees of freedom
##   (28 observations deleted due to missingness)
## Multiple R-squared:  0.0124,	Adjusted R-squared:  -0.00489 
## F-statistic: 0.718 on 1 and 57 DF,  p-value: 0.401
```

2. do not wish to save the output (e.g., exploratory data analysis)  
For example, when we want to summarize our data and plot the summary data without saving it.

```r
starwars %>% 
  #filter(mass < 1000) %>% 
  group_by(gender) %>% 
  summarize_at(vars(c("height", "mass")), list(~mean(., na.rm = T), ~sd(.,na.rm = T))) %>% 
  pivot_longer(cols = -gender, 
               names_to = c("var", "stat"),
               names_sep = "_",
               values_to = "value") %>% 
  spread(stat, value) %>% 
  ggplot(aes(x = as.factor(gender), y = mean, fill = as.factor(var))) +
  geom_col(position = position_dodge(width=0.9)) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), 
                position = position_dodge(width=0.9), width = 0.25) + 
  scale_fill_discrete("") +
  theme_bw()
```

![](practical_r_files/figure-html/unnamed-chunk-5-1.png)<!-- -->




As an example, let's calculate the average height of female Starwars characters.

<div class = "row">
<div class = "col-md-6">
<br><br> base R   
In order to perform multiple functions using base R, we perform them sequentially or nest functions. 

```r
# sequential operations
female_height_only <- starwars[starwars$gender=="female", ]$height # subset data 
mean(female_height_only, na.rm = T) # calculate mean of the subset

# nesting subset function inside mean
colMeans(subset(starwars, # subsetting the data frame 
                subset = gender == "female", # based on the condition 
                select = "height"), # column of interest
         na.rm = T) # then perform mean on the subsetted data
```
</div>

<div class = "col-md-6">
<br><br>tidyverse R    
tidyverse uses a pipe (`%>%`) to perform multiple functions sequentially without creating an object. 

```r
starwars %>% # take the starwars dataset, then (`%>%`)
  subset(subset = gender == "female", select = "height") %>% # subset the data, then (`%>%`)
  colMeans(na.rm = T) # calculate the mean
```
</div>
</div>


## *dplyr* verbs  

There are [5 dplyr functions](https://dplyr.tidyverse.org/) that are useful for data manipulation. 

|verb|function|example|
|:-|:-|:-|
|[`select()`](#select)|choose variables by (column) names|select(starwars, height, mass)|
|[`filter()`](#filter)|choose observations by (conditional) values|filter(starwars, gender == "none" )|
|[`mutate()`](#mutate)|transform or create new variables|mutate(starwars, BMI = $weight/height^2$)|
|[`summarize()`](#summarize)|summarize variables|summarize(starwars, mean_height = mean(height, na.rm = T))|
|`arrange()`|order variables|arrange(starwars, height, desc(mass))|

# Data Manipulation  
## Subsetting data with `select()` & `filter()`  

### <a name="select"></a>`select()` columns    
Like the square bracket `[]`, the dollar sign `$` in base R, and `subset(data, select = column)`, `select()` allows you to extract elements by the column name(s). 

![](Fig/select_func.png)

<div class = "row">
<div class = "col-md-6">
<br><br>Base R

```r
head(starwars[ ,c("height", "mass")])
```

<div class="kable-table">

 height   mass
-------  -----
    172     77
    167     75
     96     32
    202    136
    150     49
    178    120

</div>
</div>

<div class = "col-md-6">
<br><br>tidyverse R

```r
starwars %>% 
  select(height, mass) %>% 
  head()
```

<div class="kable-table">

 height   mass
-------  -----
    172     77
    167     75
     96     32
    202    136
    150     49
    178    120

</div>
</div>
</div>

#### conditional selection

You can combine `select()` function with conditional statements such as `starts_with()`. 

For example, if we want to find all the columns whose names that do NOT (i.e., negating with the minus sign, `-`) begin with the letter *s*, we can nest the conditional statement, `starts_with("s")` inside the `select()` function. 


```r
starwars %>% 
  select(-starts_with("s")) %>% 
  head()
```

<div class="kable-table">

name              height   mass  hair_color    eye_color    birth_year  gender   homeworld   films                                                                                                                                                        vehicles                                  
---------------  -------  -----  ------------  ----------  -----------  -------  ----------  -----------------------------------------------------------------------------------------------------------------------------------------------------------  ------------------------------------------
Luke Skywalker       172     77  blond         blue               19.0  male     Tatooine    c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")                                                 c("Snowspeeder", "Imperial Speeder Bike") 
C-3PO                167     75  NA            yellow            112.0  NA       Tatooine    c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope")                        character(0)                              
R2-D2                 96     32  NA            red                33.0  NA       Naboo       c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")   character(0)                              
Darth Vader          202    136  none          yellow             41.9  male     Tatooine    c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope")                                                                      character(0)                              
Leia Organa          150     49  brown         brown              19.0  female   Alderaan    c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")                                                 Imperial Speeder Bike                     
Owen Lars            178    120  brown, grey   blue               52.0  male     Tatooine    c("Attack of the Clones", "Revenge of the Sith", "A New Hope")                                                                                               character(0)                              

</div>

These are some useful conditional statements you can use with `select()`:   

|condition|function|
|:-|:-|
|`starts_with("x")`|column names that begin with "x"|
|`ends_with("x")`|column names that end with "x"|
|`contains("x")`|column names that contain "x"|
|`num_range("x", 1:3)`|columns that match `x1`, `x2`, and `x3`|
|`everything()`|select everything|
|`one_of(c("height", "mass"))`|select one of `height` or `mass`|


### <a name="filter"></a>`filter()` observations  

Like the conditional statement inside the square bracket `[]`, `filter()` allows you to extract elements that meet the specified conditions.   
![](Fig/filter_func.png)  

<div class = "row">
<div class = "col-md-6">
<br><br>Base R

```r
starwars[c(starwars$mass<1000 & starwars$height > 100), ]
```

</div>

<div class = "col-md-6">
<br><br>tidyverse R

```r
starwars %>% 
  filter(mass < 1000, height > 100)
```
</div>
</div>  

#### conditional filtering  
Like `select()`, you can add more specification inside the `filter()` function with logical operators (e.g., `==`), and `between()` or `is.na()` statements. 





### **Exercise 1** {.tabset .tabset-fade .tabset-pills}  
Let's subset our starwars data set using multiple conditions. 

#### Question
Find the names (`name`) and gender (`gender`) of human characters (i.e., `species == Human`) who are between 23 to 35 years of age (i.e., `birth_year`)and do not have blue eyes (i.e., `eye_colour`). 

#### Answer  

```r
starwars %>% 
  filter(species == "Human", # human 
         eye_color != "blue", # eye color not blue
         between(birth_year, left = 23, right = 35)) %>% # age falling between 23 and 35
  select(name, gender) # just choosing the name column
```

<div class="kable-table">

name                gender 
------------------  -------
Biggs Darklighter   male   
Han Solo            male   
Boba Fett           male   
Lando Calrissian    male   

</div>


## Summarize data with `mutate()` and `summarize()`   

### <a name="mutate"></a>`mutate()` variables  
`mutate()` creates a new variable by operating on our dataset. 

![](Fig/mutate_func.png)  

<div class = "row">
<div class = "col-md-6">
<br><br>Base R

```r
# using `within()`
within(starwars, 
       {bmi = 703 * mass/(height^2)})

# Or, writing directly inside
starwars$bmi = 703 * starwars$mass/(starwars$height^2)
```
</div>

<div class = "col-md-6">
<br><br>tidyverse R

```r
starwars %>% 
  mutate(bmi = 703 * mass/(height^2)) %>% 
  select(name, height, mass, bmi) %>% 
  head()
```

<div class="kable-table">

name              height   mass    bmi
---------------  -------  -----  -----
Luke Skywalker       172     77   1.83
C-3PO                167     75   1.89
R2-D2                 96     32   2.44
Darth Vader          202    136   2.34
Leia Organa          150     49   1.53
Owen Lars            178    120   2.66

</div>
</div>
</div>

#### conditional mutation  

We can conditionally mutate our datasets based on variable names (`mutate_at()`) and specific conditions (`mutate_if()`). 

##### `mutate_at()` to score variables  

Let's use an example data with participant's demographic data (i.e., age, gender) and responses to BFI-10 (Rammstedt & John, 2007).  

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

Let's reverse score, and create aggregate scores of OCEAN. 

Step 1: I am creating a custom function to reverse score items. 

```r
reverse_x <- function(x, max) {
  ifelse(is.na(x) == FALSE, (max + 1) - x , NA)
}
```

Step 2: Reverse score items (without saving) and calculate an aggregate score  

```r
example_data <- example_data %>% 
  mutate_at(vars(paste("BFI", c(1, 3:5, 7, 11), sep = "_")),  # selecting which variables to reverse score
            ~reverse_x(., max = 5)) %>% # apply our custom functions 
  mutate(extraversion = rowMeans(cbind(BFI_1, BFI_6), na.rm = T), # then create a new variable to store aggregate scores
         conscientiousness = rowMeans(cbind(BFI_3, BFI_8), na.rm = T),
         neuroticism = rowMeans(cbind(BFI_4, BFI_9, BFI_11), na.rm = T),
         agreableness = rowMeans(cbind(BFI_2, BFI_7), na.rm = T),
         openness = rowMeans(cbind(BFI_5, BFI_10), na.rm = T))
```


### <a name="summarize"></a>`summarize()` data  

Without creating a new variable, we can create a summary of our data. For example, let's look at average height and mass with their standard deviations using `mean()` and `sd()` function. 

![](Fig/summarize_func.png)



```r
starwars %>% 
  summarize(height_mean = mean(height, na.rm = T),
            height_sd = sd(height, na.rm = T),
            mass_mean = mean(mass, na.rm = T),
            mass_sd = sd(mass, na.rm = T))
```

<div class="kable-table">

 height_mean   height_sd   mass_mean   mass_sd
------------  ----------  ----------  --------
         174        34.8        97.3       169

</div>



```r
# alternatively, you can use `summarize_at()` if you are feeling terse
starwars %>% 
  summarise_at(vars(height, mass), # variables we want to apply functions on
               list(~mean(., na.rm = T), # first function 
                    ~sd(., na.rm = T))) # second function
```

<div class="kable-table">

 height_mean   mass_mean   height_sd   mass_sd
------------  ----------  ----------  --------
         174        97.3        34.8       169

</div>

#### summary functions  
You can use the following functions with `summary()`. 

|name|function|
|:-|:-|
|`n()`|# of observations or row |
|`mean(x)`|average of x |
|`sd(x)`|standard deviation of x |
|`min(x)`|minimum value of x |
|`max(x)`|maximum value of x |
|`sum(is.na(x))`|# of missing observations|




```r
starwars %>% 
  summarize(height_n = n(),
            height_mean = mean(height, na.rm = T),
            height_sd = sd(height, na.rm = T),
            height_min = min(height, na.rm = T),
            height_max = max(height, na.rm = T),
            height_na = sum(is.na(height)))
```

<div class="kable-table">

 height_n   height_mean   height_sd   height_min   height_max   height_na
---------  ------------  ----------  -----------  -----------  ----------
       87           174        34.8           66          264           6

</div>
Check for more useful summary functions with `?summarize()` 

#### selective summary with `summarize_at()`   

You can selectively apply the same functions to multiple variables using `summarize_at()`:  

```r
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
```

<div class="kable-table">

test    height     mass
-----  -------  -------
mean     174.4     97.3
sd        34.8    169.5
min       66.0     15.0
max      264.0   1358.0
sum        6.0     28.0

</div>



#### conditional summary with `group_by()`  
When we want to create a summary for different groups (e.g., gender), we can combine `mutate()` and `summarize()` with `group_by()` function.  

For example, we can calculate average height and mass for each gender group.  

```r
starwars %>% 
  group_by(gender) %>% # grouping our data based on gender
  summarise_at(vars(height, mass), 
               list(~mean(., na.rm = T), 
                    ~sd(., na.rm = T))) 
```

<div class="kable-table">

gender           height_mean   mass_mean   height_sd   mass_sd
--------------  ------------  ----------  ----------  --------
female                   165        54.0        23.0      8.37
hermaphrodite            175      1358.0          NA        NA
male                     179        81.0        35.4     28.22
none                     200       140.0          NA        NA
NA                       120        46.3        40.7     24.83

</div>

Use `ungroup()` to remove grouping.  

```r
starwars %>% 
  ungroup()
```

<div class="kable-table">

name                     height     mass  hair_color      skin_color            eye_color        birth_year  gender          homeworld        species          films                                                                                                                                                        vehicles                                      starships                                                                                                             
----------------------  -------  -------  --------------  --------------------  --------------  -----------  --------------  ---------------  ---------------  -----------------------------------------------------------------------------------------------------------------------------------------------------------  --------------------------------------------  ----------------------------------------------------------------------------------------------------------------------
Luke Skywalker              172     77.0  blond           fair                  blue                   19.0  male            Tatooine         Human            c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")                                                 c("Snowspeeder", "Imperial Speeder Bike")     c("X-wing", "Imperial shuttle")                                                                                       
C-3PO                       167     75.0  NA              gold                  yellow                112.0  NA              Tatooine         Droid            c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope")                        character(0)                                  character(0)                                                                                                          
R2-D2                        96     32.0  NA              white, blue           red                    33.0  NA              Naboo            Droid            c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")   character(0)                                  character(0)                                                                                                          
Darth Vader                 202    136.0  none            white                 yellow                 41.9  male            Tatooine         Human            c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope")                                                                      character(0)                                  TIE Advanced x1                                                                                                       
Leia Organa                 150     49.0  brown           light                 brown                  19.0  female          Alderaan         Human            c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")                                                 Imperial Speeder Bike                         character(0)                                                                                                          
Owen Lars                   178    120.0  brown, grey     light                 blue                   52.0  male            Tatooine         Human            c("Attack of the Clones", "Revenge of the Sith", "A New Hope")                                                                                               character(0)                                  character(0)                                                                                                          
Beru Whitesun lars          165     75.0  brown           light                 blue                   47.0  female          Tatooine         Human            c("Attack of the Clones", "Revenge of the Sith", "A New Hope")                                                                                               character(0)                                  character(0)                                                                                                          
R5-D4                        97     32.0  NA              white, red            red                      NA  NA              Tatooine         Droid            A New Hope                                                                                                                                                   character(0)                                  character(0)                                                                                                          
Biggs Darklighter           183     84.0  black           light                 brown                  24.0  male            Tatooine         Human            A New Hope                                                                                                                                                   character(0)                                  X-wing                                                                                                                
Obi-Wan Kenobi              182     77.0  auburn, white   fair                  blue-gray              57.0  male            Stewjon          Human            c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope")                        Tribubble bongo                               c("Jedi starfighter", "Trade Federation cruiser", "Naboo star skiff", "Jedi Interceptor", "Belbullab-22 starfighter") 
Anakin Skywalker            188     84.0  blond           fair                  blue                   41.9  male            Tatooine         Human            c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith")                                                                                       c("Zephyr-G swoop bike", "XJ-6 airspeeder")   c("Trade Federation cruiser", "Jedi Interceptor", "Naboo fighter")                                                    
Wilhuff Tarkin              180       NA  auburn, grey    fair                  blue                   64.0  male            Eriadu           Human            c("Revenge of the Sith", "A New Hope")                                                                                                                       character(0)                                  character(0)                                                                                                          
Chewbacca                   228    112.0  brown           unknown               blue                  200.0  male            Kashyyyk         Wookiee          c("Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")                                                 AT-ST                                         c("Millennium Falcon", "Imperial shuttle")                                                                            
Han Solo                    180     80.0  brown           fair                  brown                  29.0  male            Corellia         Human            c("Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")                                                                        character(0)                                  c("Millennium Falcon", "Imperial shuttle")                                                                            
Greedo                      173     74.0  NA              green                 black                  44.0  male            Rodia            Rodian           A New Hope                                                                                                                                                   character(0)                                  character(0)                                                                                                          
Jabba Desilijic Tiure       175   1358.0  NA              green-tan, brown      orange                600.0  hermaphrodite   Nal Hutta        Hutt             c("The Phantom Menace", "Return of the Jedi", "A New Hope")                                                                                                  character(0)                                  character(0)                                                                                                          
Wedge Antilles              170     77.0  brown           fair                  hazel                  21.0  male            Corellia         Human            c("Return of the Jedi", "The Empire Strikes Back", "A New Hope")                                                                                             Snowspeeder                                   X-wing                                                                                                                
Jek Tono Porkins            180    110.0  brown           fair                  blue                     NA  male            Bestine IV       Human            A New Hope                                                                                                                                                   character(0)                                  X-wing                                                                                                                
Yoda                         66     17.0  white           green                 brown                 896.0  male            NA               Yoda's species   c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back")                                      character(0)                                  character(0)                                                                                                          
Palpatine                   170     75.0  grey            pale                  yellow                 82.0  male            Naboo            Human            c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back")                                      character(0)                                  character(0)                                                                                                          
Boba Fett                   183     78.2  black           fair                  brown                  31.5  male            Kamino           Human            c("Attack of the Clones", "Return of the Jedi", "The Empire Strikes Back")                                                                                   character(0)                                  Slave 1                                                                                                               
IG-88                       200    140.0  none            metal                 red                    15.0  none            NA               Droid            The Empire Strikes Back                                                                                                                                      character(0)                                  character(0)                                                                                                          
Bossk                       190    113.0  none            green                 red                    53.0  male            Trandosha        Trandoshan       The Empire Strikes Back                                                                                                                                      character(0)                                  character(0)                                                                                                          
Lando Calrissian            177     79.0  black           dark                  brown                  31.0  male            Socorro          Human            c("Return of the Jedi", "The Empire Strikes Back")                                                                                                           character(0)                                  Millennium Falcon                                                                                                     
Lobot                       175     79.0  none            light                 blue                   37.0  male            Bespin           Human            The Empire Strikes Back                                                                                                                                      character(0)                                  character(0)                                                                                                          
Ackbar                      180     83.0  none            brown mottle          orange                 41.0  male            Mon Cala         Mon Calamari     c("Return of the Jedi", "The Force Awakens")                                                                                                                 character(0)                                  character(0)                                                                                                          
Mon Mothma                  150       NA  auburn          fair                  blue                   48.0  female          Chandrila        Human            Return of the Jedi                                                                                                                                           character(0)                                  character(0)                                                                                                          
Arvel Crynyd                 NA       NA  brown           fair                  brown                    NA  male            NA               Human            Return of the Jedi                                                                                                                                           character(0)                                  A-wing                                                                                                                
Wicket Systri Warrick        88     20.0  brown           brown                 brown                   8.0  male            Endor            Ewok             Return of the Jedi                                                                                                                                           character(0)                                  character(0)                                                                                                          
Nien Nunb                   160     68.0  none            grey                  black                    NA  male            Sullust          Sullustan        Return of the Jedi                                                                                                                                           character(0)                                  Millennium Falcon                                                                                                     
Qui-Gon Jinn                193     89.0  brown           fair                  blue                   92.0  male            NA               Human            The Phantom Menace                                                                                                                                           Tribubble bongo                               character(0)                                                                                                          
Nute Gunray                 191     90.0  none            mottled green         red                      NA  male            Cato Neimoidia   Neimodian        c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith")                                                                                       character(0)                                  character(0)                                                                                                          
Finis Valorum               170       NA  blond           fair                  blue                   91.0  male            Coruscant        Human            The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Jar Jar Binks               196     66.0  none            orange                orange                 52.0  male            Naboo            Gungan           c("Attack of the Clones", "The Phantom Menace")                                                                                                              character(0)                                  character(0)                                                                                                          
Roos Tarpals                224     82.0  none            grey                  orange                   NA  male            Naboo            Gungan           The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Rugor Nass                  206       NA  none            green                 orange                   NA  male            Naboo            Gungan           The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Ric Olié                    183       NA  brown           fair                  blue                     NA  male            Naboo            NA               The Phantom Menace                                                                                                                                           character(0)                                  Naboo Royal Starship                                                                                                  
Watto                       137       NA  black           blue, grey            yellow                   NA  male            Toydaria         Toydarian        c("Attack of the Clones", "The Phantom Menace")                                                                                                              character(0)                                  character(0)                                                                                                          
Sebulba                     112     40.0  none            grey, red             orange                   NA  male            Malastare        Dug              The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Quarsh Panaka               183       NA  black           dark                  brown                  62.0  male            Naboo            NA               The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Shmi Skywalker              163       NA  black           fair                  brown                  72.0  female          Tatooine         Human            c("Attack of the Clones", "The Phantom Menace")                                                                                                              character(0)                                  character(0)                                                                                                          
Darth Maul                  175     80.0  none            red                   yellow                 54.0  male            Dathomir         Zabrak           The Phantom Menace                                                                                                                                           Sith speeder                                  Scimitar                                                                                                              
Bib Fortuna                 180       NA  none            pale                  pink                     NA  male            Ryloth           Twi'lek          Return of the Jedi                                                                                                                                           character(0)                                  character(0)                                                                                                          
Ayla Secura                 178     55.0  none            blue                  hazel                  48.0  female          Ryloth           Twi'lek          c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith")                                                                                       character(0)                                  character(0)                                                                                                          
Dud Bolt                     94     45.0  none            blue, grey            yellow                   NA  male            Vulpter          Vulptereen       The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Gasgano                     122       NA  none            white, blue           black                    NA  male            Troiken          Xexto            The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Ben Quadinaros              163     65.0  none            grey, green, yellow   orange                   NA  male            Tund             Toong            The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Mace Windu                  188     84.0  none            dark                  brown                  72.0  male            Haruun Kal       Human            c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith")                                                                                       character(0)                                  character(0)                                                                                                          
Ki-Adi-Mundi                198     82.0  white           pale                  yellow                 92.0  male            Cerea            Cerean           c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith")                                                                                       character(0)                                  character(0)                                                                                                          
Kit Fisto                   196     87.0  none            green                 black                    NA  male            Glee Anselm      Nautolan         c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith")                                                                                       character(0)                                  character(0)                                                                                                          
Eeth Koth                   171       NA  black           brown                 brown                    NA  male            Iridonia         Zabrak           c("The Phantom Menace", "Revenge of the Sith")                                                                                                               character(0)                                  character(0)                                                                                                          
Adi Gallia                  184     50.0  none            dark                  blue                     NA  female          Coruscant        Tholothian       c("The Phantom Menace", "Revenge of the Sith")                                                                                                               character(0)                                  character(0)                                                                                                          
Saesee Tiin                 188       NA  none            pale                  orange                   NA  male            Iktotch          Iktotchi         c("The Phantom Menace", "Revenge of the Sith")                                                                                                               character(0)                                  character(0)                                                                                                          
Yarael Poof                 264       NA  none            white                 yellow                   NA  male            Quermia          Quermian         The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
Plo Koon                    188     80.0  none            orange                black                  22.0  male            Dorin            Kel Dor          c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith")                                                                                       character(0)                                  Jedi starfighter                                                                                                      
Mas Amedda                  196       NA  none            blue                  blue                     NA  male            Champala         Chagrian         c("Attack of the Clones", "The Phantom Menace")                                                                                                              character(0)                                  character(0)                                                                                                          
Gregar Typho                185     85.0  black           dark                  brown                    NA  male            Naboo            Human            Attack of the Clones                                                                                                                                         character(0)                                  Naboo fighter                                                                                                         
Cordé                       157       NA  brown           light                 brown                    NA  female          Naboo            Human            Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Cliegg Lars                 183       NA  brown           fair                  blue                   82.0  male            Tatooine         Human            Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Poggle the Lesser           183     80.0  none            green                 yellow                   NA  male            Geonosis         Geonosian        c("Attack of the Clones", "Revenge of the Sith")                                                                                                             character(0)                                  character(0)                                                                                                          
Luminara Unduli             170     56.2  black           yellow                blue                   58.0  female          Mirial           Mirialan         c("Attack of the Clones", "Revenge of the Sith")                                                                                                             character(0)                                  character(0)                                                                                                          
Barriss Offee               166     50.0  black           yellow                blue                   40.0  female          Mirial           Mirialan         Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Dormé                       165       NA  brown           light                 brown                    NA  female          Naboo            Human            Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Dooku                       193     80.0  white           fair                  brown                 102.0  male            Serenno          Human            c("Attack of the Clones", "Revenge of the Sith")                                                                                                             Flitknot speeder                              character(0)                                                                                                          
Bail Prestor Organa         191       NA  black           tan                   brown                  67.0  male            Alderaan         Human            c("Attack of the Clones", "Revenge of the Sith")                                                                                                             character(0)                                  character(0)                                                                                                          
Jango Fett                  183     79.0  black           tan                   brown                  66.0  male            Concord Dawn     Human            Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Zam Wesell                  168     55.0  blonde          fair, green, yellow   yellow                   NA  female          Zolan            Clawdite         Attack of the Clones                                                                                                                                         Koro-2 Exodrive airspeeder                    character(0)                                                                                                          
Dexter Jettster             198    102.0  none            brown                 yellow                   NA  male            Ojom             Besalisk         Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Lama Su                     229     88.0  none            grey                  black                    NA  male            Kamino           Kaminoan         Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Taun We                     213       NA  none            grey                  black                    NA  female          Kamino           Kaminoan         Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Jocasta Nu                  167       NA  white           fair                  blue                     NA  female          Coruscant        Human            Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Ratts Tyerell                79     15.0  none            grey, blue            unknown                  NA  male            Aleen Minor      Aleena           The Phantom Menace                                                                                                                                           character(0)                                  character(0)                                                                                                          
R4-P17                       96       NA  none            silver, red           red, blue                NA  female          NA               NA               c("Attack of the Clones", "Revenge of the Sith")                                                                                                             character(0)                                  character(0)                                                                                                          
Wat Tambor                  193     48.0  none            green, grey           unknown                  NA  male            Skako            Skakoan          Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
San Hill                    191       NA  none            grey                  gold                     NA  male            Muunilinst       Muun             Attack of the Clones                                                                                                                                         character(0)                                  character(0)                                                                                                          
Shaak Ti                    178     57.0  none            red, blue, white      black                    NA  female          Shili            Togruta          c("Attack of the Clones", "Revenge of the Sith")                                                                                                             character(0)                                  character(0)                                                                                                          
Grievous                    216    159.0  none            brown, white          green, yellow            NA  male            Kalee            Kaleesh          Revenge of the Sith                                                                                                                                          Tsmeu-6 personal wheel bike                   Belbullab-22 starfighter                                                                                              
Tarfful                     234    136.0  brown           brown                 blue                     NA  male            Kashyyyk         Wookiee          Revenge of the Sith                                                                                                                                          character(0)                                  character(0)                                                                                                          
Raymus Antilles             188     79.0  brown           light                 brown                    NA  male            Alderaan         Human            c("Revenge of the Sith", "A New Hope")                                                                                                                       character(0)                                  character(0)                                                                                                          
Sly Moore                   178     48.0  none            pale                  white                    NA  female          Umbara           NA               c("Attack of the Clones", "Revenge of the Sith")                                                                                                             character(0)                                  character(0)                                                                                                          
Tion Medon                  206     80.0  none            grey                  black                    NA  male            Utapau           Pau'an           Revenge of the Sith                                                                                                                                          character(0)                                  character(0)                                                                                                          
Finn                         NA       NA  black           dark                  dark                     NA  male            NA               Human            The Force Awakens                                                                                                                                            character(0)                                  character(0)                                                                                                          
Rey                          NA       NA  brown           light                 hazel                    NA  female          NA               Human            The Force Awakens                                                                                                                                            character(0)                                  character(0)                                                                                                          
Poe Dameron                  NA       NA  brown           light                 brown                    NA  male            NA               Human            The Force Awakens                                                                                                                                            character(0)                                  T-70 X-wing fighter                                                                                                   
BB8                          NA       NA  none            none                  black                    NA  none            NA               Droid            The Force Awakens                                                                                                                                            character(0)                                  character(0)                                                                                                          
Captain Phasma               NA       NA  unknown         unknown               unknown                  NA  female          NA               NA               The Force Awakens                                                                                                                                            character(0)                                  character(0)                                                                                                          
Padmé Amidala               165     45.0  brown           light                 brown                  46.0  female          Naboo            Human            c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith")                                                                                       character(0)                                  c("H-type Nubian yacht", "Naboo star skiff", "Naboo fighter")                                                         

</div>


#### **Exercise 2** {.tabset .tabset-fade .tabset-pills}  
##### Question  
Create an aggregate score of `neuroticism` for each participant by 1a) reverse-coding BFI_4, and BFI_11, 1b) averaging neuroticm items (i.e., BFI_4, BFI_9, and BFI_11), and 2) mean-center neuroticism score on gender. 

##### Answer    

```r
#' step 1: creating a custom function to reverse-score items
reverse_x <- function(x, max) {
  ifelse(is.na(x) == FALSE, (max + 1) - x , NA)
}

#' step 2: reverse score, create an average score, and centre it on group mean 
#' @param neuroticism aggregate score of neuroticism (BFI_4, BFI_11, BFI_9)
#' @param neuroticism_mc mean-centered neuroticism 

example_data <- example_data %>% 
  mutate_at( vars(c("BFI_4", "BFI_11")), # specify which variables to apply the function
             ~reverse_x(., max = 5)) %>% # apply the reverse-score function
  mutate(neuroticism = rowMeans(cbind(BFI_4, BFI_11, BFI_9), na.rm = T)) %>%  # create an aggregate score
  group_by(gender) %>% # this will allow us to calcualte the group mean when we use mean function
  mutate(neuroticism_mc = neuroticism - mean(neuroticism, na.rm = T)) # center neuroticism score on group mean
```




