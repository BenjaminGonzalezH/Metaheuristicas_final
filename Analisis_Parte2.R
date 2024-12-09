################ Libraries.
library(ggplot2)
library(dplyr)
library(tidyr)

################ WorkSpaces.

setwd("C:/Users/Benjamin Gonzalez/Desktop/Workspace/Metaheuristicas_final/Results/Experimentals/Parte2_P")

################
# Diversity.
################

Diversity_GA1 <- read.csv("DiversityOXc.txt")
Diversity_GA2 <- read.csv("DiversityOXe.txt")
Diversity_GA3 <- read.csv("DiversityPBXc.txt")
Diversity_GA4 <- read.csv("DiversityPBXe.txt")
Diversity_GA5 <- read.csv("DiversityPMXc.txt")
Diversity_GA6 <- read.csv("DiversityPMXe.txt")

Diversity_GA1 <- Diversity_GA1 %>% mutate(x = 1:n(), Valor = mean, Metodo = "OXc")
Diversity_GA2 <- Diversity_GA2 %>% mutate(x = 1:n(), Valor = mean, Metodo = "OXe")
Diversity_GA3 <- Diversity_GA3 %>% mutate(x = 1:n(), Valor = mean, Metodo = "PBXc")
Diversity_GA4 <- Diversity_GA4 %>% mutate(x = 1:n(), Valor = mean, Metodo = "PBXe")
Diversity_GA5 <- Diversity_GA5 %>% mutate(x = 1:n(), Valor = mean, Metodo = "PMXc")
Diversity_GA6 <- Diversity_GA6 %>% mutate(x = 1:n(), Valor = mean, Metodo = "PMXe")

##############################
# Unir todos los DataFrames en uno solo
##############################
df_diversity_filtered <- df_diversity %>% 
  group_by(Metodo) %>% 
  slice_head(n = 200) %>% 
  ungroup()

##############################
# Graficar la diversidad para cada método
##############################
ggplot(df_diversity_filtered, aes(x = x, y = mean, color = Metodo)) +
  geom_line(size = 1.2) + 
  labs(
    title = "Diversidad de diferentes métodos (primeras 200 generaciones)",
    x = "Generaciones",
    y = "Kendall tau Distance"
  ) +
  theme_minimal() +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom"
  )


################
# Convergencia.
################

Converge_SA <- read.csv("TS_converge_38.csv")

Converge_GA_1 <- read.csv("GAcPMXswp_converge_38.csv")
Converge_GA_2 <- read.csv("GAcOXin_converge_38.csv")
Converge_GA_3 <- read.csv("GAcPBXscr_converge_38.csv")
Converge_GA_4 <- read.csv("GAePMXswp_converge_38.csv")
Converge_GA_5 <- read.csv("GAeOXin_converge_38.csv")
Converge_GA_6 <- read.csv("GAePBXscr_converge_38.csv")

################
# Resultados.
################
Caso_GA_11 <- read.csv("GAe_PMX_swp_results_38_80000.txt",header = FALSE)
Caso_GA_12 <- read.csv("GAe_PMX_swp_results_76_80000.txt",header = FALSE)
Caso_GA_13 <- read.csv("GAe_PMX_swp_results_194_80000.txt",header = FALSE)

Caso_GA_21 <- read.csv("GAe_OX_inv_results_38_80000.txt", header = FALSE)
Caso_GA_22 <- read.csv("GAe_OX_inv_results_76_80000.txt", header = FALSE)
Caso_GA_23 <- read.csv("GAe_OX_inv_results_194_80000.txt", header = FALSE)

Caso_GA_31 <- read.csv("GAe_PBX_scr_results_38_80000.txt", header = FALSE)
Caso_GA_32 <- read.csv("GAe_PBX_scr_results_76_80000.txt", header = FALSE)
Caso_GA_33 <- read.csv("GAe_PBX_scr_results_194_80000.txt", header = FALSE)

