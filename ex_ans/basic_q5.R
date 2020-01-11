birth_data$yr_remaining = ifelse(test = birth_data$sex == "men",
                                 yes = 80 - birth_data$age,
                                 no = 84 -  birth_data$age)

birth_data