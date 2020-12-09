####################################
### Conexion a PostgreSQL

# Instalamos los paquetes DBI y RPostgreSQL
install.packages("RPostgreSQL")

# Cargamos el paquete DBI y RPostgreSQL
library(DBI)
library("RPostgreSQL")

# https://www.dataquest.io/blog/r-api-tutorial/

# Cargamos el controlador PostgreSQL
drv <- dbDriver("PostgreSQL")

# Creamos un objeto de conexión mediante dbConnect()
# https://rnacentral.org/help/public-database
con <- dbConnect(drv, dbname = "pfmegrnargs",
                 host = "hh-pgsql-public.ebi.ac.uk",
                 port = 5432,
                 user = "reader",
                 password = "NWDMCE5xdipIjRrp")

# Corroborando que la tabla existe en la base de datos
dbExistsTable(con, "rnc_rna_precomputed")

# Ejecutamos una consulta directa a la base de datos 
df_postgres <- dbGetQuery(con, "SELECT
  upi,     -- RNAcentral URS identifier
  taxid,   -- NCBI taxid
  ac       -- external accession
FROM xref
WHERE ac IN ('OTTHUMT00000106564.1', 'OTTHUMT00000416802.1')")

df2 = dbGetQuery(con, "SELECT
                 precomputed.id
                 FROM rnc_rna_precomputed precomputed
                 JOIN rnc_taxonomy tax
                 ON
                 tax.id = precomputed.taxid
                 WHERE
                 tax.lineage LIKE 'cellular organisms; Bacteria; %'
                 AND precomputed.is_active = true    -- exclude sequences without active cross-references
                 AND rna_type = 'rRNA'")
# Si ocurre algún error, seremos notificados
dbGetException(con)

# Adicionalmente, podemos listar los campos presentes en una tabla
dbListFields(con,"rna")