with(starwars, tapply(X = height, 
                      INDEX = gender, mean, na.rm = T))