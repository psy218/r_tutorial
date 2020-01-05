starwars %>% 
  filter(species == "Human", # human 
         eye_color != "blue", # eye color not blue
         between(birth_year, left = 23, right = 35)) %>% # age falling between 23 and 35
  select(name, gender) # just choosing the name column
