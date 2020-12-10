rm(list=ls())
setwd("~") 

##########################
# Machine Learning - KNN #
# 		    			         #
# 			  			         #
##########################

#install.packages(c("class", "gmodels"))
require(class)
require(gmodels)
require(dplyr)

dir1 <- "/home/rstudio/datascience-jalisco-b2"

#Leer datos
#Base de datos de Wisconsin Breast Cancer Diagnostic 
#569 muestras, 
wbcd <- read.csv(paste(dir1, "wisc_bc_data.csv", sep="/"), stringsAsFactors = FALSE)

# ver al estructura
#32 propiedades, 1 con un identificador unico, 1 para el diagnóstico, 30 númericas
str(wbcd)

# Quitamos la variable id 
# no es necesaria para el clasificador. Si no la quitamos, dará cálculos de distancias irrelevantes
wbcd <- wbcd[-1]
str(wbcd)
# Generamos una tabla con los diagnósticos
table(wbcd$diagnosis)

# recodificamos la colmna diagnosis como factor
# los algoritmos requieren que el valor "objetivo" sea un factor 
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"),
                         labels = c("Benigno", "Maligno"))

# Transformamos la tabla a porcentajes
round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)

# Exploramos los valores de tres de los atributos 
summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])

# Determinamos que se ocupa normalizar los valores
# Funcion para normalizar los valores de 0 a 1
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

# Probamos la funcion - los resultados deben de ser idénticos
normalize(c(1, 2, 3, 4, 5, 5, 5, 6))
normalize(c(10, 20, 30, 40, 50))

# Normalizamos nuestra DB desde la columna 2 a la 31 y en todas las filas
# La columna 1 guarda el diagnóstico
# ??lapply - aplica una funcion a una lista o vector
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize)) #list apply
head(wbcd_n)

# validamos los datos normalizados
# el valor mínimo debe de ser 0 y el máximo 1 
summary(wbcd_n$area_mean)
summary(wbcd_n[c("radius_mean", "area_mean", "smoothness_mean")])

# separamos la DB en un set como entrenamiento y otro como prueba
nfilas <- nrow(wbcd_n) * .80
set.seed(123)
index <- sample(1:nrow(wbcd_n), nfilas) # 80%
wbcd_train <- wbcd_n[index,] # Obtener solo las muestras
wbcd_test <- wbcd_n[-index,] # Todo menos las muestras

# Guardamos la clasificación de cada uno (B o M) de la primera columna
wbcd_train_labels <- wbcd[index, 1]
wbcd_test_labels <- wbcd[-index, 1]
str(wbcd_train_labels)
## ---------- Cargamos los datos a la función knn
# cl = factor de clasificación
# k = número de vecinos a usar 
# - preferentemente usar un número impar para romper empates
# - La raiz cuadrada de las 455 es 21.33, tomamos k = 21
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)

## ----------- Evaluamos los resultados del modelo 
# Creamos una tabla para compara predicciones vs real
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.r=FALSE, prop.chisq = FALSE)

# [0,1] Benigno, Benigno = Verdadero Negativo = Diagnóstico negativo + enfermedad ausente 
# [1,0] Maligno, Maligno = Verdadero Positivo = Diagnóstico positivo + enfermedad presente

# [0,0] Maligno, Benigno = Falso Negativo = Diagnóstico negativo + enfermedad presente
# [1,1]	Benigno, Maligno = Falso Positivo = Diagnóstico positivo + enfermedad ausente 

## ----------- ¿Se pueden mejorar los resultados?

# Normalizamos los datos usando z-score 
# Usamos la función scale() 
wbcd_z <- as.data.frame(scale(wbcd[-1]))

# Validamos la normalización
summary(wbcd[c("radius_mean", "area_mean", "smoothness_mean")])
summary(wbcd_z[c("radius_mean", "area_mean", "smoothness_mean")])

# Creamos los datasets
nzfilas <- nrow(wbcd_z) * .80
set.seed(123)
index <- sample(1:nrow(wbcd_z), nzfilas) # 80%
wbcd_train <- wbcd_z[index,] # Obtener solo las muestras
wbcd_test <- wbcd_z[-index,] # Todo menos las muestras

# Clasificamos las pruebas
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test,
                      cl = wbcd_train_labels, k = 21)

## TAREA OPCIONAL:
# ¿Qué sucede si probamos con distintos valores para K?
# Generar un for para utilizar valores del 1:455 (valores para k)
# Obtener los valores del CrossTable para determinar a cuál modelo le fue mejor
# (falsos positivos o falsos negativos)

# Comparamos resultados
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred,
           prop.chisq = FALSE, prop.t = FALSE, prop.c = FALSE)