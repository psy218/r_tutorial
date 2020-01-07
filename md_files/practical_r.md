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
    df_print: paged
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

## core packages   
These are select core packages that are included in Tidyverse:   
1. [ggplot2](https://r4ds.had.co.nz/data-visualisation.html) for data visualization   
2. [dplyr](https://dplyr.tidyverse.org/) for data manipulation   
3. [tidyr](https://r4ds.had.co.nz/tidy-data.html) for tidying data  
4. [readr](https://r4ds.had.co.nz/data-import.html) for data import & export   
5. [tibble](https://r4ds.had.co.nz/tibbles.html) for handling data frames   
6. [purrr](https://r4ds.had.co.nz/iteration.html) for iterative programming  
7. [forcats](https://r4ds.had.co.nz/factors.html) for manipulating factors (i.e., categorical variables)  

*Note* the packages under `tidyverse_conflicts()`; these are tidyverse functions that have the same name as other functions from different packages (e.g., base R).  



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
  xlab("Gender") + 
  ylab("Average Measurement") +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), 
                position = position_dodge(width=0.9), width = 0.25) + 
  scale_fill_discrete("") +
  theme_bw()
```

![](practical_r_files/figure-html/unnamed-chunk-5-1.png)<!-- -->




As an example, let's calculate the average height of female Starwars characters.

<div class = "row">
<div class = "col-md-6">
<br><br> Base R   
In order to perform multiple functions using base R, we perform them sequentially or nest multiple functions. 

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
starwars %>% # take the starwars dataset
  subset(subset = gender == "female", select = "height") %>% # subset the data
  colMeans(na.rm = T) # calculate the mean
```
</div>
</div>


## *dplyr* verbs  

There are [5 dplyr functions](https://dplyr.tidyverse.org/) that are useful for data manipulation. 

|verb|function|example|
|:-|:-|:-|
|[`select()`](#select_function)|choose variables by (column) names|`select(starwars, height, mass)`|
|[`filter()`](#filter_function)|choose observations by (conditional) values|`filter(starwars, gender == "none")`|
|[`mutate()`](#mutate_function)|transform or create new variables|`mutate(starwars, BMI = $weight/height^2$)`|
|[`summarize()`](#summarize_function)|summarize variables|`summarize(starwars, mean_height = mean(height, na.rm = T))`|
|`arrange()`|order variables|`arrange(starwars, height, desc(mass))`|

# Data Manipulation  
## Subsetting data with `select()` & `filter()`  

### <a id="select_function"></a>`select()` columns    
Like the square bracket `[]`, the dollar sign `$` in base R, and `subset(data, select = column)`, `select(x)` allows you to extract elements by the column name(s). 

![](Fig/select_func.png)

<div class = "row">
<div class = "col-md-6">
<br><br>Base R

```r
starwars[ ,c("height", "mass")]
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["height"],"name":[1],"type":["int"],"align":["right"]},{"label":["mass"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"172","2":"77.0"},{"1":"167","2":"75.0"},{"1":"96","2":"32.0"},{"1":"202","2":"136.0"},{"1":"150","2":"49.0"},{"1":"178","2":"120.0"},{"1":"165","2":"75.0"},{"1":"97","2":"32.0"},{"1":"183","2":"84.0"},{"1":"182","2":"77.0"},{"1":"188","2":"84.0"},{"1":"180","2":"NA"},{"1":"228","2":"112.0"},{"1":"180","2":"80.0"},{"1":"173","2":"74.0"},{"1":"175","2":"1358.0"},{"1":"170","2":"77.0"},{"1":"180","2":"110.0"},{"1":"66","2":"17.0"},{"1":"170","2":"75.0"},{"1":"183","2":"78.2"},{"1":"200","2":"140.0"},{"1":"190","2":"113.0"},{"1":"177","2":"79.0"},{"1":"175","2":"79.0"},{"1":"180","2":"83.0"},{"1":"150","2":"NA"},{"1":"NA","2":"NA"},{"1":"88","2":"20.0"},{"1":"160","2":"68.0"},{"1":"193","2":"89.0"},{"1":"191","2":"90.0"},{"1":"170","2":"NA"},{"1":"196","2":"66.0"},{"1":"224","2":"82.0"},{"1":"206","2":"NA"},{"1":"183","2":"NA"},{"1":"137","2":"NA"},{"1":"112","2":"40.0"},{"1":"183","2":"NA"},{"1":"163","2":"NA"},{"1":"175","2":"80.0"},{"1":"180","2":"NA"},{"1":"178","2":"55.0"},{"1":"94","2":"45.0"},{"1":"122","2":"NA"},{"1":"163","2":"65.0"},{"1":"188","2":"84.0"},{"1":"198","2":"82.0"},{"1":"196","2":"87.0"},{"1":"171","2":"NA"},{"1":"184","2":"50.0"},{"1":"188","2":"NA"},{"1":"264","2":"NA"},{"1":"188","2":"80.0"},{"1":"196","2":"NA"},{"1":"185","2":"85.0"},{"1":"157","2":"NA"},{"1":"183","2":"NA"},{"1":"183","2":"80.0"},{"1":"170","2":"56.2"},{"1":"166","2":"50.0"},{"1":"165","2":"NA"},{"1":"193","2":"80.0"},{"1":"191","2":"NA"},{"1":"183","2":"79.0"},{"1":"168","2":"55.0"},{"1":"198","2":"102.0"},{"1":"229","2":"88.0"},{"1":"213","2":"NA"},{"1":"167","2":"NA"},{"1":"79","2":"15.0"},{"1":"96","2":"NA"},{"1":"193","2":"48.0"},{"1":"191","2":"NA"},{"1":"178","2":"57.0"},{"1":"216","2":"159.0"},{"1":"234","2":"136.0"},{"1":"188","2":"79.0"},{"1":"178","2":"48.0"},{"1":"206","2":"80.0"},{"1":"NA","2":"NA"},{"1":"NA","2":"NA"},{"1":"NA","2":"NA"},{"1":"NA","2":"NA"},{"1":"NA","2":"NA"},{"1":"165","2":"45.0"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>
</div>
</div>

<div class = "col-md-6">
<br><br>Tidyverse R

```r
starwars %>% 
  select(height, mass) 
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["height"],"name":[1],"type":["int"],"align":["right"]},{"label":["mass"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"172","2":"77.0"},{"1":"167","2":"75.0"},{"1":"96","2":"32.0"},{"1":"202","2":"136.0"},{"1":"150","2":"49.0"},{"1":"178","2":"120.0"},{"1":"165","2":"75.0"},{"1":"97","2":"32.0"},{"1":"183","2":"84.0"},{"1":"182","2":"77.0"},{"1":"188","2":"84.0"},{"1":"180","2":"NA"},{"1":"228","2":"112.0"},{"1":"180","2":"80.0"},{"1":"173","2":"74.0"},{"1":"175","2":"1358.0"},{"1":"170","2":"77.0"},{"1":"180","2":"110.0"},{"1":"66","2":"17.0"},{"1":"170","2":"75.0"},{"1":"183","2":"78.2"},{"1":"200","2":"140.0"},{"1":"190","2":"113.0"},{"1":"177","2":"79.0"},{"1":"175","2":"79.0"},{"1":"180","2":"83.0"},{"1":"150","2":"NA"},{"1":"NA","2":"NA"},{"1":"88","2":"20.0"},{"1":"160","2":"68.0"},{"1":"193","2":"89.0"},{"1":"191","2":"90.0"},{"1":"170","2":"NA"},{"1":"196","2":"66.0"},{"1":"224","2":"82.0"},{"1":"206","2":"NA"},{"1":"183","2":"NA"},{"1":"137","2":"NA"},{"1":"112","2":"40.0"},{"1":"183","2":"NA"},{"1":"163","2":"NA"},{"1":"175","2":"80.0"},{"1":"180","2":"NA"},{"1":"178","2":"55.0"},{"1":"94","2":"45.0"},{"1":"122","2":"NA"},{"1":"163","2":"65.0"},{"1":"188","2":"84.0"},{"1":"198","2":"82.0"},{"1":"196","2":"87.0"},{"1":"171","2":"NA"},{"1":"184","2":"50.0"},{"1":"188","2":"NA"},{"1":"264","2":"NA"},{"1":"188","2":"80.0"},{"1":"196","2":"NA"},{"1":"185","2":"85.0"},{"1":"157","2":"NA"},{"1":"183","2":"NA"},{"1":"183","2":"80.0"},{"1":"170","2":"56.2"},{"1":"166","2":"50.0"},{"1":"165","2":"NA"},{"1":"193","2":"80.0"},{"1":"191","2":"NA"},{"1":"183","2":"79.0"},{"1":"168","2":"55.0"},{"1":"198","2":"102.0"},{"1":"229","2":"88.0"},{"1":"213","2":"NA"},{"1":"167","2":"NA"},{"1":"79","2":"15.0"},{"1":"96","2":"NA"},{"1":"193","2":"48.0"},{"1":"191","2":"NA"},{"1":"178","2":"57.0"},{"1":"216","2":"159.0"},{"1":"234","2":"136.0"},{"1":"188","2":"79.0"},{"1":"178","2":"48.0"},{"1":"206","2":"80.0"},{"1":"NA","2":"NA"},{"1":"NA","2":"NA"},{"1":"NA","2":"NA"},{"1":"NA","2":"NA"},{"1":"NA","2":"NA"},{"1":"165","2":"45.0"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>
</div>
</div>
</div>

#### conditional selection

You can combine `select()` function with conditional statements such as `starts_with()`. 

For example, if we want to find all the columns whose names that do NOT (i.e., negating with the minus sign, `-`) begin with the letter *s*, we can nest the conditional statement, `starts_with("s")` inside the `select()` function. 


```r
starwars %>% 
  select(-starts_with("s")) 
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["height"],"name":[2],"type":["int"],"align":["right"]},{"label":["mass"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["hair_color"],"name":[4],"type":["chr"],"align":["left"]},{"label":["eye_color"],"name":[5],"type":["chr"],"align":["left"]},{"label":["birth_year"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["gender"],"name":[7],"type":["chr"],"align":["left"]},{"label":["homeworld"],"name":[8],"type":["chr"],"align":["left"]},{"label":["films"],"name":[9],"type":["list"],"align":["right"]},{"label":["vehicles"],"name":[10],"type":["list"],"align":["right"]}],"data":[{"1":"Luke Skywalker","2":"172","3":"77.0","4":"blond","5":"blue","6":"19.0","7":"male","8":"Tatooine","9":"<chr [5]>","10":"<chr [2]>"},{"1":"C-3PO","2":"167","3":"75.0","4":"NA","5":"yellow","6":"112.0","7":"NA","8":"Tatooine","9":"<chr [6]>","10":"<chr [0]>"},{"1":"R2-D2","2":"96","3":"32.0","4":"NA","5":"red","6":"33.0","7":"NA","8":"Naboo","9":"<chr [7]>","10":"<chr [0]>"},{"1":"Darth Vader","2":"202","3":"136.0","4":"none","5":"yellow","6":"41.9","7":"male","8":"Tatooine","9":"<chr [4]>","10":"<chr [0]>"},{"1":"Leia Organa","2":"150","3":"49.0","4":"brown","5":"brown","6":"19.0","7":"female","8":"Alderaan","9":"<chr [5]>","10":"<chr [1]>"},{"1":"Owen Lars","2":"178","3":"120.0","4":"brown, grey","5":"blue","6":"52.0","7":"male","8":"Tatooine","9":"<chr [3]>","10":"<chr [0]>"},{"1":"Beru Whitesun lars","2":"165","3":"75.0","4":"brown","5":"blue","6":"47.0","7":"female","8":"Tatooine","9":"<chr [3]>","10":"<chr [0]>"},{"1":"R5-D4","2":"97","3":"32.0","4":"NA","5":"red","6":"NA","7":"NA","8":"Tatooine","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Biggs Darklighter","2":"183","3":"84.0","4":"black","5":"brown","6":"24.0","7":"male","8":"Tatooine","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Obi-Wan Kenobi","2":"182","3":"77.0","4":"auburn, white","5":"blue-gray","6":"57.0","7":"male","8":"Stewjon","9":"<chr [6]>","10":"<chr [1]>"},{"1":"Anakin Skywalker","2":"188","3":"84.0","4":"blond","5":"blue","6":"41.9","7":"male","8":"Tatooine","9":"<chr [3]>","10":"<chr [2]>"},{"1":"Wilhuff Tarkin","2":"180","3":"NA","4":"auburn, grey","5":"blue","6":"64.0","7":"male","8":"Eriadu","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Chewbacca","2":"228","3":"112.0","4":"brown","5":"blue","6":"200.0","7":"male","8":"Kashyyyk","9":"<chr [5]>","10":"<chr [1]>"},{"1":"Han Solo","2":"180","3":"80.0","4":"brown","5":"brown","6":"29.0","7":"male","8":"Corellia","9":"<chr [4]>","10":"<chr [0]>"},{"1":"Greedo","2":"173","3":"74.0","4":"NA","5":"black","6":"44.0","7":"male","8":"Rodia","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Jabba Desilijic Tiure","2":"175","3":"1358.0","4":"NA","5":"orange","6":"600.0","7":"hermaphrodite","8":"Nal Hutta","9":"<chr [3]>","10":"<chr [0]>"},{"1":"Wedge Antilles","2":"170","3":"77.0","4":"brown","5":"hazel","6":"21.0","7":"male","8":"Corellia","9":"<chr [3]>","10":"<chr [1]>"},{"1":"Jek Tono Porkins","2":"180","3":"110.0","4":"brown","5":"blue","6":"NA","7":"male","8":"Bestine IV","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Yoda","2":"66","3":"17.0","4":"white","5":"brown","6":"896.0","7":"male","8":"NA","9":"<chr [5]>","10":"<chr [0]>"},{"1":"Palpatine","2":"170","3":"75.0","4":"grey","5":"yellow","6":"82.0","7":"male","8":"Naboo","9":"<chr [5]>","10":"<chr [0]>"},{"1":"Boba Fett","2":"183","3":"78.2","4":"black","5":"brown","6":"31.5","7":"male","8":"Kamino","9":"<chr [3]>","10":"<chr [0]>"},{"1":"IG-88","2":"200","3":"140.0","4":"none","5":"red","6":"15.0","7":"none","8":"NA","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Bossk","2":"190","3":"113.0","4":"none","5":"red","6":"53.0","7":"male","8":"Trandosha","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Lando Calrissian","2":"177","3":"79.0","4":"black","5":"brown","6":"31.0","7":"male","8":"Socorro","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Lobot","2":"175","3":"79.0","4":"none","5":"blue","6":"37.0","7":"male","8":"Bespin","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Ackbar","2":"180","3":"83.0","4":"none","5":"orange","6":"41.0","7":"male","8":"Mon Cala","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Mon Mothma","2":"150","3":"NA","4":"auburn","5":"blue","6":"48.0","7":"female","8":"Chandrila","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Arvel Crynyd","2":"NA","3":"NA","4":"brown","5":"brown","6":"NA","7":"male","8":"NA","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Wicket Systri Warrick","2":"88","3":"20.0","4":"brown","5":"brown","6":"8.0","7":"male","8":"Endor","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Nien Nunb","2":"160","3":"68.0","4":"none","5":"black","6":"NA","7":"male","8":"Sullust","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Qui-Gon Jinn","2":"193","3":"89.0","4":"brown","5":"blue","6":"92.0","7":"male","8":"NA","9":"<chr [1]>","10":"<chr [1]>"},{"1":"Nute Gunray","2":"191","3":"90.0","4":"none","5":"red","6":"NA","7":"male","8":"Cato Neimoidia","9":"<chr [3]>","10":"<chr [0]>"},{"1":"Finis Valorum","2":"170","3":"NA","4":"blond","5":"blue","6":"91.0","7":"male","8":"Coruscant","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Jar Jar Binks","2":"196","3":"66.0","4":"none","5":"orange","6":"52.0","7":"male","8":"Naboo","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Roos Tarpals","2":"224","3":"82.0","4":"none","5":"orange","6":"NA","7":"male","8":"Naboo","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Rugor Nass","2":"206","3":"NA","4":"none","5":"orange","6":"NA","7":"male","8":"Naboo","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Ric Olié","2":"183","3":"NA","4":"brown","5":"blue","6":"NA","7":"male","8":"Naboo","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Watto","2":"137","3":"NA","4":"black","5":"yellow","6":"NA","7":"male","8":"Toydaria","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Sebulba","2":"112","3":"40.0","4":"none","5":"orange","6":"NA","7":"male","8":"Malastare","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Quarsh Panaka","2":"183","3":"NA","4":"black","5":"brown","6":"62.0","7":"male","8":"Naboo","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Shmi Skywalker","2":"163","3":"NA","4":"black","5":"brown","6":"72.0","7":"female","8":"Tatooine","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Darth Maul","2":"175","3":"80.0","4":"none","5":"yellow","6":"54.0","7":"male","8":"Dathomir","9":"<chr [1]>","10":"<chr [1]>"},{"1":"Bib Fortuna","2":"180","3":"NA","4":"none","5":"pink","6":"NA","7":"male","8":"Ryloth","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Ayla Secura","2":"178","3":"55.0","4":"none","5":"hazel","6":"48.0","7":"female","8":"Ryloth","9":"<chr [3]>","10":"<chr [0]>"},{"1":"Dud Bolt","2":"94","3":"45.0","4":"none","5":"yellow","6":"NA","7":"male","8":"Vulpter","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Gasgano","2":"122","3":"NA","4":"none","5":"black","6":"NA","7":"male","8":"Troiken","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Ben Quadinaros","2":"163","3":"65.0","4":"none","5":"orange","6":"NA","7":"male","8":"Tund","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Mace Windu","2":"188","3":"84.0","4":"none","5":"brown","6":"72.0","7":"male","8":"Haruun Kal","9":"<chr [3]>","10":"<chr [0]>"},{"1":"Ki-Adi-Mundi","2":"198","3":"82.0","4":"white","5":"yellow","6":"92.0","7":"male","8":"Cerea","9":"<chr [3]>","10":"<chr [0]>"},{"1":"Kit Fisto","2":"196","3":"87.0","4":"none","5":"black","6":"NA","7":"male","8":"Glee Anselm","9":"<chr [3]>","10":"<chr [0]>"},{"1":"Eeth Koth","2":"171","3":"NA","4":"black","5":"brown","6":"NA","7":"male","8":"Iridonia","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Adi Gallia","2":"184","3":"50.0","4":"none","5":"blue","6":"NA","7":"female","8":"Coruscant","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Saesee Tiin","2":"188","3":"NA","4":"none","5":"orange","6":"NA","7":"male","8":"Iktotch","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Yarael Poof","2":"264","3":"NA","4":"none","5":"yellow","6":"NA","7":"male","8":"Quermia","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Plo Koon","2":"188","3":"80.0","4":"none","5":"black","6":"22.0","7":"male","8":"Dorin","9":"<chr [3]>","10":"<chr [0]>"},{"1":"Mas Amedda","2":"196","3":"NA","4":"none","5":"blue","6":"NA","7":"male","8":"Champala","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Gregar Typho","2":"185","3":"85.0","4":"black","5":"brown","6":"NA","7":"male","8":"Naboo","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Cordé","2":"157","3":"NA","4":"brown","5":"brown","6":"NA","7":"female","8":"Naboo","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Cliegg Lars","2":"183","3":"NA","4":"brown","5":"blue","6":"82.0","7":"male","8":"Tatooine","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Poggle the Lesser","2":"183","3":"80.0","4":"none","5":"yellow","6":"NA","7":"male","8":"Geonosis","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Luminara Unduli","2":"170","3":"56.2","4":"black","5":"blue","6":"58.0","7":"female","8":"Mirial","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Barriss Offee","2":"166","3":"50.0","4":"black","5":"blue","6":"40.0","7":"female","8":"Mirial","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Dormé","2":"165","3":"NA","4":"brown","5":"brown","6":"NA","7":"female","8":"Naboo","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Dooku","2":"193","3":"80.0","4":"white","5":"brown","6":"102.0","7":"male","8":"Serenno","9":"<chr [2]>","10":"<chr [1]>"},{"1":"Bail Prestor Organa","2":"191","3":"NA","4":"black","5":"brown","6":"67.0","7":"male","8":"Alderaan","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Jango Fett","2":"183","3":"79.0","4":"black","5":"brown","6":"66.0","7":"male","8":"Concord Dawn","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Zam Wesell","2":"168","3":"55.0","4":"blonde","5":"yellow","6":"NA","7":"female","8":"Zolan","9":"<chr [1]>","10":"<chr [1]>"},{"1":"Dexter Jettster","2":"198","3":"102.0","4":"none","5":"yellow","6":"NA","7":"male","8":"Ojom","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Lama Su","2":"229","3":"88.0","4":"none","5":"black","6":"NA","7":"male","8":"Kamino","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Taun We","2":"213","3":"NA","4":"none","5":"black","6":"NA","7":"female","8":"Kamino","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Jocasta Nu","2":"167","3":"NA","4":"white","5":"blue","6":"NA","7":"female","8":"Coruscant","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Ratts Tyerell","2":"79","3":"15.0","4":"none","5":"unknown","6":"NA","7":"male","8":"Aleen Minor","9":"<chr [1]>","10":"<chr [0]>"},{"1":"R4-P17","2":"96","3":"NA","4":"none","5":"red, blue","6":"NA","7":"female","8":"NA","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Wat Tambor","2":"193","3":"48.0","4":"none","5":"unknown","6":"NA","7":"male","8":"Skako","9":"<chr [1]>","10":"<chr [0]>"},{"1":"San Hill","2":"191","3":"NA","4":"none","5":"gold","6":"NA","7":"male","8":"Muunilinst","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Shaak Ti","2":"178","3":"57.0","4":"none","5":"black","6":"NA","7":"female","8":"Shili","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Grievous","2":"216","3":"159.0","4":"none","5":"green, yellow","6":"NA","7":"male","8":"Kalee","9":"<chr [1]>","10":"<chr [1]>"},{"1":"Tarfful","2":"234","3":"136.0","4":"brown","5":"blue","6":"NA","7":"male","8":"Kashyyyk","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Raymus Antilles","2":"188","3":"79.0","4":"brown","5":"brown","6":"NA","7":"male","8":"Alderaan","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Sly Moore","2":"178","3":"48.0","4":"none","5":"white","6":"NA","7":"female","8":"Umbara","9":"<chr [2]>","10":"<chr [0]>"},{"1":"Tion Medon","2":"206","3":"80.0","4":"none","5":"black","6":"NA","7":"male","8":"Utapau","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Finn","2":"NA","3":"NA","4":"black","5":"dark","6":"NA","7":"male","8":"NA","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Rey","2":"NA","3":"NA","4":"brown","5":"hazel","6":"NA","7":"female","8":"NA","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Poe Dameron","2":"NA","3":"NA","4":"brown","5":"brown","6":"NA","7":"male","8":"NA","9":"<chr [1]>","10":"<chr [0]>"},{"1":"BB8","2":"NA","3":"NA","4":"none","5":"black","6":"NA","7":"none","8":"NA","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Captain Phasma","2":"NA","3":"NA","4":"unknown","5":"unknown","6":"NA","7":"female","8":"NA","9":"<chr [1]>","10":"<chr [0]>"},{"1":"Padmé Amidala","2":"165","3":"45.0","4":"brown","5":"brown","6":"46.0","7":"female","8":"Naboo","9":"<chr [3]>","10":"<chr [0]>"}],"options":{"columns":{"min":{},"max":[5]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>
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


### <a id="filter_function"></a>`filter()` observations  

Like the conditional statement inside the square bracket `[]`, `filter()` allows you to extract elements that meet the specified conditions.   
![](Fig/filter_func.png)  

<div class = "row">
<div class = "col-md-6">
<br><br>Base R

```r
starwars[c(starwars$mass<1000 & starwars$height > 100), ]
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["height"],"name":[2],"type":["int"],"align":["right"]},{"label":["mass"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["hair_color"],"name":[4],"type":["chr"],"align":["left"]},{"label":["skin_color"],"name":[5],"type":["chr"],"align":["left"]},{"label":["eye_color"],"name":[6],"type":["chr"],"align":["left"]},{"label":["birth_year"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["gender"],"name":[8],"type":["chr"],"align":["left"]},{"label":["homeworld"],"name":[9],"type":["chr"],"align":["left"]},{"label":["species"],"name":[10],"type":["chr"],"align":["left"]},{"label":["films"],"name":[11],"type":["list"],"align":["right"]},{"label":["vehicles"],"name":[12],"type":["list"],"align":["right"]},{"label":["starships"],"name":[13],"type":["list"],"align":["right"]}],"data":[{"1":"Luke Skywalker","2":"172","3":"77.0","4":"blond","5":"fair","6":"blue","7":"19.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [5]>","12":"<chr [2]>","13":"<chr [2]>"},{"1":"C-3PO","2":"167","3":"75.0","4":"NA","5":"gold","6":"yellow","7":"112.0","8":"NA","9":"Tatooine","10":"Droid","11":"<chr [6]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Darth Vader","2":"202","3":"136.0","4":"none","5":"white","6":"yellow","7":"41.9","8":"male","9":"Tatooine","10":"Human","11":"<chr [4]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Leia Organa","2":"150","3":"49.0","4":"brown","5":"light","6":"brown","7":"19.0","8":"female","9":"Alderaan","10":"Human","11":"<chr [5]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Owen Lars","2":"178","3":"120.0","4":"brown, grey","5":"light","6":"blue","7":"52.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Beru Whitesun lars","2":"165","3":"75.0","4":"brown","5":"light","6":"blue","7":"47.0","8":"female","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Biggs Darklighter","2":"183","3":"84.0","4":"black","5":"light","6":"brown","7":"24.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Obi-Wan Kenobi","2":"182","3":"77.0","4":"auburn, white","5":"fair","6":"blue-gray","7":"57.0","8":"male","9":"Stewjon","10":"Human","11":"<chr [6]>","12":"<chr [1]>","13":"<chr [5]>"},{"1":"Anakin Skywalker","2":"188","3":"84.0","4":"blond","5":"fair","6":"blue","7":"41.9","8":"male","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [2]>","13":"<chr [3]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Chewbacca","2":"228","3":"112.0","4":"brown","5":"unknown","6":"blue","7":"200.0","8":"male","9":"Kashyyyk","10":"Wookiee","11":"<chr [5]>","12":"<chr [1]>","13":"<chr [2]>"},{"1":"Han Solo","2":"180","3":"80.0","4":"brown","5":"fair","6":"brown","7":"29.0","8":"male","9":"Corellia","10":"Human","11":"<chr [4]>","12":"<chr [0]>","13":"<chr [2]>"},{"1":"Greedo","2":"173","3":"74.0","4":"NA","5":"green","6":"black","7":"44.0","8":"male","9":"Rodia","10":"Rodian","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Wedge Antilles","2":"170","3":"77.0","4":"brown","5":"fair","6":"hazel","7":"21.0","8":"male","9":"Corellia","10":"Human","11":"<chr [3]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"Jek Tono Porkins","2":"180","3":"110.0","4":"brown","5":"fair","6":"blue","7":"NA","8":"male","9":"Bestine IV","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Palpatine","2":"170","3":"75.0","4":"grey","5":"pale","6":"yellow","7":"82.0","8":"male","9":"Naboo","10":"Human","11":"<chr [5]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Boba Fett","2":"183","3":"78.2","4":"black","5":"fair","6":"brown","7":"31.5","8":"male","9":"Kamino","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"IG-88","2":"200","3":"140.0","4":"none","5":"metal","6":"red","7":"15.0","8":"none","9":"NA","10":"Droid","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Bossk","2":"190","3":"113.0","4":"none","5":"green","6":"red","7":"53.0","8":"male","9":"Trandosha","10":"Trandoshan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Lando Calrissian","2":"177","3":"79.0","4":"black","5":"dark","6":"brown","7":"31.0","8":"male","9":"Socorro","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Lobot","2":"175","3":"79.0","4":"none","5":"light","6":"blue","7":"37.0","8":"male","9":"Bespin","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ackbar","2":"180","3":"83.0","4":"none","5":"brown mottle","6":"orange","7":"41.0","8":"male","9":"Mon Cala","10":"Mon Calamari","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Nien Nunb","2":"160","3":"68.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Sullust","10":"Sullustan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Qui-Gon Jinn","2":"193","3":"89.0","4":"brown","5":"fair","6":"blue","7":"92.0","8":"male","9":"NA","10":"Human","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Nute Gunray","2":"191","3":"90.0","4":"none","5":"mottled green","6":"red","7":"NA","8":"male","9":"Cato Neimoidia","10":"Neimodian","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Jar Jar Binks","2":"196","3":"66.0","4":"none","5":"orange","6":"orange","7":"52.0","8":"male","9":"Naboo","10":"Gungan","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Roos Tarpals","2":"224","3":"82.0","4":"none","5":"grey","6":"orange","7":"NA","8":"male","9":"Naboo","10":"Gungan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Sebulba","2":"112","3":"40.0","4":"none","5":"grey, red","6":"orange","7":"NA","8":"male","9":"Malastare","10":"Dug","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Darth Maul","2":"175","3":"80.0","4":"none","5":"red","6":"yellow","7":"54.0","8":"male","9":"Dathomir","10":"Zabrak","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Ayla Secura","2":"178","3":"55.0","4":"none","5":"blue","6":"hazel","7":"48.0","8":"female","9":"Ryloth","10":"Twi'lek","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Ben Quadinaros","2":"163","3":"65.0","4":"none","5":"grey, green, yellow","6":"orange","7":"NA","8":"male","9":"Tund","10":"Toong","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Mace Windu","2":"188","3":"84.0","4":"none","5":"dark","6":"brown","7":"72.0","8":"male","9":"Haruun Kal","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ki-Adi-Mundi","2":"198","3":"82.0","4":"white","5":"pale","6":"yellow","7":"92.0","8":"male","9":"Cerea","10":"Cerean","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Kit Fisto","2":"196","3":"87.0","4":"none","5":"green","6":"black","7":"NA","8":"male","9":"Glee Anselm","10":"Nautolan","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Adi Gallia","2":"184","3":"50.0","4":"none","5":"dark","6":"blue","7":"NA","8":"female","9":"Coruscant","10":"Tholothian","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Plo Koon","2":"188","3":"80.0","4":"none","5":"orange","6":"black","7":"22.0","8":"male","9":"Dorin","10":"Kel Dor","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Gregar Typho","2":"185","3":"85.0","4":"black","5":"dark","6":"brown","7":"NA","8":"male","9":"Naboo","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Poggle the Lesser","2":"183","3":"80.0","4":"none","5":"green","6":"yellow","7":"NA","8":"male","9":"Geonosis","10":"Geonosian","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Luminara Unduli","2":"170","3":"56.2","4":"black","5":"yellow","6":"blue","7":"58.0","8":"female","9":"Mirial","10":"Mirialan","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Barriss Offee","2":"166","3":"50.0","4":"black","5":"yellow","6":"blue","7":"40.0","8":"female","9":"Mirial","10":"Mirialan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Dooku","2":"193","3":"80.0","4":"white","5":"fair","6":"brown","7":"102.0","8":"male","9":"Serenno","10":"Human","11":"<chr [2]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Jango Fett","2":"183","3":"79.0","4":"black","5":"tan","6":"brown","7":"66.0","8":"male","9":"Concord Dawn","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Zam Wesell","2":"168","3":"55.0","4":"blonde","5":"fair, green, yellow","6":"yellow","7":"NA","8":"female","9":"Zolan","10":"Clawdite","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Dexter Jettster","2":"198","3":"102.0","4":"none","5":"brown","6":"yellow","7":"NA","8":"male","9":"Ojom","10":"Besalisk","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Lama Su","2":"229","3":"88.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Kamino","10":"Kaminoan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Wat Tambor","2":"193","3":"48.0","4":"none","5":"green, grey","6":"unknown","7":"NA","8":"male","9":"Skako","10":"Skakoan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Shaak Ti","2":"178","3":"57.0","4":"none","5":"red, blue, white","6":"black","7":"NA","8":"female","9":"Shili","10":"Togruta","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Grievous","2":"216","3":"159.0","4":"none","5":"brown, white","6":"green, yellow","7":"NA","8":"male","9":"Kalee","10":"Kaleesh","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"Tarfful","2":"234","3":"136.0","4":"brown","5":"brown","6":"blue","7":"NA","8":"male","9":"Kashyyyk","10":"Wookiee","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Raymus Antilles","2":"188","3":"79.0","4":"brown","5":"light","6":"brown","7":"NA","8":"male","9":"Alderaan","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Sly Moore","2":"178","3":"48.0","4":"none","5":"pale","6":"white","7":"NA","8":"female","9":"Umbara","10":"NA","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Tion Medon","2":"206","3":"80.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Utapau","10":"Pau'an","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"NA","2":"NA","3":"NA","4":"NA","5":"NA","6":"NA","7":"NA","8":"NA","9":"NA","10":"NA","11":"<NULL>","12":"<NULL>","13":"<NULL>"},{"1":"Padmé Amidala","2":"165","3":"45.0","4":"brown","5":"light","6":"brown","7":"46.0","8":"female","9":"Naboo","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [3]>"}],"options":{"columns":{"min":{},"max":[5]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>
</div>

</div>

<div class = "col-md-6">
<br><br>tidyverse R

```r
starwars %>% 
  filter(mass < 1000, height > 100)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["height"],"name":[2],"type":["int"],"align":["right"]},{"label":["mass"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["hair_color"],"name":[4],"type":["chr"],"align":["left"]},{"label":["skin_color"],"name":[5],"type":["chr"],"align":["left"]},{"label":["eye_color"],"name":[6],"type":["chr"],"align":["left"]},{"label":["birth_year"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["gender"],"name":[8],"type":["chr"],"align":["left"]},{"label":["homeworld"],"name":[9],"type":["chr"],"align":["left"]},{"label":["species"],"name":[10],"type":["chr"],"align":["left"]},{"label":["films"],"name":[11],"type":["list"],"align":["right"]},{"label":["vehicles"],"name":[12],"type":["list"],"align":["right"]},{"label":["starships"],"name":[13],"type":["list"],"align":["right"]}],"data":[{"1":"Luke Skywalker","2":"172","3":"77.0","4":"blond","5":"fair","6":"blue","7":"19.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [5]>","12":"<chr [2]>","13":"<chr [2]>"},{"1":"C-3PO","2":"167","3":"75.0","4":"NA","5":"gold","6":"yellow","7":"112.0","8":"NA","9":"Tatooine","10":"Droid","11":"<chr [6]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Darth Vader","2":"202","3":"136.0","4":"none","5":"white","6":"yellow","7":"41.9","8":"male","9":"Tatooine","10":"Human","11":"<chr [4]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Leia Organa","2":"150","3":"49.0","4":"brown","5":"light","6":"brown","7":"19.0","8":"female","9":"Alderaan","10":"Human","11":"<chr [5]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Owen Lars","2":"178","3":"120.0","4":"brown, grey","5":"light","6":"blue","7":"52.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Beru Whitesun lars","2":"165","3":"75.0","4":"brown","5":"light","6":"blue","7":"47.0","8":"female","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Biggs Darklighter","2":"183","3":"84.0","4":"black","5":"light","6":"brown","7":"24.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Obi-Wan Kenobi","2":"182","3":"77.0","4":"auburn, white","5":"fair","6":"blue-gray","7":"57.0","8":"male","9":"Stewjon","10":"Human","11":"<chr [6]>","12":"<chr [1]>","13":"<chr [5]>"},{"1":"Anakin Skywalker","2":"188","3":"84.0","4":"blond","5":"fair","6":"blue","7":"41.9","8":"male","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [2]>","13":"<chr [3]>"},{"1":"Chewbacca","2":"228","3":"112.0","4":"brown","5":"unknown","6":"blue","7":"200.0","8":"male","9":"Kashyyyk","10":"Wookiee","11":"<chr [5]>","12":"<chr [1]>","13":"<chr [2]>"},{"1":"Han Solo","2":"180","3":"80.0","4":"brown","5":"fair","6":"brown","7":"29.0","8":"male","9":"Corellia","10":"Human","11":"<chr [4]>","12":"<chr [0]>","13":"<chr [2]>"},{"1":"Greedo","2":"173","3":"74.0","4":"NA","5":"green","6":"black","7":"44.0","8":"male","9":"Rodia","10":"Rodian","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Wedge Antilles","2":"170","3":"77.0","4":"brown","5":"fair","6":"hazel","7":"21.0","8":"male","9":"Corellia","10":"Human","11":"<chr [3]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"Jek Tono Porkins","2":"180","3":"110.0","4":"brown","5":"fair","6":"blue","7":"NA","8":"male","9":"Bestine IV","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Palpatine","2":"170","3":"75.0","4":"grey","5":"pale","6":"yellow","7":"82.0","8":"male","9":"Naboo","10":"Human","11":"<chr [5]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Boba Fett","2":"183","3":"78.2","4":"black","5":"fair","6":"brown","7":"31.5","8":"male","9":"Kamino","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"IG-88","2":"200","3":"140.0","4":"none","5":"metal","6":"red","7":"15.0","8":"none","9":"NA","10":"Droid","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Bossk","2":"190","3":"113.0","4":"none","5":"green","6":"red","7":"53.0","8":"male","9":"Trandosha","10":"Trandoshan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Lando Calrissian","2":"177","3":"79.0","4":"black","5":"dark","6":"brown","7":"31.0","8":"male","9":"Socorro","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Lobot","2":"175","3":"79.0","4":"none","5":"light","6":"blue","7":"37.0","8":"male","9":"Bespin","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ackbar","2":"180","3":"83.0","4":"none","5":"brown mottle","6":"orange","7":"41.0","8":"male","9":"Mon Cala","10":"Mon Calamari","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Nien Nunb","2":"160","3":"68.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Sullust","10":"Sullustan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Qui-Gon Jinn","2":"193","3":"89.0","4":"brown","5":"fair","6":"blue","7":"92.0","8":"male","9":"NA","10":"Human","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Nute Gunray","2":"191","3":"90.0","4":"none","5":"mottled green","6":"red","7":"NA","8":"male","9":"Cato Neimoidia","10":"Neimodian","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Jar Jar Binks","2":"196","3":"66.0","4":"none","5":"orange","6":"orange","7":"52.0","8":"male","9":"Naboo","10":"Gungan","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Roos Tarpals","2":"224","3":"82.0","4":"none","5":"grey","6":"orange","7":"NA","8":"male","9":"Naboo","10":"Gungan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Sebulba","2":"112","3":"40.0","4":"none","5":"grey, red","6":"orange","7":"NA","8":"male","9":"Malastare","10":"Dug","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Darth Maul","2":"175","3":"80.0","4":"none","5":"red","6":"yellow","7":"54.0","8":"male","9":"Dathomir","10":"Zabrak","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"Ayla Secura","2":"178","3":"55.0","4":"none","5":"blue","6":"hazel","7":"48.0","8":"female","9":"Ryloth","10":"Twi'lek","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ben Quadinaros","2":"163","3":"65.0","4":"none","5":"grey, green, yellow","6":"orange","7":"NA","8":"male","9":"Tund","10":"Toong","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Mace Windu","2":"188","3":"84.0","4":"none","5":"dark","6":"brown","7":"72.0","8":"male","9":"Haruun Kal","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ki-Adi-Mundi","2":"198","3":"82.0","4":"white","5":"pale","6":"yellow","7":"92.0","8":"male","9":"Cerea","10":"Cerean","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Kit Fisto","2":"196","3":"87.0","4":"none","5":"green","6":"black","7":"NA","8":"male","9":"Glee Anselm","10":"Nautolan","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Adi Gallia","2":"184","3":"50.0","4":"none","5":"dark","6":"blue","7":"NA","8":"female","9":"Coruscant","10":"Tholothian","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Plo Koon","2":"188","3":"80.0","4":"none","5":"orange","6":"black","7":"22.0","8":"male","9":"Dorin","10":"Kel Dor","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Gregar Typho","2":"185","3":"85.0","4":"black","5":"dark","6":"brown","7":"NA","8":"male","9":"Naboo","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Poggle the Lesser","2":"183","3":"80.0","4":"none","5":"green","6":"yellow","7":"NA","8":"male","9":"Geonosis","10":"Geonosian","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Luminara Unduli","2":"170","3":"56.2","4":"black","5":"yellow","6":"blue","7":"58.0","8":"female","9":"Mirial","10":"Mirialan","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Barriss Offee","2":"166","3":"50.0","4":"black","5":"yellow","6":"blue","7":"40.0","8":"female","9":"Mirial","10":"Mirialan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Dooku","2":"193","3":"80.0","4":"white","5":"fair","6":"brown","7":"102.0","8":"male","9":"Serenno","10":"Human","11":"<chr [2]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Jango Fett","2":"183","3":"79.0","4":"black","5":"tan","6":"brown","7":"66.0","8":"male","9":"Concord Dawn","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Zam Wesell","2":"168","3":"55.0","4":"blonde","5":"fair, green, yellow","6":"yellow","7":"NA","8":"female","9":"Zolan","10":"Clawdite","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Dexter Jettster","2":"198","3":"102.0","4":"none","5":"brown","6":"yellow","7":"NA","8":"male","9":"Ojom","10":"Besalisk","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Lama Su","2":"229","3":"88.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Kamino","10":"Kaminoan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Wat Tambor","2":"193","3":"48.0","4":"none","5":"green, grey","6":"unknown","7":"NA","8":"male","9":"Skako","10":"Skakoan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Shaak Ti","2":"178","3":"57.0","4":"none","5":"red, blue, white","6":"black","7":"NA","8":"female","9":"Shili","10":"Togruta","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Grievous","2":"216","3":"159.0","4":"none","5":"brown, white","6":"green, yellow","7":"NA","8":"male","9":"Kalee","10":"Kaleesh","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"Tarfful","2":"234","3":"136.0","4":"brown","5":"brown","6":"blue","7":"NA","8":"male","9":"Kashyyyk","10":"Wookiee","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Raymus Antilles","2":"188","3":"79.0","4":"brown","5":"light","6":"brown","7":"NA","8":"male","9":"Alderaan","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Sly Moore","2":"178","3":"48.0","4":"none","5":"pale","6":"white","7":"NA","8":"female","9":"Umbara","10":"NA","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Tion Medon","2":"206","3":"80.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Utapau","10":"Pau'an","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Padmé Amidala","2":"165","3":"45.0","4":"brown","5":"light","6":"brown","7":"46.0","8":"female","9":"Naboo","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [3]>"}],"options":{"columns":{"min":{},"max":[5]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>
</div>
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

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["gender"],"name":[2],"type":["chr"],"align":["left"]}],"data":[{"1":"Biggs Darklighter","2":"male"},{"1":"Han Solo","2":"male"},{"1":"Boba Fett","2":"male"},{"1":"Lando Calrissian","2":"male"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>


## Summarize data with `mutate()` and `summarize()`   

### <a id="mutate_function"></a>`mutate()` variables  
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
  select(name, height, mass, bmi) 
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["height"],"name":[2],"type":["int"],"align":["right"]},{"label":["mass"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["bmi"],"name":[4],"type":["dbl"],"align":["right"]}],"data":[{"1":"Luke Skywalker","2":"172","3":"77.0","4":"1.830"},{"1":"C-3PO","2":"167","3":"75.0","4":"1.891"},{"1":"R2-D2","2":"96","3":"32.0","4":"2.441"},{"1":"Darth Vader","2":"202","3":"136.0","4":"2.343"},{"1":"Leia Organa","2":"150","3":"49.0","4":"1.531"},{"1":"Owen Lars","2":"178","3":"120.0","4":"2.663"},{"1":"Beru Whitesun lars","2":"165","3":"75.0","4":"1.937"},{"1":"R5-D4","2":"97","3":"32.0","4":"2.391"},{"1":"Biggs Darklighter","2":"183","3":"84.0","4":"1.763"},{"1":"Obi-Wan Kenobi","2":"182","3":"77.0","4":"1.634"},{"1":"Anakin Skywalker","2":"188","3":"84.0","4":"1.671"},{"1":"Wilhuff Tarkin","2":"180","3":"NA","4":"NA"},{"1":"Chewbacca","2":"228","3":"112.0","4":"1.515"},{"1":"Han Solo","2":"180","3":"80.0","4":"1.736"},{"1":"Greedo","2":"173","3":"74.0","4":"1.738"},{"1":"Jabba Desilijic Tiure","2":"175","3":"1358.0","4":"31.173"},{"1":"Wedge Antilles","2":"170","3":"77.0","4":"1.873"},{"1":"Jek Tono Porkins","2":"180","3":"110.0","4":"2.387"},{"1":"Yoda","2":"66","3":"17.0","4":"2.744"},{"1":"Palpatine","2":"170","3":"75.0","4":"1.824"},{"1":"Boba Fett","2":"183","3":"78.2","4":"1.642"},{"1":"IG-88","2":"200","3":"140.0","4":"2.461"},{"1":"Bossk","2":"190","3":"113.0","4":"2.201"},{"1":"Lando Calrissian","2":"177","3":"79.0","4":"1.773"},{"1":"Lobot","2":"175","3":"79.0","4":"1.813"},{"1":"Ackbar","2":"180","3":"83.0","4":"1.801"},{"1":"Mon Mothma","2":"150","3":"NA","4":"NA"},{"1":"Arvel Crynyd","2":"NA","3":"NA","4":"NA"},{"1":"Wicket Systri Warrick","2":"88","3":"20.0","4":"1.816"},{"1":"Nien Nunb","2":"160","3":"68.0","4":"1.867"},{"1":"Qui-Gon Jinn","2":"193","3":"89.0","4":"1.680"},{"1":"Nute Gunray","2":"191","3":"90.0","4":"1.734"},{"1":"Finis Valorum","2":"170","3":"NA","4":"NA"},{"1":"Jar Jar Binks","2":"196","3":"66.0","4":"1.208"},{"1":"Roos Tarpals","2":"224","3":"82.0","4":"1.149"},{"1":"Rugor Nass","2":"206","3":"NA","4":"NA"},{"1":"Ric Olié","2":"183","3":"NA","4":"NA"},{"1":"Watto","2":"137","3":"NA","4":"NA"},{"1":"Sebulba","2":"112","3":"40.0","4":"2.242"},{"1":"Quarsh Panaka","2":"183","3":"NA","4":"NA"},{"1":"Shmi Skywalker","2":"163","3":"NA","4":"NA"},{"1":"Darth Maul","2":"175","3":"80.0","4":"1.836"},{"1":"Bib Fortuna","2":"180","3":"NA","4":"NA"},{"1":"Ayla Secura","2":"178","3":"55.0","4":"1.220"},{"1":"Dud Bolt","2":"94","3":"45.0","4":"3.580"},{"1":"Gasgano","2":"122","3":"NA","4":"NA"},{"1":"Ben Quadinaros","2":"163","3":"65.0","4":"1.720"},{"1":"Mace Windu","2":"188","3":"84.0","4":"1.671"},{"1":"Ki-Adi-Mundi","2":"198","3":"82.0","4":"1.470"},{"1":"Kit Fisto","2":"196","3":"87.0","4":"1.592"},{"1":"Eeth Koth","2":"171","3":"NA","4":"NA"},{"1":"Adi Gallia","2":"184","3":"50.0","4":"1.038"},{"1":"Saesee Tiin","2":"188","3":"NA","4":"NA"},{"1":"Yarael Poof","2":"264","3":"NA","4":"NA"},{"1":"Plo Koon","2":"188","3":"80.0","4":"1.591"},{"1":"Mas Amedda","2":"196","3":"NA","4":"NA"},{"1":"Gregar Typho","2":"185","3":"85.0","4":"1.746"},{"1":"Cordé","2":"157","3":"NA","4":"NA"},{"1":"Cliegg Lars","2":"183","3":"NA","4":"NA"},{"1":"Poggle the Lesser","2":"183","3":"80.0","4":"1.679"},{"1":"Luminara Unduli","2":"170","3":"56.2","4":"1.367"},{"1":"Barriss Offee","2":"166","3":"50.0","4":"1.276"},{"1":"Dormé","2":"165","3":"NA","4":"NA"},{"1":"Dooku","2":"193","3":"80.0","4":"1.510"},{"1":"Bail Prestor Organa","2":"191","3":"NA","4":"NA"},{"1":"Jango Fett","2":"183","3":"79.0","4":"1.658"},{"1":"Zam Wesell","2":"168","3":"55.0","4":"1.370"},{"1":"Dexter Jettster","2":"198","3":"102.0","4":"1.829"},{"1":"Lama Su","2":"229","3":"88.0","4":"1.180"},{"1":"Taun We","2":"213","3":"NA","4":"NA"},{"1":"Jocasta Nu","2":"167","3":"NA","4":"NA"},{"1":"Ratts Tyerell","2":"79","3":"15.0","4":"1.690"},{"1":"R4-P17","2":"96","3":"NA","4":"NA"},{"1":"Wat Tambor","2":"193","3":"48.0","4":"0.906"},{"1":"San Hill","2":"191","3":"NA","4":"NA"},{"1":"Shaak Ti","2":"178","3":"57.0","4":"1.265"},{"1":"Grievous","2":"216","3":"159.0","4":"2.396"},{"1":"Tarfful","2":"234","3":"136.0","4":"1.746"},{"1":"Raymus Antilles","2":"188","3":"79.0","4":"1.571"},{"1":"Sly Moore","2":"178","3":"48.0","4":"1.065"},{"1":"Tion Medon","2":"206","3":"80.0","4":"1.325"},{"1":"Finn","2":"NA","3":"NA","4":"NA"},{"1":"Rey","2":"NA","3":"NA","4":"NA"},{"1":"Poe Dameron","2":"NA","3":"NA","4":"NA"},{"1":"BB8","2":"NA","3":"NA","4":"NA"},{"1":"Captain Phasma","2":"NA","3":"NA","4":"NA"},{"1":"Padmé Amidala","2":"165","3":"45.0","4":"1.162"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[5],"max":[5]},"pages":{}}}
  </script>
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


### <a id="summarize_function"></a>`summarize()` data  

Without creating a new variable, we can create a summary of our data. For example, let's look at average height and mass with their standard deviations using `mean()` and `sd()` function. 

![](Fig/summarize_func.png)



```r
starwars %>% 
  summarize(height_mean = mean(height, na.rm = T),
            height_sd = sd(height, na.rm = T),
            mass_mean = mean(mass, na.rm = T),
            mass_sd = sd(mass, na.rm = T))
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["height_mean"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["height_sd"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["mass_mean"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["mass_sd"],"name":[4],"type":["dbl"],"align":["right"]}],"data":[{"1":"174","2":"34.8","3":"97.3","4":"169"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>



```r
# alternatively, you can use `summarize_at()` if you are feeling terse
starwars %>% 
  summarise_at(vars(height, mass), # variables we want to apply functions on
               list(~mean(., na.rm = T), # first function 
                    ~sd(., na.rm = T))) # second function
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["height_mean"],"name":[1],"type":["dbl"],"align":["right"]},{"label":["mass_mean"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["height_sd"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["mass_sd"],"name":[4],"type":["dbl"],"align":["right"]}],"data":[{"1":"174","2":"97.3","3":"34.8","4":"169"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
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

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["height_n"],"name":[1],"type":["int"],"align":["right"]},{"label":["height_mean"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["height_sd"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["height_min"],"name":[4],"type":["int"],"align":["right"]},{"label":["height_max"],"name":[5],"type":["int"],"align":["right"]},{"label":["height_na"],"name":[6],"type":["int"],"align":["right"]}],"data":[{"1":"87","2":"174","3":"34.8","4":"66","5":"264","6":"6"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
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

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["test"],"name":[1],"type":["chr"],"align":["left"]},{"label":["height"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["mass"],"name":[3],"type":["dbl"],"align":["right"]}],"data":[{"1":"mean","2":"174.4","3":"97.3"},{"1":"sd","2":"34.8","3":"169.5"},{"1":"min","2":"66.0","3":"15.0"},{"1":"max","2":"264.0","3":"1358.0"},{"1":"sum","2":"6.0","3":"28.0"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
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

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["gender"],"name":[1],"type":["chr"],"align":["left"]},{"label":["height_mean"],"name":[2],"type":["dbl"],"align":["right"]},{"label":["mass_mean"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["height_sd"],"name":[4],"type":["dbl"],"align":["right"]},{"label":["mass_sd"],"name":[5],"type":["dbl"],"align":["right"]}],"data":[{"1":"female","2":"165","3":"54.0","4":"23.0","5":"8.37"},{"1":"hermaphrodite","2":"175","3":"1358.0","4":"NA","5":"NA"},{"1":"male","2":"179","3":"81.0","4":"35.4","5":"28.22"},{"1":"none","2":"200","3":"140.0","4":"NA","5":"NA"},{"1":"NA","2":"120","3":"46.3","4":"40.7","5":"24.83"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

Use `ungroup()` to remove grouping.  

```r
starwars %>% 
  ungroup()
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["height"],"name":[2],"type":["int"],"align":["right"]},{"label":["mass"],"name":[3],"type":["dbl"],"align":["right"]},{"label":["hair_color"],"name":[4],"type":["chr"],"align":["left"]},{"label":["skin_color"],"name":[5],"type":["chr"],"align":["left"]},{"label":["eye_color"],"name":[6],"type":["chr"],"align":["left"]},{"label":["birth_year"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["gender"],"name":[8],"type":["chr"],"align":["left"]},{"label":["homeworld"],"name":[9],"type":["chr"],"align":["left"]},{"label":["species"],"name":[10],"type":["chr"],"align":["left"]},{"label":["films"],"name":[11],"type":["list"],"align":["right"]},{"label":["vehicles"],"name":[12],"type":["list"],"align":["right"]},{"label":["starships"],"name":[13],"type":["list"],"align":["right"]}],"data":[{"1":"Luke Skywalker","2":"172","3":"77.0","4":"blond","5":"fair","6":"blue","7":"19.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [5]>","12":"<chr [2]>","13":"<chr [2]>"},{"1":"C-3PO","2":"167","3":"75.0","4":"NA","5":"gold","6":"yellow","7":"112.0","8":"NA","9":"Tatooine","10":"Droid","11":"<chr [6]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"R2-D2","2":"96","3":"32.0","4":"NA","5":"white, blue","6":"red","7":"33.0","8":"NA","9":"Naboo","10":"Droid","11":"<chr [7]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Darth Vader","2":"202","3":"136.0","4":"none","5":"white","6":"yellow","7":"41.9","8":"male","9":"Tatooine","10":"Human","11":"<chr [4]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Leia Organa","2":"150","3":"49.0","4":"brown","5":"light","6":"brown","7":"19.0","8":"female","9":"Alderaan","10":"Human","11":"<chr [5]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Owen Lars","2":"178","3":"120.0","4":"brown, grey","5":"light","6":"blue","7":"52.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Beru Whitesun lars","2":"165","3":"75.0","4":"brown","5":"light","6":"blue","7":"47.0","8":"female","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"R5-D4","2":"97","3":"32.0","4":"NA","5":"white, red","6":"red","7":"NA","8":"NA","9":"Tatooine","10":"Droid","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Biggs Darklighter","2":"183","3":"84.0","4":"black","5":"light","6":"brown","7":"24.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Obi-Wan Kenobi","2":"182","3":"77.0","4":"auburn, white","5":"fair","6":"blue-gray","7":"57.0","8":"male","9":"Stewjon","10":"Human","11":"<chr [6]>","12":"<chr [1]>","13":"<chr [5]>"},{"1":"Anakin Skywalker","2":"188","3":"84.0","4":"blond","5":"fair","6":"blue","7":"41.9","8":"male","9":"Tatooine","10":"Human","11":"<chr [3]>","12":"<chr [2]>","13":"<chr [3]>"},{"1":"Wilhuff Tarkin","2":"180","3":"NA","4":"auburn, grey","5":"fair","6":"blue","7":"64.0","8":"male","9":"Eriadu","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Chewbacca","2":"228","3":"112.0","4":"brown","5":"unknown","6":"blue","7":"200.0","8":"male","9":"Kashyyyk","10":"Wookiee","11":"<chr [5]>","12":"<chr [1]>","13":"<chr [2]>"},{"1":"Han Solo","2":"180","3":"80.0","4":"brown","5":"fair","6":"brown","7":"29.0","8":"male","9":"Corellia","10":"Human","11":"<chr [4]>","12":"<chr [0]>","13":"<chr [2]>"},{"1":"Greedo","2":"173","3":"74.0","4":"NA","5":"green","6":"black","7":"44.0","8":"male","9":"Rodia","10":"Rodian","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Jabba Desilijic Tiure","2":"175","3":"1358.0","4":"NA","5":"green-tan, brown","6":"orange","7":"600.0","8":"hermaphrodite","9":"Nal Hutta","10":"Hutt","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Wedge Antilles","2":"170","3":"77.0","4":"brown","5":"fair","6":"hazel","7":"21.0","8":"male","9":"Corellia","10":"Human","11":"<chr [3]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"Jek Tono Porkins","2":"180","3":"110.0","4":"brown","5":"fair","6":"blue","7":"NA","8":"male","9":"Bestine IV","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Yoda","2":"66","3":"17.0","4":"white","5":"green","6":"brown","7":"896.0","8":"male","9":"NA","10":"Yoda's species","11":"<chr [5]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Palpatine","2":"170","3":"75.0","4":"grey","5":"pale","6":"yellow","7":"82.0","8":"male","9":"Naboo","10":"Human","11":"<chr [5]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Boba Fett","2":"183","3":"78.2","4":"black","5":"fair","6":"brown","7":"31.5","8":"male","9":"Kamino","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"IG-88","2":"200","3":"140.0","4":"none","5":"metal","6":"red","7":"15.0","8":"none","9":"NA","10":"Droid","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Bossk","2":"190","3":"113.0","4":"none","5":"green","6":"red","7":"53.0","8":"male","9":"Trandosha","10":"Trandoshan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Lando Calrissian","2":"177","3":"79.0","4":"black","5":"dark","6":"brown","7":"31.0","8":"male","9":"Socorro","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Lobot","2":"175","3":"79.0","4":"none","5":"light","6":"blue","7":"37.0","8":"male","9":"Bespin","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ackbar","2":"180","3":"83.0","4":"none","5":"brown mottle","6":"orange","7":"41.0","8":"male","9":"Mon Cala","10":"Mon Calamari","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Mon Mothma","2":"150","3":"NA","4":"auburn","5":"fair","6":"blue","7":"48.0","8":"female","9":"Chandrila","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Arvel Crynyd","2":"NA","3":"NA","4":"brown","5":"fair","6":"brown","7":"NA","8":"male","9":"NA","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Wicket Systri Warrick","2":"88","3":"20.0","4":"brown","5":"brown","6":"brown","7":"8.0","8":"male","9":"Endor","10":"Ewok","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Nien Nunb","2":"160","3":"68.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Sullust","10":"Sullustan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Qui-Gon Jinn","2":"193","3":"89.0","4":"brown","5":"fair","6":"blue","7":"92.0","8":"male","9":"NA","10":"Human","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Nute Gunray","2":"191","3":"90.0","4":"none","5":"mottled green","6":"red","7":"NA","8":"male","9":"Cato Neimoidia","10":"Neimodian","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Finis Valorum","2":"170","3":"NA","4":"blond","5":"fair","6":"blue","7":"91.0","8":"male","9":"Coruscant","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Jar Jar Binks","2":"196","3":"66.0","4":"none","5":"orange","6":"orange","7":"52.0","8":"male","9":"Naboo","10":"Gungan","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Roos Tarpals","2":"224","3":"82.0","4":"none","5":"grey","6":"orange","7":"NA","8":"male","9":"Naboo","10":"Gungan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Rugor Nass","2":"206","3":"NA","4":"none","5":"green","6":"orange","7":"NA","8":"male","9":"Naboo","10":"Gungan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ric Olié","2":"183","3":"NA","4":"brown","5":"fair","6":"blue","7":"NA","8":"male","9":"Naboo","10":"NA","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Watto","2":"137","3":"NA","4":"black","5":"blue, grey","6":"yellow","7":"NA","8":"male","9":"Toydaria","10":"Toydarian","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Sebulba","2":"112","3":"40.0","4":"none","5":"grey, red","6":"orange","7":"NA","8":"male","9":"Malastare","10":"Dug","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Quarsh Panaka","2":"183","3":"NA","4":"black","5":"dark","6":"brown","7":"62.0","8":"male","9":"Naboo","10":"NA","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Shmi Skywalker","2":"163","3":"NA","4":"black","5":"fair","6":"brown","7":"72.0","8":"female","9":"Tatooine","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Darth Maul","2":"175","3":"80.0","4":"none","5":"red","6":"yellow","7":"54.0","8":"male","9":"Dathomir","10":"Zabrak","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"Bib Fortuna","2":"180","3":"NA","4":"none","5":"pale","6":"pink","7":"NA","8":"male","9":"Ryloth","10":"Twi'lek","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ayla Secura","2":"178","3":"55.0","4":"none","5":"blue","6":"hazel","7":"48.0","8":"female","9":"Ryloth","10":"Twi'lek","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Dud Bolt","2":"94","3":"45.0","4":"none","5":"blue, grey","6":"yellow","7":"NA","8":"male","9":"Vulpter","10":"Vulptereen","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Gasgano","2":"122","3":"NA","4":"none","5":"white, blue","6":"black","7":"NA","8":"male","9":"Troiken","10":"Xexto","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ben Quadinaros","2":"163","3":"65.0","4":"none","5":"grey, green, yellow","6":"orange","7":"NA","8":"male","9":"Tund","10":"Toong","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Mace Windu","2":"188","3":"84.0","4":"none","5":"dark","6":"brown","7":"72.0","8":"male","9":"Haruun Kal","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ki-Adi-Mundi","2":"198","3":"82.0","4":"white","5":"pale","6":"yellow","7":"92.0","8":"male","9":"Cerea","10":"Cerean","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Kit Fisto","2":"196","3":"87.0","4":"none","5":"green","6":"black","7":"NA","8":"male","9":"Glee Anselm","10":"Nautolan","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Eeth Koth","2":"171","3":"NA","4":"black","5":"brown","6":"brown","7":"NA","8":"male","9":"Iridonia","10":"Zabrak","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Adi Gallia","2":"184","3":"50.0","4":"none","5":"dark","6":"blue","7":"NA","8":"female","9":"Coruscant","10":"Tholothian","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Saesee Tiin","2":"188","3":"NA","4":"none","5":"pale","6":"orange","7":"NA","8":"male","9":"Iktotch","10":"Iktotchi","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Yarael Poof","2":"264","3":"NA","4":"none","5":"white","6":"yellow","7":"NA","8":"male","9":"Quermia","10":"Quermian","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Plo Koon","2":"188","3":"80.0","4":"none","5":"orange","6":"black","7":"22.0","8":"male","9":"Dorin","10":"Kel Dor","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Mas Amedda","2":"196","3":"NA","4":"none","5":"blue","6":"blue","7":"NA","8":"male","9":"Champala","10":"Chagrian","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Gregar Typho","2":"185","3":"85.0","4":"black","5":"dark","6":"brown","7":"NA","8":"male","9":"Naboo","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"Cordé","2":"157","3":"NA","4":"brown","5":"light","6":"brown","7":"NA","8":"female","9":"Naboo","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Cliegg Lars","2":"183","3":"NA","4":"brown","5":"fair","6":"blue","7":"82.0","8":"male","9":"Tatooine","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Poggle the Lesser","2":"183","3":"80.0","4":"none","5":"green","6":"yellow","7":"NA","8":"male","9":"Geonosis","10":"Geonosian","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Luminara Unduli","2":"170","3":"56.2","4":"black","5":"yellow","6":"blue","7":"58.0","8":"female","9":"Mirial","10":"Mirialan","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Barriss Offee","2":"166","3":"50.0","4":"black","5":"yellow","6":"blue","7":"40.0","8":"female","9":"Mirial","10":"Mirialan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Dormé","2":"165","3":"NA","4":"brown","5":"light","6":"brown","7":"NA","8":"female","9":"Naboo","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Dooku","2":"193","3":"80.0","4":"white","5":"fair","6":"brown","7":"102.0","8":"male","9":"Serenno","10":"Human","11":"<chr [2]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Bail Prestor Organa","2":"191","3":"NA","4":"black","5":"tan","6":"brown","7":"67.0","8":"male","9":"Alderaan","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Jango Fett","2":"183","3":"79.0","4":"black","5":"tan","6":"brown","7":"66.0","8":"male","9":"Concord Dawn","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Zam Wesell","2":"168","3":"55.0","4":"blonde","5":"fair, green, yellow","6":"yellow","7":"NA","8":"female","9":"Zolan","10":"Clawdite","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [0]>"},{"1":"Dexter Jettster","2":"198","3":"102.0","4":"none","5":"brown","6":"yellow","7":"NA","8":"male","9":"Ojom","10":"Besalisk","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Lama Su","2":"229","3":"88.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Kamino","10":"Kaminoan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Taun We","2":"213","3":"NA","4":"none","5":"grey","6":"black","7":"NA","8":"female","9":"Kamino","10":"Kaminoan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Jocasta Nu","2":"167","3":"NA","4":"white","5":"fair","6":"blue","7":"NA","8":"female","9":"Coruscant","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Ratts Tyerell","2":"79","3":"15.0","4":"none","5":"grey, blue","6":"unknown","7":"NA","8":"male","9":"Aleen Minor","10":"Aleena","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"R4-P17","2":"96","3":"NA","4":"none","5":"silver, red","6":"red, blue","7":"NA","8":"female","9":"NA","10":"NA","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Wat Tambor","2":"193","3":"48.0","4":"none","5":"green, grey","6":"unknown","7":"NA","8":"male","9":"Skako","10":"Skakoan","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"San Hill","2":"191","3":"NA","4":"none","5":"grey","6":"gold","7":"NA","8":"male","9":"Muunilinst","10":"Muun","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Shaak Ti","2":"178","3":"57.0","4":"none","5":"red, blue, white","6":"black","7":"NA","8":"female","9":"Shili","10":"Togruta","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Grievous","2":"216","3":"159.0","4":"none","5":"brown, white","6":"green, yellow","7":"NA","8":"male","9":"Kalee","10":"Kaleesh","11":"<chr [1]>","12":"<chr [1]>","13":"<chr [1]>"},{"1":"Tarfful","2":"234","3":"136.0","4":"brown","5":"brown","6":"blue","7":"NA","8":"male","9":"Kashyyyk","10":"Wookiee","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Raymus Antilles","2":"188","3":"79.0","4":"brown","5":"light","6":"brown","7":"NA","8":"male","9":"Alderaan","10":"Human","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Sly Moore","2":"178","3":"48.0","4":"none","5":"pale","6":"white","7":"NA","8":"female","9":"Umbara","10":"NA","11":"<chr [2]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Tion Medon","2":"206","3":"80.0","4":"none","5":"grey","6":"black","7":"NA","8":"male","9":"Utapau","10":"Pau'an","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Finn","2":"NA","3":"NA","4":"black","5":"dark","6":"dark","7":"NA","8":"male","9":"NA","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Rey","2":"NA","3":"NA","4":"brown","5":"light","6":"hazel","7":"NA","8":"female","9":"NA","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Poe Dameron","2":"NA","3":"NA","4":"brown","5":"light","6":"brown","7":"NA","8":"male","9":"NA","10":"Human","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [1]>"},{"1":"BB8","2":"NA","3":"NA","4":"none","5":"none","6":"black","7":"NA","8":"none","9":"NA","10":"Droid","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Captain Phasma","2":"NA","3":"NA","4":"unknown","5":"unknown","6":"unknown","7":"NA","8":"female","9":"NA","10":"NA","11":"<chr [1]>","12":"<chr [0]>","13":"<chr [0]>"},{"1":"Padmé Amidala","2":"165","3":"45.0","4":"brown","5":"light","6":"brown","7":"46.0","8":"female","9":"Naboo","10":"Human","11":"<chr [3]>","12":"<chr [0]>","13":"<chr [3]>"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
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




