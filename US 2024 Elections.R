
set.seed(7)

library(tidyverse)
library(lubridate)
polls <- read.csv("polls.csv")



# Definir los resultados reales (valores oficiales)
real_dem <- 48.4   # % votos demócratas reales
real_rep <- 50.1   # % votos republicanos reales
real_gap = real_dem - real_rep

polls <- polls %>%
  mutate(
    gap = dem - rep,                 # margen en la encuesta
    error = gap - real_gap,          # diferencia entre encuesta y realidad
    error_abs = abs(error)           # error absoluto 
  )
names(polls)

#ANALISIS DE SAMPLE SIZE

#uso log sample
polls <- polls %>%
  mutate(log_sample = log(sample_size))

modelo_log_lin <- lm(error_abs ~ log_sample, data = polls)  #modelo lineal 
summary(modelo_log_lin)

modelo_log_quad <- lm(error_abs ~ log_sample + I(log_sample^2), data = polls) #modelo cuadratico (ajusta mejor)
summary(modelo_log_quad)


#ANALISIS DE RECENCY


election_day <- mdy("11/05/2024")  # 5 de nov de 2024


polls <- polls %>% #agrego la variable days to election 
  mutate(
    end_date_chr = trimws(as.character(end_date)),
    end_date = mdy(end_date_chr),                 
    days_to_election = as.numeric(election_day - end_date)
  )

cor(polls$days_to_election, polls$error_abs, use = "complete.obs") #analizo correlacion 

modelo_recency_lin <- lm(error_abs ~ days_to_election, data = polls) #utilizo regresion lineal 
summary(modelo_recency_lin)


#ANALISIS METODOLOGIA

table(polls$methodology)

aggregate(error_abs ~ methodology, data = polls, mean, na.rm = TRUE) #mean de los errores absolutos por metodo 

aggregate(error_abs ~ methodology, data = polls, sd, na.rm = TRUE) #desvio standard de los errores absolutos por metodo 

#por ultimo utilizo de vuelta una regresion usando como base el metodo "Online Panel"
polls$methodology <- as.factor(polls$methodology)
polls$methodology <- relevel(polls$methodology, ref = "Online Panel")
modelo_metodo <- lm(error_abs ~ methodology, data = polls)
summary(modelo_metodo)


