# mi primercodigo
library(unmarked) # esta linea carga el paquete unmarked
source("code/TEAM_code.R")
pecari<- as.matrix(read.csv("data/pecari_sincamara.csv",header = TRUE)) # esta linea carga los datos del pecari
#pecari<-as.numeric(pecari)
#pecari<-matrix(pecari)
pecari2<-f.shrink.matrix.to15(matrix=pecari) # esta linea colapsa 5 dias a 1

covariables<- read.csv("data/covariables.csv") # esta linea carga las covariables
covariables$cabra<- as.factor(covariables$cabra)
pecari_UMF<-unmarkedFrameOccu(pecari2) # esta linea crea la matriz para unmarked
siteCovs(pecari_UMF)<-covariables # esta linea le pega las covariables a la matriz unmarked

#chequear el orden de las camaras pecari es igual a las covariables
#los modelos tienen el orden detectabilidad y despues ocupacion
fm0<-occu(~1~1,pecari_UMF) #este es el modelo nulo
fm1<-occu(~1~elev,pecari_UMF) #este es el modelo donde la occupacion esta explicada por la elevacion
fm2<-occu(~1~slope,pecari_UMF)
fm3<-occu(~elev~elev,pecari_UMF) # este modelo tiene la elevacion explicando la detectabilidad y la ocupacion
fm4<-occu(~canopy_h~elev,pecari_UMF) # la detectabilidad dependiendo de alturadeldosel y la ocupac dependiendo de la elevacion
fm5<-occu(~canopy_h~slope,pecari_UMF) #la detectabilidad depende de la altura del dosel y la ocupacion de la elevacion
fm6<-occu(~basal_a~dist_rd,pecari_UMF) # la detectabilidad depende del area basal y la ocupacion de la distancia a las carreteras
fm7<-occu(~elev~elev+slope,pecari_UMF)
modelos<-fitList(
  "p(.) occu(.)"=fm0,
  "p(.) occu(elev)"=fm1,
  "p(.) occu(slope)"=fm2,
  "p(elev) occu(elev)"=fm3,
  "p(canopy) occu(elev)"=fm4,
  "p(canopy) occu(slope)"=fm5,
  "p(basal_a) occu(dist_rd)"=fm6,
  "p(elev) occu(elev+slope)"=fm7)

  modSel(modelos)
  rangoelev<-data.frame(elev=seq(27,647,length=100)) #esta linea crea 100 datos de elevacion en secuencia para predecir
    re<-ranef(fm3)
  sum(bup(re,stat = "mode")) #un estmiado empirico de la proporcion de sitios ocupados con un metodo bayesiano
  pred_pecari<-predict(fm3,type="state",newdata=rangoelev,appendData=TRUE) #esta linea calcula la prediccion para 100 datos de elevacion
  plot(Predicted~elev,pred_pecari,type="l",col="blue",
       xlab="elevacion (m)",
       ylab="ocupacion")
  lines(lower~elev,pred_pecari,type="l",col=gray(0.5))
  lines(upper~elev,pred_pecari,type="l",col=gray(0.5))
  
  
  pred_pecari2<-predict(fm3,type="det",newdata=rangoelev,appendData=TRUE) #esta linea calcula la prediccion para 100 datos de elevacion
  plot(Predicted~elev,pred_pecari2,type="l",col="blue",
       xlab="elevacion (m)",
       ylab="detectabilidad")
  lines(lower~elev,pred_pecari2,type="l",col=gray(0.5))
  lines(upper~elev,pred_pecari2,type="l",col=gray(0.5))
  
  
  #nuevo
  
  #fm8<-occu(~elev~cabra,pecari_UMF)
  #pred_pecari2<-predict(fm8,type="det",newdata=rangoelev,appendData=TRUE) #esta linea calcula la prediccion para 100 datos de elevacion
  #plot(Predicted~elev,pred_pecari2,type="l",col="blue",
       #xlab="elevacion (m)",
       #ylab="cabra")
  #lines(lower~elev,pred_pecari2,type="l",col=gray(0.5))
  #lines(upper~elev,pred_pecari2,type="l",col=gray(0.5))
  
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
    "p(dist_rd) occu(cabra)"=fm11)
  
  modSel(modelos)
  rangoelev<-data.frame(elev=seq(27,647,length=100),
                      cabra=rep(c(0,1),100))
  re<-ranef(fm9)
  sum(bup(re,stat = "mode")) #un estimado empirico de la proporcion de sitios ocupados con un metodo bayesiano
  pred_pecari<-predict(fm9,type="state",newdata=rangoelev,appendData=TRUE) #esta linea calcula la prediccion para 100 datos de elevacion
  plot(Predicted~cabra,pred_pecari,type="p",col="blue",
       xlab="cabra",
       ylab="occupa")
  #lines(lower~cabra,pred_pecari,type="l",col=gray(0.5))
  #lines(upper~cabra,pred_pecari,type="l",col=gray(0.5))
  
  
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
  