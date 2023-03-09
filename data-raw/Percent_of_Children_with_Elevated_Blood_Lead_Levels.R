## code to prepare `Percent_of_Children_with_Elevated_Blood_Lead_Levels` dataset goes here

Percent_of_Children_with_Elevated_Blood_Lead_Levels <- subset(Percent_of_Children_with_Elevated_Blood_Lead_Levels, select=-c(OBJECTID, Shape__Area, Shape__Length))

usethis::use_data(Percent_of_Children_with_Elevated_Blood_Lead_Levels, overwrite = TRUE)
