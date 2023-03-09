## code to prepare `Fast_Food_Outlet_Density_per_1000_Residents` dataset goes here

Fast_Food_Outlet_Density_per_1000_Residents <- subset(Fast_Food_Outlet_Density_per_1000_Residents, select=-c(OBJECTID, Shape__Area, Shape__Length))

usethis::use_data(Fast_Food_Outlet_Density_per_1000_Residents, overwrite = TRUE)
