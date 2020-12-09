rm(list=ls())
setwd("~")

####################
# Machine Learning #
# Decision Trees	 #
#   			 		     #
####################

#install.packages(c("C50", "gmodels"))
library(tidyverse)
library(gmodels) # Herramientas para evaluar árbol de decisión
library('C50') # Genera el árbol de decisión

## ---------- Decisiones de árboles
# Entropia de un segmento de dos clases 
-0.50 * log2(0.50) - 0.50 * log2(0.50)
-0.60 * log2(0.60) - 0.40 * log2(0.40)
-0.70 * log2(0.70) - 0.30 * log2(0.30)
-0.80 * log2(0.80) - 0.20 * log2(0.20)
-0.90 * log2(0.90) - 0.10 * log2(0.10)

#Graficamos la curva
curve(-x * log2(x) - (1 - x) * log2(1 - x), col = "red", xlab = "x", ylab = "Entropy", lwd = 1)
      
#Leer datos
#Base de datos de Wisconsin Breast Cancer Diagnostic
#569 muestras, 
dir1 <- "/home/krax7/ClasesDevf/IDS/7-DecisionTrees"
# "/home/krax7/ClasesDevf/IDS/DecisionTrees/wisc_bc_data.csv"

wbcd <- read.csv(paste(dir1, "wisc_bc_data.csv", sep="/"), stringsAsFactors = FALSE)
# credit <- read.csv(paste(dir1, "credit.csv", sep="/"), stringsAsFactors = TRUE)

# ver al estructura
#32 propiedades, 1 con un identificador unico, 1 para el diagnóstico, 30 númericas
str(wbcd)

## Quedarnos únicamente con las columnas necesarias
# Quitamos la variable id 
# no es necesaria para el clasificador. Si no la quitamos, dará resultados irrelevantes
wbcd <- wbcd[-1]
str(wbcd)
# Generamos una tabla con los diagnósticos
table(wbcd$diagnosis)

# recodificamos la columna diagnosis como factor
# los algoritmos requieren que el valor "objetivo" (columna de respuestas) sea un factor 
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B", "M"), labels = c("Benigno", "Maligno"))

# Transformamos la tabla a porcentajes
round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)

## Entrenamiento
# separamos la DB en un set como entrenamiento y otro como prueba
nfilas <- nrow(wbcd_n) * .80
index <- sample(1:nrow(wbcd_n), nfilas) # 80%
wbcd_train <- wbcd[index, -1] # Obtener solo las muestras
wbcd_test <- wbcd[-index, -1] # Todo menos las muestras

wbcd_train_labels <- wbcd[index, 1]
wbcd_test_labels <- wbcd[-index, 1]

# Guardamos la clasificación de cada uno (B o M) de la primera columna
wbcd_train_labels <- wbcd[1:nfilas, 1]
wbcd_test_labels <- wbcd[(nfilas+1):nfilas, 1]
str(wbcd_train_labels)

# Generando el modelo
wbcd_model <- C5.0(wbcd_train, wbcd_train_labels)
wbcd_model
summary(wbcd_model)

## ------------- ------------- ------------- ------------- -------------
# Evaluamos el modelo
# Creamos un vector con las predicciones sobre nuestos datos de pruebas
wbcd_pred <- predict(wbcd_model, wbcd_test)

CrossTable(wbcd_test_labels, wbcd_pred,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE)

## ------------- ------------- ------------- ------------- -------------
# boosts
# 
wbcd_boost10_model <- C5.0(wbcd_train, wbcd_train_labels,trials = 10)
wbcd_boost10_model
summary(wbcd_boost10_model)

wbcd_boost_pred10 <- predict(wbcd_boost10_model, wbcd_test)
CrossTable(wbcd_test_labels, wbcd_boost_pred10,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual', 'predicción'))