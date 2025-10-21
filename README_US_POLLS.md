#️ US Polls – Análisis de encuestas electorales (EE.UU. 2024)

Este proyecto analiza la **precisión de las encuestas electorales** en Estados Unidos antes de las elecciones presidenciales de 2024.  
Utiliza un dataset con información sobre el tamaño de muestra, metodología, fechas de campo y porcentajes de voto estimados para candidatos demócrata y republicano.  
El objetivo es identificar qué factores explican las diferencias entre los resultados de las encuestas y los resultados reales.

---

## Estructura del proyecto

- **`informe.pdf`** → Documento con el desarrollo metodológico y la interpretación de los resultados.  
- **`us_polls.R`** → Código en R con los modelos y gráficos.  
- **`polls.csv`** → Dataset original con los datos de encuestas.  
- **`README.md`** → Este archivo, con la descripción general del proyecto.

---

## Variables principales

| Variable | Descripción |
|-----------|--------------|
| `dem` / `rep` | Porcentaje estimado de votos demócratas y republicanos. |
| `sample_size` | Tamaño de la muestra (número de casos). |
| `end_date` | Fecha de finalización del trabajo de campo. |
| `methodology` | Tipo de recolección (teléfono, online, mixto, etc.). |
| `error_abs` | Error absoluto entre el resultado real y la encuesta. |
| `days_to_election` | Días restantes hasta la elección. |
| `log_sample` | Logaritmo del tamaño muestral. |

---

## Preguntas de investigación

1. **¿Cómo influye el tamaño de la muestra en la precisión?**  
   → Se analiza si aumentar el tamaño reduce el error, considerando rendimientos decrecientes.

2. **¿Cómo afecta la recencia (días hasta la elección) a la precisión?**  
   → Se evalúa si las encuestas más cercanas al día de votación son más exactas.

3. **¿Qué rol cumple la metodología de recolección?**  
   → Se comparan los distintos métodos mediante promedios, varianzas y una regresión categórica.

---

##️ Modelos estimados

```r
# Modelo tamaño muestral (con efecto cuadrático)
lm(error_abs ~ log_sample + I(log_sample^2), data = polls)

# Modelo recency
lm(error_abs ~ days_to_election, data = polls)

# Modelo metodología
lm(error_abs ~ methodology, data = polls)

```

---

## Principales resultados

- **Tamaño muestral:** el error disminuye al aumentar la muestra, pero con **rendimientos decrecientes** (efecto cuadrático positivo).  
- **Recency:** las encuestas más cercanas a la elección son **significativamente más precisas**.  
- **Metodología:** los promedios y las varianzas de los erores absolutos junto con la regresión confirman diferencias significativas; las encuestas **mixtas y digitales** presentan menor error promedio. 

---

## Conclusión general

La precisión de las encuestas electorales depende simultáneamente del **tamaño de la muestra**, la **proximidad temporal** a la elección y la **metodología de recolección**.  
Las encuestas más recientes, con tamaños muestrales moderados y estrategias mixtas de contacto (texto, web y panels online), ofrecen estimaciones más confiables del resultado real.  
Estos hallazgos confirman que los factores metodológicos y de diseño tienen un impacto directo sobre la calidad predictiva de las encuestas electorales.

---

## Autor

Francisco Di Menna, Valentin Paniagua, Lorenzo Lavieri y Tomas Ripoll Brandoni
Universidad Torcuato Di Tella  
Fecha: 20/10/2025
