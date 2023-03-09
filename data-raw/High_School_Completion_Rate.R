## code to prepare `High_School_Completion_Rate` dataset goes here

High_School_Completion_Rate <- subset(High_School_Completion_Rate, select=-c(OBJECTID, Shape__Area, Shape__Length))

usethis::use_data(High_School_Completion_Rate, overwrite = TRUE)

