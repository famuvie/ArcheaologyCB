###########################
### CASA DE LAS AGUILAS ###
###########################

## Percent carbonates variable

## the third coordinate and the data value are the same thing
shp.quimicos@coords <- shp.quimicos@coords[, -3]
shp.quimicos@bbox <- shp.quimicos@bbox[-3, ]

## Extract observation data from SpatialPointsDataFrame
obs.pc <- cbind(coordinates(shp.quimicos),
                slot(shp.quimicos, 'data'))
names(obs.pc) <- c('x', 'y', 'pc')

## Remove duplicated measurements
obs.pc <- obs.pc[!duplicated(obs.pc[, c('x', 'y')]), ]


## Phosphates

## move a bit some points that fall on walls
idx <- c(200, 222, 227, 284)
shiftx <- c(0, -.1, 0, 0)
shifty <- c(.1, 0, .1, .1)
shp.fosfatos@coords[idx, ] <- 
  shp.fosfatos@coords[idx, ] + cbind(shiftx, shifty)
obs.po4 <- data.frame(
  cbind(
    coordinates(shp.fosfatos),
    slot(shp.fosfatos, 'data')$F3
  )
)

names(obs.po4) <- c('x', 'y', 'po4')


## Full dataset
obs <- rbind(rename(transform(obs.pc, var = 'pc'),
                    value = pc),
             rename(transform(obs.po4, var = 'po4'),
                    value = po4))

## Coordinates of the border 
border_coord <- with(fortify(shp.contorno),
                     data.frame(x = long,
                                y = lat))
# ggplot(border_coord, aes(x, y)) + geom_path() + coord_equal()


#############
### INDIA ###
#############

# obs.india = dataset + dataset.20150107 + India.enclosed
# extent.india

## Updated version of dataset (07/01/2015)
## with additional calculated variables
## check consistency and integrate into dataset
id.vars <- c('SAMPLE', 'Area', 'Side', 'X', 'Y')
stopifnot(identical(dataset[, id.vars], dataset.20150107[, id.vars]))
dataset <- cbind(dataset, select(dataset.20150107, -one_of(id.vars)))


## Updated version of enclosedspaces variable (11/01/2015)
stopifnot(identical(dataset[, id.vars], India.enclosed[, id.vars]))
dataset$enclosedspaces <- India.enclosed$enclosedspaces


dataset <- rename(dataset, sample = SAMPLE, x = X, y = Y)


## Fix an isolated coordinate
dataset$x[30] <- 10.2   


## Final data.frame of observations
obs.india <- gather(dataset, variable, value, -(sample:y))


# extent.india <- extent(c(extendrange(c(dataset.Ca.Cu$X,
#                                        extent(shp.walls)@xmin,
#                                        extent(shp.walls)@xmax)),
#                          extendrange(c(dataset.Ca.Cu$Y,
#                                        extent(shp.walls)@ymin,
#                                        extent(shp.walls)@ymax))))

# Manually indicated to match previous study
extent.india <- extent(c(6.5, 17.5, -14.5, -7.5))

## Cleanup
rm(dataset.20150107)
