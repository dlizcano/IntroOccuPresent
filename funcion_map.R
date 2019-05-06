
###############################
## The function starts here ###
###############################

# Function definition with set of default values
data.fn <- function(M = 60, J = 30, mean.occupancy = 0.6, 
                    beta1 = -2, beta2 = 2, beta3 = 1, mean.detection = 0.3, 
                    alpha1 = -1, alpha2 = -3, alpha3 = 0, show.plot = TRUE){
  # Function to simulate occupancy measurements replicated at M sites during J occasions.
  # Population closure is assumed for each site.
  # Expected occurrence may be affected by elevation (elev), 
  # forest cover (forest) and their interaction.
  # Expected detection probability may be affected by elevation, 
  # temperature (temp) and their interaction.
  # Function arguments:
  #     M: Number of spatial replicates (sites)
  #     J: Number of temporal replicates (occasions)
  #     mean.occupancy: Mean occurrence at value 0 of occurrence covariates
  #     beta1: Main effect of elevation on occurrence
  #     beta2: Main effect of forest cover on occurrence
  #     beta3: Interaction effect on occurrence of elevation and forest cover
  #     mean.detection: Mean detection prob. at value 0 of detection covariates
  #     alpha1: Main effect of elevation on detection probability
  #     alpha2: Main effect of temperature on detection probability
  #     alpha3: Interaction effect on detection of elevation and temperature
  #     show.plot: if TRUE, plots of the data will be displayed; 
  #               set to FALSE if you are running simulations.
  
  # Create covariates
  elev <- runif(n = M, -1, 1)                         # Scaled elevation
  forest <- runif(n = M, -1, 1)                       # Scaled forest cover
  temp <- array(runif(n = M*J, -1, 1), dim = c(M, J)) # Scaled temperature
  
  # Model for occurrence
  beta0 <- qlogis(mean.occupancy)               # Mean occurrence on link scale
  psi <- plogis(beta0 + beta1*elev + beta2*forest + beta3*elev*forest)
  z <- rbinom(n = M, size = 1, prob = psi)      # Realised occurrence
  
  # Plots
  if(show.plot){
    par(mfrow = c(2, 2), cex.main = 1)
    devAskNewPage(ask = TRUE)
    curve(plogis(beta0 + beta1*x), -1, 1, col = "red", frame.plot = FALSE, 
          ylim = c(0, 1), xlab = "Elevation", ylab = "psi", lwd = 2)
    plot(elev, psi, frame.plot = FALSE, ylim = c(0, 1), xlab = "Elevation", 
         ylab = "")
    curve(plogis(beta0 + beta2*x), -1, 1, col = "red", frame.plot = FALSE, 
          ylim = c(0, 1), xlab = "Forest cover", ylab = "psi", lwd = 2)
    plot(forest, psi, frame.plot = FALSE, ylim = c(0, 1), xlab = "Forest cover", 
         ylab = "")
  }
  
  # Model for observations
  y <- p <- matrix(NA, nrow = M, ncol = J)# Prepare matrix for y and p
  alpha0 <- qlogis(mean.detection)        # mean detection on link scale
  for (j in 1:J){                         # Generate counts by survey
    p[,j] <- plogis(alpha0 + alpha1*elev + alpha2*temp[,j] + alpha3*elev*temp[,j])
    y[,j] <- rbinom(n = M, size = 1, prob = z * p[,j])
  }
  
  # True and observed measures of 'distribution'
  sumZ <- sum(z)                     # Total occurrence (all sites)
  sumZ.obs <- sum(apply(y,1,max))    # Observed number of occ sites
  psi.fs.true <- sum(z) / M          # True proportion of occ. sites in sample
  psi.fs.obs <- mean(apply(y,1,max)) # Observed proportion of occ. sites in sample
  
  # More plots
  if(show.plot){
    par(mfrow = c(2, 2))
    curve(plogis(alpha0 + alpha1*x), -1, 1, col = "red", 
          main = "Relationship p-elevation \nat average temperature", 
          xlab = "Scaled elevation", frame.plot = F)
    matplot(elev, p, xlab = "Scaled elevation", 
            main = "Relationship p-elevation\n at observed temperature", 
            pch = "*", frame.plot = F)
    curve(plogis(alpha0 + alpha2*x), -1, 1, col = "red", 
          main = "Relationship p-temperature \n at average elevation", 
          xlab = "Scaled temperature", frame.plot = F)
    matplot(temp, p, xlab = "Scaled temperature", 
            main = "Relationship p-temperature \nat observed elevation", 
            pch = "*", frame.plot = F)
  }
  
  # Output
  return(list(M = M, J = J, mean.occupancy = mean.occupancy, 
              beta0 = beta0, beta1 = beta1, beta2 = beta2, beta3 = beta3, 
              mean.detection = mean.detection, 
              alpha0 = alpha0, alpha1 = alpha1, alpha2 = alpha2, alpha3 = alpha3, 
              elev = elev, forest = forest, temp = temp, 
              psi = psi, z = z, p = p, y = y, sumZ = sumZ, sumZ.obs = sumZ.obs, 
              psi.fs.true = psi.fs.true, psi.fs.obs = psi.fs.obs))
}

###############################
## The function ends  here  ###
###############################




# lets make random maps for the three covariates
library(raster)
library(spatstat)
set.seed(24) # Remove for random simulations

# CONSTRUCT ANALYSIS WINDOW USING THE FOLLOWING:
xrange=c(-2.5, 1002.5)
yrange=c(-2.5, 502.5)
window<-owin(xrange, yrange)

# Build maps from random points and interpole in same line
elev_map   <- density(rpoispp(lambda=0.6, win=window)) # 
forest_map <- density(rpoispp(lambda=0.2, win=window)) # 
temp_map   <- density(rpoispp(lambda=0.5, win=window)) # 

# Convert covs to raster and Put in the same stack 
mapdata.m<-stack(raster(elev_map),raster(forest_map), raster(temp_map)) 
names(mapdata.m)<- c("elev", "forest", "temp") # put names to raster

# lets plot the covs maps
plot(mapdata.m)