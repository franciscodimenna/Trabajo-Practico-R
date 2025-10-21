
set.seed(7)


#1
# Esta función simula una tirada de dados entre el atacante y el defensor
# Devuelve cuántas fichas pierde cada uno en una ronda.
resultado_ataque <- function(dados_atacante, dados_defensor) {
  
  # Se tiran los dados del atacante y del defensor (números entre 1 y 6)
  # Se ordenan en orden descendente (el dado más alto primero)
  dados_atacante <- sort(sample(1:6, dados_atacante, replace = TRUE), decreasing = TRUE)
  dados_defensor <- sort(sample(1:6, dados_defensor, replace = TRUE), decreasing = TRUE)
  
  # Inicializamos las pérdidas de cada jugador
  perdidas_atacante <- 0
  perdidas_defensor <- 0
  
  # Se comparan los dados de a pares, hasta el menor número de dados tirados
  comparaciones <- min(length(dados_atacante), length(dados_defensor))
  
  # Bucle para comparar cada dado
  for (i in 1:comparaciones) {
    # Si el dado del atacante es mayor, el defensor pierde una ficha
    if (dados_atacante[i] > dados_defensor[i]) {
      perdidas_defensor <- perdidas_defensor + 1
    } else {
      # En caso contrario (incluye empate), pierde el atacante
      perdidas_atacante <- perdidas_atacante + 1
    }
  }
  
  # Devuelve un vector con las pérdidas
  return(c(perdidas_atacante, perdidas_defensor))
}



#2
# Esta función simula una batalla completa
simular_batalla <- function(fichas_atacante, fichas_defensor, verbose = TRUE) {
  ronda <- 1
  
  # Mientras el atacante tenga más de una ficha y el defensor tenga al menos una
  while (fichas_atacante > 1 && fichas_defensor > 0) {
    
    # Se determina cuántos dados tiran en esta ronda:
    # El atacante puede tirar hasta 3, pero debe dejar una ficha sin atacar.
    dados_atacante <- min(3, fichas_atacante - 1)
    
    # El defensor puede tirar hasta 3 dados, o menos si tiene menos fichas.
    dados_defensor <- min(3, fichas_defensor)
    
    # Se ejecuta una ronda de ataque
    resultado <- resultado_ataque(dados_atacante, dados_defensor)
    
    # Se actualizan las fichas según las pérdidas
    fichas_atacante <- fichas_atacante - resultado[1]
    fichas_defensor <- fichas_defensor - resultado[2]
    
    if (verbose) {
      cat("Ronda", ronda, "→ fichas atacante:", fichas_atacante,
          "| fichas defensor:", fichas_defensor, "\n")
    }
    ronda <- ronda + 1
  }
  
  # Al finalizar la batalla, se muestra el resultado final 
  if (verbose) {
    cat("Batalla terminada → Resultado final:",
        "Atacante =", fichas_atacante, "| Defensor =", fichas_defensor, "\n\n")
  }
  
  # Devuelve el número final de fichas de cada jugador
  return(c(fichas_atacante, fichas_defensor))
}



#3
# Esta función simulara 1000 veces y calcula la probabilidad de que el atacante gane.
probabilidad_ataque <- function(simulaciones = 1000) {
  
  # Contador de victorias del atacante
  victorias_atacante <- 0
  
  # Bucle para repetir la simulación "simulaciones" veces
  for (i in 1:simulaciones) {
    
    # Cada simulación comienza con 5 fichas por jugador
    resultado_final <- simular_batalla(5, 5, verbose = FALSE)
    
    # Si el defensor pierde todas sus fichas, gana el atacante
    if (resultado_final[2] == 0) {
      victorias_atacante <- victorias_atacante + 1
    }
    
    # Cada 100 simulaciones, se muestra el progreso
    if (i %% 100 == 0) {
      cat("Simulación", i, "→ victorias atacante:", victorias_atacante, "\n")
    }
  }
  
  # Devuelve la proporción de victorias del atacante (probabilidad estimada)
  return(victorias_atacante / simulaciones)
}


#prueba

# Estimamos la probabilidad de victoria del atacante en 1000 batallas (5 vs 5)
probabilidad_ataque()

# Simulamos una batalla individual para ver el desarrollo ronda a ronda
simular_batalla(5,5)
