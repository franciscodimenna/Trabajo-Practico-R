### Trábajo práctico N°1

### En primer lugar, ejecutamos todas las librerías que usaremos a lo largo del trabajo
set.seed(123)
library(ggplot2)
library(patchwork)
library(readr) 
library(tidyverse) 
### Usamos el comando suppressWarnigns para que no los salgan avisos de potenciales NA
### a lo largo del trabajo eliminamos los potenciales NA
gapminder <- suppressWarnings(
  read_csv("C:/Users/alepa/OneDrive/Escritorio/Valentin/LAB/TP R/gapminder.csv") ### Leemos el dataset
)
View(gapminder) ### Chequeamos que la lectura del dataset se haya realizado de manera correcta 

### Parte 1

### Inciso 1

argentina <- gapminder %>%  
  filter(country == "Argentina")%>% ### Aca creamos otro dateset donde almacenamos 
                                    ### toda la información sobre Argentina
  
  mutate(year=as.numeric(year)) ### Aca nos aseguramos que year este en formato numérico 
                                ### evitando el surgimiento de posible NA
 
View(argentina) ### Chequeamos que la línea anterior haya guardado los datos que buscabamos 

### Gráfico de evolución del ingreso por persona
ggplot(argentina, aes(x = year, y = income_per_person)) +
  geom_line(color = "blue", linewidth = 1) +
  labs(
    title = "Evolución del ingreso per cápita en Argentina",
    x = "Año",
    y = "Ingreso por persona"
  ) 

### Inciso 2
### Separamos a los datos de Argentina según lo pedido en la consigna entre Train y Test

train_arg <- head(argentina, -10) ### todos los años excepto los últimos 10 
test_arg <- tail(argentina, 10)   ### los últimos 10 años

### Chequeamos que la división haya sido realizada correctamente
View(train_arg)
View(test_arg)

### A continuación corremos tres regresiones donde en todas la variable 
### independiente es income_per_person y la única variable explicativa es el año
### En lo que las regresiones es que la primera es linea, la segunda de grado 2
### y la última de grado 10

# Modelo lineal 
modelo_lineal <- lm(income_per_person ~ year, data = train_arg)
summary(modelo_lineal) ### Aqui obtenemos un resumen de los datos más relevantes de la regresión

# Modelo polinómico de grado 2 
modelo_pol_2 <- lm(income_per_person ~ poly(year, 2), data = train_arg)
summary(modelo_pol_2) ### Aqui obtenemos un resumen de los datos más relevantes de la regresión

# Modelo polinómico grado 10
modelo_pol_10 <- lm(income_per_person ~ poly(year, 10), data = train_arg)
summary(modelo_pol_10) ### Aqui obtenemos un resumen de los datos más relevantes de la regresión

pred1 <- predict(modelo_lineal, newdata=test_arg)
pred2 <- predict(modelo_pol_2, newdata=test_arg)
pred3 <- predict(modelo_pol_10, newdata=test_arg)

### Estas tres últimas lineas del código realizan las predicciones 
### de los 3 modelos anteriormente mencionados utilizando como datos
### los almacenados en el dataset test_arg

test_arg <- test_arg %>%
  mutate(
    pred_lineal = pred1,     ### Agregamos las preddciones obtenidas en el dataset train_arg
    pred_pol2   = pred2,
    pred_pol10  = pred3
  )

