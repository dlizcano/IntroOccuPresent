##################################################
####                                          ####  
####  Single-season occupancy models          ####
####          with covariates                 #### 
####                                          #### 
##################################################

library("unmarked")

# setwd("~/Desktop/Occupancy_Brasilia/Day 2")

# Single-season occupancy with covariates

n <- 25
J <- 5
vegHt <- rnorm(n)
wind <- matrix(rnorm(n*J), nrow=n, ncol=J)
y <- p <- matrix(NA, nrow=n, ncol=J, 
                 dimnames=list(paste("site", 1:n, sep=""), paste("survey", 1:J, sep="")))

# Ecological process
(psi <- plogis(-1 + 2*vegHt))	# Linear model for psi (intercept=-1, slope=2)
Z <- rbinom(n, size=1, prob=psi)
cbind(Z)

# Detection process

for(i in 1:n) {
  p[i,] <- plogis(1 + -2*wind[i,] + 2*vegHt[i]) # Linear model for p
}

round(p, 2)

for(i in 1:n) {
  y[i,] <- rbinom(J, size = 1, prob = Z[i]*p[i,])
}

y	

# Look at Z and y together
cbind(Z, y)



###########################################################
# Single-season occupancy with covariates            ######
###########################################################

aukDat <- read.csv("occDat.csv")

names(aukDat)

## Take a look at variable distributions


hist(aukDat$vegHeight, xlab="Veg. height", main="Histogram")

hist(aukDat$patchArea, xlab="Patch area", main="Histogram")



## Format for Occupancy analysis in "unmarked"
##important: site covariates are a data frame and observatin covariates are a list

aukUMF <- with(aukDat, {
  unmarkedFrameOccu(y = cbind(auks.1, auks.2, auks.3, auks.4, auks.5),
                    siteCovs = data.frame(vegHeight,patchArea,habitat),
                    obsCovs = list(wind = cbind(wind.1, wind.2, wind.3, wind.4, wind.5)))
})


## Summarize data

summary(aukUMF)
str(aukUMF)
aukUMF[1:5,]


## Fit models and look at results


# Null model (ie, no covariates)
(null <- occu(~1 ~1, aukUMF))

# Global model (ie, all covariates)
full <- occu(~vegHeight + wind ~patchArea + vegHeight + I(vegHeight^2) + 
               habitat, aukUMF)

# Some covariates
W.VsqH <- occu(~wind ~vegHeight + I(vegHeight^2) + habitat, aukUMF)


## Backtransform psi and p to orignial scale
# NOTE: this function only works on the null model

backTransform(null, "state")
backTransform(null, "det")


## Model selection

modList <- fitList(Null = null, Full = full, W.VsqH = W.VsqH)

modSel(modList, nullmod = 'Null')	


## Assess goodness-of-fit
## Simulate datasets from a fitted model, refit the model, 
## and generate a sampling distribution of a fit statistic
##Default is the sum of squared residuals

gof <- parboot(full, nsim=100) # nsim=100

gof
plot(gof) ##compare the observed statistic with the distribution


## Expected values and std. errors for all the sites

round(predict(full, type="state"), 2)  # Expected psi at each site
round(predict(modList, type="state"), 2) # Model-averaged prediction


# Hold everything constant except for habitat type

newDatHab <- data.frame(vegHeight = mean(aukDat$vegHeight), 
                        patchArea = 1, 
                        habitat = factor(c("Forest", "Grassland")))

EfullHab <- as.data.frame(predict(full, newdata=newDatHab, type="state"))
##get predicted values for forest and grasslands, at mean vegheight and constant patch area

## Plot parameter estimates

# Plot difference in psi between habitat types
bp <- barplot(EfullHab$Predicted, ylim=c(0, 0.6), names.arg=newDatHab$habitat, 
              ylab="Occupancy", cex.lab=1.5, xlim=c(-0.5, 3), space=c(0.5, 0.1),
              axis.lty=1)
box()
arrows(bp, EfullHab$Predicted, bp, EfullHab$Predicted+EfullHab$SE, code=2, angle=90, length=0.05)


# Hold everything constant except veg. height

newDatVeg <- data.frame(vegHeight = seq(min(aukDat$vegHeight),max(aukDat$vegHeight), length=100),wind = 0)

EpfullVeg <- as.data.frame(predict(full, newdata=newDatVeg, type="det"))


# Plot p in relation to veg. height

with(EpfullVeg, {
  veght <- newDatVeg$vegHeight
  plot(veght, Predicted, xlab="Vegetation height", 
       ylab="Detection probability", cex.lab=1.5, pch=16, ylim=0:1, type="l", 
       lwd=2)
  lines(veght, Predicted-SE, lty=3)
  lines(veght, Predicted+SE, lty=3)
})


