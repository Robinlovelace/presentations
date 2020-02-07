# Aim: get highways data from osm

# install.packages("osmdata")
# install.packages("mapview")
# install.packages("tmap")
library(osmdata)
library(sf)

city = "louvain-la-neuve"
# To create the 'pipe' operator press Ctl-Shift-M
osm_data_city = opq(bbox = city) %>% 
  add_osm_feature(opq = ., key = "highway", "cycleway") %>% 
  osmdata_sf()
osm_data_city
osm_lines = osm_data_city$osm_lines

osm_lines
plot(osm_lines)
mapview::mapview(osm_lines)

osm_data_city2 = opq(bbox = city) %>% 
  add_osm_feature(
    opq = .,
    key = "highway",
    value = "cycleway|construction",
    value_exact = FALSE
  ) %>% 
  osmdata_sf()

osm_lines2 = osm_data_city2$osm_lines
constr = osm_lines2[
  osm_lines2$highway == "construction",
  ]
mapview::mapview(constr)

osm_data_city3 = opq(bbox = city) %>% 
  add_osm_feature(
    opq = .,
    key = "highway",
  ) %>% 
  osmdata_sf()

osm_lines3 = osm_data_city3$osm_lines
mapview::mapview(osm_lines3)
