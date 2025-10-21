# Ejercicio 4 - Simulación del TEG en R

Este proyecto implementa una simulación de batallas del juego TEG (Táctica y Estrategia de la Guerra) utilizando el lenguaje R.  
El objetivo es analizar las probabilidades de victoria del atacante cuando ambos jugadores comienzan con la misma cantidad de fichas.

---

## Estructura del proyecto

El repositorio contiene tres archivos principales:

1. informe.pdf → Documento explicativo con la descripción completa del código y el análisis de resultados.  
2. Ejercicio4_TEG.R → Archivo con el código en R que contiene las funciones del modelo.  
3. README.md → Este archivo, con las instrucciones y detalles del proyecto.

---

## Funciones principales del código

1. resultado_ataque(dados_atacante, dados_defensor)  
   Simula una única tirada de dados entre atacante y defensor.  
   - El atacante tira hasta 3 dados (dejando siempre 1 ficha sin atacar).  
   - El defensor tira hasta 3 dados, según sus fichas disponibles.  
   - Los dados se ordenan y comparan uno a uno.  
   - Los empates favorecen al defensor.  
   - Devuelve un vector con las pérdidas de cada jugador.

2. simular_batalla(fichas_atacante, fichas_defensor, verbose = TRUE)  
   Simula una batalla completa repitiendo tiradas hasta que uno de los dos no pueda continuar.  
   - El atacante deja de atacar si solo le queda una ficha.  
   - El defensor pierde si se queda sin fichas.  
   - Si verbose = TRUE, muestra las rondas de la batalla en consola.  
   - Devuelve las fichas finales de cada jugador.

3. probabilidad_ataque()  
   Simula múltiples batallas (por defecto, 1000) para estimar la probabilidad de victoria del atacante.  
   - Se considera victoria del atacante cuando el defensor termina con 0 fichas.  
   - Muestra el progreso cada 100 simulaciones.  
   - Devuelve la probabilidad estimada.

---

## Ejemplo de uso

```r
# Cargar las funciones
source("Ejercicio4_TEG.R")

# Simular una batalla
simular_batalla(5, 5)

# Calcular probabilidad de victoria del atacante con 1000 simulaciones
probabilidad_ataque(1000)
```

---

## Resultados y conclusiones

A partir de las simulaciones (1000 repeticiones con 5 fichas por jugador), se obtuvo que la probabilidad de victoria del atacante es aproximadamente 0.2 (20%).

Esto refleja que, aunque el atacante puede tirar más dados, el desempate siempre favorece al defensor, y además el atacante debe dejar una ficha sin atacar, lo que le da una desventaja estructural.  
Por lo tanto, en igualdad de condiciones (5 vs 5), el atacante gana solo una de cada cinco batallas.

---

## Autor

Francisco Di Menna, Valentin Paniagua, Lorenzo Lavieri y Tomas Ripoll Brandoni
Universidad Torcuato Di Tella  
Fecha de entrega: 20/10/2025
