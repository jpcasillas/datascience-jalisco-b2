rm(list=ls())
setwd("~") 

####################
# Machine Learning #
# K - means  			 #
####################

# install.packages(c("fpc", 'cluster'))
library('fpc')
library('cluster')
dir1 <- '/home/krax7/ClasesDevf/IDS/7-k-means-b'

## Leer los datos
## Tenemos una muestra (30,000) de perfiles de estudiantes de secundaria en una red social en el 2006
# Se contabilizaron las palabras en todos los perfiles
# Del top de palabras más frecuentes se seleccionaron 36 de las cuales podrían indicar 5 categorías de interés
# 1) actividades extracurriculares
# 2) fashion
# 3) religion
# 4) romance
# 5) comportamiento anti-social
# se tiene la edad, el género, el año de graduación (representando el año en el que se ha de graduar el estudiante), y la cantidad de amigos
#----
teens <- read.csv(paste(dir1,"snsdata.csv", sep="/"))
str(teens)

# Analizamos la variable de género
table(teens$gender)
summary(teens$gender)
# Especificamos que se debe de incluir los valores NA "missings"
table(teens$gender, useNA = "ifany")
prop.table(table(teens$gender, useNA = "ifany"))

# Analizamos el resto de las variables
summary(teens$age)
summary(teens$gradyear)
summary(teens$friends)

# ------------------------------------------------
# Limpiamos nuestro dataset
# Eliminamos los datos de edad atípicos
teens$age <- ifelse(teens$age >= 13 & teens$age < 20,teens$age, NA)


#¿Eliminamos los datos con valores NA?

# Para datos categóricos como género, se puede incorporar la opción de "desconocido"
# Generamos variables categóricas para incorporar la opción de "desconocido"
# Solo se ocupan dos dado que 
# Si female = 0 Y no_gender = 0 , significa que es M 
teens$female <- ifelse(teens$gender == "F" & !is.na(teens$gender), 1, 0)
teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)

# validamos las nuevas variables
table(teens$gender, useNA = "ifany")
table(teens$female, useNA = "ifany")
table(teens$no_gender, useNA = "ifany")

#Para datos númericos, se puede imputar un valor a todos los NA, en este caso, el valor promedio
#Calculamos el valor promedio
mean(teens$age)
#Quitamos los valores NA
mean(teens$age, na.rm = TRUE) # works
#Tenemos el promedio de edad considerando los 4 años de graduacion. Necesitamos el valor promedio de cada grado

# Podemos hacerlo con un ciclo o usando aggregate
# (dataset, columna a usar para el cálculo ~ columna para agrupar, operación, eliminamos los NA )
aggregate(data = teens, age ~ gradyear, mean, na.rm = TRUE)

# Para asignar los datos creamos un arreglo de la misma longitud de nuestro dataset con el promedio por cada observacion
ave_age <- ave(teens$age, teens$gradyear, FUN = function(x) mean(x, na.rm = TRUE))
str(ave_age)
#Asignamos el valor promedio en nuestro vector si el dato es NA, sino usamos la edad del dataset
teens$age <- ifelse(is.na(teens$age), ave_age, teens$age)

# Validamos los datos
summary(teens$age)


#------ Comenzamos con seleccionar las columnas para el entrenameinto
## - Empezamos solo con las columnas de las palabras
interests <- teens[5:40]
# Normalizamos los datos usando la normalizacion z-score 
# Escala el valor en medida de cuántas desviaciones estándares está por debajo o por encima de la media
# Nota: lapply regresa una lista, usamos as.data.frame para transformarla 
interests_z <- as.data.frame(lapply(interests, scale))

str(lapply(interests, scale))

#Seleccionamos un seed dado que kmeans funciona con datos random al principio y queremos que sean replicables
set.seed(2345) # Establecer un puntp de partida para los número aleatorios
teen_clusters <- kmeans(interests_z, 5)

## --------------------------------
# ¿Cómo evaluar el modelo? 
# 1) comparando el tamaño de cada cluster
teen_clusters$size

# 2) comparando los centros de los clusters
# Dado que normalizamos usando z-score valores positivos indican arriba del promedio, valores negativos indican debajo del promedio
teen_clusters$centers
#¿Qué grupo podría representar cada cluster?

#¿Sí visualizamos nuestros clusters?
# Opcion A
plotcluster(interests_z, teen_clusters$cluster)

# Opcion B
clusplot(interests_z,teen_clusters$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

#para mas detalle de cómo funciona clusplot
# https://wis.kuleuven.be/stat/robust/papers/1999/pisonstruyfrousseeuw-displayclusplot-csda-1999.pdf


## -----------------------------------
# kmeans()$cluster contiene el número del cluster al cual fue asinado cada observacion
# Agregamos el número de cluster a nuestro dataset
teens$cluster <- teen_clusters$cluster


# Vemos si el promedio de edad por cluster hace sentido
aggregate(data = teens, age ~ cluster, mean)

# Vemos si la proporcion de F por cluster hace sentido
aggregate(data = teens, female ~ cluster, mean)

# Vemos si la proporcion de amigos por cluster hace sentido
aggregate(data = teens, friends ~ cluster, mean)

## -----------------------------------
# Ejercicios
# 1) https://rpubs.com/FelipeRego/K-Means-Clustering
# 2) https://rstudio-pubs-static.s3.amazonaws.com/33876_1d7794d9a86647ca90c4f182df93f0e8.html
# 3) https://www.r-bloggers.com/k-means-clustering-in-r/
# 4) http://www.statmethods.net/advstats/cluster.html