### Graficamos los resultados obtenidos 
ggplot(train_arg, aes(x = year, y = log(income_per_person))) +  
  # Datos reales (train)
  geom_point(color = "black", alpha = 0.7) +
  geom_line(color = "black", alpha = 0.6) +
  
  # Ajustes en train
  geom_line(aes(y = log(predict(modelo_lineal, newdata = train_arg)), color = "Lineal"), linewidth = 1) +
  geom_line(aes(y = log(predict(modelo_pol_2, newdata = train_arg)), color = "Polinomio grado 2"), 
            linewidth = 1, linetype = "dashed") +
  geom_line(aes(y = log(predict(modelo_pol_10, newdata = train_arg)), color = "Polinomio grado 10"), 
            linewidth = 1, linetype = "dotted") +
  
  # Datos de test (naranja)
  geom_point(data = argentina, aes(x = year, y = log(income_per_person), shape = "Datos"),   
             color = "orange", size = 3) +
  
  # Predicciones en test
  geom_line(data = test_arg, aes(x = year, y = log(pred_lineal), color = "Lineal"), linewidth = 1) +
  geom_line(data = test_arg, aes(x = year, y = log(pred_pol2), color = "Polinomio grado 2"), 
            linewidth = 1, linetype = "dashed") +
  geom_line(data = test_arg, aes(x = year, y = log(pred_pol10), color = "Polinomio grado 10"), 
            linewidth = 1, linetype = "dotted") +
  
  # Etiquetas
  labs(
    title = "Modelos de regresión sobre el logaritmo del ingreso per cápita en Argentina",
    x = "Año",
    y = "Logaritmo del ingreso per capita",
    shape = ""
  ) +
  
  # Tema
  scale_color_manual(values = c("Lineal" = "blue", "Polinomio grado 2" = "red", "Polinomio grado 10" = "green")) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 16, color = "#2E86AB"),
    plot.subtitle = element_text(size = 12, color = "gray40"),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom"
  )



### Inciso 3
### Seleccionamos 4 paises sudamericanos distintos a Argentina 
### y los alacenamos en paises 
paises <- c( "Chile", "Peru", "Uruguay", "Brazil")

### Creamos un nuevo dataset sudam donde almacenamos 
### datos sobre el ingreso per cápita a lo largo del 
### tiempo para los paises seleccionados 
sudam <- gapminder %>%
  filter(country %in% paises) %>%
  mutate(
    year = as.numeric(year),
    income_per_person = as.numeric(income_per_person)
  ) %>%
  arrange(country, year)
### Reorganizamos en formato ancho
ingresos <- sudam %>%
  select(country, year, income_per_person) %>%
  pivot_wider(names_from = country, values_from = income_per_person)

### Calculamos la matriz de correlaciones
cor_ingresos <- cor(ingresos %>% select(-year), use = "pairwise.complete.obs")
print(cor_ingresos)


### Calculamos la tasa de crecimiento interanual 
### en términos porcentuales 
sudam <- sudam %>%
  group_by(country) %>%
  arrange(year) %>%
  mutate(growth = (income_per_person / lag(income_per_person) - 1) * 100) %>%
  ungroup()

### Reorganizamos en formato ancho para correlación
crecimiento <- sudam %>%
  select(country, year, growth) %>%
  pivot_wider(names_from = country, values_from = growth)

### Matriz de correlaciones de tasas de crecimiento
cor_crecimiento <- cor(crecimiento %>% select(-year), use = "pairwise.complete.obs")
print(cor_crecimiento)


### Parte 2
### Inciso 5    
gapminder_2010 <- gapminder %>% ### Creamos un nuevo dataset que contenga la información sobre el año 2010
  filter(year == 2010) %>%
  mutate(
    life_expectancy = as.numeric(life_expectancy), ### Aca nos aseguramos que life_expentacy este en formato numérico
    life_expectancy_female = suppressWarnings(as.numeric(life_expectancy_female)) ### Aca nos aseguramos que life_expentacy_female este en formato numérico
  ) %>%                                                                           
  na.omit() ### Con esta línea de código omitimos los valores vacios

### Graficamos
ggplot(gapminder_2010, aes(x = life_expectancy, y = life_expectancy_female)) +
  geom_point(color = "orange", alpha = 0.7, size = 2) +
  geom_smooth(method = "lm")+  ### Aca le agremamos una linea de tendencia para complementar nuestro análisis
  labs(
    title = "Relación entre expectativa de vida y expectativa de vida femenina (2010)",
    x = "Expectativa de vida",
    y = "Expectativa de vida de las mujeres"
  ) +
  scale_x_continuous(limits = c(30, 110), breaks = seq(30, 110, 10)) +
  scale_y_continuous(limits = c(30, 110), breaks = seq(30, 110, 10)) +
  coord_equal() +   
  theme_minimal()

### Inciso 6
### Aca correremos una regresión lineal simple de life_expectancy sobre life_expectancy_female 

regresion_1 <-  lm(life_expectancy ~ life_expectancy_female, data = gapminder_2010) ### Con el comando lm corremos una regresión lineasl
                                                                                    ### simple con los datos proporcionados

summary(regresion_1) ### Esta línea nos devuelve un resumen de los datos de la regresión corrida anteriormente 

