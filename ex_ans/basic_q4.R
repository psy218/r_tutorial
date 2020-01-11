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

