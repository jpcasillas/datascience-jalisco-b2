library(tidyverse)
library(readr)
e <- read_csv("datascience-jalisco-b2/e.csv")
#pregunta1#
pregunta1 <- summarise(group_by(e, branch_office), total = sum(tiempodeses))
gr <- ggplot(pregunta1, aes(x=branch_office, y=total)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=round(total, 2)),vjust=-1) +
  labs(title="Tiempo de sesion",  x="Oficina", y="Tiempo")

ggsave(paste(dir2, "pregunta1.png", sep="/"), plot=gr, width=20, height=12)

#Pregunta 2#
pregunta2 <- filter(e,visitor==TRUE)%>%group_by(day_of_week_tz)%>%count(visitor=TRUE)
gr <- ggplot(pregunta2, aes(x=day_of_week_tz, y=n)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=round(n, 2)),vjust=-1) +
  labs(title="Tiempo de sesion",  x="Dia", y="Tiempo")

ggsave(paste(dir2, "pregunta2.png", sep="/"), plot=gr, width=20, height=12)
##group_by(visitantes,day_of_week_tz)
##count(visitantes,visitor==TRUE)
##grupos <- group_by(visitantes,day_of_week_tz)
##pregunta2 <- count(grupos,day_of_week_tz)

visitantes <- filter(e,visitor==TRUE)
#pregunta3#
pregunta3 <- mean(visitantes$tiempodeses) / 60 / 60

#pregunta4#
pregunta4 <- group_by(visitantes,month_tz)%>%count(month_tz)
#pregunta4 <- count(mes)
gr <- ggplot(pregunta4, aes(x=month_tz, y=n)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=round(n, 2)),vjust=-1) +
  labs(title="Tiempo de sesion",  x="Mes", y="Tiempo")

ggsave(paste(dir2, "pregunta4.png", sep="/"), plot=gr, width=20, height=12)


#pregunta5#
pregunta5 <- group_by(visitantes,hour_tz)%>%
count(hour_tz)
#pregunta5 <- count(hora)
gr <- ggplot(pregunta5, aes(x=hour_tz, y=n)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=round(n, 2)),vjust=-1) +
  labs(title="Tiempo de sesion",  x="Horas", y="Tiempo")

ggsave(paste(dir2, "pregunta5.png", sep="/"), plot=gr, width=20, height=12)