Caso_GA_41 <- read.csv("GAc_PMX_sw_results_38_80000.txt",header = FALSE)
Caso_GA_42 <- read.csv("GAc_PMX_sw_results_76_80000.txt",header = FALSE)
Caso_GA_43 <- read.csv("GAc_PMX_sw_results_194_80000.txt",header = FALSE)

Caso_GA_51 <- read.csv("GAc_OX_inv_results_38_80000.txt", header = FALSE)
Caso_GA_52 <- read.csv("GAc_OX_inv_results_76_80000.txt", header = FALSE)
Caso_GA_53 <- read.csv("GAc_OX_inv_results_194_80000.txt", header = FALSE)

Caso_GA_61 <- read.csv("GAc_PBX_scr_results_38_80000.txt", header = FALSE)
Caso_GA_62 <- read.csv("GAc_PBX_scr_results_76_80000.txt", header = FALSE)
Caso_GA_63 <- read.csv("GAc_PBX_scr_results_194_80000.txt", header = FALSE)

Caso_TS_1 <- read.csv("TS_results_38_80000.txt",header = FALSE)
Caso_TS_2 <- read.csv("TS_results_76_80000.txt",header = FALSE)
Caso_TS_3 <- read.csv("TS_results_194_80000.txt",header = FALSE)


df_38 <- bind_rows(
  data.frame(Caso = "GAcPMX-swp", Error = Caso_GA_11$V2),
  data.frame(Caso = "GAcOX-inv", Error = Caso_GA_21$V2),
  data.frame(Caso = "GAcPBX-scr", Error = Caso_GA_31$V2),
  data.frame(Caso = "GAePMX-swap", Error = Caso_GA_41$V2),
  data.frame(Caso = "GAeOX-inv", Error = Caso_GA_51$V2),
  data.frame(Caso = "GAePBX-scr", Error = Caso_GA_61$V2),
  data.frame(Caso = "TS", Error = Caso_TS_1$V2)
)

df_76 <- bind_rows(
  data.frame(Caso = "GAcPMX-swp", Error = Caso_GA_12$V2),
  data.frame(Caso = "GAcOX-inv", Error = Caso_GA_22$V2),
  data.frame(Caso = "GAcPBX-scr", Error = Caso_GA_32$V2),
  data.frame(Caso = "GAePMX-swap", Error = Caso_GA_42$V2),
  data.frame(Caso = "GAeOX-inv", Error = Caso_GA_52$V2),
  data.frame(Caso = "GAePBX-scr", Error = Caso_GA_62$V2),
  data.frame(Caso = "TS", Error = Caso_TS_2$V2)
)

