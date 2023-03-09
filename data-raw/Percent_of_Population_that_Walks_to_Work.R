## code to prepare `Percent_of_Population_that_Walks_to_Work` dataset goes here

Percent_of_Population_that_Walks_to_Work <- subset(Percent_of_Population_that_Walks_to_Work, select=-c(OBJECTID, Shape__Area, Shape__Length))

usethis::use_data(Percent_of_Population_that_Walks_to_Work, overwrite = TRUE)
