####### Workflow For Adding Data to the Package #######

library(devtools)
library(roxygen2)


####### BNIA DATASETS (EASY TO WRANGLE) #######

####### EDUCATION #######
# Adding Raw EDUCATION Data 1
use_data_raw("Perc_Pop_School_Employed")

# Adding Raw EDUCATION Data 2
use_data_raw("High_School_Completion_Rate")

# Adding Raw EDUCATION Data 3
use_data_raw("Kindergarten_Readiness")

# Adding Raw EDUCATION Data 4
use_data_raw("Percentage_of_Students_Receiving_Free_or_Reduced_Meals")

# Adding Raw EDUCATION Data 5
use_data_raw("Percentage_of_Students_Suspended_or_Expelled_During_School_Year")


####### SUSTAINABILITY #######
# Adding Raw SUSTAINABILITY Data 1
use_data_raw("Percent_of_Households_with_No_Vehicles_Available")

# Adding Raw SUSTAINABILITY Data 2
use_data_raw("Percent_of_Employed_Population_with_Travel_Time_to_Work_of_45_Minutes_and_Over")

# Adding Raw SUSTAINABILITY Data 3
use_data_raw("Percent_of_Population_that_Uses_Public_Transportation_to_Get_to_Work")

# Adding Raw SUSTAINABILITY Data 4
use_data_raw("Percent_of_Population_that_Carpool_to_Work")

# Adding Raw SUSTAINABILITY Data 5
use_data_raw("Percent_of_Population_that_Walks_to_Work")


####### Children and Family Health #######
# Adding Raw Health Data 1
use_data_raw("Fast_Food_Outlet_Density_per_1000_Residents")

# Adding Raw Health Data 2
use_data_raw("Percent_of_Children_with_Elevated_Blood_Lead_Levels")

# Adding Raw Health Data 3
use_data_raw("Life_Expectancy")

# Adding Raw Health Data 4
use_data_raw("Infant_Mortality_Rate")

# Adding Raw Health Data 5
use_data_raw("Teen_Birth_Rate_per_1000_Females")

####### Open Baltimore (Medium/Hard TO WRANGLE) #######

# Adding City Data 1
use_data_raw("Baltimore_City_Employee_Salaries")

# Adding City Data 2
use_data_raw("Open_Checkbook_FY2020_Dataset")

# Adding City Data 3
use_data_raw("Customer_Service_Requests_2018")

# Adding City Data 4
#names(Surface_Water_Quality_Data_1995_through_September_2022) <- Surface_Water_Quality_Data_1995_through_September_2022[1, ]
#Surface_Water_Quality_Data_1995_through_September_2022 <- Surface_Water_Quality_Data_1995_through_September_2022[-1, ]
use_data_raw("Surface_Water_Quality_Data_1995_through_September_2022")

# Adding City Data 5
use_data_raw("Racial_Diversity_Index")

# Adding Metadata
use_data_raw("metadata_full")

### MetaData Creation

