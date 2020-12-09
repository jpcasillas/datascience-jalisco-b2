#### MAPAS ####

rm(list=ls())
# Set working directory
setwd("/home/krax7/ClasesDevf/intro-to-datascience/5-6-EDA/mapas/")
setwd("datascience-jalisco-b2/mapas/")

# Load the library
# Instalar rgdal: sudo apt-get install libgdal-dev
# install.packages("rgdal")
library(rgdal)
# install.packages("leaflet")
library(leaflet)
library(mxmaps)
install.packages("RColorBrewer")
library(RColorBrewer)
# Tidyverse
library(dplyr)
library(ggplot2)

## Mapa coloreado

# PASO 1: Descargar el shapefile. Almacenaremos nuestros shapefiles en una carpeta llamada DATA
download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="DATA/world_shape_file.zip")
# Corrobora que el archivo haya sido descargado en la pestaña files.

# Descomprimimos el archivo. La ruta después de la bandera "-d" es la carpeta destino de nuestros archivos.
system("unzip DATA/world_shape_file.zip -d DATA/world_shape_file")
#  -- > Accede a tu nueva carpeta, deberías ver al menos 4 archivos.
# Uno de ellos es el shapefile, lo podrás identificar por su extensión ".shp" (TM_WORLD_BORDERS_SIMPL-0.3.shp)

# Ahora podemos leer el shapefile con rgdal.
world_spdf <- readOGR(
  dsn= paste0(getwd(),"/DATA/world_shape_file/") ,
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

# Si nuestro mapa contempla múltiples regiones, debemos identificar la columna que los distingue
# en este caso, la columna REGION etiqueta cada polígono según su contiente
# class(world_spdf@data)
# africa2 <- world_spdf@data %>%
#   filter(REGION==2)
# africa@data <- africa2

africa <- world_spdf[world_spdf@data$REGION==2 , ]

# -- > Now you have a Spdf object (spatial polygon data frame). You can start doing maps!

## Graficar el mapa con base R
plot(africa , xlim=c(-20,60) , ylim=c(-40,40))

# Observamos los datos de población relacionados con África
africa@data
class(africa@data$POP2005) # ¿Es numérica?

# Make sure the variable you are studying is numeric
africa@data$POP2005 <- as.numeric(africa@data$POP2005)

# Distribution of the population per country?
africa@data %>% 
  ggplot( aes(x=as.numeric(POP2005))) + 
  geom_histogram(bins=20, fill='#69b3a2', color='white')

# Palette of 30 colors
# Tomamos los primeros 30 colores
my_colors <- brewer.pal(9, "Reds")
my_colors <- colorRampPalette(my_colors)(30)

# Attribute the appropriate color to each country
class_of_country <- cut(africa@data$POP2005, 30)
my_colors <- my_colors[as.numeric(class_of_country)]

# Make the plot
plot(africa , xlim=c(-20,60) , ylim=c(-40,40), col=my_colors ,  bg = "#A6CAE0")

## Con leaflet

# Vamos a utilizar el spdf mundial que ya teníamos
world_spdf@data$POP2005[ which(world_spdf@data$POP2005 == 0)] = NA
world_spdf@data$POP2005 <- as.numeric(as.character(world_spdf@data$POP2005)) / 1000000 %>% round(2)

# -- > Listo, ya tenemos un objeto spdf (spatial polygon data frame). ¡Ya podemos comenzar a generar mapas!

# Create a color palette for the map:
mypalette <- colorNumeric(palette="viridis", domain=world_spdf@data$POP2005, na.color="transparent")
mypalette(c(45,43,44))

# Basic choropleth with leaflet?
m <- leaflet(world_spdf) %>%
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( fillColor = ~mypalette(POP2005), stroke=FALSE )
m

# Exportar
# Podeamos guardar nuestro trabajo mediante el botón 'Export'

#### MXMAPS

# Install mxmaps
if (!require("devtools")) {
  install.packages("devtools")
}
# sudo apt install libudunits2-dev
devtools::install_github("diegovalle/mxmaps")
# Skip updates

# Cargamos datos de prueba para municipios
data("df_mxstate")

df_mxstate$value <- df_mxstate$pop
mxstate_choropleth(df_mxstate,
                   title = "Total population, by state") 

# Cargamos datos de prueba para municipios
data("df_mxmunicipio")

# Siempre es necesario generar la columna value
df_mxmunicipio$value <-  df_mxmunicipio$indigenous / df_mxmunicipio$pop * 100
mxmunicipio_choropleth(df_mxmunicipio, num_colors = 3,
                       title = "Percentage of the population that self-identifies as indigenous")

# Ahora visualicemos algunos estados solamente
mxmunicipio_choropleth(df_mxmunicipio, num_colors = 1,
                       zoom = subset(df_mxmunicipio, metro_area %in% c("Valle de México",
                                                                       "Puebla-Tlaxcala",
                                                                       "Cuernavaca",
                                                                       "Toluca"))$region,
                       title = "Percentage of the population that self-identifies as indigenous")

mxmunicipio_choropleth(df_mxmunicipio, num_colors = 1,
                       zoom = subset(df_mxmunicipio, state_name %in% c('Jalisco'))$region,
                       title = "Percentage of the population that self-identifies as indigenous")


#### INEGI

# Clic derecho sobre el botón de descarga y copiar dirección del enlace
download.file("https://www.inegi.org.mx/contenidos/masiva/indicadores/programas/accidentes/atus_00_csv.zip" , destfile="DATA/atus_00_csv.zip")
# You now have it in your current working directory, have a look!

# Unzip this file. You can do it with R (as below), or clicking on the object you downloaded.
system("unzip DATA/atus_00_csv.zip -d DATA/atus_00_csv")

data_inegi <- read_csv("DATA/atus_00_csv/conjunto_de_datos/atus_00_valor.csv")

# Obtenemos los datos
data("df_mxmunicipio")

value_data <- data_inegi %>%
  filter(cve_entidad != 0, cve_municipio != 0, indicador == 'Víctimas muertas en los accidentes de tránsito') %>%
  group_by(cve_entidad, cve_municipio) %>%
  summarise(value = sum(valor))

names(value_data) <- c('state_code', 'municipio_code', 'value')

df_inegi <- df_mxmunicipio %>%
  inner_join(value_data)

head(df_inegi)
table(df_inegi$value, useNA = 'ifany')
summary(data_inegi$año)

mxmunicipio_choropleth(df_inegi, num_colors = 3,
                       title = "Víctimas muertas en los accidentes de tránsito 1997 - 2019")
