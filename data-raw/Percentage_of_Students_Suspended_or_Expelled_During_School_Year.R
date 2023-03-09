## code to prepare `Percentage_of_Students_Suspended_or_Expelled_During_School_Year` dataset goes here

Percentage_of_Students_Suspended_or_Expelled_During_School_Year <- subset(Percentage_of_Students_Suspended_or_Expelled_During_School_Year, select=-c(OBJECTID, SHAPE_Area, SHAPE_Length))

usethis::use_data(Percentage_of_Students_Suspended_or_Expelled_During_School_Year, overwrite = TRUE)