# Create a dataframe
metadata <- data.frame(
  dataset = c("Perc_Pop_School_Employed", "Baltimore_City_Employee_Salaries", "Customer_Service_Requests_2018", "Fast_Food_Outlet_Density_per_1000_Residents", "High_School_Completion_Rate", "Infant_Mortality_Rate"),
  title = c("Percentage of Population aged 16-19 in School or Employed in Baltimore City", "Baltimore City Employee Salaries", "Baltimore City 311 Customer Service Requests 2018", "Fast Food Outlet Density per 1,000 Residents in Baltimore City", "High School Completion Rate in Baltimore City", "Infant Mortality Rate in Baltimore City"),
  information = c("The percentage of persons aged 16 to 19 who are in school and/or are employed out of all persons in their age cohort broken down by community statistical area regions.", "This dataset includes Baltimore City employee salaries and gross pay from fiscal year 2011 through last fiscal year and includes employees who were employed on June 30 of the last fiscal year. For fiscal years 2020 and prior, data are extracted from the ADP payroll system. For fiscal year 2022, the data are combined from the ADP system and the Workday enterprise resource planning system which now includes payroll.", "This dataset represents the 311 call for service requests for the 2018 calendar year which includes service request types and status.", "The Johns Hopkins Center for a Livable Future (CLF) obtained the food permit list from the Baltimore City Health Department in August 2011, which includes all sites that sell food, such as stores, restaurants and temporary locations such as farmers' market stands and street carts.", "The percentage of 12th graders in a school year that successfully completed high school out of all 12th graders within an area. Completers are identified as completing their program of study at the high school level and satisfying the graduation requirements for a Maryland High School Diploma or the requirements for a Maryland Certificate of Program Completion.", "The number of infant deaths (babies under one year of age) per 1,000 live births within the area in a five year period. This is the most stable and commonly measured indicator of mortality in this age group."),
  source = c("https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percentage-of-population-aged-16-19-in-school-or-employed-community-statistical-area/about", "https://data.baltimorecity.gov/datasets/baltimore::baltimore-city-employee-salaries-2/about", "https://data.baltimorecity.gov/datasets/baltimore::311-customer-service-requests-2018/about", "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::fast-food-outlet-density-per-1000-residents-community-statistical-area/about", "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::high-school-completion-rate-community-statistical-area/about", "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::infant-mortality-rate/about")
)


# Create a dataframe
metadata2 <- data.frame(
  dataset = c("Kindergarten_Readiness", "Life_Expectancy", "Perc_Pop_School_Employed", "Percent_of_Children_with_Elevated_Blood_Lead_Levels", "Percent_of_Employed_Population_with_Travel_Time_to_Work_of_45_Minutes_and_Over", "Percent_of_Households_with_No_Vehicles_Available", "Percent_of_Population_that_Carpool_to_Work", "Percent_of_Population_that_Uses_Public_Transportation_to_Get_to_Work"),
  title = c("Kindergarten Readiness Assessment (KRA) results in Baltimore City", "Life Expectancy in Baltimore City", "Percentage of Population aged 16-19 in School or Employed in Baltimore City", "Percent of Children Tested (Aged 0-6) with Elevated Blood Lead Levels in Baltimore City", "Percent of Employed Population with Travel Time to Work Over 45 Minutes in Baltimore City", "Percent of Households with No Vehicle Available in Baltimore City", "Percent of Population that Carpool to Work in Baltimore City", "Percent of Population that Uses Public Transportation to Get to Work in Baltimore City"),
  information = c("The Kindergarten Readiness Assessment (KRA) measure children's readiness to do kindergarten work.", "The average number of years a newborn can expect to live, assuming he or she experiences the currently prevailing rates of death through their lifespan.", "The percentage of persons aged 16 to 19 who are in school and/or are employed out of all persons in their age cohort broken down by community statistical area regions.", "The number of children aged 0-6 that are found to either have elevated blood lead levels (10Mg/dL) or lead poisoning (20 Mg/dL) out of the number of children tested within an area in a calendar year.", "The percentage of commuters that spend more than 45 minutes travelling to work out of all commuters aged 16 and above.", "The percentage of households that do not have a personal vehicle available for use out of all households in an area.", "The percentage of commuters that carpool out of all commuters aged 16 and above.", "The percentage of commuters that use public transit out of all commuters aged 16 and above."),
  source = c("https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::kindergarten-readiness/about", "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::life-expectancy-community-statistical-area/about", "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percentage-of-population-aged-16-19-in-school-or-employed-community-statistical-area/about", "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percent-of-children-tested-aged-0-6-with-elevated-blood-lead-levels-community-statistical-area/about", "https://vital-signs-bniajfi.hub.arcgis.com/maps/bniajfi::percent-of-employed-population-with-travel-time-to-work-of-45-minutes-and-over-1/about", "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percent-of-households-with-no-vehicle-available-community-statistical-area/about", "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percent-of-population-that-carpool-to-work-community-statistical-area/about","https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percent-of-population-that-uses-public-transportation-to-get-to-work-community-statistical-area/about"))


