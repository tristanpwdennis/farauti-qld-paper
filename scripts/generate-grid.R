library(fs)
library(sf)
library(dggridR)

# This needs to be run in RStudio - change to manual path spec if run as Rscript
setwd("/scratch/user/uqtdenni/github/farauti-qld-paper/scripts")
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Define bounding box manually: xmin, ymin, xmax, ymax (lon/lat WGS84)
xmin <- 127
ymin <- -23
xmax <- 151
ymax <- -6

bbox_sf <- st_sf(
  geometry = st_as_sfc(st_bbox(c(xmin = xmin, ymin = ymin,
                                  xmax = xmax, ymax = ymax),
                                crs = 4326))
)
st_write(bbox_sf, "bbox.shp", append = FALSE)

grid_resolution <- 6

dggs <- dgconstruct(
  res        = grid_resolution,
  precision  = 30,
  projection = "ISEA",
  aperture   = 4,
  topology   = "TRIANGLE"
)

out_file_name <- paste0(
  "dgg_triangle_res_", sprintf("%02d", grid_resolution), ".shp"
)

dgshptogrid(
  dggs, "bbox.shp",
  cellsize = 0.1, savegrid = out_file_name
)

message("Grid written to: ", out_file_name)
