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
zones = pct::get_pct_zones(region_name, geography = "msoa")
centroids_all = pct::get_centroids_ew()
centroids_lonlat = centroids_all %>% 
  sf::st_transform(4326)
centroids = centroids_lonlat %>% 
  filter(msoa11cd %in% zones$geo_code)

plot(centroids_lonlat$geometry)
plot(zones, add = TRUE)
plot(zones)
plot(centroids)

# Get od data in region
od_all = pct::get_od()
od = od_all %>% 
  filter(geo_code1 %in% centroids$msoa11cd) %>% 
  filter(geo_code1 %in% centroids$msoa11cd)
sum(od_all$all)
sum(od$all)
sum(od$all) / sum(od_all$all) # ~1% UK's working population

desire_lines = od::od_to_sf(x = od, z = centroids)
plot(desire_lines)

desire_lines_mutated = desire_lines %>% 
  mutate(
    proportion_drive = car_driver / all,
    length_m = as.numeric(sf::st_length(desire_lines))
    )

desire_lines_car_dependent = desire_lines_mutated %>% 
  filter(length_m < 3000) %>% 
  filter(proportion_drive > 0.5)

plot(desire_lines_car_dependent)
sum(desire_lines_car_dependent$car_driver)
sum(desire_lines_car_dependent$car_driver) / sum(desire_lines$all)


# Questions ---------------------------------------------------------------

# What is the spatial distribution of the most are the most car dependent desire lines in Oxford

