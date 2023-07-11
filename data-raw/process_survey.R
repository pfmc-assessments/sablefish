## Revise nwfscSurvey data pulling and processing code for the 2023 limited 
## sablefish update assessment. This script revises code used for the 2019 
## update assessment (dated 19 Jan 2021 and reran on 08 Feb 2021). 
## Revised by Chantel Wetzel and Kelli Johnson

library(dplyr)

dir <- here::here()
table_dir <- here::here('data-tables')
fig_dir <- here::here('data-figures')
pull_data <- FALSE

if (pull_data){
  catch <- nwfscSurvey::pull_catch(
    dir = here::here('data-raw'), 
    common_name = "sablefish",
    survey = "NWFSC.Combo",
    convert  = TRUE)
  
  bio <- nwfscSurvey::pull_bio(
    dir = here::here('data-raw'), 
    common_name = "sablefish",
    survey = "NWFSC.Combo",
    convert  = TRUE)  
} else {
  load(here::here('data-raw', 'catch_sablefish_NWFSC.Combo_2023-06-27.rdata'))
  catch <- x
  load(here::here('data-raw', 'bio_sablefish_NWFSC.Combo_2023-06-27.rdata'))
  bio <- x
}

head(catch)
head(bio)

# Look at the number of positive tows and biological samples by years
n_obs <- bio %>%
  group_by(Year) %>%
  summarise(
    length_samples = length(Length_cm),
    age_samples = sum(!is.na(Age))
  )
n_tows <- catch %>%
  group_by(Year) %>%
  summarise(
    positive_tows = sum(total_catch_numbers > 0),
    percent_positive = round(positive_tows/length(Year), 2)
  )
out <- cbind(n_tows, n_obs[, c("length_samples", "age_samples")])
colnames(out) <- c("Year", "Positive Tows", "Percent Positive", "Length Samples", "Read Age Samples")
write.csv(out, row.names = FALSE, file = file.path(table_dir, "wcgbt_positive_tows_and_bio_samples.csv"))
t <- sa4ss::table_format(
  x = out,
  caption = 'The total number of positive tows, the percent of positive tows, and the number of length and age samples by year collected by the NWFSC WCGBT survey.',
  label = 'wcgbt-tow-data')
kableExtra::save_kable(t, file = here::here(table_dir, "wcgbt_positive_tows_and_bio_samples.tex"))

# Create stratification that will be used to calculate a design-based index and to expand the length data:
# The stratification areas are calculated from the SA3 file which is attached to the package.
# Stratification was used in both the 2011 and 2019 assessment.
strata <- nwfscSurvey::CreateStrataDF.fn(
  names=c("55m-183m_32-34.5", "183m-549m_32-34.5", "549m-900m_32-34.5", "900m-1280m_32-34.5",
          "55m-183m_34.5-40.5", "183m-549m_34.5-40.5", "549m-900m_34.5-40.5", "900m-1280m_34.5-40.5",
          "55m-183m_40.5-45", "183m-549m_40.5-45", "549m-900m_40.5-45", "900m-1280m_40.5-45",
          "55m-183m_45-49", "183m-549m_45-49", "549m-900m_45-49", "900m-1280m_45-49"),
  depths.shallow = c(55,  183, 549, 900,55,  183, 549, 900,55,  183, 549, 900,55,  183, 549, 900),
  depths.deep    = c(183, 549, 900, 1280, 183, 549, 900, 1280, 183, 549, 900, 1280, 183, 549, 900, 1280),
  lats.south     = c(32,   32,   32,   32,  34.5,  34.5, 34.5, 34.5, 40.5, 40.5, 40.5, 40.5, 45, 45, 45, 45),
  lats.north     = c(34.5, 34.5, 34.5, 34.5, 40.5, 40.5, 40.5, 40.5, 45, 45, 45, 45, 49, 49, 49, 49))
col_names <- c("Strata", "Area (km2)", "Shallow Depth", "Deep Depth", "South Latitude", "North Latitude")
t <- sa4ss::table_format(
  x = strata,
  caption = 'The stratification used to estimate a design-based index of abundance and to expand the length composition data from the NWFSC WCGBT survey.',
  label = 'wcgbt-strata',
  col_names = col_names)
