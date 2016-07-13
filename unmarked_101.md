---
title       : "R como herramienta de modelado"
subtitle    : Modelos 101
author      : Diego J. Lizcano
job         : ULEAM, Manta
logo        : TSG.png
biglogo     : tsg_logo.gif

twitter     : dlizcano
license     : by-nc-sa  
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax, bootstrap, quiz]# 
mode        : selfcontained # {standalone, draft}
assets      : {js: 'test.js', css: "https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css"}

github      : {user: dlizcano, repo: IntroOccuPresent}
knit        : slidify::knit2slides
---


## Unmarked

### El paquete por exelencia para analisis de abundancia en fauna. 

> - Modela ocupación, abundancia y densidad de animales NO marcados. 
> - Contrasta con el programa Mark

![unmarked](assets/img/unmarked.jpg)

---

## Tipos de modelos:

• Single-season site occupancy model (MacKenzie et al., 2002)
• Royle-Nichols model (Royle and Nichols, 2003)
• Binomial N-mixture models (Royle, 2004b)
• Multinomial N-mixture models (Royle, 2004a)
• Distance sampling models (Royle et al., 2004)
• “Open population” versions of the above: (MacKenzie et al., 2003; Chandler
et al., 2011; Dail and Madsen, 2011)

---

## Árbol basico de decisión de modelos en el paquete unmarked

![unmarked](assets/img/unmarked2.jpg)

---

## Estructura de los datos 


|        | visita 1| visita 2| visita 3| visita 4|
|:-------|--------:|--------:|--------:|--------:|
|sitio 1 |        1|        0|        0|        1|
|sitio 2 |        0|        0|        0|        0|
|sitio 3 |        1|        1|        0|        0|
|sitio X |        0|        0|        0|        0|

> - Las unidades de muestreo son los sitios 
> - Idealmente debe haber por lo menos 3 visitas por sitio
> - Las covariables idealmente en otra tabla. Coviariables de sitio y covariables de observacion (varias tablas)

---

## Estructura de los datos 

Las tres tablas se enlazan en un objeto especial llamado unmarkedFrame


```r
umf <- unmarkedFrame (y = detections,
                      siteCovs = sitedata,
                      obsCovs = list(wind=viento, date=fecha))
```

---

## Ejemplo del paquete

vinieta de unmarkedFrameOccu


```r
# Fake data
R <- 4 # number of sites
J <- 3 # number of visits
y <- matrix(c(
   1,1,0,
   0,0,0,
   1,1,1,
   1,0,1), nrow=R, ncol=J, byrow=TRUE)
y

site.covs <- data.frame(x1=1:4, x2=factor(c('A','B','A','B')))
site.covs

obs.covs <- list(
   x3 = matrix(c(
      -1,0,1,
      -2,0,0,
      -3,1,0,
      0,0,0), nrow=R, ncol=J, byrow=TRUE),
   x4 = matrix(c(
      'a','b','c',
      'd','b','a',
      'a','a','c',
      'a','b','a'), nrow=R, ncol=J, byrow=TRUE))
obs.covs

umf <- unmarkedFrameOccu(y=y, siteCovs=site.covs, 
    obsCovs=obs.covs)   # organize data
umf                     # look at data
summary(umf)            # summarize      
fm <- occu(~1 ~1, umf)  # fit a model
```


---





