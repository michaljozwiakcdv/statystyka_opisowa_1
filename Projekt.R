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
current_dir <- dirname(rstudioapi::getSourceEditorContext()$path)
data_dir <- paste(current_dir, '/dane/')
dane <- dir(path=data_dir, pattern = '*.csv', full.names="TRUE", recursive="FALSE")

data_list <- list()
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
clear_data <- ordered_data[
  list(
    'Nazwa', 
    'Miesiące', 
    'Rodzaje.towarów.i.usług', 
    'Rok', 
    'Wartosc')
  ]

ggplot()
regions <- unique(clear_data['Nazwa'])
for (region in regions) {
  region_data <- subset(clear_data, Nazwa == region)
  products <- list()
  meanPrice <- list()
  product_year <- list();
  
  products_type <- unique(region_data['Rodzaje.towarów.i.usług'])
  for (product in products_type) {
    product_data <- subset(region_data, Rodzaje.towarów.i.usług == product)
    
    years <- unique(clear_data['Rok'])
    for (year in years) {
      yearly_for_product <- subset(product_data, Rok == year)
      price <- as.numeric(sub(',', '.', as.character(yearly_for_product['Wartosc'])))
      products <- list(products, product)
      product_year <- list(product_year, year)
      prices <- list(meanPrice, price)
    }
  }
  
  data = data.frame(products, product_year, prices)
  ggplot(data=data, aes(x=product_year), size='qsec') +
  geom_line(aes(y=prices, col=products)) +
  labs(
    title = "Avg prices in years 2006-2019", 
    subtitle = paste("Region", region),
    x = "Year",
    y = "Avg price"
  )
  ggsave(paste(region, "pdf", sep="."))
}
