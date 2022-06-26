---
title       : The concept of occupation and its modeling
subtitle    : Static model of occupation
author      : Diego J. Lizcano, Ph.D.
job         : OTS, Palo Verde
logo        : OTS-logo_small.png
biglogo     : Logo-OTS.png

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

## Models and simulations in ecology

> - A model in ecology is the mathematical description of an ecological system.

> - When the description is done with a practical purpose it is called simulation.

> - More about [models in ecology](http://www.planta.cn/forum/files_planta/an_introduction_to_mathematical_models_in_ecology_336.pdf)


--- &twocol

## Simulations are simplified versions of a real system, in which we can test how certain parameters vary, affecting the estimates of other parameters.


*** =left

```
All models are wrong but some are useful.
George Box, 1978. British statistician.
Statististics prof. Univ Princeton
Student of Egon Pearson
Box-Cox transformation
```

More about [George Box](https://en.wikipedia.org/wiki/George_E._P._Box) 

*** =right

<img src="https://s3.amazonaws.com/media-p.slid.es/uploads/402520/images/2417431/Pox.png"  align="right" />




--- &twocol

# Why simulations are useful:

*** =left


> - I know the true parameters.
> - They are a good way to learn.
> - We can calibrate a model.
> - By being able to simulate data under a certain model, it is guaranteed that one understands the model, its restrictions and limitations.
> - They allow verifying the quality of the estimates, as well as the precision and the effect of the sample size.
> - We can visualize how identifiable the parameters are in more complex models.

*** =right

![plot of chunk statmodel](assets/fig/statmodel-1.png)

---.segue bg:black


## Let's do a simulation of occupancy ($\psi$) and detectability (_p_).   

---.segue bg:black



## Imitate the way the measures of interest originate. The occupancy ($\psi$) and the detectability (_p_).

## Mechanistic approximation (mechanism).

--- &twocol

# There are two processes

*** =left

## proc. ecological _z_.

Which governs the presence of the species.
> - The species is (_z_=1), or is not (_z_=0) in the site. Simulated from a Bernoulli distribution.

![plot of chunk occumodel](assets/fig/occumodel-1.png)



*** =right


## proc. of observation _y_.

Which governs the observation of the species.
> - The species is observed (_p_=1), if the species is present. Conditional probability. Simulated with a Bernoulli distribution.


![plot of chunk obsmodel](assets/fig/obsmodel-1.png)

---

## It is important to understand that both processes are linked in a hierarchical way.

<img src="assets/img/hmodel.png"  align="right" />


> - The ecological process ($\psi$) follows a Bernoulli distribution.

> - The observation model ($p$) follows a Bernoulli distribution.

> - The probability of occurrence is also a proportion (occupancy):

$\psi$ = Pr($z_{i}$=1)  

> - The probability of observing the species given that the species is present is:   

$p$ = Pr($y_{i}$=1 $\mid$ $z_{i}$=1)  



---

## Now let's play around with the Bernoulli distribution

### is a variation of the binomial distribution

#### Let's vary ni and pi and see how the estimated mean (blue) approaches pi



```r
ni<-10 # numero de datos
pi<- 0.5 # probabilidad (~proporcion de unos)
# Generemos datos con esa informacion 
daber<-data.frame(estimado=rbinom(ni, 1, pi)) 
# Grafiquemos 
library(ggplot2)
ggplot(daber, aes(x=estimado)) + 
    geom_histogram(aes(y=..density..), # Histograma y densidad 
                   binwidth=.1, # Ancho del bin
                   colour="black", fill="white") + 
        geom_vline(aes(xintercept=mean(estimado, na.rm=T)), 
          color="blue", linetype="dashed", size=1) # media en azul
```


---.segue bg:#202020

## Let's change the approximation. Let's study the relationship from the data and the covariates

--- &twocol

## Relationship parameters and covariates


*** =left

### Occupancy and covariates

> - The occupancy ($\psi$) is a set of 1s and 0s.

> - Covariates can be continuous or discrete.


|sitio |psi |cov1 |cov2 |cov3   |
|:-----|:---|:----|:----|:------|
|1     |1   |10   |1.5  |bosque |
|2     |0   |15   |1.1  |cafe   |
|3     |1   |20   |5.5  |bosque |
|4     |0   |30   |2.1  |cacao  |
|5     |0   |40   |2.2  |bosque |

#### Logistic regression

*** =right

### Observation and covariates

> - The Observations are a set of 1s and 0s.

> - Covariates can be continuous or discrete.



|obs |cov1 |cov2 |cov3    |
|:---|:----|:----|:-------|
|1   |10   |1.5  |nublado |
|0   |15   |1.1  |soleado |
|1   |20   |5.5  |nublado |
|0   |30   |2.1  |nublado |
|0   |40   |2.2  |soleado |

#### Logistic regression

--- &twocol

## Logistic regression


```r
data(mtcars)
obs<-mtcars$vs
cov1<-mtcars$mpg
table3<-cbind.data.frame (obs,cov1)
library(ggplot2)
ggplot(table3, aes(x=cov1, y=obs)) + geom_point() + 
  geom_smooth(method = "glm", method.args = list(family = "binomial"))
```

![plot of chunk logist](assets/fig/logist-1.png)


---.hundred50
# Logistic regression allows to find the relationship between a binary variable and covariates.

The logistic regression has the form:

$y = { 1 \over 1 + e^{ -(\alpha + \beta_1 X_1 + \beta_2 X_2 + \cdots + \beta_p X_p + \epsilon) } }$

Applying the "algebraic trick" of the logit function, it takes the form:

$ logit(y) = \alpha + \beta_1 X_1 + \beta_2 X_2 + \cdots + \beta_p X_p + \epsilon$

--- 

## Putting it all together...
  
![Coding now](assets/img/Occu_Bayes.png)
> - Pass to occu model in unmarked


--- &twocol

## Cronograma

*** =left 

| Day       | Topic                                                                                                                                |
|-----------------|------------------------------------------------------|
| Tuesday 28 pm |  Remembering R                                                                                                                |
|           | [R as model tool](https://dlizcano.github.io/IntroOccuPresent/R_toModel_E.html)                                    |
| Wednesday 29 am | [Occupancy concept](https://dlizcano.github.io/IntroOccuPresent/modelOccuData_E.html)                        |
|           | Intro Occu Static model - [unmarked101](https://dlizcano.github.io/IntroOccuPresent/unmarked_101_E.html)                            |
| Wednesday 29 pm | Static Model in deep I- [Sim Machalilla](https://dlizcano.github.io/occu_book/)                                             |
|           | Static Model in deep II- [Data in unmarked](https://dlizcano.github.io/occu_book/unmarked.html) |
| Thursday 30 am | Questions. Real World Data - [Deer](https://github.com/dlizcano/IntroOccuPresent/raw/gh-pages/code/Pecari.rar)          |
|           | [More models](https://dlizcano.github.io/IntroOccuPresent/Otros_modelos_jerarquicos.html)                        |


*** =right

![Coding fast](http://i.giphy.com/fQZX2aoRC1Tqw.gif)



--- .segue #towork bg:url(assets/img/children-593313_1280.jpg)

## At the end: Spatially Explicit Bayesian occupancy model.


