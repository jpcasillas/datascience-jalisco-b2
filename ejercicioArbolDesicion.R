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
library('C50') # Genera el árbol de decisión

dir1 <- "/home/rstudio/datascience-jalisco-b2"

#Leer datos
#Base de datos de Wisconsin Breast Cancer Diagnostic 
#569 muestras, 
wbcd <- read.csv(paste(dir1, "v.csv", sep="/"), stringsAsFactors = FALSE)

wbcd <- wbcd[-1]
str(wbcd)
