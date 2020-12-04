install.packages(c("corplot", "plotly"))

##limpieza de datos
rm(list = ls())##limpia global enviroment

# Cargamos los paquetes con los que vamos a trabajar
library(stringr) # Tratamiento de strings https://stringr.tidyverse.org/index.html
library(tibble) # Tidyverse https://tibble.tidyverse.org/
library(dplyr) # Tidyverse https://dplyr.tidyverse.org/
library(ggplot2) # Graphs https://ggplot2.tidyverse.org/
library(lubridate) # Tratamiento de fechas https://lubridate.tidyverse.org/
library(assertive) # Validaciones https://rdrr.io/cran/assertive/
library(visdat) # Visualizar missing data 


num <- c(1,2,3,4,5,6,7,8,9,10)
char <- c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j')
log <- c(TRUE, FALSE, FALSE, TRUE, T, F, T, T, T, F)
to.factor <- c(10, 20, 30, 20, 30, 20, 10, 10, 10, 20)
factor <- factor(to.factor, levels = c(10,20,30))

(df <- data.frame(num, char, log, factor, stringsAsFactors = FALSE))

sumatoria <- function(valores) {
  result <- sum(valores)
  return(result)
}

# ¿Qué pasa si hago lo siguiente?
sumatoria(df$factor)

##correccion
sumatoria <- function(valores) {
  result = NULL
  if(is.factor(valores) | is.character(valores)) {
    print('No es posible')
  } else {
    result <- sum(valores)
  }
  return(result)
}
# Note que utilizamos el operador lógico OR ( | ), esto porque no podemos
# tener un conjunto de datos con dos tipos a la vez.

assert_is_numeric(df$factor) # Validar si los datos son numéricos
assert_is_character(df$char) # Validar si los datos son caracteres
assert_is_logical(df$char) # Validar si los datos son lógicos
assert_is_factor(df$factor) # Validar si los datos son factores

# Hacemos una copia para proteger nuestro dataset original de alteraciones
columna.factor <- df$factor
# Si de verdad quieres sobrescribir la columna factor:
# df$factor <- as.numeric(as.character(df$factor))
columna.numeric <- as.numeric(as.character(columna.factor))
sumatoria(columna.numeric)

