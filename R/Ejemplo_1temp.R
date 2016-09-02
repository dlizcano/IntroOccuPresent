##########################
## Ejemplo de una temporada (single season)
##########################

### Installar el paquete de "unmarked"
# install.packages("unmarked")

library(unmarked)

### Vamos a simular unos datos de observaciones de presencia/ausencia
### Este estudio tiene 10 sitios de muestreo, a donde se registraron aves 
### en tres muestreos repetidos

nSites <- 10 # Numero de sitios
nOcc <- 3    # visitas repetidas

# Definir una matriz de datos vacia
Obsv <- matrix(NA, nrow=nSites, ncol=nOcc)

head(Obsv)

# Vamos a especificar los valores de ocupacion y probabilidad de deteccion
psi <- 0.6
p <- 0.2

########## Realidad Biologica - Ocupacion
# Vamos a generar los datos de ocupacion   # The Bernoulli distribution is a binomial distribution with n=1
Z <- rbinom(nSites, size = 1, prob = psi)  # El estado biologico- resultado de un proceso binomial
                                           # queremos 10 valores, 1 prueba por valor, con una probabilidad
                                           # de obtener un "1", una observacion, es psi=0.6

########## Observacion - Deteccion
# Aca Generamos "datos" de los conteos repetidos, cuando la probabilidad de deteccion es p=0.2
# los datos se crean por sitio y se almacenan en la matriz de datos de NAs (linea 18)
for(i in 1:nSites){ # loop de 1 a nSites
  Obsv[i,] <- rbinom(nOcc, size = 1, prob = Z[i]*p)
}

# Ver los valores de observaciones que generamos
Obsv

## Vamos a comparar la realidad biologica (Z) con nuestras observaciones (Obsv)
summary(Z)

ys <- apply(Obsv,1,sum)   ##sumar las observaciones por sitio
summary(ys)

## La cantidad de sitios a donde si se encuentra la especie presente, 
## pero no la observamos en los conteos 
sum(Z[ys==0])

## Observe como la observacion es un sub estimado de la realidad!!!



########################################################
######## Vamos a analizar nuestros datos que generamos
########################################################
Data.1 <- unmarkedFrameOccu(y = Obsv, siteCovs = NULL, obsCovs = NULL)  
# le indicamos que estos son los datos, y no tenemos covariables

### Utilizamos la funcion 'occu' para analizar los datos. 
DataMod <- occu(~1 ~ 1, Data.1)

# Detalles del modelo
summary(DataMod)

# Transformar los resultados a una escala normal
coef(DataMod)     				      # Escala logistica
ests <- plogis(coef(DataMod))		# Escala original

# Obtener los resultados a una escala normal con el error estandard
(psiSE <- backTransform(DataMod, type="state")) # ocupacion
(pSE <- backTransform(DataMod, type="det"))     # deteccion

### Cuales valores obtenemos?
# Intervalos de confianza

(ciPsi <- confint(psiSE))
(ciP <- confint(pSE))

# Poner los resultados en una tabla
resultsTable <- rbind(psi = c(ests[1], ciPsi), p = c(ests[2], ciP))
colnames(resultsTable) <- c("Estimate", "lowerCI", "upperCI")

# ver la tabla
resultsTable

# Hacer un grafico
plot(1:2, resultsTable[,"Estimate"], xlim=c(0.5, 2.5), ylim=0:1, 
     col=c("blue", "darkgreen"), pch=16, cex=2, cex.lab=1.5,
     xaxt="n", ann=F)
axis(1, 1:2, labels=c(expression(psi), expression(italic(p))), cex.axis=1.5)
arrows(1:2, resultsTable[,"lowerCI"], 1:2, resultsTable[,"upperCI"], 
       angle=90, length=0.1, code=3, col=c("blue", "darkgreen"), lwd=2)



## Exportar la tabal de resultados 
# write.csv(resultsTable, "C:/resultsTable.csv")

#############################################################################################################
#############################################################################################################
### Leer los datos

lynxData <- read.csv("data/nullOccHighP.csv", header=TRUE)

## Lynx data


head(lynxData, n=15)  #queremos ves las primeras 15 filas de los datos

str(lynxData)


### Montar los datos para analizarlos


lynxUMF <- unmarkedFrameOccu(y = lynxData, siteCovs = NULL, obsCovs = NULL)  #le indicamos que estos son los datos, y no tenemos covariables


### Vamos a visualizar los datos de nuevo

lynxUMF

summary(lynxUMF)  ###resumir los datos

plot(lynxUMF)


### Ejecutar el modelo nulo, de una temporada, sin covariables, utilizando la funcion "occu"
###  esta funcion modela primero ocupacion, y despues detectabilidad
###  Aqui vamos a decir que ocupacion es constante (1) y que detectabilidad tambien (1)

lynxMod <- occu(~1 ~ 1, lynxUMF)


# Resultados del modelo (valores estimados en escala logistica)

lynxMod

# Mas detalles (AICc)

summary(lynxMod)


# Transformar los resultados a la escala original

coef(lynxMod) 						# Psi: ocupacion en escala logistica, p: probabilidad de deteccion en escala logistica

resultados <- plogis(coef(lynxMod))		# Transformacion a escala original

# Obtener los resultados pero con un error estandard

(psiSE <- backTransform(lynxMod, type="state")) 

(pSE <- backTransform(lynxMod, type="det"))

# Obtener intervalos de confianza

(ciPsi <- confint(psiSE))
(ciP <- confint(pSE))

# Crear una tabla con los resultados

Tabla_res <- rbind(psi = c(resultados[1], ciPsi), p = c(resultados[2], ciP))
colnames(Tabla_res) <- c("Resultado", "ICbajo", "ICalto")

Tabla_res


#Vamos a visualizar los resultados
# Plot

plot(1:2, Tabla_res[,"Resultado"], xlim=c(0.5, 2.5), ylim=0:1, 
	col=c("blue", "darkgreen"), pch=16, cex=2, cex.lab=1.5,
	xaxt="n", ann=F)

##a?adirle los simbolos de ocupacion y de probabilidad de deteccion
axis(1, 1:2, labels=c(expression(psi), expression(italic(p))), cex.axis=1.5)

##a?adirle barras de error
arrows(1:2, Tabla_res[,"ICbajo"], 1:2, Tabla_res[,"ICalto"], 
	angle=90, length=0.1, code=3, col=c("blue", "darkgreen"), lwd=2)



## Si quieren exporat los resultados a folder donde estan trabajando

# write.csv(Tabla_res, "C:/Tabla_res.csv")





########################## Laboratorio ###################################################################################

### Vamos a realizar el mismo analisis, pero con diferentes datos
## vamos a cargar el archivo de los datos


badgerData <- read.csv("nullOccLowP.csv", header=TRUE)


### Montar los datos para analizarlos

badgerUMF <- unmarkedFrameOccu(y = badgerData, siteCovs = NULL, obsCovs = NULL)


### Vamos a visualizar los datos de nuevo

summary(badgerUMF)  ###resumir los datos



### Ejecutar el modelo nulo, de una temporada, sin covariables, utilizando la funcion "occu"




# Ver los resultados reales (transformados de la escala logistica) con errores estandar y intervalos de confianza



#Visualizar los resultados


######################
# Pregunta adicional
######################

###  Que podriamos hacer con el ejemplo de la simulacion, para poder obtener valores mas cercanos a la verdad?
###  Debemos aumentar la cantidad de sitios (nSitios)?, incrementar visitas por sitio (nOcc)? 
###  o tratar de aumentar la probabilidad de deteccion? (Por ejemplo, realizar conteos de aves de 15minutos en vez de 5)









