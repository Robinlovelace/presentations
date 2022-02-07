# Aim: show od wpz data in action

library(tidyverse)
library(tmap)
tmap_mode("view")

od = read_csv("~/hd/data/raw/od/wu03buk_oa_wz_v4.csv", col_names = c("o", "d", "n"))
oas = sf::read_sf("~/hd/data/uk/centroids/2001-oas-point.shp")
wpz = readRDS("~/hd/data/uk/centroids/wpz_ew.Rds")
# wpz = sf::read_sf("~/hd/data/raw/geo/wpz.kml")
summary(wpz)
names(wpz)
oas_wgs = sf::st_transform(oas, 4326)
summary(od[[1]] %in% oas$LABEL)

# within 5km of specific area
buffer_distance = 5000
location_name = "westminster london"
location_point = tmaptools::geocode_OSM(location_name, as.sf = TRUE)
location_buffer = sf::st_buffer(location_point, dist = buffer_distance)

oas_in_buffer = oas_wgs[location_buffer, ]
wpz_in_buffer = wpz[location_buffer, ]
nrow(oas_in_buffer) # 2982
nrow(wpz_in_buffer) # 2730

qtm(location_buffer) + # study area
  qtm(oas_in_buffer)

od_to_buffer = od %>% 
  filter(d %in% wpz$wz11cd)
nrow(od_to_buffer) # 15,791,592
od_intra_buffer = od_to_buffer %>% 
  filter(o %in% oas_in_buffer$LABEL)
nrow(od_intra_buffer) # 313,598
od_intra_top = od_intra_buffer %>% 
  top_n(n = 1000, wt = n)
wpz_clean = wpz_in_buffer %>% 
  select(o = wz11cd)
od_intra_top_sf = od::od_to_sf(od_intra_top, z = oas_in_buffer, wpz_clean)
qtm(od_intra_top_sf)
sf::write_sf(od_intra_top_sf, "od_intra_top_sf.geojson")
piggyback::pb_upload("od_intra_top_sf.geojson", repo = "itsleeds/od")
piggyback::pb_download_url("od_intra_top_sf.geojson", repo = "itsleeds/od")
