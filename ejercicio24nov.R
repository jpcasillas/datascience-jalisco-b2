library(tidyverse)

#pregunta1#
pregunta1 <- summarise(group_by(e, branch_office), sum(tiempodeses))

#Pregunta 2#
visitantes <- filter(e,visitor==TRUE)
group_by(filtro,day_of_week_tz)
count(filtro,visitor==TRUE)

grupos <- group_by(visitantes,day_of_week_tz)
pregunta2 <- count(grupos,day_of_week_tz)

#pregunta3#
pregunta3 <- mean(visitantes$tiempodeses) / 60 / 60

#pregunta4#
mes <- group_by(visitantes,month_tz)
pregunta4 <- count(mes)

#pregunta5#
hora <- group_by(visitantes,hour_tz)
count(hora)
pregunta5 <- count(hora)
