1) ¿Cuál es la sucursal que recibe mas conexiones?
  Agrupar: branch_office
Colapsar: suma de conexiones por sucursal

2) ¿Qué día de las semana tenemos mas visitantes?
  Filtrar: visitor = true
  Agrupar: day_of_week
  Colapsar: Suma de visitantes por día
  
  3) ¿Cuál es el tiempo promedio de conexión de un visitante?
  Filtrar: visitor = true
  Colapsar: Promedio de tiempo de conexión
  
  4) Cuantas persona por mes han realizado visitas
filtrar: por visitors
agrupar: por mes
colapsar: conteo

5) ¿A qué hora se registran más visitantes?
  Filtrar: Obtener los registros por hora (hour_tz)
Agrupar: Visitantes y no visitantes (visitor)
Colapsar: Contar cuantos registros hay en cada grupo (count)
Se compara cuantos registros de visitantes hay en cada hora.

#pregunta1#
pregunta1 <- summarise(group_by(e, branch_office), sum(tiempodeses))

#Pregunta 2#
filter(e,visitor==TRUE)
group_by(e,day_of_week_tz)
count(e,visitor==TRUE)

visitantes <- filter(e,visitor==TRUE)
grupos <- group_by(visitantes,day_of_week_tz)

pregunta2 <- count(visitantes,day_of_week_tz)

#pregunta3#

pregunta3 <- mean(visitantes$tiempodeses)

#pregunta4#

mes <- group_by(visitantes,month_tz)
pregunta4 <- count(mes)

#pregunta5#

hora <- group_by(visitantes,hour_tz)
count(hora)
pregunta5 <- count(hora)
