#' Step 1. Evaluate the error statement: Is y (i.e., sex) greater than or equal to 0 
#' and smaller than or equal to 1? 
table(glm_data$sex) # no; one value is coded as `-1`! 

#' Step 2. recode -1 to 0
#' base R
summary(glm(ifelse(glm_data$sex == -1, 0, glm_data$sex) ~ happiness + marital_status, 
            family = "binomial",
            data = glm_data))

#' tidyverse R
glm_data %>% 
  # recode `sex` variable
  mutate(sex = ifelse(sex == -1, 0, sex)) %>% 
  # then run it again
  glm(sex ~ happiness + marital_status,
      family = "binomial", 
      data = .) %>% 
  summary
