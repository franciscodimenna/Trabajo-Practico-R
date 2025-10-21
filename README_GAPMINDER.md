# Análisis econométrico con datos de Gapminder

### Trabajo Práctico N°1 – Universidad Torcuato Di Tella  
**Autor:** Francisco Di Menna  
**Fecha:** 20/10/2025  

---

## Descripción general

Este proyecto utiliza el dataset **Gapminder**, que contiene información sobre distintos países del mundo entre 1960 y 2010: ingreso per cápita, expectativa de vida, mortalidad infantil, población, religión, entre otros indicadores.  

El objetivo es realizar un **análisis econométrico y visual** para estudiar:  
1. La evolución del ingreso por persona en Argentina.  
2. Las correlaciones entre países sudamericanos.  
3. Las relaciones entre salud, expectativa de vida y desarrollo económico.

---

##️ Librerías utilizadas

```r
library(ggplot2)
library(patchwork)
library(readr)
library(tidyverse)
```

> Se incluye `suppressWarnings()` para evitar alertas por posibles valores `NA`.  
> Todos los datos vacíos se eliminaron mediante `na.omit()`.

---

## Parte 1 – Ingreso por persona

### Inciso 1 – Evolución del ingreso per cápita argentino
Se filtra el dataset para Argentina y se grafica la variable `income_per_person`.  
El gráfico muestra un **crecimiento de largo plazo** con **alta volatilidad macroeconómica**, destacando los períodos de expansión (1990-1998) y crisis (2001-2002).

```r
ggplot(argentina, aes(x = year, y = income_per_person)) +
  geom_line(color = "blue", linewidth = 1)
```

---

### Inciso 2 – Modelos de regresión

Se entrenan tres modelos predictivos sobre el ingreso per cápita:
- **Lineal:** tendencia general.  
- **Polinómico grado 2:** captura curvaturas y aceleraciones.  
- **Polinómico grado 10:** sobreajusta el ruido (overfitting).  

Los resultados muestran que el modelo de **grado 2** ofrece el mejor equilibrio entre ajuste y capacidad predictiva.

```r
modelo_lineal  <- lm(income_per_person ~ year, data = train_arg)
modelo_pol_2   <- lm(income_per_person ~ poly(year, 2), data = train_arg)
modelo_pol_10  <- lm(income_per_person ~ poly(year, 10), data = train_arg)
```

> La comparación entre train y test evidencia la disyuntiva **sesgo–varianza** típica del modelado econométrico.

---

### Inciso 3 – Correlaciones regionales

Se comparan los ingresos per cápita de **Chile, Perú, Uruguay y Brasil**.  
Las correlaciones entre niveles son **altas (≈ 0.85)**, indicando una tendencia común de largo plazo.  
Sin embargo, las correlaciones entre **tasas de crecimiento** son mucho menores, reflejando diferencias estructurales y de política macroeconómica.

```r
cor_ingresos <- cor(ingresos %>% select(-year), use = "pairwise.complete.obs")
cor_crecimiento <- cor(crecimiento %>% select(-year), use = "pairwise.complete.obs")
```

---

## Parte 2 – Expectativa de vida

### Inciso 5 – Relación entre expectativa de vida general y femenina

Se analiza el año 2010.  
El gráfico y la regresión muestran una **relación positiva fuerte**: los países con mayor expectativa femenina tienen mayor expectativa total.

```r
ggplot(gapminder_2010, aes(x = life_expectancy, y = life_expectancy_female)) +
  geom_point(color = "orange", alpha = 0.7) +
  geom_smooth(method = "lm")
```

---

### Inciso 6 – Regresión lineal simple

El modelo  
\[
\text{life_expectancy} = \alpha + \beta \cdot \text{life_expectancy_female} + \varepsilon
\]  
arroja un **coeficiente positivo y significativo**, con **R² = 0.86**, lo que confirma una relación casi proporcional entre ambas variables.

---

### Inciso 7 – Test t de diferencia

Se prueba si la expectativa de vida femenina es mayor que la total:

```r
t_test_res <- t.test(gapminder_2010$diff, mu = 0, alternative = "greater")
```

El resultado (t = 7.39, p < 0.001) rechaza la hipótesis nula:  
**las mujeres viven significativamente más que el promedio poblacional.**

---

### Inciso 8 – Regresión múltiple

Se incorpora el **ingreso per cápita** como nueva variable explicativa:

```r
regresion_2 <- lm(life_expectancy ~ life_expectancy_female + income_per_person, data = gapminder_2010)
```

El coeficiente de `income_per_person` no resulta significativo, mostrando que su efecto ya está captado por la expectativa de vida femenina.  
El R² se mantiene prácticamente igual.

---

### Inciso 9 – Determinantes múltiples de la esperanza de vida

Modelo con varias variables explicativas:

```r
modelo_vida <- lm(life_expectancy ~ income_per_person + child_mortality + children_per_woman, data = gapminder_2010)
```

- `income_per_person`: positivo pero no significativo.  
- `child_mortality`: **negativo y significativo** → menor mortalidad → mayor esperanza.  
- `children_per_woman`: no significativo.  

Tras refinar el modelo, la versión final:

```r
modelo_vida_corregido_2 <- lm(life_expectancy ~ child_mortality + life_expectancy_male, data = gapminder_2010)
```

obtuvo un **R² ajustado de 0.89**, siendo el modelo con mejor desempeño predictivo.

---

## Conclusión general

El trabajo evidencia cómo el uso de herramientas estadísticas y econométricas en R permite vincular los datos empíricos con fenómenos económicos y sociales.  
Los resultados muestran que:

- El **ingreso per cápita argentino** presenta tendencia creciente pero altamente volátil.  
- Las **economías sudamericanas** muestran correlaciones altas en niveles, pero divergencias en ciclos.  
- La **expectativa de vida femenina** es un predictor fuerte del bienestar general.  
- La **mortalidad infantil** y la **longevidad masculina** son los factores más robustos para explicar la esperanza de vida total.  

En conjunto, los hallazgos destacan la interdependencia entre crecimiento económico, desarrollo humano y salud pública.

---

## Autor

Francisco Di Menna, Valentin Paniagua, Lorenzo Lavieri y Tomas Ripoll Brandoni
Universidad Torcuato Di Tella  
Fecha: 20/10/2025

