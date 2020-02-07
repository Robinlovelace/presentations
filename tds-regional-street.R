## ---- eval=FALSE-----------------------------------------------------
## # to reproduce these slides do:
## pkgs = c("rgdal", "sf", "geojsonsf")
## install.packages(pkgs)


## ----setup, include=FALSE--------------------------------------------
options(htmltools.dir.version = FALSE)


## --------------------------------------------------------------------
system("whoami")


## ---- eval=FALSE-----------------------------------------------------
## devtools::install_github("r-rust/gifski")
## system("youtube-dl https://youtu.be/CzxeJlgePV4 -o v.mp4")
## system("ffmpeg -i v.mp4 -t 00:00:03 -c copy out.mp4")
## system("ffmpeg -i out.mp4 frame%04d.png ")
## f = list.files(pattern = "frame")
## gifski::gifski(f, gif_file = "g.gif", width = 200, height = 200)


## ---- out.width="100%"-----------------------------------------------
knitr::include_graphics("https://user-images.githubusercontent.com/1825120/39661313-534efd66-5047-11e8-8d99-a5597fe160ff.gif")


## ---- echo=FALSE-----------------------------------------------------
knitr::include_graphics("https://raw.githubusercontent.com/npct/pct-team/master/figures/Leeds-network.png")


## ---- echo=FALSE-----------------------------------------------------
knitr::include_graphics("https://user-images.githubusercontent.com/1825120/73912683-0f369980-48ad-11ea-9139-e24919a45368.png")


## ---- echo=FALSE, out.width="70%"------------------------------------
knitr::include_graphics("https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/DIKW_Pyramid.svg/220px-DIKW_Pyramid.svg.png")


## ---- eval=FALSE, echo=FALSE-----------------------------------------
## # remotes::install_github("itsleeds/geofabrik")
## library(geofabrik)
## library(osmdata)
## library(sf)
## system.time({ # around 2 seconds
##   louvain = opq("louvain-la-neuve") %>%
##     add_osm_feature("highway", value = "primary|secondary|cycleway", value_exact = F) %>%
##     osmdata_sf()
##   })
## louvain_highway = louvain$osm_lines
## plot(louvain_highway)
## saveRDS(louvain_highway, "louvain_highway.Rds")
## piggyback::pb_upload("louvain_highway.Rds")


## ---- eval=FALSE, echo=FALSE-----------------------------------------
## louvain_highway = readRDS("louvain_highway.Rds")


## ---- echo=FALSE-----------------------------------------------------
knitr::include_graphics("https://i.imgur.com/09yWU7V.png")


## ---- eval=FALSE, echo=FALSE-----------------------------------------
## # remotes::install_github("itsleeds/geofabrik")
## library(geofabrik)
## lvn_centroid = tmaptools::geocode_OSM("louvain-la-neuve", as.sf = T)
## system.time({
##   # belgium = get_geofabrik(lvn_centroid) # warning: downloads giant file
##   belgium = get_geofabrik("Beligium") # equivalent code
##   })
## object.size(belgium)
## saveRDS(belgium, "belgium_lines.Rds")
## file.size("belgium_lines.Rds")
## louvain_highway
## plot(louvain_highway)


## --------------------------------------------------------------------
belgium_filename = geofabrik::gf_filename("Belgium")
belgium_filename
utils:::format.object_size(file.size(belgium_filename), units = "MB")
# Around 1 GB in RAM...


## ---- eval=FALSE-----------------------------------------------------
## library(geofabrik)
## system.time({
##     belgium_cycleway = get_geofabrik("Belgium", key = "highway", value = "cycleway")
## })
## #>    user  system elapsed
## #>  23.658   1.933  23.130
## format(object.size(belgium_cycleway), units = "MB")
## #> [1] "36.9 Mb"


## ---- eval=FALSE, echo=FALSE-----------------------------------------
## # save belgium_cycleway object
## saveRDS(belgium_cycleway, "belgium_cycleway.Rds")
## file.size("belgium_cycleway.Rds") # 4 MB
## piggyback::pb_upload("belgium_cycleway.Rds")


## --------------------------------------------------------------------
# piggyback::pb_download_url("belgium_cycleway.Rds")
u = "https://github.com/Robinlovelace/presentations/releases/download/2020-02/belgium_cycleway.Rds"
f = "belgium_cycleway.Rds"
if(!file.exists(f)) {
  download.file(url = u, destfile = f)
}
system.time({
  belgium_cycleway = readRDS("belgium_cycleway.Rds")
})
format(object.size(belgium_cycleway), units = "MB")


## ---- eval=FALSE-----------------------------------------------------
## lvn_box = stplanr::geo_bb(louvain_highway)
## mapview::mapview(lvn_box)
## system.time({
##   lvn_lines = belgium[lvn_box, ]
## })
## #>   user  system elapsed
## #>  8.767   0.142   8.911


## ---- eval=FALSE, echo=FALSE-----------------------------------------
## saveRDS(lvn_lines, "lvn_lines.Rds")
## piggyback::pb_upload("lvn_lines.Rds")


## --------------------------------------------------------------------
piggyback::pb_download_url("lvn_lines.Rds")
u = "https://github.com/Robinlovelace/presentations/releases/download/2020-02/lvn_lines.Rds"
f = "lvn_lines.Rds"
if(!file.exists(f)) download.file(url = u, destfile = f)
system.time({
  lvn_lines = readRDS("lvn_lines.Rds")
})
format(object.size(lvn_lines), units = "MB")


## --------------------------------------------------------------------
library(sf)
plot(lvn_lines["highway"])


## --------------------------------------------------------------------
summary(as.factor(lvn_lines$highway))


## ---- message=FALSE--------------------------------------------------
# the tidyverse way:
library(dplyr)
lvn_lines = lvn_lines %>% mutate(highway2 = case_when(
  stringr::str_detect(highway, "const|corri|eleva|_link|plat|unc") ~ as.character(NA),
  TRUE ~ lvn_lines$highway
  ))


## --------------------------------------------------------------------
# (a) base R way
lvn_lines_highway_table = table(lvn_lines$highway)
lvn_lines_highway_table
lvn_lines_to_remove = names(lvn_lines_highway_table)[lvn_lines_highway_table < 89]
lvn_lines_to_remove
lvn_lines$highway3 = lvn_lines$highway
lvn_lines$highway3[lvn_lines$highway3 %in% lvn_lines_to_remove] = NA


## --------------------------------------------------------------------
plot(lvn_lines %>% select(contains("high")))


## --------------------------------------------------------------------
library(tmap)
tm_shape(lvn_lines) + tm_lines("highway3")


## --------------------------------------------------------------------
tmap_mode("view")
tm_shape(lvn_lines) + tm_lines("highway3")


## ---- eval=FALSE-----------------------------------------------------
## remotes::install_github("luukvdmeer/sfnetworks")


## --------------------------------------------------------------------
library(sfnetworks)


## ---- eval=FALSE-----------------------------------------------------
## plot(sf::st_geometry(belgium_cycleway))


## ---- echo=FALSE, out.width="90%"------------------------------------
knitr::include_graphics("https://raw.githubusercontent.com/npct/pct-team/master/figures/front-page-leeds-pct-demo.png")