### Download data from website and check it out

squirrelFishData <- read.csv("squirrelfishDat.csv", header = TRUE)

str(squirrelFishData)
head(squirrelFishData, n=10)


### Format data for occupancy analysis in unmarked

sqFishUMF <- with(squirrelFishData, {
  unmarkedFrameOccu(
    y = cbind(squirrelFish.1, squirrelFish.2, squirrelFish.3, squirrelFish.4,
              squirrelFish.5),
    siteCovs = data.frame(waterClarity, coralDensity, waterDepth),
    obsCovs = list(current = cbind(current.1, current.2, current.3, 
                                   current.4, current.5)))
})

summary(sqFishUMF)
plot(sqFishUMF)


### Fit several models

(Null <- occu(~1 ~1, data=sqFishUMF))
(Global <- occu(~current + waterClarity ~ coralDensity + waterDepth + 
                  waterClarity + I(waterClarity^2), data=sqFishUMF))
(CurrentClarity.CoralClaritySQ <- occu(~current + waterClarity 
                                       ~ coralDensity + waterClarity + I(waterClarity^2), data=sqFishUMF))
(Clarity.Clarity <- occu(~waterClarity ~ waterClarity, data=sqFishUMF))
(Clarity.Depth <- occu(~waterClarity ~ waterDepth, data=sqFishUMF))
(CurrentClarity.Coral <- occu(~current + waterClarity ~ coralDensity, 
                              data=sqFishUMF))

### Model selection

mods <- fitList(Null=Null, Global=Global, 
                CurrClar.CoralClarSQ = CurrentClarity.CoralClaritySQ, 
                Clar.Clar=Clarity.Clarity, Clar.Depth=Clarity.Depth, 
                CurrClar.Coral=CurrentClarity.Coral)

(modSel.sqFish <- modSel(mods, nullmod = 'Null'))



### Interpreting model results

CurrentClarity.CoralClaritySQ


# Use the linear equation:
# logit(psi) = b0 + b1*coralDensity + b2*waterClarity + b3*waterClarity^2

attach(squirrelFishData)	# This makes columns available as variables

psi.site1 <- -2.6 + 3.2*coralDensity[1] + 4.1*waterClarity[1] + 
  -0.99*waterClarity[1]^2

psi.site1			# Logit scale
plogis(psi.site1)	# Original scale ...
# ... this is expected psi level for these covariate values

detach(squirrelFishData)	# Clean up

## Do the same for all sites and get SE

Epsi <- predict(CurrentClarity.CoralClaritySQ, type="state")

round(Epsi, 2)


## Use the model to visualize relationships

# First, psi vs waterClarity
# Need to created new data.frame with coralDensity constant

newDat <- data.frame(coralDensity = mean(squirrelFishData$coralDensity), 
                     waterClarity = seq(min(squirrelFishData$waterClarity), 
                                        max(squirrelFishData$waterClarity), length=100))
head(newDat)

# Get predicted psi values and SE for each new 'site'

psiClarity <- predict(CurrentClarity.CoralClaritySQ, type="state", 
                      newdata=newDat)

# Plot relationship

plot(newDat$waterClarity, psiClarity[,"Predicted"], type="l", ylim = 0:1, 
     xlab="Water clarity", ylab=expression(paste("Probability of occurence ( ", 
                                                 psi, " )", sep="")))


# What about relationship b/w detection probability and current?
# First create new data.frame with waterClarity held constant

newDat2 <- data.frame(current = seq(min(obsCovs(sqFishUMF)$current), 
                                    max(obsCovs(sqFishUMF)$current), length=100), 
                      waterClarity = mean(squirrelFishData$waterClarity))
head(newDat2)

# Get predicted detection prob values and SE for each new 'site'

pCurrent <- predict(CurrentClarity.CoralClaritySQ, type="det", 
                    newdata=newDat2)

# Plot relationship

plot(newDat2$current, pCurrent[,"Predicted"], type="l", ylim = 0:1, 
     xlab="Current speed index", ylab=expression(paste("Detection probability ( ", 
                                                       italic(p), " )", sep="")))
lines(newDat2$current, pCurrent[,"Predicted"]-1.96*pCurrent[,"SE"], lty=2)	
lines(newDat2$current, pCurrent[,"Predicted"]+1.96*pCurrent[,"SE"], lty=2)	

##################################################
#######Real data example           ###############
##################################################


# Import data from the website and check structure
alfl.data <- read.csv("alfl05.csv", row.names=1)
str(alfl.data)

# Pull out count matrix and covert to binary
alfl.y <- alfl.data[,c("alfl1", "alfl2", "alfl3")]
alfl.y1 <- alfl.y # Make a copy
alfl.y1[alfl.y>1] <- 1


