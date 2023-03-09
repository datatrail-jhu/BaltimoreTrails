## code to prepare `Infant_Mortality_Rate` dataset goes here

Infant_Mortality_Rate <- subset(Infant_Mortality_Rate, select=-c(OBJECTID, SHAPE_Area, SHAPE_Length))

usethis::use_data(Infant_Mortality_Rate, overwrite = TRUE)
