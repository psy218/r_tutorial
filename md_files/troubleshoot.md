---
title: "troubleshoot"
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



# Troubleshooting

## General tips
### 0. Update your R and RStudio  
As of today, 2020-01-06, the most updated versions of R and RStudio are 3.6.2 and 1.2.5033, respectively. 

Check your R and RStudio versions regularly by running this code (for R),

```r
R.version.string
```

```
## [1] "R version 3.6.2 (2019-12-12)"
```
   
and RStudio -> About RStudio (for RStudio)   
![](Fig/rstudio_version.png)

You may encounter errors related to the old versions of R; consider keeping your R and RStudio up to date. 

`Restart R` periodically: Session -> Restart R   
![](https://community.rstudio.com/uploads/default/original/2X/9/993b9b9c1f1231fa1c462115b7eb52991b5a7c14.png)


### 1. Debug sequentially

Functions may rely on other subordinate function(s), which may be the source of an error. For example, `outer_function()` relies on `nested_function()`, which relies on `nested_nested_function()`. 

```r
outer_function <- function(input1) nested_function(input1)
nested_function <- function(input2) nested_nested_function(input2)
nested_nested_function <- function(input3) "input3" + 1
```

When we run the `outer_function()`, we will see an error message.

```r
outer_function(3)
```

```
## Error in "input3" + 1: non-numeric argument to binary operator
```

When this occus, we need to identify the very first function and work from there. 

You can either press `Show Traceback` option, 
![](Fig/error_traceback.png)   

or run `traceback()`, and check at which step you got the error message. 

If you are running all the functions in one line, work from the inner-most function (i.e., `nested_nested_function()`) and work out:

```r
outer_function(nested_function(nested_nested_function(3)))
```

```
## Error in "input3" + 1: non-numeric argument to binary operator
```


### 2. Practice nonattachment 

Dry-run your codes before saving it as an object or making a permanent change (e.g., creating a new column in a dataset).   

```r
# bmi_summary <- 
starwars %>% 
  # select(height, mass, gender) %>% 
  mutate(bmi = 703 * mass/(height^2)) %>% 
  group_by(gender) %>% 
  summarize(bmi_mean = mean(bmi, na.rm = T),
            bmi_sd = sd(bmi, na.rm = T))
```


### 3. Be consistent   
Name your objects (or variables, functions) with a clear rule that makes sense to you; a consistent naming convention will go a long way.   

For example, I specify the type of an object at the end of an object name, following `_`. For example, I name my regression summary output as `model_lm`:

```r
heightMass_lm <- starwars %>% 
  lm(height ~ mass,
     data = .) %>% 
  summary
```

For datasets, I used `name_dataset`:

```r
starwars_dataset <- dplyr::starwars
```

For variables, I use consistent abbreviations:   
`variable.gc` group-centered   
`variable.c` (mean-)centered   
`variable.rs` reverse-scored    


## Packages & Functions
### Package installation  
If you have problem installing packages, check this [help page](https://support.rstudio.com/hc/en-us/articles/200554786-Problem-Installing-Packages).  


### Package loading   

```r
library(nonexistent_package)
```

```
## Error in library(nonexistent_package): there is no package called 'nonexistent_package'
```

If you get this error although you swear you installed it a million times,    

a) check whether you can find it under System Library in the Packages tab  
![](Fig/system_library.png)  


b) check where your packages are installed    

```r
.libPaths()
```

```
## [1] "/Library/Frameworks/R.framework/Versions/3.6/Resources/library"
```

c) install for the last time the package using the RStudio Packages tab:


### Help for a function
Looking for a manual for a function in two ways:   

1. using ?function

```r
?sum
```

2. help(function)   

```r
help(sum)
```

If help page returns no documentation, try `??function`  

```r
??sum
```

### Funtion arguments   

```r
args(sum)
```

```
## function (..., na.rm = FALSE) 
## NULL
```

