## code to prepare `Life_Expectancy` dataset goes here

Life_Expectancy <- subset(Life_Expectancy, select=-c(OBJECTID, SHAPE_Area, SHAPE_Length))

usethis::use_data(Life_Expectancy, overwrite = TRUE)
