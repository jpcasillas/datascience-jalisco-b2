#1.- Filtra los vuelos para mostrar únicamente los aviones que han realizado al menos cien viajes.
#2.- Combina datos::vehiculos y datos::comunes para encontrar los registros de los modelos más comunes.
#3.- Encuentra las 48 horas (en el transcurso del año) que tengan los peores atrasos. 
#3.- Haz una referencia cruzada con la tabla clima. ¿Puedes observar patrones?
#4.- ¿Qué te indica anti_join(vuelos, aeropuertos, by = c("destino" = "codigo_aeropuerto"))?
#4.- ¿Qué te indica anti_join(aeropuertos, vuelos, by = c("codigo_aeropuerto" = "destino"))?

library(dplyr)
library(datos)
library(ggplot2)

vuelos
#pregunta 1
grupo <- group_by(vuelos, vuelo)
conteo <- count(grupo, vuelo)
filtrar <- filter(conteo, (n < 100))

#pregunta 2
str(vehiculos)
comunes
comunes <- inner_join(vehiculos,comunes, by = c('fabricante','modelo'))
##comunes <- vehiculos %>% inner_join(comunes)

#pregunta 3
atraso <- summarise(group_by(vuelos,vuelo),sum(atraso_salida))
cruzada <- full_join(vuelos,clima)
## respuesta
summary(vuelos$atraso_salida)
filter(vuelos,atraso_salida >= 12.64)
atrasados = arrange(vuelos,-atraso_salida, -atraso_llegada)
clima
atrasados48 = atrasados[1:48,]
vuelos_clima <- atrasados48 %>%
  left_join(clima)%>%
  select(anio,mes,dia,origen,hora,fecha_hora,atraso_salida, atraso_llegada,temperatura,punto_rocio, 
         humedad, direccion_viento,velocidad_viento, velocidad_rafaga, precipitacion, visibilidad, presion)

ggplot(vuelos_clima,aes(x=atraso_llegada, y=visibilidad))+
  geom_point()

ggplot(vuelos_clima,aes(x=atraso_salida, y=visibilidad))+
  geom_point()

ggplot(vuelos_clima,aes(x=atraso_salida, y=temperatura))+
  geom_point()

#pregunta 4
vuelos
aeropuertos

anti1 <- anti_join(vuelos, aeropuertos, by = c("destino" = "codigo_aeropuerto"))##mantiene datos de vuelos
anti2 <- anti_join(aeropuertos, vuelos, by = c("codigo_aeropuerto" = "destino"))##mantiene datos de aeropuertos