# Standardize site-covariates
woody.mean <- mean(alfl.data$woody)
woody.sd <- sd(alfl.data$woody)
woody.z <- (alfl.data$woody-woody.mean)/woody.sd

struct.mean <- mean(alfl.data$struct)
struct.sd <- sd(alfl.data$struct)
struct.z <- (alfl.data$struct-struct.mean)/struct.sd


# Create unmarkedFrame
alfl.umf <- unmarkedFrameOccu(y=alfl.y1,
                              siteCovs=data.frame(woody=woody.z, struct=struct.z),
                              obsCovs=list(time=alfl.data[,c("time.1", "time.2", "time.3")],
                                           date=alfl.data[,c("date.1", "date.2", "date.3")]))
summary(alfl.umf)


# Here's an easy way to standardize covariates after making the UMF
#obsCovs(alfl.umf) <- scale(obsCovs(alfl.umf))
#summary(alfl.umf)

##Fit all of the models

(fm1 <- occu(~1 ~1, alfl.umf))
backTransform(fm1, type="state")
backTransform(fm1, type="det")


(fm2 <- occu(~date+time ~1, alfl.umf))
(fm3 <- occu(~date+time ~woody, alfl.umf))
(fm4 <- occu(~date+time ~woody+struct, alfl.umf))
(fm5 <- occu(~date+time+struct ~woody+struct, alfl.umf))

# Put the fitted models in a "fitList"
fms <- fitList("psi(.)p(.)"                           = fm1,
               "psi(.)p(date+time)"                   = fm2,
               "psi(woody)p(date+time)"               = fm3,
               "psi(woody+struct)p(date+time)"        = fm4,
               "psi(woody+struct)p(date+time+struct)" = fm5)

# Rank them by AIC
(ms <- modSel(fms))

#Get results
coef(ms)
toExport <- as(ms, "data.frame")

# Prediction

# Expected detection probability as function of time of day
# We standardized "time", so we predict over range of values on that scale
# We must fix "date" at some arbitrary value (let's use the mean)
newData1 <- data.frame(time=seq(-2.08, 1.86, by=0.1), date=0)
E.p <- predict(fm3, type="det", newdata=newData1, appendData=TRUE)
head(E.p)

# Plot it
plot(Predicted ~ time, E.p, type="l", ylim=c(0,1),
     xlab="time of day (standardized)",
     ylab="Expected detection probability")
lines(lower ~ time, E.p, type="l", col=gray(0.5))
lines(upper ~ time, E.p, type="l", col=gray(0.5))



# Expected occupancy over range of "woody"
newData2 <- data.frame(woody=seq(-1.6, 2.38, by=0.1))
E.psi <- predict(fm3, type="state", newdata=newData2, appendData=TRUE)
head(E.psi)

# Plot predictions with 95% CI
plot(Predicted ~ woody, E.psi, type="l", ylim=c(0,1),
     xlab="woody vegetation (standardized)",
     ylab="Expected occupancy probability")
lines(lower ~ woody, E.psi, type="l", col=gray(0.5))
lines(upper ~ woody, E.psi, type="l", col=gray(0.5))


# Plot it again, but this time convert the x-axis back to original scale
plot(Predicted ~ woody, E.psi, type="l", ylim=c(0,1),
     xlab="Percent cover - woody vegetation",
     ylab="Expected occupancy probability",
     xaxt="n")
xticks <- -1:2
xlabs <- xticks*woody.sd + woody.mean
axis(1, at=xticks, labels=round(xlabs, 1))
lines(lower ~ woody, E.psi, type="l", col=gray(0.5))
lines(upper ~ woody, E.psi, type="l", col=gray(0.5))



# Model-averaging

# Average predictions from all models

newData3 <- data.frame(woody=seq(-1.6, 2.38, by=0.1), struct=0)
E.psi.bar <- predict(fms, type="state", newdata=newData3,
                     appendData=TRUE)
head(E.psi.bar)

# Plot it
plot(Predicted ~ woody, E.psi.bar, type="l", ylim=c(-0.1, 1.1),
     xlab="Percent cover - woody vegetation",
     ylab="Expected occupancy probability",
     xaxt="n")
xticks <- -1:2
xlabs <- xticks*woody.sd + woody.mean
axis(1, at=xticks, labels=round(xlabs, 1))
lines(lower ~ woody, E.psi.bar, type="l", col=gray(0.5))
lines(upper ~ woody, E.psi.bar, type="l", col=gray(0.5))


#####################################################


#1. Analyze the covariate data we simulated


#2. Simulate a sampling design and covariates for a study in groups



