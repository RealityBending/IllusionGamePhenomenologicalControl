#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#| message: false
#| warning: false

library(tidyverse)
library(ggdist)
library(ggside)
library(easystats)
library(patchwork)
library(psych)


# data_ppt <- read.csv("https://raw.githubusercontent.com/RealityBending/IllusionGamePhenomenologicalControl/refs/heads/main/data/rawdata_participants.csv")

data_ppt <- read.csv("C:/Users/asf25/Desktop/studies/IllusionGamePhenomenologicalControl/data/data_participants.csv")

# df <- read.csv("https://raw.githubusercontent.com/RealityBending/IllusionGamePhenomenologicalControl/refs/heads/main/data/data_participants.csv")  |>
  # group_by(Illusion_Type) |> 
  # mutate(Illusion_Side = sign(Illusion_Difference), 
  #   Illusion_Effect = ifelse(sign(Illusion_Strength) > 0, "Incongruent", "Congruent"),
  #   Task_Difficulty = abs(Illusion_Difference),
  #        Condition_Illusion = datawizard::categorize(
  #          Illusion_Strength, split="quantile", n_groups=4,
  #          labels=c("Congruent - Strong", "Congruent - Mild", "Incongruent - Mild", "Incongruent - Strong")),
  #        Condition_Difficulty = datawizard::categorize(Task_Difficulty, split="quantile", n_groups=2, labels=c("Hard", "Easy"))) |> 
  # ungroup() |>
  # mutate(
  #   Block = as.factor(Block),
  #   Illusion_Side = as.factor(Illusion_Side),
  #   Illusion_Effect = fct_relevel(as.factor(Illusion_Effect), "Incongruent", "Congruent")
  # ) 
  #  
    
#taken from illusion game international
data_ig <- read.csv("../data/data_IllusionGame.csv") |>
  group_by(Illusion_Type) |> 
  mutate(Illusion_Side = sign(Illusion_Difference), 
    Illusion_Effect = ifelse(sign(Illusion_Strength) > 0, "Incongruent", "Congruent"),
    Task_Difficulty = abs(Illusion_Difference),
      Condition_Illusion = case_when(
        Illusion_Effect == "Congruent" ~ "Congruent",
        Illusion_Effect == "Incongruent" & Illusion_Strength <= median(Illusion_Strength[Illusion_Effect == "Incongruent"], na.rm = TRUE) ~ "Mild",
        Illusion_Effect == "Incongruent" & Illusion_Strength > median(Illusion_Strength[Illusion_Effect == "Incongruent"], na.rm = TRUE) ~ "Strong"),
    Condition_Difficulty = datawizard::categorize(Task_Difficulty, split="quantile", n_groups=2, labels=c("Hard", "Easy"))) |> 
  ungroup() |>
  mutate(
    Block = as.factor(Block),
    Illusion_Side = as.factor(Illusion_Side),
    Illusion_Effect = fct_relevel(as.factor(Illusion_Effect), "Incongruent", "Congruent"),
    Response_Correct = as.factor(Response_Correct)
  ) 
#
#
#
#
#
#
#
#
#
#
#
data_ppt$pcs_tastescore <- rowMeans(data_ppt[grepl("taste", names(data_ppt))])
data_ppt$pcs_postsessionsuggetsion <- sqrt(data_ppt$pcs_urgepress * data_ppt$pcs_memorypress)
data_ppt$pcs <- rowMeans(data_ppt[, c("pcs_handslow", "pcs_mosquito", "pcs_magnetichands", "pcs_armrigidity", "pcs_tastescore", "pcs_postsessionsuggetsion", "pcs_armimmobile", "pcs_music", "pcs_negativehallucination", "pcs_amnesia")], na.rm = TRUE)
data_ppt$pcs_SD <- sd(data_ppt$pcs, na.rm = TRUE)

#
#
#
#

data_ppt |>
  select("pcs_handslow", "pcs_mosquito", "pcs_magnetichands", "pcs_armrigidity", "pcs_tastescore", "pcs_postsessionsuggetsion", "pcs_armimmobile", "pcs_music", "pcs_negativehallucination", "pcs_amnesia") |>
  psych::alpha()

#
#
#
#
#
#
#
#
#
#

Error_rate <- data_ig |>
  group_by(Participant, Illusion_Type, Condition_Illusion) |>
  summarise(
    incorrect_responses = sum(Response_Correct == "false", na.rm = TRUE),
    total_responses = n(),
    error_rate = (incorrect_responses / total_responses) * 100
  )

Error_rate

#
#
#
#
#
#
#
#
#
#

ER_ebbinghaus <- Error_rate |> filter(Illusion_Type == "Ebbinghaus")

