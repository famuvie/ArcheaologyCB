## the third coordinate and the data value are the same thing
shp.quimicos@coords <- shp.quimicos@coords[, -3]
shp.quimicos@bbox <- shp.quimicos@bbox[-3, ]

## Extract observation data from SpatialPointsDataFrame
obs <- cbind(coordinates(shp.quimicos),
             slot(shp.quimicos, 'data'))
names(obs) <- c('x', 'y', 'pc')

## Remove duplicated measurements
obs <- obs[!duplicated(obs[, c('x', 'y')]), ]


## Coordinates of the border 
border_coord <- with(fortify(shp.contorno),
                     data.frame(x = long,
                                y = lat))
# ggplot(border_coord, aes(x, y)) + geom_path() + coord_equal()
