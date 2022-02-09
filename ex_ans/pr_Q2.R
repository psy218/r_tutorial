#' step 1: creating a custom function to reverse-score items
reverse_x <- function(x, max) {
  ifelse(is.na(x) == FALSE, (max + 1) - x , NA)
}

#' step 2: reverse score, create an average score, and centre it on group mean 
#' @param neuroticism aggregate score of neuroticism (BFI_4, BFI_11, BFI_9)
#' @param neuroticism_mc mean-centered neuroticism 

ocean_data <- ocean_data %>% 
  mutate_at( vars(c("BFI_4", "BFI_11")), # specify which variables to apply the function
             ~reverse_x(., max = 5)) %>% # apply the reverse-score function
  mutate(neuroticism = rowMeans(cbind(BFI_4, BFI_11, BFI_9), na.rm = T)) %>%  # create an aggregate score
  group_by(gender) %>% # this will allow us to calcualte the group mean when we use mean function
  mutate(neuroticism_mc = neuroticism - mean(neuroticism, na.rm = T)) # center neuroticism score on group mean
  
  