ER_CongruentMild_ebbinghaus_BF <- BayesFactor::ttestBF(
  x = ER_ebbinghaus$error_rate[ER_ebbinghaus$Condition_Illusion == "Congruent"],
  y = ER_ebbinghaus$error_rate[ER_ebbinghaus$Condition_Illusion == "Mild"],
  paired = TRUE
)

ER_StrongMild_ebbinghaus_BF <- BayesFactor::ttestBF(
  x = ER_ebbinghaus$error_rate[ER_ebbinghaus$Condition_Illusion == "Mild"],
  y = ER_ebbinghaus$error_rate[ER_ebbinghaus$Condition_Illusion == "Strong"],
  paired = TRUE
)

#
#
#
#
#

ER_mullerlyer <- Error_rate |> filter(Illusion_Type == "MullerLyer")

ER_CongruentMild_mullerlye_BF <- BayesFactor::ttestBF(
  x = ER_mullerlyer$error_rate[ER_mullerlyer$Condition_Illusion == "Congruent"],
  y = ER_mullerlyer$error_rate[ER_mullerlyer$Condition_Illusion == "Mild"],
  paired = TRUE
)

ER_StrongMild_mullerlye_BF <- BayesFactor::ttestBF(
  x = ER_mullerlyer$error_rate[ER_mullerlyer$Condition_Illusion == "Mild"],
  y = ER_mullerlyer$error_rate[ER_mullerlyer$Condition_Illusion == "Strong"],
  paired = TRUE
)

#
#
#
#
#

ER_verticalhorizontal  <- Error_rate |> filter(Illusion_Type == "VerticalHorizontal")


ER_CongruentMild_vh_BF <- BayesFactor::ttestBF(
  x = ER_verticalhorizontal$error_rate[ER_verticalhorizontal$Condition_Illusion == "Congruent"],
  y = ER_verticalhorizontal$error_rate[ER_verticalhorizontal$Condition_Illusion == "Mild"],
  paired = TRUE
)

ER_StrongMild_vh_BF <- BayesFactor::ttestBF(
  x = ER_verticalhorizontal$error_rate[ER_verticalhorizontal$Condition_Illusion == "Mild"],
  y = ER_verticalhorizontal$error_rate[ER_verticalhorizontal$Condition_Illusion == "Strong"],
  paired = TRUE
)


#
#
#
#
#
#
#
#
#

IES <- data_ig |>
  group_by(Participant, Illusion_Type, Condition_Illusion) |>
  summarise(
    mean_RT = mean(RT[Response_Correct == "true"], na.rm = TRUE),  # Only calculate mean RT for correct responses
    correct_proportion = mean(Response_Correct == "true", na.rm = TRUE),  # Proportion of correct responses
    IES = mean_RT / correct_proportion  # Compute IES
  )

IES

#
#
#
#
#
#
#
#
#

IES_ebbinghaus <- IES |> filter(Illusion_Type == "Ebbinghaus")

BF_Congruent_vs_Mild_ebbinghaus <- BayesFactor::ttestBF(
  x = IES_ebbinghaus$IES[IES_ebbinghaus$Condition_Illusion == "Congruent"],
  y = IES_ebbinghaus$IES[IES_ebbinghaus$Condition_Illusion == "Mild"],
  paired = TRUE
)

BF_Mild_vs_Strong_ebbinghaus <- BayesFactor::ttestBF(
  x = IES_ebbinghaus$IES[IES_ebbinghaus$Condition_Illusion == "Mild"],
  y = IES_ebbinghaus$IES[IES_ebbinghaus$Condition_Illusion == "Strong"],
  paired = TRUE
)

#
#
#
#
#

IES_mullerlyer <- IES |> filter(Illusion_Type == "MullerLyer")

BF_Congruent_vs_Mild_mullerlyer <- BayesFactor::ttestBF(
  x = IES_mullerlyer$IES[IES_mullerlyer$Condition_Illusion == "Congruent"],
  y = IES_mullerlyer$IES[IES_mullerlyer$Condition_Illusion == "Mild"],
  paired = TRUE
)

BF_Mild_vs_Strong_mullerlyer <- BayesFactor::ttestBF(
  x = IES_mullerlyer$IES[IES_mullerlyer$Condition_Illusion == "Mild"],
  y = IES_mullerlyer$IES[IES_mullerlyer$Condition_Illusion == "Strong"],
  paired = TRUE
)

#
#
#
#
#

IES_verticalhorizontal  <- IES |> filter(Illusion_Type == "VerticalHorizontal")

