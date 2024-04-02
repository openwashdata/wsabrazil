#' Wastewater management and household infrastructure in Brazil - Demographic Census 2010
#'
#' This dataset about wastewater management and household infrastructure
#' from various Brazilian regions provides insights into wastewater disposal habits,
#' water sources, bathroom facilities, and sanitation infrastructure.
#'
#' @format A tibble with 1965 rows and 19 variables
#' \describe{
#'   \item{sector_code       }{sector code}
#'   \item{MR_name           }{metropolitan region name}
#'   \item{municipality_code }{municipality code}
#'   \item{municipality_name }{municipality name}
#'   \item{sector_situation  }{location type: urban or rural}
#'   \item{sector_type       }{living conditions: 1 stands for poor housing conditions}
#'   \item{avg_income          }{average nominal monthly income of permanent private households}
#'   \item{total_households          }{number of permanent private households}
#'   \item{piped_water          }{number of permanent private households with water supply by piped network}
#'   \item{well_spring_water          }{number of permanent private households with water supply by property's well or spring}
#'   \item{stored_rainwater          }{number of permanent private households with water supply by stored rainwater}
#'   \item{other_water_source          }{number of permanent private households with water supply by other source}
#'   \item{private_bathroom          }{number of permanent private households with private bathroom or toilet}
#'   \item{bathroom_sewerage          }{number of permanent private households with private bathroom or toilet & sanitation via sewerage or drainage network}
#'   \item{bathroom_septic_tank          }{number of permanent private households with private bathroom or toilet & sanitation via septic tank}
#'   \item{bathroom_cesspit          }{number of permanent private households with private bathroom or toilet & sanitation via cesspit}
#'   \item{bathroom_ditch          }{number of permanent private households with private bathroom or toilet & wastewater discharged into ditch}
#'   \item{bathroom_waterbodies          }{number of permanent private households with private bathroom or toilet & wastewater discharged into water bodies (river, lake or sea)}
#'   \item{bathroom_other}{number of permanent private households with private bathroom or toilet & wastewater discharged into other outlet}
#' }
"wsabrazil"