df_194 <- bind_rows(
  data.frame(Caso = "GAcPMX-swp", Error = Caso_GA_13$V2),
  data.frame(Caso = "GAcOX-inv", Error = Caso_GA_23$V2),
  data.frame(Caso = "GAcPBX-scr", Error = Caso_GA_33$V2),
  data.frame(Caso = "GAePMX-swap", Error = Caso_GA_43$V2),
  data.frame(Caso = "GAeOX-inv", Error = Caso_GA_53$V2),
  data.frame(Caso = "GAePBX-scr", Error = Caso_GA_63$V2),
  data.frame(Caso = "TS", Error = Caso_TS_3$V2)
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

################
# Gráfico convergencia GA.
################
# Lista.
Converge_GA_list_1 <- split(Converge_GA_1, Converge_GA_1$Iteration)
Converge_GA_list_2 <- split(Converge_GA_2, Converge_GA_2$Iteration)
Converge_GA_list_3 <- split(Converge_GA_3, Converge_GA_3$Iteration)
Converge_GA_list_4 <- split(Converge_GA_4, Converge_GA_4$Iteration)
Converge_GA_list_5 <- split(Converge_GA_5, Converge_GA_5$Iteration)
Converge_GA_list_6 <- split(Converge_GA_6, Converge_GA_6$Iteration)

# Elementos a mostrar.
inicio <- 0
fin <- 75

# Filtrar el dataframe para obtener las iteraciones dentro del rango especificado
df_filtrado_1 <- Converge_GA_1 %>%
  filter(Iteration >= inicio & Iteration <= fin) %>%
  arrange(Iteration)
df_filtrado_2 <- Converge_GA_2 %>%
  filter(Iteration >= inicio & Iteration <= fin) %>%
  arrange(Iteration)
df_filtrado_3 <- Converge_GA_3 %>%
  filter(Iteration >= inicio & Iteration <= fin) %>%
  arrange(Iteration)
df_filtrado_4 <- Converge_GA_4 %>%
  filter(Iteration >= inicio & Iteration <= fin) %>%
  arrange(Iteration)
df_filtrado_5 <- Converge_GA_5 %>%
  filter(Iteration >= inicio & Iteration <= fin) %>%
  arrange(Iteration)
df_filtrado_6 <- Converge_GA_6 %>%
  filter(Iteration >= inicio & Iteration <= fin) %>%
  arrange(Iteration)

# Graficar boxplot para 'Error' por cada 'iteration'
ggplot(df_filtrado_1, aes(x = factor(Iteration), y = Error)) +
  geom_boxplot(aes(fill = factor(Iteration)), alpha = 0.7) + 
  labs(
    title = "Gráfico de convergencia GA clásico PMX-swaping",
    x = "Iteración",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(df_filtrado_2, aes(x = factor(Iteration), y = Error)) +
  geom_boxplot(aes(fill = factor(Iteration)), alpha = 0.7) + 
  labs(
    title = "Gráfico de convergencia GA clásico OX-invertion",
    x = "Iteración",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(df_filtrado_3, aes(x = factor(Iteration), y = Error)) +
  geom_boxplot(aes(fill = factor(Iteration)), alpha = 0.7) + 
  labs(
    title = "Gráfico de convergencia GA clásico PBX-scramble(Shuffle)",
    x = "Iteración",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(df_filtrado_4, aes(x = factor(Iteration), y = Error)) +
  geom_boxplot(aes(fill = factor(Iteration)), alpha = 0.7) + 
  labs(
    title = "Gráfico de convergencia GA celular PMX-swaping",
    x = "Iteración",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(df_filtrado_5, aes(x = factor(Iteration), y = Error)) +
  geom_boxplot(aes(fill = factor(Iteration)), alpha = 0.7) + 
  labs(
    title = "Gráfico de convergencia GA celular OX-invertion",
    x = "Iteración",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

ggplot(df_filtrado_6, aes(x = factor(Iteration), y = Error)) +
  geom_boxplot(aes(fill = factor(Iteration)), alpha = 0.7) + 
  labs(
    title = "Gráfico de convergencia GA celular PBX-scramble(Shuffle)",
    x = "Iteración",
    y = "Error"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

################
# Prueba Normal.
################

resultado_shapiro <- shapiro.test(Caso_GA_11$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_21$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_31$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_41$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_51$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_61$V2)
print(resultado_shapiro)

resultado_shapiro <- shapiro.test(Caso_GA_12$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_22$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_32$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_42$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_52$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_62$V2)
print(resultado_shapiro)

resultado_shapiro <- shapiro.test(Caso_GA_13$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_23$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_33$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_43$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_53$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_GA_63$V2)
print(resultado_shapiro)

resultado_shapiro <- shapiro.test(Caso_TS_1$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_TS_2$V2)
print(resultado_shapiro)
resultado_shapiro <- shapiro.test(Caso_TS_3$V2)
print(resultado_shapiro)

################
# Pruebas estadísticas.
################

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
    title = "P-valores ajustados de la prueba de Tukey HSD qa194",
    x = "Comparación de métodos",
    y = "P-valor ajustado"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