Type the function name (e.g., sum()) and press `Tab` key
![](https://rc2e.com/images_v2/mean_tooltip.png)


## Look for relevant functions & packages   
1. [CRAN Task Views](http://cran.r-project.org/web/views/)
Packages related to [Social Science research](http://cran.r-project.org/web/views/SocialSciences.html) and [Reproducible Research](http://cran.r-project.org/web/views/ReproducibleResearch.html)

2. [crantastic](http://crantastic.org)
Keyword-based search tool for R packages.  

3. [ROpenSci](http://ropensci.org/packages/)
Open science tools & R packages 

4. [rseek](http://rseek.org)
Search by name or keyworld 

## Everything failed
Search the web
1. [rseek](http://rseek.org)
2. [StackOverflow](http://stackoverflow.com)


# Common errors
For more details, check Noam Ross's [analysis of the most common errors](https://github.com/noamross/zero-dependency-problems/blob/master/misc/stack-overflow-common-r-errors.md) asked on Stack Overflow. 
  

## [Object not found](http://varianceexplained.org/courses/errors/) {.tabset .tabset-fade .tabset-pills}  

### Error   


```r
Basket
```

```
## Error in eval(expr, envir, enclos): object 'Basket' not found
```


### Solutions  
a) R is case-sensitive

```r
some_object
```

b) Code that assigned the object was not ran
Try `Cmd` or `Ctlr` + `F` to find the line that assigns the object.  

c) Specify what you want to do in your code
R does not treat `space` between objects as multiplication 

```r
some_object (x + 1)
```
specify the operation with `*`

```r
some_object*(x+1)
```


## [Function not found](http://varianceexplained.org/courses/errors/) {.tabset .tabset-fade .tabset-pills}  

### Error  

```r
some_function(x)
```

```
## Error in some_function(x): could not find function "some_function"
```

### Solutions  

Different packages may include different functions of the same name, which will create a conflict. 

When you get an error that a function cannot be found, explicitly specify what package includes the function you are referring to by using `package_name::function`. 


```r
package_function_is_from::some_function(x)
```

For older versions of R, these are some *problem* functions that can be resolved with this technique:

```
dplyr::select()
```

## Syntax Error {.tabset .tabset-fade .tabset-pills}  
### Error   


```r
# retain observations for those whose height is smaller than 100 or equal to 200. 
starwars[starwars$height < 100 | = 200, ]
```

```
## Error: <text>:2:34: unexpected '='
## 1: # retain observations for those whose height is smaller than 100 or equal to 200. 
## 2: starwars[starwars$height < 100 | =
##                                     ^
```

### Solutions
Chekc your logical operators   


```r
library(dplyr)

starwars[starwars$height < 100 | 
           starwars$height == 200, ] # a new statement
```

<div class="kable-table">

name                     height   mass  hair_color   skin_color    eye_color    birth_year  gender   homeworld     species          films                                                                                                                                                        vehicles       starships    
----------------------  -------  -----  -----------  ------------  ----------  -----------  -------  ------------  ---------------  -----------------------------------------------------------------------------------------------------------------------------------------------------------  -------------  -------------
R2-D2                        96     32  NA           white, blue   red                  33  NA       Naboo         Droid            c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back", "A New Hope", "The Force Awakens")   character(0)   character(0) 
R5-D4                        97     32  NA           white, red    red                  NA  NA       Tatooine      Droid            A New Hope                                                                                                                                                   character(0)   character(0) 
Yoda                         66     17  white        green         brown               896  male     NA            Yoda's species   c("Attack of the Clones", "The Phantom Menace", "Revenge of the Sith", "Return of the Jedi", "The Empire Strikes Back")                                      character(0)   character(0) 
IG-88                       200    140  none         metal         red                  15  none     NA            Droid            The Empire Strikes Back                                                                                                                                      character(0)   character(0) 
NA                           NA     NA  NA           NA            NA                   NA  NA       NA            NA               NULL                                                                                                                                                         NULL           NULL         
Wicket Systri Warrick        88     20  brown        brown         brown                 8  male     Endor         Ewok             Return of the Jedi                                                                                                                                           character(0)   character(0) 
Dud Bolt                     94     45  none         blue, grey    yellow               NA  male     Vulpter       Vulptereen       The Phantom Menace                                                                                                                                           character(0)   character(0) 
Ratts Tyerell                79     15  none         grey, blue    unknown              NA  male     Aleen Minor   Aleena           The Phantom Menace                                                                                                                                           character(0)   character(0) 
R4-P17                       96     NA  none         silver, red   red, blue            NA  female   NA            NA               c("Attack of the Clones", "Revenge of the Sith")                                                                                                             character(0)   character(0) 
NA                           NA     NA  NA           NA            NA                   NA  NA       NA            NA               NULL                                                                                                                                                         NULL           NULL         
NA                           NA     NA  NA           NA            NA                   NA  NA       NA            NA               NULL                                                                                                                                                         NULL           NULL         
NA                           NA     NA  NA           NA            NA                   NA  NA       NA            NA               NULL                                                                                                                                                         NULL           NULL         
NA                           NA     NA  NA           NA            NA                   NA  NA       NA            NA               NULL                                                                                                                                                         NULL           NULL         
NA                           NA     NA  NA           NA            NA                   NA  NA       NA            NA               NULL                                                                                                                                                         NULL           NULL         

</div>

Make sure each logical operator is accompanied by its corresponding object(s), and check your operators are correctly specified. For example, one equal sign (`=`) is designated for object assignment; two equal signs (`==`) should be used to denote equal to. 

## No Output {.tabset .tabset-fade .tabset-pills}    
There may be times where R doesn't return anything even though you are running multiple codes. This is indicated by the prompt sign change from `>` to `+`:  
![](Fig/promt_plus.png)

### Error   
Fix these errors:  
a) 

```r
starwars %>% 
  dplyr::select(height, mass
```

```
## Error: <text>:3:0: unexpected end of input
## 1: starwars %>% 
## 2:   dplyr::select(height, mass
##   ^
```
   
b)  

```r
starwars[ ,c("height", "mass)]
```

```
## Error: <text>:1:24: unexpected INCOMPLETE_STRING
## 1: starwars[ ,c("height", "mass)]
##                            ^
```

### Solution  

The prompt sign `+` denotes incomplete code. When this happens, 
a) check whether you forgot to close a bracket in your code; Type `)` to close the bracket  


```r
starwars %>% 
  dplyr::select(height, mass)
```

<div class="kable-table">

 height     mass
-------  -------
    172     77.0
    167     75.0
     96     32.0
    202    136.0
    150     49.0
    178    120.0
    165     75.0
     97     32.0
    183     84.0
    182     77.0
    188     84.0
    180       NA
    228    112.0
    180     80.0
    173     74.0
    175   1358.0
    170     77.0
    180    110.0
     66     17.0
    170     75.0
    183     78.2
    200    140.0
    190    113.0
    177     79.0
    175     79.0
    180     83.0
    150       NA
     NA       NA
     88     20.0
    160     68.0
    193     89.0
    191     90.0
    170       NA
    196     66.0
    224     82.0
    206       NA
    183       NA
    137       NA
    112     40.0
    183       NA
    163       NA
    175     80.0
    180       NA
    178     55.0
     94     45.0
    122       NA
    163     65.0
    188     84.0
    198     82.0
    196     87.0
    171       NA
    184     50.0
    188       NA
    264       NA
    188     80.0
    196       NA
    185     85.0
    157       NA
    183       NA
    183     80.0
    170     56.2
    166     50.0
    165       NA
    193     80.0
    191       NA
    183     79.0
    168     55.0
    198    102.0
    229     88.0
    213       NA
    167       NA
     79     15.0
     96       NA
    193     48.0
    191       NA
    178     57.0
    216    159.0
    234    136.0
    188     79.0
    178     48.0
    206     80.0
     NA       NA
     NA       NA
     NA       NA
     NA       NA
     NA       NA
    165     45.0

</div>

b) check your quotes   

```r
starwars[ ,c("height", "mass")]
```

<div class="kable-table">

 height     mass
-------  -------
    172     77.0
    167     75.0
     96     32.0
    202    136.0
    150     49.0
    178    120.0
    165     75.0
     97     32.0
    183     84.0
    182     77.0
    188     84.0
    180       NA
    228    112.0
    180     80.0
    173     74.0
    175   1358.0
    170     77.0
    180    110.0
     66     17.0
    170     75.0
    183     78.2
    200    140.0
    190    113.0
    177     79.0
    175     79.0
    180     83.0
    150       NA
     NA       NA
     88     20.0
    160     68.0
    193     89.0
    191     90.0
    170       NA
    196     66.0
    224     82.0
    206       NA
    183       NA
    137       NA
    112     40.0
    183       NA
    163       NA
    175     80.0
    180       NA
    178     55.0
     94     45.0
    122       NA
    163     65.0
    188     84.0
    198     82.0
    196     87.0
    171       NA
    184     50.0
    188       NA
    264       NA
    188     80.0
    196       NA
    185     85.0
    157       NA
    183       NA
    183     80.0
    170     56.2
    166     50.0
    165       NA
    193     80.0
    191       NA
    183     79.0
    168     55.0
    198    102.0
    229     88.0
    213       NA
    167       NA
     79     15.0
     96       NA
    193     48.0
    191       NA
    178     57.0
    216    159.0
    234    136.0
    188     79.0
    178     48.0
    206     80.0
     NA       NA
     NA       NA
     NA       NA
     NA       NA
     NA       NA
    165     45.0

</div>

c) Or hit `esc` key  
This will cancel the incomplete code, and allows you to inspect the code.  

