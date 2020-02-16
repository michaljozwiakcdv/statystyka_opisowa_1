library(tidyverse)
library(reshape2)

#8. Mięso wieprzowe bez kości
#18. Ser dojrzewający - za 1kg
#21. Jaja kurze świerze (chów klatkowy lub ściółkowy) za 1 szt
#23. Margaryna za 400 g
#26. Pomarańcze - za 1 kg
#33. Kawa naturalna mielona - za 250g
#45. Półbuty damskie skórzane na podeszwie nieskórzanej - za 1 parę
#55. Olej napędowy - za 1l
#58. Pasta do zębów
ggplot()

dane <- dir(path='dane/', pattern = '*.csv', full.names="TRUE", recursive="FALSE")
data_list <- c()
for (i in 1:length(dane)) {
  data <- read.csv(dane[i], sep=";")
  data_list[[i]] = data
}
data_frame <- do.call(rbind, data_list)

grouped_data_frame <- data_frame %>% group_by(Rodzaje.towarów.i.usług, Nazwa)

ordered_data <- data_frame[
  order(
    data_frame['Nazwa'], 
    data_frame['Rok'], 
    data_frame['Rodzaje.towarów.i.usług']
  ), 
]

clear_data <- ordered_data[c('Nazwa', 'Miesiące', 'Rodzaje.towarów.i.usług', 'Rok', 'Wartosc')]

#options(repr.plot.width=400, repr.plot.height = 100)
regions <- unique(clear_data['Nazwa'])
for (region in regions) {
  region_data <- subset(clear_data, Nazwa == region)
  products <- c()
  meanPrice <- c()
  product_year <- c();
  
  products_type <- unique(region_data['Rodzaje.towarów.i.usług'])
  for (product in products_type) {
    product_data <- subset(region_data, Rodzaje.towarów.i.usług == product)
    
    years <- unique(clear_data['Rok'])
    for (year in years) {
      data <- subset(product_data, Rok == year)
      mv <- as.numeric(sub(',', '.', as.character(data['Wartosc'])))
      products <- c(products, product)
      product_year <- c(product_year, year)
      meanPrice <- c(meanPrice, mv)
    }
  }
  
  data = data.frame(products, product_year, meanPrice)
  ggplot(data=data, aes(x=product_year)) + 
    geom_line(aes(y=meanPrice, col=products))+
    labs(title="Avg prices in years 2006-2019",
         subtitle=paste("Region", region),
         x="Year",
         y="Avg price") +
    theme(legend.position = "bottom")
  ggsave(paste(region, "png", sep="."), scale=4)
}
