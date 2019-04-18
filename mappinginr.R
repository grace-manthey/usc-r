install.packages("leaflet")
install.packages("rgdal")
install.packages("sp")

library(leaflet)
library(rgdal)

states <- readOGR("~/Documents/USC/Term-3-Spring/Data/week14/tl_2018_us_state",layer="tl_2018_us_state", GDAL1_integer64_policy = TRUE)

bestCoast <- subset(states, states$STUSPS %in% c("CA","OR","WA"))

leaflet(bestCoast) %>% 
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5, opacity = 1.0, fillOpacity = 0.5, fillColor = ~colorQuantile("YlOrRd",ALAND)(ALAND), highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE, popupOptions(text = rate))) %>% 
  addTiles() %>% 
  addProviderTiles(providers$CartoDB.Positron)

install.packages("tidycensus")
library(tidycensus)



remove.packages("dplyr")
install.packages("dplyr", dependencies = TRUE)
packageVersion("dplyr")
install.packages("tidycensus")
library(tidycensus)

census_api_key("82cb051d5f060791be7f50c3cdf914ea52b90940", overwrite = FALSE, install = FALSE)

m90 <- get_decennial(geography = "state", variables = "H043A001", year = 1990)
View(m90)

library(tidyverse)
m90 %>% 
  ggplot(aes(x = value, y = reorder(NAME, value))) +
  geom_point()

v17 <- load_variables(2017, "acs5", cache = TRUE)
View(v17)

transpo <- get_acs(geography = "state", variables = "B08006_008", geometry = FALSE, survey = "acs5", year = 2017)

View(transpo)

transpo_total <- get_acs(geography = "state", variables = "B08006_001", geometry = FALSE, survey="acs5", year = 2017)

View(transpo_total)

transpo <- transpo %>% left_join(transpo_total, by = "NAME")
View(transpo)

transpo$rate <- (transpo$estimate.x/transpo$estimate.y)*100
View(transpo)

states_with_rate <- sp::merge(states, transpo, by = "NAME")

qpal <- colorQuantile("YlOrRd", states_with_rate$rate, 9)

states_with_rate %>%  leaflet() %>% addTiles %>% 
  addPolygons(weight = 1, smoothFactor = 0.5, opacity = 1.0, fillOpacity = 0.5, color = ~qpal(rate), highlightOptions = highlightOptions(color = "purple", weight = 2, bringToFront = TRUE))
