################ Libraries.
library(ggplot2)
library(dplyr)
library(tidyr)

################ WorkSpaces
setwd("C:/Users/Benjamin Gonzalez/Desktop/Workspace/Metaheuristicas_final/Results/Experimentals")

################
# Converge.
################

Converge_HGA_1 <- read.csv("HGAc_ini_converge_38.csv")
Converge_HGA_3 <- read.csv("HGAc1_ini_converge_38.csv")

Converge_HGA_list_1 <- split(Converge_HGA_1, Converge_HGA_1$Iteration)
Converge_HGA_list_3 <- split(Converge_HGA_3, Converge_HGA_3$Iteration)

# Elementos a mostrar.
inicio <- 1270
fin <- 1277

# Filtrar el dataframe para obtener las iteraciones dentro del rango especificado
df_filtrado_1 <- Converge_HGA_1 %>%
  filter(Iteration >= inicio & Iteration <= fin) %>%
  arrange(Iteration)
df_filtrado_3 <- Converge_HGA_3 %>%
  filter(Iteration >= inicio & Iteration <= fin) %>%
  arrange(Iteration)

ggplot(df_filtrado_1, aes(x = factor(Iteration), y = Error)) +
  geom_boxplot(aes(fill = factor(Iteration)), alpha = 0.7) + 
  labs(
    title = "Gráfico de convergencia HGA clásico con GLS al inicio",
    x = "Iteración",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


ggplot(df_filtrado_3, aes(x = factor(Iteration), y = Error)) +
  geom_boxplot(aes(fill = factor(Iteration)), alpha = 0.7) + 
  labs(
    title = "Gráfico de convergencia HGA clasico con 2opt",
    x = "Iteración",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none")


############ Ejecuciones.

Caso_GA_21 <- read.csv("Parte2_P/GAe_OX_inv_results_38_80000.txt", header = FALSE)
Caso_GA_22 <- read.csv("Parte2_P/GAe_OX_inv_results_76_80000.txt", header = FALSE)
Caso_GA_23 <- read.csv("Parte2_P/GAe_OX_inv_results_194_80000.txt", header = FALSE)

Caso_GA_51 <- read.csv("Parte2_P/GAc_OX_inv_results_38_80000.txt", header = FALSE)
Caso_GA_52 <- read.csv("Parte2_P/GAc_OX_inv_results_76_80000.txt", header = FALSE)
Caso_GA_53 <- read.csv("Parte2_P/GAc_OX_inv_results_194_80000.txt", header = FALSE)

Caso_HGA_11 <- read.csv("HGAc_ini_results_38.txt")
Caso_HGA_12 <- read.csv("HGAc_ini_results_76.txt")
Caso_HGA_13 <- read.csv("HGAc_ini_results_194.txt")

Caso_HGA_21 <- read.csv("HGAc1_ini_results_38.txt")
Caso_HGA_22 <- read.csv("HGAc1_ini_results_76.txt")
Caso_HGA_23 <- read.csv("HGAc1_ini_results_194.txt")


df_38 <- bind_rows(
  data.frame(Caso = "GAe", Error = Caso_GA_21$V2),
  data.frame(Caso = "GAc", Error = Caso_GA_51$V2),
  data.frame(Caso = "GAcGLS", Error = Caso_HGA_11$Error),
  data.frame(Caso = "GAc2op", Error = Caso_HGA_21$Error),
)

df_76 <- bind_rows(
  data.frame(Caso = "GAe", Error = Caso_GA_22$V2),
  data.frame(Caso = "GAc", Error = Caso_GA_52$V2),
  data.frame(Caso = "GAcGLS", Error = Caso_HGA_12$Error),
  data.frame(Caso = "GAc2op", Error = Caso_HGA_22$Error),
)

df_194 <- bind_rows(
  data.frame(Caso = "GAe", Error = Caso_GA_23$V2),
  data.frame(Caso = "GAc", Error = Caso_GA_53$V2),
  data.frame(Caso = "GAcGLS", Error = Caso_HGA_13$Error),
  data.frame(Caso = "GAc2opt", Error = Caso_HGA_23$Error),
)

ggplot(df_38, aes(x = Caso, y = Error, fill = Caso)) +
  geom_boxplot(alpha = 0.7) + 
  labs(
    title = "Boxplots de Error normalizado dj38 (80.000 llamadas)",
    x = "Caso",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none", 
        axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1))


ggplot(df_76, aes(x = Caso, y = Error, fill = Caso)) +
  geom_boxplot(alpha = 0.7) + 
  labs(
    title = "Boxplots de Error normalizado pr76 (80.000 llamadas)",
    x = "Caso",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none", 
        axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(df_194, aes(x = Caso, y = Error, fill = Caso)) +
  geom_boxplot(alpha = 0.7) + 
  labs(
    title = "Boxplots de Error normalizado qa194 (80.000 llamadas)",
    x = "Caso",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none", 
        axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1))

################ normalidad

resultado_shapiro <- shapiro.test(Caso_GA_21$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_51$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_HGA_11$Error)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_HGA_21$Error)
print(resultado_shapiro)

resultado_shapiro <- shapiro.test(Caso_GA_22$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_52$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_HGA_12$Error)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_HGA_22$Error)
print(resultado_shapiro)

resultado_shapiro <- shapiro.test(Caso_GA_23$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_53$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_HGA_13$Error)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_HGA_23$Error)
print(resultado_shapiro)

anova_resultado <- aov(Error ~ Caso, data = df_38)
summary(anova_resultado)

anova_resultado <- aov(Error ~ Caso, data = df_76)
summary(anova_resultado)

anova_resultado <- aov(Error ~ Caso, data = df_194)
summary(anova_resultado)

tukey_resultado <- TukeyHSD(anova_resultado)
print(tukey_resultado)

tukey_resultado <- TukeyHSD(anova_resultado)

# Convertir el resultado de la prueba de Tukey a un DataFrame
tukey_df <- as.data.frame(tukey_resultado$Caso)
tukey_df$comparacion <- rownames(tukey_df)
rownames(tukey_df) <- NULL

# Visualizar la tabla de resultados de la prueba de Tukey
print(tukey_df)

##############################
# Graficar el intervalo de confianza de la diferencia de medias
##############################
ggplot(tukey_df, aes(x = comparacion, y = `p adj`, fill = `p adj` < 0.05)) +
  geom_bar(stat = "identity", color = "black") +
  geom_hline(yintercept = 0.05, linetype = "dashed", color = "red", linewidth = 1) + 
  scale_fill_manual(values = c("TRUE" = "red", "FALSE" = "steelblue")) +
  labs(
    title = "P-valores ajustados de la prueba de Tukey HSD pr76",
    x = "Comparación de métodos",
    y = "P-valor ajustado"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


