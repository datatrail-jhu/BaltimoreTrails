## code to prepare `Percentage_of_Students_Receiving_Free_or_Reduced_Meals` dataset goes here

Percentage_of_Students_Receiving_Free_or_Reduced_Meals <- subset(Percentage_of_Students_Receiving_Free_or_Reduced_Meals, select=-c(OBJECTID, SHAPE_Area, SHAPE_Length))

usethis::use_data(Percentage_of_Students_Receiving_Free_or_Reduced_Meals, overwrite = TRUE)