BF_Congruent_vs_Mild_verticalhorizontal <- BayesFactor::ttestBF(
  x = IES_verticalhorizontal$IES[IES_verticalhorizontal$Condition_Illusion == "Congruent"],
  y = IES_verticalhorizontal$IES[IES_verticalhorizontal$Condition_Illusion == "Mild"],
  paired = TRUE
)

BF_Mild_vs_Strong_verticalhorizontal <- BayesFactor::ttestBF(
  x = IES_verticalhorizontal$IES[IES_verticalhorizontal$Condition_Illusion == "Mild"],
  y = IES_verticalhorizontal$IES[IES_verticalhorizontal$Condition_Illusion == "Strong"],
  paired = TRUE
)

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#

ER_Incongruent_eb <- Error_rate |> filter(Condition_Illusion != "Congruent" & Illusion_Type == "Ebbinghaus")
ER_Incongruent_eb_BF <- BayesFactor::correlationBF(
  y = ER_Incongruent_eb$error_rate[ER_Incongruent_eb$Condition_Illusion == "Mild"], 
  x = ER_Incongruent_eb$error_rate[ER_Incongruent_eb$Condition_Illusion == "Strong"])

describe_posterior(ER_Incongruent_eb_BF)
ER_Incongruent_eb_BF
#
#
#
#
#
#

ER_Incongruent_ml <- Error_rate |> filter(Condition_Illusion != "Congruent" & Illusion_Type == "MullerLyer")
ER_Incongruent_ml_BF <- BayesFactor::correlationBF(
  y = ER_Incongruent_ml$error_rate[ER_Incongruent_ml$Condition_Illusion == "Mild"], 
  x = ER_Incongruent_ml$error_rate[ER_Incongruent_ml$Condition_Illusion == "Strong"])

describe_posterior(ER_Incongruent_ml_BF)
ER_Incongruent_ml_BF
#
#
#
#
#
#
ER_Incongruent_vh <- Error_rate |> filter(Condition_Illusion != "Congruent" & Illusion_Type == "VerticalHorizontal")
ER_Incongruent_vh_BF <- BayesFactor::correlationBF(
  y = ER_Incongruent_vh$error_rate[ER_Incongruent_vh$Condition_Illusion == "Mild"], 
  x = ER_Incongruent_vh$error_rate[ER_Incongruent_vh$Condition_Illusion == "Strong"])

describe_posterior(ER_Incongruent_vh_BF)
ER_Incongruent_vh_BF
#
#
#
#
#
#
#
#
#
#
#

IES_Incongruent_eb <- IES |> filter(Condition_Illusion != "Congruent" & Illusion_Type == "Ebbinghaus")
IES_Incongruent_eb_BF <- BayesFactor::correlationBF(
  y = IES_Incongruent_eb$IES[IES_Incongruent_eb$Condition_Illusion == "Mild"], 
  x = IES_Incongruent_eb$IES[IES_Incongruent_eb$Condition_Illusion == "Strong"])

describe_posterior(IES_Incongruent_eb_BF)
IES_Incongruent_eb_BF
#
#
#
#
#
IES_Incongruent_ml <- IES |> filter(Condition_Illusion != "Congruent" & Illusion_Type == "MullerLyer")
IES_Incongruent_ml_BF <- BayesFactor::correlationBF(
  y = IES_Incongruent_ml$IES[IES_Incongruent_ml$Condition_Illusion == "Mild"], 
  x = IES_Incongruent_ml$IES[IES_Incongruent_ml$Condition_Illusion == "Strong"])

describe_posterior(IES_Incongruent_ml_BF)
IES_Incongruent_ml_BF
#
#
#
#
#
IES_Incongruent_vh <- IES|> filter(Condition_Illusion != "Congruent" & Illusion_Type == "VerticalHorizontal")
IES_Incongruent_vh_BF <- BayesFactor::correlationBF(
  y = IES_Incongruent_vh$IES[IES_Incongruent_vh$Condition_Illusion == "Mild"], 
  x = IES_Incongruent_vh$IES[IES_Incongruent_vh$Condition_Illusion == "Strong"])

