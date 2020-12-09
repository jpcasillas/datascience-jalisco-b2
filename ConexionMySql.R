#########################################
##   Conexion a MySql

# Instalamos los paquetes DBI y RMySQL
install.packages("DBI") ##libreria para conexion de conecciones
install.packages("RMySQL") ## controlador

# Cargamos el paquete DBI. RMySQL será cargado en conjunto.
library(DBI)

# Creamos un objeto de conexión mediante dbConnect()
con <- dbConnect(RMySQL::MySQL(), 
                 dbname = "tweater", 
                 host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com", #localhost 
                 port = 3306,
                 user = "student",
                 password = "datacamp")

# Exploremos todas las tablas disponibles en la base de datos
tables <- dbListTables(con)

# Muestra la estructura de todas las tablas disponibles
str(tables)

# Importamos una de las tablas de nuestra base, en este caso, la tabla users de tweater
users <- dbReadTable(con, 'users')

# Veamos qué contiene nuestra tabla users
users

#Import the users ta table from tweater: users
users <- dbReadTable(con,'users')
distinct(users,name, login)##tabla, campos a leer

table_names <- db_list_tables(con)
# Podemos importar todas nuestras tablas en un solo paso
tables <- lapply(table_names, dbReadTable, conn = con)

# El resultado será una lista de data frames
tables

# Obtener información mediante una query
user <- dbGetQuery(con, 'SELECT id, name, login FROM users WHERE name = "mike"')