---
title       : Abundancia
subtitle    : Entendiendo la historia
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
assets      : {js: 'test.js'}

github      : {user: dlizcano, repo: IntroOccuPresent}
knit        : slidify::knit2slides
---


# About me

<img src="assets/img/me.jpg" align="right" />


> - De: Cucuta, Colombia
> - [Biólogo (Uniandes, Bogotá)](https://cienciasbiologicas.uniandes.edu.co/)
> - [DICE, University of Kent](https://www.kent.ac.uk/dice/) 
> - Actualmente en: ULEAM, Manta
> - [Fauna de manabi](https://faunamanabi.github.io)
> - [TEAM Network](http://www.teamnetwork.org/user/1082)
> - [IUCN/SSC Tapir Specialist Group](http://www.tapirs.org/committees/index.html)
> - Mountain Tapir 
> - http://dlizcano.github.io
> - [@dlizcano en twitter](https://twitter.com/dlizcano)



---.segue bg:black

<q> 
La Ecología:  Estudio de las interacciones que determinan la _distribución y abundancia_.
</q> 

<p> 
 
</p>

### C. Krebs  

---

# Distribución y abundancia
  
## Donde están y cuantos son ?
  
### Relacionado con el problema de contar animales en ecología

> - A diferencia de las plantas... 
> - Los animales se mueven!

---

# Contar Animales
![Obtener densidad](assets/img/pinguinos.jpg)  
  
#### Facil para animales que conspicuos que se agrupan.

---

# Contar Animales
![Obtener densidad](assets/img/432.jpg)

#### No tan facil si no se agrupan. Metodos de Captura - Marca - Recaptura. Distance

---

# Contar Animales
![Obtener densidad](assets/img/Moose-capture_011.jpg)

#### Para algunas especies es engorroso, poco practico y muy costoso

---.segue bg:green

## Abundancia relativa: Una variable indicadora del estado de la población

---

## Los muestreos no son infalibles

![Hiding cat](http://i.giphy.com/nejXhE8hnCiQ0.gif)


#### La detectabilidad depende de:

> - 1. Las condiciones del muestreo (clima, hora)
> - 2. La habilidad del observador (sensor)
> - 3. La biología de la especie que se muestrea
> - Este error debe considerarse para evitar sesgos en las estimaciones de abundancia.

---.segue bg:#202020

## Mackenzie et al 2002, 2003, 2006 al rescate

--- &twocol

## Libro y programa presence

*** =left

![Mackenzie book](assets/img/mackenziebook.jpg)

*** =right

![presence software](http://www.mbr-pwrc.usgs.gov/software/doc/presence/falsePos.jpg)

Populariza la ocupación ($\psi$) como proxi de la abundancia teniendo en cuenta la detectabilidad ($p$)

---

## La ocupación ($\psi$) y la probabilidad de detección ($p$)

> - 1. Proporción del área muestreada que esta ocupada por la especie.
> - 2. Visitando el sitio varias veces puedo estar mas seguro que detecto la especie.  
  
  
Así debería verse una tabla de datos con muestreos repetidos.
  


|        | visita 1| visita 2| visita 3| visita 4|
|:-------|--------:|--------:|--------:|--------:|
|sitio 1 |        1|        0|        0|        1|
|sitio 2 |        0|        0|        0|        0|
|sitio 3 |        1|        1|        0|        0|
|sitio X |        0|        0|        0|        0|




--- &twocol

## Ejemplo del calculo de $\psi$ y $p$
  
### Método frecuentista (Máxima verosimilitud).
  
  
*** =left


|    | v 1| v 2| v 3| v 4|
|:---|---:|---:|---:|---:|
|s 1 |   1|   0|   0|   1|
|s 2 |   0|   0|   0|   0|
|s 3 |   1|   1|   0|   0|
|s X |   0|   0|   0|   0|

*** =right


| **Historias de detección**                            |
|-------------------------------------------------------|
| Pr($H_{1}$=1001)= $\psi$ × p1(1–p2)(1–p3)p4           |
| Pr($H_{2}$=0000)= $\psi$ × (1–p2)(1–p2)(1–p3)(1–p4)p4 |
| Pr($H_{3}$=1100)= $\psi$ × p1p2(1–p3)(1–p4)           |  
| Pr($H_{x}$=0000)= $\psi$ × (1–p2)(1–p2)(1–p3)(1–p4)p4 |  

  



---

## Estas Historias se combinan en un solo modelo de maxima verosimilitud

| **Historias de detección**                            |
|-------------------------------------------------------|
| Pr($H_{1}$=1001)= $\psi$ × p1(1–p2)(1–p3)p4           |
| Pr($H_{2}$=0000)= $\psi$ × (1–p2)(1–p2)(1–p3)(1–p4)p4 |
| Pr($H_{3}$=1100)= $\psi$ × p1p2(1–p3)(1–p4)           |  
| Pr($H_{x}$=0000)= $\psi$ × (1–p2)(1–p2)(1–p3)(1–p4)p4 |  

<br />
<br />

$$
\begin{aligned}
L(\psi, p \mid H_{1},...,H_{x}) =  \prod_{i=1}^{x} Pr (H_{i})
\end{aligned}
$$
  
  
> - El modelo admite incorporar covariables para explicar $\psi$ y $p$

--- &twocol

## El mismo ejemplo del calculo de $\psi$ y $p$
  
### Método Bayesiano.
  
  
*** =left


|    | v 1| v 2| v 3| v 4|
|:---|---:|---:|---:|---:|
|s 1 |   1|   0|   0|   1|
|s 2 |   0|   0|   0|   0|
|s 3 |   1|   1|   0|   0|
|s X |   0|   0|   0|   0|

*** =right
 
Es importante entender que hay dos procesos que se pueden modelar de forma jerarquica.
  
> - El proceso ecologico ($\psi$) sigue una distribucion Bernoulli.
> - El modelo de observacion ($p$) sigue una distribucion Bernoulli.
> - La probabilidad de observar la especie dada que esta presente: $p$=Pr($y_{i}$=1 $\mid$ $z_{i}$=1)
> - La probabilidad de ocurrencia: $\psi$ =Pr($z_{i}$=1)

---

## Un modelo jerarquico (Bayesiano)
  
![Full Occu Bayes](assets/img/Occu_Bayes.png)

### Admite covariables

--- &twocol

## Cual uso? Maxima verosimilitud o Bayesiano?
  
  
*** =left

### ML

> - Paquete [unmarked](https://cran.r-project.org/web/packages/unmarked/index.html) en R
> - Admite seleccion "automatica" de modelos con AIC
> - Problemas con matrices que tienen muchos NAs
> - Problema Hesian y estimados ok.
> - Dificultad de 1 a 10: 3 si ya sabes R.

*** =right
 
### Bayesiano

> - Lenguaje BUGS o Stan, llamado desde R
> - La seleccion de modelos no es tan sencilla, BIC no es adecuado
> - No tiene tantos problemas con muchos NAs en la matriz  
> - Los estimados son mas precisos.
> - Dificultad de 1 a 10: 7 si ya sabes R.

---.segue bg:#202020

## De donde vienen los modelos jerarquicos? 

--- &twocol

## [Andy Royle](http://www.pwrc.usgs.gov/staff/profiles/documents/royle.htm) 
  

  
*** =left


![Andy Royle](http://www.pwrc.usgs.gov/staff/profiles/images/royle.jpg)

Padre junto con (James Nichols and Darryl MacKenzie) de los modelos de ocupacion.

*** =right

### Autor del libro azul (2008).
  
![libro azul](https://secure-ecsd.elsevier.com/covers/80/Tango2/large/9780123740977.jpg)

Libro de nivel avanzado con muchos detalles, formulas, ejemplos y codigo en R y lenguage BUGS.

--- &twocol

## Libro de la libelula (2015).

#### Recientemente publicado con [Marc Kery](http://store.elsevier.com/Marc-Kery/ELS_1059944/).

*** =left  

![libro libelula](https://images-na.ssl-images-amazon.com/images/I/513ulKHhAKL._SX404_BO1,204,203,200_.jpg)

*** =right

Mas de 700 paginas explicando claramente de donde viene la teoria, en estilo tutorial, comenzando con un nivel basico de R hasta modelos avanzados y su implementacion en R y lenguaje BUGS.  


  
<a class="btn btn-large btn-danger" rel="popover" data-content="No. Hay modelos jerarquicos que no son Bayesianos." data-original-title="A Title" id='example'>Son todos los modelos jerarquicos Bayesianos ?</a>


--- #alfinal bg:url(https://pixabay.com/get/e131b70d2fe90021d85a5840981318c3fe76e6d31fb816429df8c6/baby-84627_1280.jpg)

## Manos a la obra!

#### Primeros pasos en   
  
![Coding now](https://www.r-project.org/Rlogo.png)


--- .segue #towork bg:url(https://pixabay.com/get/ec3cb20c29f71c22d2524518a33219c8b66ae3d11fb7184696f5c170/children-593313_1280.jpg)

## Al final: Modelo de ocupacion Bayesiano espacial.