### Graficamos la recta que obtenemos de la regresion_1
ggplot(gapminder_2010, aes(x=life_expectancy_female, y=life_expectancy))+geom_point(size=1,color="red")+geom_smooth(method="lm", color="blue")+labs()

### Inciso 7

# Nos aseguramos de que las variables sean tratadas como numéricas
gapminder_2010 <- gapminder %>%
  filter(year == 2010) %>%
  mutate(
    life_expectancy = as.numeric(life_expectancy),
    life_expectancy_female = suppressWarnings(as.numeric(life_expectancy_female)),
    diff = life_expectancy_female - life_expectancy
  ) %>%
  na.omit() ### Aca omitimos los NA de manera que no alteren nuestro análisis

# Test t de una muestra sobre la diferencia
t_test_res <- t.test(gapminder_2010$diff, mu = 0, alternative = "greater")

print(t_test_res) ### Printeamos los resultados obtenidos 

### Inciso 8
### Corremos una regresión múltiple sobre life_expectancy utilizando como variables
### explicativas a life_expectancy_female y income_per_person
regresion_2 <- lm(life_expectancy ~ life_expectancy_female + income_per_person, 
                   data = gapminder_2010)
### Printeamos los resultados de regresion_2
summary(regresion_2)

# Ajustamos los dos modelos
reg_simple <- lm(life_expectancy ~ life_expectancy_female, data = gapminder_2010)
reg_multiple <- lm(life_expectancy ~ life_expectancy_female + income_per_person, 
                   data = gapminder_2010)

# Guardamos los valores ajustados en el dataset
gapminder_2010 <- gapminder_2010 %>%
  mutate(
    fitted_simple = fitted(reg_simple),
    fitted_multiple = fitted(reg_multiple)
  )

# Gráfico 1: Modelo simple
g1 <- ggplot(gapminder_2010, aes(x = life_expectancy, y = fitted_simple)) +
  geom_point(color = "steelblue", alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Modelo simple: Ajuste de la esperanza de vida",
    subtitle = "life_expectancy ~ life_expectancy_female",
    x = "Esperanza de vida observada",
    y = "Esperanza de vida ajustada"
  ) +
  coord_equal() +
  theme_minimal()

# Gráfico 2: Modelo múltiple
g2 <- ggplot(gapminder_2010, aes(x = life_expectancy, y = fitted_multiple)) +
  geom_point(color = "darkgreen", alpha = 0.7) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Modelo múltiple: Ajuste de la esperanza de vida",
    subtitle = "life_expectancy ~ life_expectancy_female + income_per_person",
    x = "Esperanza de vida observada",
    y = "Esperanza de vida ajustada"
  ) +
  coord_equal() +
  theme_minimal()

### Aca utilizamos la libreria patchwork la cual nos permite mostrar ambos gráficos a la vez
library(patchwork)
g1 + g2

### Inciso 9
gapminder_2010 <- gapminder %>% ### Trabajamos sobre gapminder_2010 de manera tal que 
  filter(year == 2010) %>%      ### tome a las variables de nuestro interes como numeros
  mutate(
    child_mortality = as.numeric(child_mortality),
    life_expectancy_male = as.numeric(life_expectancy_male),
  ) %>%
  na.omit() ### Aca omitimos los NA 

### Corremos una regresión múltiple sobre life_expectancy utilizando como variables
### explicativas a income_per_person, child_mortality y children_per_woman
modelo_vida <- lm(life_expectancy ~ income_per_person + child_mortality + children_per_woman,
                  data = gapminder_2010)
### Printeamos los resultados obtenidos de modelo_vida
summary(modelo_vida)

### Quitamos children_per_woman dado que nos dio no significativo
modelo_vida_corregido <- lm(life_expectancy ~ income_per_person + child_mortality + life_expectancy_male,
                  data = gapminder_2010)
### Printeamos los resultados obtenidos de la regresión corrida anteriormente
summary(modelo_vida_corregido)

### Quitamos income_per_person dado que nos dio no significativo 
modelo_vida_corregido_2 <- lm(life_expectancy ~  child_mortality + life_expectancy_male,
                            data = gapminder_2010)
### Mostramos los resultados de la regresión
summary(modelo_vida_corregido_2)











