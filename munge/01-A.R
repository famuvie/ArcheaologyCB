## Extract observation data from SpatialPointsDataFrame
obs <- cbind(coordinates(shp.quimicos),
             slot(shp.quimicos, 'data'))
names(obs) <- c('x', 'y', 'z', 'pc')

## the third coordinate and the data value are the same thing
obs <- obs[, -3]

## Remove duplicated measurements
obs <- obs[!duplicated(obs[, c('x', 'y')]), ]


## Coordinates of the border 
border_coord <- with(fortify(shp.contorno),
                     data.frame(x = long,
                                y = lat))
# ggplot(border_coord, aes(x, y)) + geom_path() + coord_equal()
