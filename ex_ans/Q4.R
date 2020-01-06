# read-in saved basket dataset for the example
basket <- readr::read_csv(here::here("dataset", "basket.csv"))

# Finding the names of fruits and veggies whose names do not start with "c" using the startsWith() function. 
basket[!startsWith(basket$fruits, "c"), "fruits"]
basket[!startsWith(basket$veggies, "c"), "veggies"]
