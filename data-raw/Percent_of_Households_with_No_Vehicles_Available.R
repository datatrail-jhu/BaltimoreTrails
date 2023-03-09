## code to prepare `Percent_of_Households_with_No_Vehicles_Available` dataset goes here

Percent_of_Households_with_No_Vehicles_Available <- subset(Percent_of_Households_with_No_Vehicles_Available, select=-c(OBJECTID, Shape__Area, Shape__Length))

usethis::use_data(Percent_of_Households_with_No_Vehicles_Available, overwrite = TRUE)
