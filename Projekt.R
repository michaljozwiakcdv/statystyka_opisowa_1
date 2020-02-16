#8. Mięso wieprzowe bez kości
#18. Ser dojrzewający - za 1kg
#21. Jaja kurze świerze (chów klatkowy lub ściółkowy) za 1 szt
#23. Margaryna za 400 g
#26. Pomarańcze - za 1 kg
#33. Kawa naturalna mielona - za 250g
#45. Półbuty damskie skórzane na podeszwie nieskórzanej - za 1 parę
#55. Olej napędowy - za 1l
#58. Pasta do zębów

data <- dir(path='dane', pattern = '*.csv', full.names="TRUE", recursive="FALSE")

for (i in 1:length(dane)) {
  data <- read.csv(dane[i], sep=";")
  data_list[[i]] = data
}
data_frame <- do.call(rbind, data_list)

grouped_data_frame <- data_frame %>% group_by(Rodzaje.towarów.i.usług, Nazwa)

ordered <- data_frame[
  order(
    data_frame$Nazwa, 
    data_frame$Rok, 
    data_frame$Rodzaje.towarów.i.usług
  ), 
  ]

clear_data <- ordered[c('Nazwa', 'Miesiące', 'Rodzaje.towarów.i.usług', 'Rok', 'Wartosc')]