kableExtra::save_kable(t, file = here::here(table_dir, "wcgbt_strata.tex"))

# Check the number of observations per strata by year
num_strata <- nwfscSurvey::CheckStrata.fn(
  dat = catch, 
  strat.df = strata)


# Calculate the design-based index of abundance using the specified stratification
biomass <- nwfscSurvey::Biomass.fn(
  dat = catch, 
  strat.df = strata, 
  outputMedian = TRUE)

nwfscSurvey::PlotBio.fn(
  dir = fig_dir, 
  dat = biomass, 
  main = "NWFSC Groundfish Bottom Trawl Survey")

nwfscSurvey::PlotBioStrata.fn(
  dir = fig_dir, 
  dat = biomass, 
  mfrow.in = c(4, 4), gap = 0.01,
  sameylim = TRUE, ylim = c(0, 60))


#===============================================================================
# Calculate the length composition data
#===============================================================================
# The GetN.fn calculated input sample sizes based on Hamel & Stewart bootstrap approach.
# The effN sample size is calculated using the others multiplier of 2.38. 
# This number is multiplied by the number of tows in each year.
input_n_sexed <- nwfscSurvey::GetN.fn(
  dat = bio[bio$Sex != "U", ], 
  type = "length", 
  species = "others")

# Expand and format length composition data for SS
lf_sexed <- nwfscSurvey::SurveyLFs.fn(
  datL = bio[bio$Sex %in% c("F", "M"), ], 
  datTows = catch,
  strat.df = strata, 
  lgthBins = len_bins, 
  sex = 3,
  fleet = 8, 
  month = 7,
  nSamps = input_n_sexed,
  printfolder = "")

# Create the unsexed composition data
input_n_unsexed <- nwfscSurvey::GetN.fn(
  dat = bio[bio$Sex == "U", ], 
  type = "length", 
  species = "others")

# Expand and format length composition data for SS
lf_unsexed <- nwfscSurvey::SurveyLFs.fn(
  datL = bio[bio$Sex %in% c("U"), ], 
  datTows = catch,
  strat.df = strata, 
  lgthBins = len_bins, 
  sex = 0,
  fleet = 8, 
  month = 7,
  nSamps = input_n_unsexed,
  printfolder = "")

nwfscSurvey::plot_comps(
  dir = fig_dir, 
  add_save_name = "sexed",
  data = lf_sexed)

nwfscSurvey::plot_comps(
  dir = fig_dir, 
  add_save_name = "unsexed",
  data = lf_unsexed)

colnames(lf_unsexed) <- colnames(lf_sexed)
out <- rbind(lf_sexed, lf_unsexed)
write.csv(out, file = file.path(here::here('data-processed'), "wcgbt_length_comps_standard_expansion.csv"), row.names = FALSE) 

# The code offers two options for applying the sex ratio based on expansion stage. The sex ratio will be
# applied based on a tow basis first if sexRatioStage = 1. The other option applies the sex ratio to the
# expanded numbers of fish across a whole strata (sexRatioStage = 2, this was the option applied to the
# NWFSC combo survey data in the past).
lf_sex_ratio <- nwfscSurvey::SurveyLFs.fn(
  datL = bio, 
  datTows = catch,
  strat.df = strata, 
  lgthBins = len_bins, 
  sex = 3,
  sexRatioUnsexed = 0.50,
  maxSizeUnsexed = 32,
  sexRatioStage = 2,
  fleet = 8, 
  month = 7,
  printfolder = "")

nwfscSurvey::plot_comps(
  dir = fig_dir, 
  add_save_name = "sex_ratio",
  data = lf_sex_ratio)

nwfscSurvey::PlotFreqData.fn(
  dir =  fig_dir, 
  dat = lf_sex_ratio,
  main = "NWFSC Groundfish Bottom Trawl Survey", 
  ylim=c(0, max(len_bins)), 
  yaxs="i", 
  ylab="Length (cm)")

