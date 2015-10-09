###########################
### CASA DE LAS AGUILAS ###
###########################

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


#############
### INDIA ###
#############

dataset <- rename(dataset, sample = SAMPLE, x = X, y = Y)
obs.india <- gather(dataset, variable, value, Ca:Zn)

## Fix an isolated coordinate
dataset$x[30] <- 10.2   

# extent.india <- extent(c(extendrange(c(dataset.Ca.Cu$X,
#                                        extent(shp.walls)@xmin,
#                                        extent(shp.walls)@xmax)),
#                          extendrange(c(dataset.Ca.Cu$Y,
#                                        extent(shp.walls)@ymin,
#                                        extent(shp.walls)@ymax))))

# Manually indicated to match previous study
extent.india <- extent(c(6.5, 17.5, -14.5, -7.5))
