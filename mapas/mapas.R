##limpieza del workspace
rm(list = ls())

##definir la ruta de los mapas
setwd("/home/rstudio/datascience-jalisco-b2/mapas")

##instalar y cargar la libreria: sudo apt install libgdal-dev en caso de ser necesario
install.packages("rgdal")##en caso no estar instalado
library(rgdal)

library(leaflet)
library(mxmaps)
install.packages("RColorBrewer") ## en caso de no esta instalado
library(RColorBrewer)

library(dplyr)
library(ggplot2)

