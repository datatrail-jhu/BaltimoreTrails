#' Baltimore City 311 Customer Service Requests 2018
#'
#' This dataset represents the 311 call for service requests for the 2018 calendar year which includes service request types and status.
#'
#' @format ## `Customer_Service_Requests_2018`
#' A data frame with 793373 obs. of  23 variables:
#' \describe{
#'   \item{objectid}{Individual Row Database Identifier (Integer)}
#'   \item{srrecordid}{Service Request Observation Database Identifier (Character string)}
#'   \item{servicerequestnum}{Service Request Number (Character string)}
#'   \item{srtype}{Service Request Type (Character string)}
#'   \item{methodreceived}{How the request was received (Character string)}
#'   \item{createddate}{Service Request Creation Date (Character string)}
#'   \item{srstatus}{Service Request Status(Character string)}
#'   \item{statusdate}{Service Request Status Change Date (Character string)}
#'   \item{duedate}{Service Request Due Date(Character string)}
#'   \item{closedate}{Service Request Closing Date (Character string)}
#'   \item{agency}{Service Request Agency(Character string)}
#'   \item{lastactivity}{Last Activity Regarding Service Request (Character string)}
#'   \item{lastactivitydate}{Last Activity Update Date (Character string)}
#'   \item{address}{Service Request Client Address (Character string)}
#'   \item{zipcode}{Service Request Client Zipcode (Character string)}
#'   \item{neighborhood}{Service Request Client Neighborhood (Character string)}
#'   \item{councildistrict}{Baltimore Council District Number (Integer)}
#'   \item{policedistrict}{Baltimore Police District (Character string)}
#'   \item{policepost}{Baltimore Police District Post (Character string)}
#'   \item{latitude}{latitude (Numeric)}
#'   \item{longitude}{longitude (Numeric)}
#'   \item{geolocation}{Exact geolocation (Character string)}
#'
#' }
#' @source <https://data.baltimorecity.gov/datasets/baltimore::311-customer-service-requests-2018/about>
"Customer_Service_Requests_2018"
