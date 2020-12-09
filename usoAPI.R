####################################
#### Uso de API

# Esencialmente, utilizaremos dos paquetes:
library(httr) # Para realizar peticiones a la API web a través de HTTP
library(jsonlite) # Para manejar las respuestas en formato JSON

# Los endpoint de una API web lucen como una URL, ¿verdad?
# http://api.open-notify.org/astros.json

# Esta función GET la provee httr
res = GET("http://api.open-notify.org/astros.json")

#peticiones fallidas
get_result <- GET(url = "http://google.com/fakepagethatdoesnotexist")

if(http_error(get_result)){
  warning("The request failed")
} else {
  content(get_result)
}

##json
data = fromJSON(rawToChar(res$content))
# Lo más probable es que hayamos obtenido una lista de elementos.
# Imprime data para localizar el data frame en la lista
data
# Podemos obtener únicamente el data frame de la siguiente manera
people <- data$people
people

### desde un archivo de la nube
people_csv <- read_csv("https://finances.worldbank.org/resource/gsdw-avpz.csv")
people_csv

###query parameters
# Si nuestra API admite query parameters, podemos agregarlos de la siguiente forma
res = GET("http://api.open-notify.org/iss-pass.json",
          query = list(lat = 40.7, lon = -74))
# Lo anterior es equivalente a: http://api.open-notify.org/iss-pass.json?lat=40.7&lon=-74
data = fromJSON(rawToChar(res$content))
data$response

# Guardarmos nuestra URL base en una variable para evitar escribirla cada vez
base_url = "https://finances.worldbank.org/resource/gsdw-avpz.json?"
# Unimos los query parameters con la URL base
full_url = paste0(base_url, "member=Costa Rica")
# Codificar URL completa
full_url = URLencode(full_url)
# Lo anterior es equivalente a https://finances.worldbank.org/resource/gsdw-avpz.json?member=Costa Rica
res = GET(full_url)
data = fromJSON(rawToChar(res$content))
data

base_url = "https://data.colorado.gov/resource/tv8u-hswn.json?"
# Observa las palabras precedidas por $: where y select.
full_url = URLencode(paste0(base_url, "county=Boulder",
                            "&$where=age between 20 and 40",
                            "&$select=year,age,femalepopulation"))
res = GET(full_url)
data = fromJSON(rawToChar(res$content))
data

#########
#datos anidados

# Hacemos una petición a la API de Wikipedia, haciendo una búsqueda avanzada mediante
# query parameters
resp <- GET(url = "https://en.wikipedia.org/w/api.php",
            query = list(action = "query",
                         titles = "Hadley Wickham",
                         prop = "revisions",
                         rvprop = "timestamp|user|comment|content",
                         rvlimit = "5",
                         format = "json",
                         rvdir = "newer",
                         rvstart = "2015-01-14T17:12:45Z",
                         rvsection = "0"))
# Observamos la estructura de la respuesta
str(content(resp), max.level = 4)
# Accedemos a la información en revisions
revs <- content(resp)$query$pages$`41916270`$revisions
# La info en revisions se encuentra en listas, naturalmente, debemos sacar
# la información de allí
unlist <- unlist(revs)
# Armamos el data frame con las listas
df_wiki <- data.frame(lapply(unlist, type.convert), stringsAsFactors=FALSE)
df_wiki
