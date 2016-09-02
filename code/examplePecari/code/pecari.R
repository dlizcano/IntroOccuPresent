# mi primercodigo
library(unmarked) # esta linea carga el paquete unmarked
source("PresentOnLine/code/examplePecari/code/TEAM_code.R")
pecari<- as.matrix(read.csv("PresentOnLine/code/examplePecari/data/pecari_sincamara.csv",header = TRUE)) # esta linea carga los datos del pecari
#pecari<-as.numeric(pecari)
#pecari<-matrix(pecari)
pecari2<-f.shrink.matrix.to15(matrix=pecari) # esta linea colapsa 5 dias a 1

covariables<- read.csv("PresentOnLine/code/examplePecari/data/covariables.csv") # esta linea carga las covariables
covariables$cabra<- as.factor(covariables$cabra)  # convierte a factor


pecari_UMF<-unmarkedFrameOccu(pecari2) # esta linea crea la matriz para unmarked
siteCovs(pecari_UMF)<-covariables # esta linea le pega las covariables a la matriz unmarked

#chequear el orden de las camaras pecari es igual a las covariables
#los modelos tienen el orden detectabilidad y despues ocupacion

  
  #nuevo 2
  fm0<-occu(~1~1,pecari_UMF) #este es el modelo nulo
  fm1<-occu(~1~elev,pecari_UMF) #este es el modelo donde la occupacion esta explicada por la elevacion
  fm2<-occu(~1~slope,pecari_UMF)
  fm3<-occu(~elev~elev,pecari_UMF) # este modelo tiene la elevacion explicando la detectabilidad y la ocupacion
  fm4<-occu(~canopy_h~elev,pecari_UMF) # la detectabilidad dependiendo de alturadeldosel y la ocupac dependiendo de la elevacion
  fm5<-occu(~canopy_h~slope,pecari_UMF) #la detectabilidad depende de la altura del dosel y la ocupacion de la elevacion
  fm6<-occu(~basal_a~dist_rd,pecari_UMF) # la detectabilidad depende del area basal y la ocupacion de la distancia a las carreteras
  fm7<-occu(~elev~elev+slope,pecari_UMF)
  fm8<-occu(~1~cabra,pecari_UMF)
  fm9<-occu(~elev~cabra,pecari_UMF)# la detectabilidad depende de la elevacion y la ocupacion de la especie introducida
  fm10<-occu(~slope~cabra,pecari_UMF)
  fm11<-occu(~dist_rd~cabra,pecari_UMF)
  fm12<-occu(~1~tipo_bosque,pecari_UMF)
  fm13<-occu(~1~dist_pob,pecari_UMF)
  fm14<-occu(~basal_a~dist_pob,pecari_UMF)
  
  modelos<-fitList(
    "p(.) occu(.)"=fm0,
    "p(.) occu(elev)"=fm1,
    "p(.) occu(slope)"=fm2,
    "p(elev) occu(elev)"=fm3,
    "p(canopy) occu(elev)"=fm4,
    "p(canopy) occu(slope)"=fm5,
    "p(basal_a) occu(dist_rd)"=fm6,
    "p(elev) occu(elev+slope)"=fm7,
    "p(.) occu(cabra)"=fm8,
    "p(elev) occu(cabra)"=fm9,
    "p(slope) occu(cabra)"=fm10,
    "p(dist_rd) occu(cabra)"=fm11,
    "p(.) occu(tipo_bosque)"=fm12,
    "p(.) occu(dist_pob)"=fm13,
    "p(basal_a) occu(dist_pob)"=fm14)
  
  modSel(modelos)
  rangoelev<-data.frame(cabra=factor(c("si","no")))
            
  re<-ranef(fm9)
  sum(bup(re,stat = "mode")) #un estimado empirico de la proporcion de sitios ocupados con un metodo bayesiano
  
  pb <- parboot(fm9, nsim=250, report=10) # goodness of fit
  plot (pb)
  
  #grafica de ocupacion
  pred_pecari<-predict(fm9,type="state",newdata=rangoelev,appendData=TRUE) #esta linea calcula la prediccion para 100 datos de elevacion
  with(pred_pecari, {
    x<-barplot(Predicted,names=cabra,xlab="cabra",
               ylab="occupa")
    arrows(x,Predicted,x,Predicted+SE,code = 3,angle = 90,length = 0.08)
  })
  
  
  #grafica de detectabilidad
  elev2<-data.frame(elev=seq(27,647,length=100))
  pred_pecaridetec<-predict(fm9,type="det",newdata=elev2,appendData=TRUE) #esta linea calcula la prediccion para 100 datos de elevacion
  plot(Predicted~elev,pred_pecaridetec,type="l",col="blue",
       xlab="elev",
       ylab="detec")
  lines(lower~elev,pred_pecaridetec,type="l",col=gray(0.5))
  lines(upper~elev,pred_pecaridetec,type="l",col=gray(0.5))
  
  
library(raster)
library(rgdal)
library(maptools)
library(sp)
# machalilla.elev.full<-getData('SRTM', lon=-80.90014, lat=-1.750139)
# machalilla.elev.full<-raster("C:/Users/Diego/Documents/CodigoR/IntroOccupancy/PresentOnLine/code/examplePecari/data/Copy_srtm_20_13.tif")
# machalilla.elev.cliped<-crop(machalilla.elev.full,extent(-80.90014, -80.6, -1.7, -1.350139))
machalilla.elev.cliped<-raster("C:/Users/Diego/Documents/CodigoR/IntroOccupancy/PresentOnLine/code/examplePecari/data/Machalilla_elev.tif")
# rm(machalilla.elev.full)  ## we don't need this big raster anymore so lets get the memory back
all.pa<-readShapePoly("C:/Users/Diego/Documents/CodigoR/IntroOccupancy/PresentOnLine/code/examplePecari/shp/snap.shp")

idx <- which(all.pa@data$nombre == "Machalilla")
machalilla.limit<-all.pa[idx,]
coords.cam<-cbind(covariables$longitude, covariables$latitude)
cam.map<-SpatialPoints(coords.cam)
plot(machalilla.elev.cliped, main="elev") # plot elevation
plot(machalilla.limit, add=T, lty=3, asp=1) # plot park
plot(cam.map, add=T, pch=20, alpha=0.1, col="red", cex=0.75) # plot cams


newmap.small<- aggregate(machalilla.elev.cliped, fact=2.5, fun=mean) # resample factor de 2.5
newmap<-stack(newmap.small, newmap.small)
names(newmap)<-c("elev", "cabra")
pred.pecari.det.map<-predict(fm9,type="det",newdata=newmap, appendData=TRUE) #esta linea calcula la prediccion para mapa de elevacion
plot(pred.pecari.det.map[[1]], main="Probabilidad de deteccion", asp=1)
plot(machalilla.limit, add=T, lty=3, asp=1)
plot(cam.map, add=T, pch=20, alpha=0.1, col="red", cex=0.75)