# Create an empty dataframe
metadata3 <- data.frame(
  dataset = character(),
  title = character(),
  information = character(),
  source = character(),
  stringsAsFactors = FALSE
)

# Add rows to the dataframe
metadata3 <- rbind(metadata3,
                   c("Customer_Service_Requests_2018",
                     "Baltimore City 311 Customer Service Requests 2018",
                     "This dataset represents the 311 call for service requests for the 2018 calendar year which includes service request types and status.",
                     "https://data.baltimorecity.gov/datasets/baltimore::311-customer-service-requests-2018/about"),
                   c("Percent_of_Population_that_Walks_to_Work",
                     "Percent of Population that Walks to Work in Baltimore City",
                     "The percentage of commuters that walk to work out of all commuters aged 16 and above.",
                     "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percent-of-population-that-walks-to-work-community-statistical-area/about"),
                   c("Percentage_of_Students_Receiving_Free_or_Reduced_Meals",
                     "Percentage of Students Receiving Free or Reduced Meals in Baltimore City",
                     "The percentage of students of any grade that are eligible for and received free or reduced school meals out of all public school students. Eligibility for this program is based on the student's household income.",
                     "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percentage-of-students-receiving-free-or-reduced-meals/about"),
                   c("Percentage_of_Students_Suspended_or_Expelled_During_School_Year",
                     "Percentage of Students Suspended or Expelled During School Year in Baltimore City",
                     "The percentage of students of any grade level that were formally suspended or expelled for any reason during the school year out of all public school students within an area.",
                     "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::percentage-of-students-suspended-or-expelled-during-school-year/about"),
                   c("Racial_Diversity_Index",
                     "Baltimore City Racial Diversity Index",
                     "The percent chance that two people picked at random within an area will be of a different race/ethnicity. This number does not reflect which race/ethnicity is predominant within an area. The higher the value, the more racially and ethnically diverse an area.",
                     "https://data.baltimorecity.gov/datasets/bniajfi::racial-diversity-index-community-statistical-area/about"),
                   c("Surface_Water_Quality_Data_1995_through_September_2022",
                     "Surface Water Quality Data 1995 through Present",
                     "This dataset represents the monitoring for the water quality of the streams and Harbor in the City of Baltimore.",
                     "https://data.baltimorecity.gov/datasets/surface-water-quality-data-1995-through-present-1/about")
)

metadata3 <- rbind(metadata3,
                   c("Surface_Water_Quality_Data_1995_through_September_2022",
                     "Surface Water Quality Data 1995 through Present",
                     "This dataset represents the monitoring for the water quality of the streams and Harbor in the City of Baltimore. The Environmental Compliance and Laboratory Services Division of the Bureau of Water and Wastewater is responsible for monitoring the quality of our surface waters for any long-term trends and determine any capital investment programs or operational programs to implement. The results may be affected by a variety of factors: precipitation, land use changes, and human behavior.",
                     "https://data.baltimorecity.gov/datasets/surface-water-quality-data-1995-through-present-1/about"),
                   c("Teen_Birth_Rate_per_1000_Females",
                     "Teen Birth Rate per 1,000 Females (aged 15-19) in Baltimore City",
                     "The rate of female teens aged 15-19 that gave birth per 1,000 females aged 15-19.",
                     "https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::teen-birth-rate-per-1000-females-aged-15-19-community-statistical-area/about")
)

colnames(metadata3) <- c("dataset", "title", "information", "source")


metadata_full <- rbind(metadata,
                       metadata2,
                       metadata3)


### Package Creation Preliminary Playground

# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

hello <- function() {
  print("Hello, world!")
}
