library(tidyverse)
library(reshape2)
library(lubridate)

produkty <- read.csv("CENY_2917_CTAB_20200213211937.csv", sep = ";", dec=",", encoding = "UTF-8")

df <- data.frame(produkty)


#8. Mięso wieprzowe bez kości
#18. Ser dojrzewający - za 1kg
#21. Jaja kurze świerze (chów klatkowy lub ściółkowy) za 1 szt
#23. Margaryna za 400 g
#26. Pomarańcze - za 1 kg
#33. Kawa naturalna mielona - za 250g
#45. Półbuty damskie skórzane na podeszwie nieskórzanej - za 1 parę
#55. Olej napędowy - za 1l
#58. Pasta do zębów

df = subset(df, select = -c(Kod, Cena.i.wskaźniki, Jednostka.miary, Atrybut, X))

grouped = group_by(df, Rodzaje.towarów.i.usług, Nazwa)

ordered = grouped[order(grouped$Nazwa, grouped$Rok, grouped$Rodzaje.towarów.i.usług), ]
ordered = transform(ordered, Wartosc = as.numeric(sub(',', '.', as.character(Wartosc))))

