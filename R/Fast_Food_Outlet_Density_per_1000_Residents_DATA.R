#' Fast Food Outlet Density per 1,000 Residents in Baltimore City
#'
#' The Johns Hopkins Center for a Livable Future (CLF) obtained the food permit list from the Baltimore City Health Department in August 2011, which includes all sites that sell food, such as stores, restaurants and temporary locations such as farmers' market stands and street carts.
#' The restaurants were grouped into three categories, including full service restaurants, fast food chains and carryouts. Carryout and fast food chain restaurants were extracted from the restaurant layer and spatially joined with the 2010 Community Statistical Area (CSA) data layer, provided by BNIA-JFI.
#' The prepared foods density, per 1,000 people, was calculated for each CSA using the CSA's population and the total number of carryout and fast food restaurants, including vendors selling prepared foods in public markets, in each CSA.
#'
#' @format ## `Fast_Food_Outlet_Density_per_1000_Residents`
#' A data frame with BLA rows and BLA columns:
#' \describe{
#'   \item{BLA}{BLA}
#'   \item{BLA, BLA}{BLABLABLA}
#'   \item{BLA}{BLA}
#'   ...
#' }
#' @source <https://vital-signs-bniajfi.hub.arcgis.com/datasets/bniajfi::fast-food-outlet-density-per-1000-residents-community-statistical-area/about>
"Fast_Food_Outlet_Density_per_1000_Residents"