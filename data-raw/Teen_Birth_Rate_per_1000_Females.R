## code to prepare `Teen_Birth_Rate_per_1000_Females` dataset goes here

Teen_Birth_Rate_per_1000_Females <- subset(Teen_Birth_Rate_per_1000_Females, select=-c(OBJECTID, Shape__Area, Shape__Length))

usethis::use_data(Teen_Birth_Rate_per_1000_Females, overwrite = TRUE)
