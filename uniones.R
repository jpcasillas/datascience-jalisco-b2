# Importamos el paquete donde se encuentran nuestras tablas
library(nycflights13)
# Importamos dplyr, paquete para manipular datos
library(dplyr)

# Observamos lo que contiene la tabla fligths
flights
# Observamos lo que contiene la tabla airlines
airlines

# Generamos una copia de flights en flights2, seleccionando solo las variables necesarias para visualizar el resultado más fácilmente
flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)%>% 
  left_join(airlines)


flights2 %>% left_join(planes, by = "tailnum")

airports
flights

df <- left_join(flights,airports, by = c("origin"= "faa"))

# Creamos un par de tablas (data frames) nuevos para ejemplificar cada tipo de join
# Ejecute el código de más abajo y observe el contenido de cada tabla atentamente
df1 <- tibble(x = c(1, 2), y = 2:1)
df2 <- tibble(x = c(3, 1), a = 10, b = "a")

df1 %>% inner_join(df2)
df1 %>% left_join(df2)

df1 %>% right_join(df2)
# Versión equivalente de right_join pero con left_join(y, x)
df2 %>% left_join(df1)

df1  %>%  full_join ( df2 )

df1 <- tibble(x = c(1, 1, 2), y = 1:3)
df2 <- tibble(x = c(1, 1, 2), z = c("a", "b", "a"))

df1 %>% left_join(df2)

##filtering joins
##anti_joins
library ("nycflights13")

flights %>%  
  anti_join(planes, by = "tailnum") %>%  
  count(tailnum, sort = TRUE)

# Recuerda que los paréntesis al inicio y al final permiten mostrar el resultado en consola sin llamar a la variable
(df1 <- tibble(x = c(1, 1, 3, 4), y = 1:4))
(df2 <- tibble(x = c(1, 1, 2), z = c("a", "b", "a")))

# Four rows to start with:
df1 %>% nrow()
df1 %>% inner_join(df2, by = "x") %>% nrow()

df1 %>% semi_join(df2, by = "x") %>% nrow()

##intersec
(df1 <- tibble(x = 1:2, y = c(1L, 1L)))
(df2 <- tibble(x = 1:2, y = 1:2))

# Ejecuta las siguientes líneas y corrobora el resultado
intersect(df1, df2)## solo las coincidencias al 100 %

union(df1, df2)# integra todo pero sin repetir valores de algun lado no duplicados

setdiff(df1, df2) ##solo diferencias
setdiff(df2, df1) ##solo diferencias pero invertido


install.packages("datos")