describe_posterior(IES_Incongruent_vh_BF)
IES_Incongruent_vh_BF
```
#
#
#
#
#
#
#
#
#
#
#

ER_wide <- Error_rate|>
  select(Participant, Illusion_Type, Condition_Illusion, error_rate) |>
  unite("condition", Illusion_Type, Condition_Illusion, sep = "_") |>
  pivot_wider(names_from = condition, values_from = error_rate) |>
  as.data.frame()

## Congruent 
performance::item_split_half(ER_wide[, c("Ebbinghaus_Congruent", "MullerLyer_Congruent")])
performance::item_split_half(ER_wide[, c("VerticalHorizontal_Congruent", "MullerLyer_Congruent")])
performance::item_split_half(ER_wide[, c("VerticalHorizontal_Congruent", "Ebbinghaus_Congruent")])

## Strong
performance::item_split_half(ER_wide[, c("Ebbinghaus_Strong", "MullerLyer_Strong")])
performance::item_split_half(ER_wide[, c("VerticalHorizontal_Strong", "MullerLyer_Strong")])
performance::item_split_half(ER_wide[, c("VerticalHorizontal_Strong", "Ebbinghaus_Strong")])

## Mild
performance::item_split_half(ER_wide[, c("Ebbinghaus_Mild", "MullerLyer_Mild")])
performance::item_split_half(ER_wide[, c("VerticalHorizontal_Mild", "MullerLyer_Mild")])
performance::item_split_half(ER_wide[, c("VerticalHorizontal_Mild", "Ebbinghaus_Mild")])
#
#
#
#
#
IES_wide <- IES |>
  select(Participant, Illusion_Type, Condition_Illusion, IES) |>
  unite("condition", Illusion_Type, Condition_Illusion, sep = "_") |>
  pivot_wider(names_from = condition, values_from = IES) |>
  as.data.frame()

## Congruent 
performance::item_split_half(IES_wide[, c("Ebbinghaus_Congruent", "MullerLyer_Congruent")])
performance::item_split_half(IES_wide[, c("VerticalHorizontal_Congruent", "MullerLyer_Congruent")])
performance::item_split_half(IES_wide[, c("VerticalHorizontal_Congruent", "Ebbinghaus_Congruent")])

## Strong
performance::item_split_half(IES_wide[, c("Ebbinghaus_Strong", "MullerLyer_Strong")])
performance::item_split_half(IES_wide[, c("VerticalHorizontal_Strong", "MullerLyer_Strong")])
performance::item_split_half(IES_wide[, c("VerticalHorizontal_Strong", "Ebbinghaus_Strong")])

## Mild
performance::item_split_half(IES_wide[, c("Ebbinghaus_Mild", "MullerLyer_Mild")])
performance::item_split_half(IES_wide[, c("VerticalHorizontal_Mild", "MullerLyer_Mild")])
performance::item_split_half(IES_wide[, c("VerticalHorizontal_Mild", "Ebbinghaus_Mild")])

#
#
#
#
#
#
#
#

IES_wide |>
  select("Ebbinghaus_Congruent", "MullerLyer_Congruent", "VerticalHorizontal_Congruent") |>
  psych::alpha()

IES_wide |>
  select("Ebbinghaus_Mild", "MullerLyer_Mild", "VerticalHorizontal_Mild") |>
  psych::alpha()

IES_wide |>
  select("Ebbinghaus_Strong", "MullerLyer_Strong", "VerticalHorizontal_Strong") |>
  psych::alpha()

#
#
#
#
#
#

ER_wide |>
  select("Ebbinghaus_Congruent", "MullerLyer_Congruent", "VerticalHorizontal_Congruent") |>
  psych::alpha()

ER_wide |>
  select("Ebbinghaus_Mild", "MullerLyer_Mild", "VerticalHorizontal_Mild") |>
  psych::alpha()

ER_wide |>
  select("Ebbinghaus_Strong", "MullerLyer_Strong", "VerticalHorizontal_Strong") |>
  psych::alpha()

#
#
#
#
#
#
#
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$Ebbinghaus_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$Ebbinghaus_Mild)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$Ebbinghaus_Strong)
    
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$MullerLyer_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$MullerLyer_Mild)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$MullerLyer_Strong)
    
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$VerticalHorizontal_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$VerticalHorizontal_Mild)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = ER_wide$VerticalHorizontal_Strong)
    
#
#
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$Ebbinghaus_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$Ebbinghaus_Mild)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$Ebbinghaus_Strong)
    
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$MullerLyer_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$MullerLyer_Mild)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$MullerLyer_Strong)
    
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$VerticalHorizontal_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$VerticalHorizontal_Mild)

BayesFactor::correlationBF(
  y = data_ppt$pcs,
  x = IES_wide$VerticalHorizontal_Strong)
    
#
#
#
#
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$Ebbinghaus_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$Ebbinghaus_Mild)

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$Ebbinghaus_Strong)
    
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$MullerLyer_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$MullerLyer_Mild)

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$MullerLyer_Strong)
    
#
#
#
#

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$VerticalHorizontal_Congruent)

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$VerticalHorizontal_Mild)

BayesFactor::correlationBF(
  y = data_ppt$PID5_Psychoticism,
  x = IES_wide$VerticalHorizontal_Strong)
    
#
#
#