## ...cannot open {.tabset .tabset-fade .tabset-pills}  
### Error   


```r
data_to_import <- readr::read_csv("path_to_my_R_folder/folder_that_contains_my_data/dataset_name.csv")
```

```
## Error: 'path_to_my_R_folder/folder_that_contains_my_data/dataset_name.csv' does not exist in current working directory ('/Users/suesong/R/r_tutorial').
```


### Solutions

This error is usually caused by either nonexistent file or incorrect path. Make sure the file is located in the specified path, and your working directory is correctly defined (if you are using a relative path). 

```r
getwd()
```

```
## [1] "/Users/suesong/R/r_tutorial"
```

If the error persists, use `Import Dataset` instead:   

![](Fig/RStudio_import_dataset.png) 


## ...subscript out of bounds {.tabset .tabset-fade .tabset-pills}    
You may get an error message that says your subscript is out of bounds. 

### Error    

```r
starwars[ ,c(140, 110)]
```

```
## Error: Positive column indexes in `[` must match number of columns:
## * `.data` has 13 columns
## * Position 1 equals 140
## * Position 2 equals 110
```

### Solution  
This error usually denotes nonexistent element; check whether you are trying to access existing elements.  

```r
dim(starwars)
```

```
## [1] 87 13
```
The first corresponds to the number of rows (observations) and the second corresponds to the number of columns (variables).  

## Missing values {.tabset .tabset-fade .tabset-pills}   
### Error   
`NA` serves as a placeholder for missing values. Untreated NAs may (or may not) throw an error message.   

a) 

```r
starwars %>% 
  lm(height ~ mass, 
     na.action = NULL,
     data = .)
```

```
## Error in lm.fit(x, y, offset = offset, singular.ok = singular.ok, ...): NA/NaN/Inf in 'x'
```

b) 

```r
mean(starwars$mass)
```

```
## [1] NA
```

### Solutions  
a) 

```r
starwars %>% 
  lm(height ~ mass, 
     # na.action = NULL, # by default, NAs are omitted 
     data = .)
```

```
## 
## Call:
## lm(formula = height ~ mass, data = .)
## 
## Coefficients:
## (Intercept)         mass  
##   171.28536      0.02807
```

b) 

```r
mean(starwars$mass, na.rm = T)
```

```
## [1] 97.31186
```


# Resources & References 
## Interactive tutorial with Swirl

```r
install.packages("swirl")
librar("swirl")
swirl()
```

This tutorial heavily relies on the [R Cookbook](https://rc2e.com/), [R for Data Science](https://r4ds.had.co.nz/), and [Data Carpentry](https://datacarpentry.org/).
