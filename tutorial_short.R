### Tutorial version corta.
### Diego J. Lizcano


# see full explanation in: https://dlizcano.github.io/IntroOccuBook

source(funcion_map.R)

#######################################################
## Generamos datos de 60 camaras x 30 dias  para: 
## un venado ()
#######################################################
datos2<-data.fn(M = 60, J = 30, show.plot = FALSE,
                mean.occupancy = 0.8, beta1 = -1.5, beta2 = 0, beta3 = 0,  
                mean.detection = 0.6, alpha1 = 2, alpha2 = 1, alpha3 = 1.5)

attach(datos2)  # Make objects inside of 'datos2' accessible directly

# ver los datos de la camara
View(y)

# ver los datos de altitud
View(elev)

# ver los datos de cobertura boscosa
View(forest)

# ver los datos de temperatura
View(temp)

# los datos estan estandarizados (funcion scale)

#######################################################
## Cargamos el pauete y los datos
#######################################################
library(unmarked) # carga el paquete

siteCovs <- as.data.frame(cbind(forest,elev)) # occupancy covariates 
obselev<-matrix(rep(elev,J),ncol = J) # make elevetion per observation
obsCovs <- list(temp= temp,elev=obselev) # detection covariates

#######################################################
## enlazamos las tablas
#######################################################
umf <- unmarkedFrameOccu(y = y, siteCovs = siteCovs, obsCovs = obsCovs)
summary (umf)
plot (umf)

#######################################################
## ajustamos modelos
#######################################################
# detection first, occupancy next
fm0 <- occu(~1 ~1, umf) # Null model
fm1 <- occu(~ elev ~ 1, umf) # elev explaining detection
fm2 <- occu(~ elev ~ elev, umf) # elev explaining detection and occupancy
fm3 <- occu(~ temp ~ elev, umf)
fm4 <- occu(~ temp ~ forest, umf)
fm5 <- occu(~ elev + temp ~ 1, umf)
fm6 <- occu(~ elev + temp + elev:temp ~ 1, umf)
fm7 <- occu(~ elev + temp + elev:temp ~ elev, umf)
fm8 <- occu(~ elev + temp + elev:temp ~ forest, umf)

#######################################################
## ponemos nombres a los modelos
#######################################################
models <- fitList( # here e put names to the models
  'p(.)psi(.)'                        = fm0,
  'p(elev)psi(.)'                     = fm1,
  'p(elev)psi(elev)'                  = fm2,
  'p(temp)psi(elev)'                  = fm3,
  'p(temp)psi(forest)'                = fm4,
  'p(temp+elev)psi(.)'                = fm5,
  'p(temp+elev+elev:temp)psi(.)'      = fm6,
  'p(temp+elev+elev:temp)psi(elev)'   = fm7,
  'p(temp+elev+elev:temp)psi(forest)' = fm8)

modSel(models) # model selection procedure

#######################################################
## vemos los coeficientes del mejor modelo y vemos su ajuste
#######################################################
summary(fm7) # see the model parameters
pb <- parboot(fm7, nsim=250, report=10) # goodness of fit
plot (pb) # plot goodness of fit


#######################################################
## predecimos con el mejor modelo en grafica
#######################################################
elevrange<-data.frame(elev=seq(min(datos2$elev),max(datos2$elev),length=100)) # newdata
pred_psi <-predict(fm7,type="state",newdata=elevrange,appendData=TRUE) 
plot(Predicted~elev, pred_psi,type="l",col="blue",
     xlab="elev",
     ylab="psi")
lines(lower~elev, pred_psi,type="l",col=gray(0.5))
lines(upper~elev, pred_psi,type="l",col=gray(0.5))


#######################################################
## predecimos con el mejor modelo en mapas
#######################################################

predictions_psi <- predict(fm7, type="state", newdata=mapdata.m) # predict occu
predictions_p   <- predict(fm7, type="det",   newdata=mapdata.m) # predict p

# put in the same stack and visualize
predmaps<-stack(predictions_psi$Predicted,predictions_p$Predicted) 
names(predmaps)<-c("psi_predicted", "p_predicted") # put names
plot(predmaps)

