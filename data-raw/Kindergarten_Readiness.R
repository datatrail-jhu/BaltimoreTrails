## code to prepare `Kindergarten_Readiness` dataset goes here

Kindergarten_Readiness <- subset(Kindergarten_Readiness, select=-c(OBJECTID, SHAPE_Area, SHAPE_Length))

usethis::use_data(Kindergarten_Readiness, overwrite = TRUE)
