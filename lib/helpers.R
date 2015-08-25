#' Reverse method for data.frame
#' 
#' Reverse order of rows
#' 
#' @param x a data.frame
rev.data.frame <- function(x) {
  nr <- nrow(x)
  if (nr == 0) return(x)
  x[nr:1,]
}


## Methods for ploting variograms with ggplot
ggplot.variogram <- function(x, vgm, ...) {
  idx <- match(c('u', 'v', 'n'), names(x))
  xdf <- as.data.frame(x[idx])
  names(xdf) <- c('distance', 'semivariance', 'n')
  ggplot(xdf, aes(distance, semivariance)) +
    geom_point(aes(size = n)) + 
    expand_limits(y=0)
}


geom_variogram <- function(x, max.dist, scaled = FALSE, ...) {
  my.l <- list()
  if (missing(max.dist)) {
    my.l$max.dist <- x$max.dist
    if (is.null(my.l$max.dist)) 
      stop("argument max.dist needed for this object")
  }
  else my.l$max.dist <- max.dist
  if (any(x$cov.model == c("matern", "powered.exponential", 
                           "cauchy", "gencauchy", "gneiting.matern"))) 
    my.l$kappa <- x$kappa
  else kappa <- NULL
  if (is.vector(x$cov.pars)) 
    my.l$sill.total <- x$nugget + x$cov.pars[1]
  else my.l$sill.total <- x$nugget + sum(x$cov.pars[, 1])
  my.l$nugget <- x$nugget
  my.l$cov.pars <- x$cov.pars
  my.l$cov.model <- x$cov.model
  if (scaled) {
    if (is.vector(x$cov.model)) 
      my.l$cov.pars[1] <- my.l$cov.pars[1]/my.l$sill.total
    else my.l$cov.pars[, 1] <- my.l$cov.cov.pars[, 1]/my.l$sill.total
    my.l$sill.total <- 1
  }
  gamma.f <- function(x, my.l) {
    if (any(my.l$cov.model == c("linear", "power"))) 
      return(my.l$nugget + my.l$cov.pars[1] * (x^my.l$cov.pars[2]))
    else return(my.l$sill.total - cov.spatial(x, cov.model = my.l$cov.model, 
                                              kappa = my.l$kappa, cov.pars = my.l$cov.pars))
  }
  dat <- transform(data.frame(x = seq(0, my.l$max.dist, length = 101)),
                   y = gamma.f(x, my.l = my.l), ...)
  geom_line(aes(x, y), data = dat)
}
