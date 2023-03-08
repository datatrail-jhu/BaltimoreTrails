## code to prepare `Perc_Pop_School_Employed` dataset goes here

Perc_Pop_School_Employed <- subset(Perc_Pop_School_Employed, select=-c(OBJECTID, Shape__Area, Shape__Length))

usethis::use_data(Perc_Pop_School_Employed, overwrite = TRUE)
