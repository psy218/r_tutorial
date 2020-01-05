#' Step 1a: Reverse-code BFI_1 using `reverse_x()`
#' Step 1b: Create an aggregate score for extroversion using `rowMeans()`

example_data$extraversion <- rowMeans(cbind(reverse_x(5, example_data$BFI_1), # reverse code BFI_1
                                            example_data$BFI_6), # then column-bind with BFI_6
                                      na.rm = T) # compute an average

#' Step 2: Find the average extraversion scores for male and female participants, and save the result as an object (`group_mean`)
group_mean <- with(example_data, tapply(X = extraversion, 
                                        INDEX = gender, mean, na.rm = T))

#' Step 3: Calculate mean-centred extraversion score (`extraversion_gc`) by subtracting extraversion score from average extraversion scores (`extraversion`) of men (`group_mean["male"]`) and women (`group_mean["female"]`)
example_data <- within(example_data, {
  extraversion_gc = ifelse(test = gender == "male", 
                           yes = extraversion - group_mean["male"], 
                           no = extraversion - group_mean["female"])
})
