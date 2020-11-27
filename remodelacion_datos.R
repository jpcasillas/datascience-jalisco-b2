##remodelacion dataframe

library(tidyverse)
tabla4a

##a lo largo
tabla4a %>%
  pivot_longer(cols = c(`1999`, `2000`), names_to = "anio", values_to = "casos")

tabla2

##a lo ancho
tabla2 %>%
  pivot_wider(names_from = tipo, values_from = cuenta)

##reshape
set.seed(1234)
df <- data.frame(identifier=rep(1:5, each=3),
                 location=rep(c("up", "down", "left", "up", "center"), each=3),
                 period=rep(1:3, 5), counts=sample(35, 15, replace=TRUE),
                 values=runif(15, 5, 10))[-c(4,8,11),]
df

#de largo a ancho
df.wide <- reshape(df, idvar="identifier", timevar="period",
                   v.names=c("values", "counts"), direction="wide")
df.wide

# remove "." separator in df.wide names for counts and values
names(df.wide)[grep("\\.", names(df.wide))] <-
  gsub("\\.", "", names(df.wide)[grep("\\.", names(df.wide))])
df.wide

##de ancho a largo
reshape(df.wide, direction="long")

##separate

tabla3

tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"))

tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"), convert = TRUE)

tabla3 %>%
  separate(anio, into = c("siglo", "anio"), sep = 2)

##separara multiples valores de columnas
# Generamos una tabla con dos columnas con múltiples valores en una misma celda
gl  <-  tibble (
  x  =  1 : 3 ,
  y  =  c ( "a" , "d, e, f" , "g, h" ),
  z  =  c ( "1" , "2,3,4" , "5,6" )
)

# Indicamos a separate_rows que separe los valores la columna "y" y la columna "z"
separate_rows ( gl , y , z , convert  =  TRUE , sep = ",")

##unite

tabla5 %>%
  unite(nueva, siglo, anio)

tabla5 %>%
  unite(nueva, siglo, anio, sep = "")