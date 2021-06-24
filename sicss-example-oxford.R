# Aim get and analyse geographic transport data in Oxford

pkgs = c(
  "tidyverse",
  "sf",
  "pct",
  "stplanr",
  "od",
  "cyclestreets"
)

install.packages("remotes")

remotes::install_cran(pkgs)
library(tidyverse)
library(sf)

# Get zone/centroid data for study region Oxford

region_name = "oxfordshire"

region_geocoded = tmaptools::geocode_OSM(q = region_name, as.sf = TRUE)
region_geocoded
plot(region_geocoded$bbox)
mapview::mapview(region_geocoded$bbox)

zones = pct::get_pct_zones(region_name, geography = "msoa")
centroids_all = pct::get_centroids_ew()
class(zones)
plot(zones$geometry)

centroids_lonlat = centroids_all %>% 
  sf::st_transform(4326)

sf::st_crs(centroids_all)
sf::st_crs(centroids_lonlat)

centroids = centroids_lonlat %>% 
  filter(msoa11cd %in% zones$geo_code)

plot(centroids_lonlat$geometry)
plot(zones, add = TRUE)
plot(zones)
plot(centroids)
plot(zones$geometry)
plot(centroids$geometry, add = TRUE)

# Get od data in region
od_all = pct::get_od()

od = od_all %>% 
  filter(geo_code1 %in% centroids$msoa11cd) %>% 
  filter(geo_code1 %in% centroids$msoa11cd)
sum(od_all$all)
sum(od$all)
sum(od$all) / sum(od_all$all) # ~1% UK's working population

class(od)
od

head(od$geo_code1)
head(centroids$msoa11cd)

desire_lines = od::od_to_sf(x = od, z = centroids)
plot(desire_lines)
nrow(desire_lines)

desire_lines_mutated = desire_lines %>% 
  mutate(
    proportion_drive = car_driver / all,
    length_m = as.numeric(sf::st_length(desire_lines))
  )

summary(desire_lines_mutated$all)

desire_lines_car_dependent = desire_lines_mutated %>% 
  filter(length_m < 5000) %>% 
  filter(length_m > 1000) %>% 
  filter(proportion_drive > 0.5) %>% 
  filter(all >= 10)

plot(desire_lines_car_dependent)
plot(desire_lines_car_dependent["car_driver"])
sum(desire_lines_car_dependent$car_driver)
sum(desire_lines_car_dependent$car_driver) / sum(desire_lines$all)

library(tmap)
tm_shape(desire_lines_car_dependent) +
  tm_lines(col = "proportion_drive", palette = "viridis")

tmap_mode("view")

tm_shape(desire_lines_car_dependent) +
  tm_lines(col = "proportion_drive", palette = "viridis")

nrow(desire_lines_car_dependent)

routes = stplanr::route(l = desire_lines_car_dependent, route_fun = cyclestreets::journey)
summary(routes$busynance)


# Questions ---------------------------------------------------------------

# What is the spatial distribution of the most are the most car dependent desire lines in Oxford

