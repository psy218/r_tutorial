starwars %>% 
  lm(height ~ mass, 
     # na.action = NULL, # by default, NAs are omitted 
     data = .)