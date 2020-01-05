students_age <- c(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26)
mean(students_age, na.rm = T)

# NOT this:
mean(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26) # this will give you 28.
# Or this:
mean(c(28, 20, 24, 27, 19, NA, 18, 28, 22, 21, 21, 26)) # you have to say na. rm = T