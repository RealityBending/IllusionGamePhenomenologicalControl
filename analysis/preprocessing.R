library(jsonlite)
library(progress)

path <- "C:/Users/asf25/Box/IllusionPCS/"

# JsPsych experiment ------------------------------------------------------

# files <- list.files(path, pattern = "*.csv")
files <- "ryqwk2oej3.csv"

# Progress bar
progbar <- progress_bar$new(total = length(files))

alldata_sub <- data.frame()
alldata_ig <- data.frame()

for (file in files) {
  progbar$tick()
  rawdata <- read.csv(paste0(path, "/", file))
  
  
  # Initialize participant-level data
  dat <- rawdata[rawdata$screen == "browser_info", ]
  
  data_ppt <- data.frame(
    Participant = sub("\\.csv$", "", file),
    Recruitment = dat$researcher,
    # Condition = dat$condition,
    Experiment_StartDate = as.POSIXct(paste(dat$date, dat$time), format = "%d/%m/%Y %H:%M:%S"),
    Experiment_Duration = rawdata[rawdata$screen == "waitdatasaving", "time_elapsed"] / 1000 / 60,
    Browser_Version = paste(dat$browser, dat$browser_version),
    Mobile = dat$mobile,
    Platform = dat$os,
    Screen_Width = dat$screen_width,
    Screen_Height = dat$screen_height
  )
  
  
  if("prolific_id" %in% colnames(dat)){
    data_ppt$Prolific_ID <- dat$prolific_id
  }
  
  # Demographics
  demog <- jsonlite::fromJSON(rawdata[rawdata$screen == "demographic_questions", ]$response)
  
  #Education
  demog$Education <- ifelse(demog$Education == "other", demog$`Education-Comment`, demog$Education)
  demog$`Education-Comment` <- NULL
  
  #Discipline
  demog$Discipline <- ifelse(!is.null(demog$Discipline), demog$Discipline, NA)
  demog$Discipline <- ifelse(demog$Discipline == "other", demog$`Discipline-Comment`, demog$Discipline)
  demog$`Discipline-Comment` <- NULL
  
  #Student
  demog$Student <- ifelse(!is.null(demog$Student), demog$Student, NA)
  
  #ethnicity
  demog$Ethnicity <- ifelse(!is.null(demog$Ethnicity), demog$Ethnicity, NA)
  demog$Ethnicity <- ifelse(demog$Ethnicity == "other", demog$`Ethnicity-Comment`, demog$Ethnicity)
  demog$`Ethnicity-Comment` <- NULL
  
  demog <- as.data.frame(demog)
  data_ppt <- cbind(data_ppt, demog)
  
  # PCS ===============================================================================
  
  # PCS ratings
  data_ppt$pcs_handslow <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_handlowering_r", "response"])))
  data_ppt$pcs_magnetichands <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_magnetichands_r", "response"])))
  data_ppt$pcs_mosquito <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_mosquito_r", "response"])))
  taste <- jsonlite::fromJSON(rawdata$response[rawdata$screen == "pcs_taste_r"])
  data_ppt$pcs_tastesweet <- taste$TasteSweet_r
  data_ppt$pcs_tastesour <- taste$TasteSour_r
  data_ppt$pcs_armrigidity <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_armrigidity_r", "response"])))
  data_ppt$pcs_armimmobile <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_armrimmobile_r", "response"])))
  data_ppt$pcs_music <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_music_r", "response"])))
  
  data_ppt$pcs_negativehallucination <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_negativehallucination_r", "response"])))
  # data_ppt$pcs_negativehallucination <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_negativehallucination", "response"])))
  
  PostSessionExp <- jsonlite::fromJSON(rawdata$response[rawdata$screen == "pcs_pss_r"])
  # data_ppt$urgepress <- taste$PostSessionExperiencea_ur
  data_ppt$pcs_urgepress <- PostSessionExp$PostSessionExperiencea_ur
  data_ppt$pcs_memorypress <- PostSessionExp$PostSessionExperienceb_mr
  
  data_ppt$pcs_amnesia <- as.integer(unlist(jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_amnesia_r", "response"])))

  # Initialise all values as FALSE
  data_ppt$pcs_yellowball <- FALSE
  data_ppt$pcs_redball <- FALSE
  data_ppt$pcs_greenball <- FALSE
  data_ppt$pcs_blueball <- FALSE
  data_ppt$pcs_purpleball <- FALSE
  data_ppt$pcs_orangeball <- FALSE
  data_ppt$pcs_noballs <- FALSE
  
  # Only proceed if there's a non-empty response for pcs_balls_mc
  if (any(rawdata$screen == "pcs_balls_mc")) {
    response_raw <- rawdata$response[rawdata$screen == "pcs_balls_mc"]
    
    response <- jsonlite::fromJSON(response_raw[1])$Balls_mc
    
    # Set TRUE where appropriate
    data_ppt$pcs_yellowball <- "Yellow" %in% response
    data_ppt$pcs_redball    <- "Red" %in% response
    data_ppt$pcs_greenball  <- "Green" %in% response
    data_ppt$pcs_blueball   <- "Blue" %in% response
    data_ppt$pcs_purpleball <- "Purple" %in% response
    data_ppt$pcs_orangeball <- "Orange" %in% response
    data_ppt$pcs_noballs <- "No Balls Were Presented" %in% response
  }

  # PCS write up
  data_ppt$pcs_amnesia_w <- jsonlite::fromJSON(rawdata[rawdata$screen =="pcs_amnesia_w", "response"])
  data_ppt$pcs_amnesia_w <- trimws(data_ppt$pcs_amnesia_w)
  data_ppt$pcs_amnesia_w <- gsub("\n", "", data_ppt$pcs_amnesia_w)
  data_ppt$pcs_remember_w <- jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_remember_w", "response"])
  data_ppt$pcs_remember_w <- trimws(data_ppt$pcs_remember_w)
  data_ppt$pcs_remember_w <- gsub("\n", "", data_ppt$pcs_remember_w)
  

  # PCS manipulation 
  hello <- jsonlite::fromJSON(rawdata[rawdata$screen == "pcs_audiotest", ]$response)
  data_ppt$pcs_hello <- hello$AudioTest
  data_ppt$pcs_press <- rawdata[rawdata$screen == "pcs_press", "keyPressCount"]
  
  # Questionnaires =====================================================================
  
  pid5 <- jsonlite::fromJSON(rawdata[rawdata$screen == "questionnaire_pid5", "response"])
  data_ppt$pid_Dis1 <- pid5$Disinhibition_1
  data_ppt$pid_Dis2 <- pid5$Disinhibition_2
  data_ppt$pid_Dis3 <- pid5$Disinhibition_3
  data_ppt$pid_Dis5 <- pid5$Disinhibition_5
  data_ppt$pid_Dis6 <- pid5$Disinhibition_6
  data_ppt$pid_Det4 <- pid5$Detachment_4
  data_ppt$pid_Det13 <- pid5$Detachment_13
  data_ppt$pid_Det14 <- pid5$Detachment_14
  data_ppt$pid_Det16 <- pid5$Detachment_16
  data_ppt$pid_Det18 <- pid5$Detachment_18
  data_ppt$pid_Psy7 <- pid5$Psychoticism_7
  data_ppt$pid_Psy12 <- pid5$Psychoticism_12
  data_ppt$pid_Psy21 <- pid5$Psychoticism_21
  data_ppt$pid_Psy23 <- pid5$Psychoticism_23
  data_ppt$pid_Psy24 <- pid5$Psychoticism_24
  data_ppt$pid_NegAff8 <- pid5$NegativeAffect_8
  data_ppt$pid_NegAff9 <- pid5$NegativeAffect_9
  data_ppt$pid_NegAff10 <- pid5$NegativeAffect_10
  data_ppt$pid_NegAff11 <- pid5$NegativeAffect_11
  data_ppt$pid_NegAff15 <- pid5$NegativeAffect_15
  data_ppt$pid_Ant17 <- pid5$Antagonism_17
  data_ppt$pid_Ant19 <- pid5$Antagonism_19
  data_ppt$pid_Ant20 <- pid5$Antagonism_20
  data_ppt$pid_Ant22 <- pid5$Antagonism_22
  data_ppt$pid_Ant25 <- pid5$Antagonism_25
  
  
  ipip6 <- jsonlite::fromJSON(rawdata[rawdata$screen == "questionnaire_ipip6", "response"])
  data_ppt$ipip_Cons3 <- ipip6$Conscientiousness_3
  data_ppt$ipip_Cons10 <- ipip6$Conscientiousness_10
  data_ppt$ipip_Cons11_R <- ipip6$Conscientiousness_11_R
  data_ppt$ipip_Cons22_R <- ipip6$Conscientiousness_22_R
  data_ppt$ipip_Ext1 <- ipip6$Extraversion_1
  data_ppt$ipip_Ext7_R <- ipip6$Extraversion_7_R
  data_ppt$ipip_Ext19_R <- ipip6$Extraversion_19_R
  data_ppt$ipip_Ext23 <- ipip6$Extraversion_23
  data_ppt$ipip_Agr2 <- ipip6$Agreeableness_2
  data_ppt$ipip_Agr8_R <- ipip6$Agreeableness_8_R
  data_ppt$ipip_Agr14 <- ipip6$Agreeableness_14
  data_ppt$ipip_Agr20_R <- ipip6$Agreeableness_20_R
  data_ppt$ipip_HonHum6_R <- ipip6$HonestyHumility_6_R
  data_ppt$ipip_HonHum12_R <- ipip6$HonestyHumility_12_R
  data_ppt$ipip_HonHum18_R <- ipip6$HonestyHumility_18_R
  data_ppt$ipip_HonHum24_R <- ipip6$HonestyHumility_24_R
  data_ppt$ipip_Neuro4 <- ipip6$Neuroticism_4
  data_ppt$ipip_Neuro15_R <- ipip6$Neuroticism_15_R
  data_ppt$ipip_Neuro16 <- ipip6$Neuroticism_16
  data_ppt$ipip_Neuro17_R <- ipip6$Neuroticism_17_R
  data_ppt$ipip_Open5 <- ipip6$Openness_5
  data_ppt$ipip_Open9_R <- ipip6$Openness_9_R
  data_ppt$ipip_Open13_R <- ipip6$Openness_13_R
  data_ppt$ipip_Open21_R <- ipip6$Openness_21_R
  
  alldata_sub <- rbind(data_ppt, alldata_sub)
  
  # Visual Illusions ===============================================================================
  
  ig <- rawdata[rawdata$screen == "IG_Trial", ]
  ig <- ig |> dplyr::filter(block != "Practice")
  
  df_ig <- ig[, c("Illusion_Type", "Illusion_Difference", "Illusion_Strength")]
  df_ig$participant <- sub("\\.csv$", "", file)
  df_ig$File <- gsub("https://realitybending.github.io/IllusionGame/v3/stimuli/", "", ig$stimulus)
  df_ig$Block <- ig$block
  df_ig$Trial <- ig$trial_number
  df_ig$ISI <- ig$isi
  df_ig$RT <- as.numeric(ig$rt)/ 1000  # In seconds
  df_ig$Response <- ig$response
  df_ig$Response_Correct <- ig$correct
  df_ig$Error <- as.integer(ig$correct == "false")
  
  # Reorder Columns
  first_column <- df_ig$participant
  df_ig$participant <- NULL
  df_ig <- cbind(Participant = first_column, df_ig)

  alldata_ig <- rbind(alldata_ig, df_ig)
}
  
# Reanonimize ============================================================

#order based on the date of the experiment
alldata_sub <- alldata_sub[order(alldata_sub$Experiment_StartDate), ]
# Create correspondence map (mapping original Participant IDs to new ones)
correspondance <- setNames(paste0("S", sprintf("%03d", seq_along(alldata_sub$Participant))), alldata_sub$Participant)
# Reanonymize both datasets by updating the 'Participant' column
alldata_sub$Participant <- correspondance[alldata_sub$Participant]
alldata_ig$Participant <- correspondance[alldata_ig$Participant]

# Save --------------------------------------------------------------------

write.csv(alldata_sub, "../data/rawdata_participants.csv", row.names = FALSE)
write.csv(alldata_ig, "../data/rawdata_illusion.csv", row.names = FALSE)

