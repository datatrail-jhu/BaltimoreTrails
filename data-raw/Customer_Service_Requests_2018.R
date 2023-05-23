## code to prepare `Customer_Service_Requests_2018` dataset goes here

#No pre-processing preliminarily, but will adress NAs and missing values etc. later

Customer_Service_Requests_2018 <- Customer_Service_Requests_2018[sample(nrow(Customer_Service_Requests_2018), 500), ]

usethis::use_data(Customer_Service_Requests_2018, overwrite = TRUE)