nwfscSurvey::PlotSexRatio.fn(
  dir = fig_dir, 
  dat = bio, 
  data.type = "length")


temp <- catch %>%
  dplyr::mutate(new = factor(
    cpue_kg_km2 <= 0,
    levels = c(FALSE, TRUE),
    labels = c("Present", "Absent")
  ))

nwfscSurvey::plot_proportion(
  data = temp,
  column_factor = new,
  column_bin = Depth_m,
  width = 50,
  boundary = 0,
  bar_width = "equal"
)
ggplot2::ggsave(filename = file.path(fig_dir, "proportion_by_depth.png"))

nwfscSurvey::plot_proportion(
  data = bio %>% dplyr::mutate(Sex = nwfscSurvey::codify_sex(Sex)),
  column_factor = Sex,
  column_bin = Depth_m,
  width = 50,
  boundary = 0,
  bar_width = "equal"
)
ggplot2::ggsave(filename = file.path(fig_dir, "sex_by_depth.png"))

#===============================================================================
# Calculate the marginal and caal age composition data
#===============================================================================
input_n_sexed <- nwfscSurvey::GetN.fn(
  dat = bio[bio$Sex %in% c("F", "M"), ], 
  type = "age", 
  species = "others", 
  printfolder = "forSS")

# Expand and format the marginal age composition data for SS
marg_af_sexed <- nwfscSurvey::SurveyAFs.fn( 
  datA = bio[bio$Sex %in% c("F", "M"), ], 
  datTows = catch,
  strat.df = strata, 
  ageBins = age_bins,
  nSamps = input_n_sexed,
  sex = 3,
  fleet = 8, 
  month = 7)

input_n_unsexed <- nwfscSurvey::GetN.fn(
  dat = bio[bio$Sex == "U", ], 
  type = "age", 
  species = "others")

# Expand and format length composition data for SS
marg_af_unsexed <- nwfscSurvey::SurveyAFs.fn(
  datA = bio[bio$Sex %in% c("U"), ], 
  datTows = catch,
  strat.df = strata, 
  ageBins = age_bins,
  sex = 0,
  fleet = 8, 
  month = 7,
  nSamps = input_n_unsexed,
  printfolder = "")

nwfscSurvey::plot_comps(
  dir = fig_dir, 
  add_save_name = "sexed",
  data = marg_af_sexed)

nwfscSurvey::plot_comps(
  dir = fig_dir, 
  add_save_name = "unsexed",
  data = marg_af_unsexed)

colnames(marg_af_unsexed) <- colnames(marg_af_sexed)
out <- rbind(marg_af_sexed, marg_af_unsexed)
write.csv(out, file = file.path(here::here('data-processed'), "wcgbt_age_marginal_comps_standard_expansion.csv"), row.names = FALSE) 

caal <- nwfscSurvey::SurveyAgeAtLen.fn ( 
  datAL = bio, 
  datTows = catch,
  strat.df = strata, 
  lgthBins = len_bins,
  ageBins = age_bins,
  fleet = 8,
  month = 7,
  ageErr = 1,
  partition = 0)

colnames(caal$male) <- colnames(caal$female)
caal$unsexed <- cbind(caal$unsexed, caal$unsexed[, 10:ncol(caal$unsexed)])
colnames(caal$unsexed) <- colnames(caal$female)
out <- rbind(caal$female, caal$male, caal$unsexed)
colnames(out)[10:ncol(out)] <- c(age_bins, age_bins)
write.csv(out, file = file.path(here::here('data-processed'), "wcgbt_caal_unexpanded.csv"), row.names = FALSE)

library(ggridges)

bio <- bio %>%
  mutate(
    watlen = Weight_kg / Length_cm
  )
  
ggplot(bio[!is.na(bio$Age) & bio$Age < 10, ], aes(x = Age, y = watlen, col = as.factor(Year))) +
  geom_jitter() + 
  facet_grid(c("Age", "Year"))
  geom_density_ridges2("Age") +
  xlim(c(0, 1)) 

ggplot(bio, aes(x = watlen, y = as.factor(Year))) +
  geom_density_ridges2() +
  xlim(c(0, 0.1)) 