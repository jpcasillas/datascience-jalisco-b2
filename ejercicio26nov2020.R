personas <- tribble(
  ~nombre, ~nombres, ~valores,~medicion,
  #-----------------|--------|------
  "Phillip Woods", "edad", 45,1,
  "Phillip Woods", "estatura", 186,1,
  "Phillip Woods", "edad", 50,2,
  "Jessica Cordero", "edad", 37,1,
  "Jessica Cordero", "estatura", 156,1
)
personas

personas %>%
  pivot_wider(names_from = nombres, values_from = valores)


embarazo <- tribble(
  ~embarazo, ~hombre, ~mujer,
  "sí", NA, 10,
  "no", 20, 12
)
embarazo
embarazo %>%
  pivot_wider(names_from = tipo, values_from = cuenta)

embarazo %>%
pivot_longer(cols = c(hombre, mujer), names_to = "genero", values_to = "casos")

library(tidyverse)
tabla4a
tabla4a %>%
  pivot_longer(c(`1999`, `2000`), names_to = "anio", values_to = "casos")
