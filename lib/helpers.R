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


krige.loocv <- function(
  method = c('std', 'cst'),
  geodata,
  ddm) {
  
  method <- match.arg(method)
  
  ## Fit an exponential variogram model
  ## and return a kriging prediction on the given loc
  fit.single <- function(geodata, loc, ddm, method) {

    ## fit variogram
    likfit_args <- list(geodata = geodata,
                        data = geodata$data,
                        fix.nugget = FALSE,
                        fix.kappa = FALSE,
                        ini = c(10, 5),  # sigma^2 (partial sill) and phi (range parameter)
                        cov.model = "exponential",
                        lik.method = "REML")
    
    if (method == 'cst') {
      likfit_args$dists.mat <-  ddm$obs
    }
    
    vgmdl <- do.call('likfit', likfit_args)
    
    ## kriging
    KC = krige.control(obj.model = vgmdl)
    kriging_args <- list(geodata,
                         data = geodata$data,
                         locations = loc,
                         krige = KC)
    
    if (method == 'cst') {
      kriging_args$dd.dists.mat = ddm$obs
      kriging_args$dl.dists.mat = ddm$loc
    }
    
    kriging <- do.call('krige.conv', kriging_args)
    
    ## Return prediction in observation locations
    kriging$predict
  }
  
  ## Leave observation i out, fit without
  ## and return predicted value
  pred.loo <- function(i, geodata, ddm, method) {
    
    ## Prediction location
    loc_i <- geodata$coords[i, , drop = FALSE]
    
    ## Remove observation from data
    dat <- geodata
    dat$coords <- dat$coords[-i, ]
    dat$data   <- dat$data[-i]
    
    ## Modify the distance matrices
    d_obs <- ddm$obs[-i, -i]
    d_loc <- ddm$obs[i, -i, drop = FALSE]
    
    ## Predict silently
    sink('/dev/null')
    ans <- suppressMessages(
      fit.single(dat, loc_i, list(obs = d_obs, loc = d_loc), method)
    )
    sink()
    
    return(unname(ans))
  }
  
  # debug:
  #   geodata <- obs.gd
  #   geodata$data <- obs.gd$data[, 'Ca']
  #   res <- fit.single(geodata, loc, ddm, 'std')
  #   qplot(kriging.std.Ca$predict, res) + geom_abline(int=0, sl=1)
  #   res <- fit.single(geodata, loc, ddm, 'cst')
  #   qplot(kriging.cst.Ca$predict, res) + geom_abline(int=0, sl=1)
  
  N <- length(geodata$data)

  res <- sapply(seq_len(N), pred.loo, geodata, ddm, method)
  
  return(res)
}

