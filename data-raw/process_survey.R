## ran this code on 19 Jan 2021. Will use for other comps as applicable.
## re ran on 08 feb 2021 to get age comps from surveys. thus lcomps are from 19 run.
# catch = PullCatch.fn(Name = "sablefish", SurveyName = "NWFSC.Combo",
#                      SaveFile = TRUE, Dir = here('dataprep','raw_data'))
# bio   = PullBio.fn(Name = "sablefish", SurveyName = "NWFSC.Combo",
#                    SaveFile = TRUE, Dir = here('dataprep','raw_data'),
#                    YearRange = c(2003, 2020))
# head(catch)
# head(bio)

# Create Stratafication:
# The stratafication areas are calculated from the SA3 file which is attached to the package.
#same as 2011 assessment, also used for 2019
strata = CreateStrataDF.fn(names=c("55m-183m_32-34.5", "183m-549m_32-34.5", "549m-900m_32-34.5", "900m-1280m_32-34.5",
                                   "55m-183m_34.5-40.5", "183m-549m_34.5-40.5", "549m-900m_34.5-40.5", "900m-1280m_34.5-40.5",
                                   "55m-183m_40.5-45", "183m-549m_40.5-45", "549m-900m_40.5-45", "900m-1280m_40.5-45",
                                   "55m-183m_45-49", "183m-549m_45-49", "549m-900m_45-49", "900m-1280m_45-49"),
                           depths.shallow = c(55,  183, 549, 900,55,  183, 549, 900,55,  183, 549, 900,55,  183, 549, 900),
                           depths.deep    = c(183, 549, 900, 1280, 183, 549, 900, 1280, 183, 549, 900, 1280, 183, 549, 900, 1280),
                           lats.south     = c(32,   32,   32,   32,  34.5,  34.5, 34.5, 34.5, 40.5, 40.5, 40.5, 40.5, 45, 45, 45, 45),
                           lats.north     = c(34.5, 34.5, 34.5, 34.5, 40.5, 40.5, 40.5, 40.5, 45, 45, 45, 45, 49, 49, 49, 49))

## length comps ----

#* survey length comps ----
biomass = Biomass.fn(dir = here('dataprep','processed_data','survey'), 
                     dat = catch, 
                     strat.df = strata, printfolder = "forSS", outputMedian = T)


PlotBio.fn(dir = here('dataprep','processed_data','survey'), dat = biomass, 
           main = "NWFSC Groundfish Bottom Trawl Survey", dopng = T)
PlotBioStrata.fn(dir = here('dataprep','processed_data','survey'), 
                 dat = biomass, 
                 # main = "NWFSC Groundfish Bottom Trawl Survey",
                 mfrow.in = c(3,2), gap = 0.01,
                 sameylim = TRUE, ylim = c(0, 22), dopng = TRUE)


len = bio
len.bins = seq(18,90,by=2)

# Calculate the effN
## The effN sample size is calculated using the others multiplier of 2.38. 
## This number is multiplied by the number of tows in each year.
n = GetN.fn(dir= here('dataprep','processed_data','survey'),
            dat = len, type = "length", species = "others", 
            printfolder = "forSS")

# The GetN.fn calculated input sample sizes based on Hamel & Stewart 
# bootstrap approach.

# Expand and format length composition data for SS
LFs <- SurveyLFs.fn(dir =  here('dataprep','processed_data','survey'), 
                    datL = len, datTows = catch,
                    strat.df = strata, lgthBins = len.bins, 
                    sex = 3,
                    # month = 7,
                    # fleet = 8,
                    sexRatioStage = 2, 
                    sexRatioUnsexed = 0.5, maxSizeUnsexed = 100,
                    nSamps = n, outputStage1 = FALSE)

# The code offers two options for applying the sex ratio based on expansion stage. The sex ratio will be
# applied based on a tow basis first if sexRatioStage = 1. The other option applies the sex ratio to the
# expanded numbers of fish across a whole strata (sexRatioStage = 2, this was the option applied to the
# NWFSC combo survey data in the past).
PlotFreqData.fn(dir =  here('dataprep','processed_data','survey'), dat = LFs,
                main = "NWFSC Groundfish Bottom Trawl Survey", ylim=c(0, max(len.bins) + 4), yaxs="i", ylab="Length (cm)", dopng = TRUE)
PlotSexRatio.fn(dir = here('dataprep','processed_data','survey'), dat = len, data.type = "length", dopng = TRUE, main = "NWFSC Groundfish Bottom Trawl Survey")

#* plot comparison design based indices----
## downloaded 2019 version from 6_non_confidential_data/NWFSCCompsDesignBasedIndex/ForSS
design_based_indices %>%
  mutate(SRC = 'Dec20PACFIN') %>%
  rbind(., design_based_indices_2019 %>%
          mutate(SRC = 'WC19')) %>%
  mutate(lci = Value - seLogB*Value,uci = Value +seLogB*Value) %>% 
  ggplot(.,aes(x = Year, y = Value, color = SRC)) +
  geom_point(size = 4, position=position_dodge(width=0.5)) +
  geom_errorbar(
    aes(ymin = lci, ymax = uci),
    width = 0.1,
    position=position_dodge(width=0.5))   +
  scale_color_manual(values = c('black','grey60')) +
  theme_sleek() +
  labs(y = 'Design-Based Index',
       color = "",
       title = 'NWFSC Groundfish Bottom Trawl Survey')

ggsave(last_plot(),
       file = here('dataprep','processed_data','survey','plots',
                   'design_based_indices_COMPARISON.png'),
       height = 6, width =8, dpi = 500)


## compare prev len comps
LFs <- read_csv("dataprep/processed_data/survey/forSS/Survey_Sex3_Bins_18_90_LengthComps.csv")


## "For the NWFSC survey length comp bin 90 plus group has, 
## when taking an average 
## of the positive observations across all years, 
## 0.02 for both males and females"
mean(LFs$F90[LFs$F90 > 0]); mean(LFs$M90[LFs$M90 > 0])

names(LFs) <- tolower(names(LFs))
names(wc19dat$lencomp) <- names(LFs) ## rename for ease

lcompDiff = data.frame()
for(i in 1:nrow(LFs)){
  for(j in 1:(ncol(LFs)-6)){
    lcompDiff[i,j] <- round(wc19dat$lencomp[i,j+6],2)-round(LFs[i,j+6],2)
  }
}
names(lcompDiff) <- names(LFs)[7:ncol(LFs)]
lcompDiff$year <- 2003:2019

## some data exploration of large differences
which(max(abs(lcompDiff[,1:37][!is.na(lcompDiff[,1:37])])))
lcompDiff[which(abs(lcompDiff[,1:37]) > 0.1),1:37]

lcompDiff[,c(1:37, 75)] %>%
  melt(id = 'year') %>%
  filter(year < 2019) %>%
  mutate(Lbin = as.numeric(substr(variable,2,3))) %>%
  group_by(year) %>%
  summarise(max(value))

wc19dat$lencomp %>% filter(year == 2010)

data.frame('Year' =LFs$year,
           'Nsamp2019-Nsamp2021'=wc19dat$lencomp$nsamp - LFs$nsamp) %>%
  filter(Year > 2007 & Year < 2011) ## three years where these vary

LFs %>% filter(year == 2010)
femDiff <- lcompDiff[,c(1:37, 75)] %>%
  melt(id = 'year') %>%
  mutate(Lbin = as.numeric(substr(variable,2,3))) %>%
  ggplot(., aes(x = year, y = Lbin, fill = value)) +
  geom_tile() +
  theme_sleek() +
  scale_fill_gradient2(high = 'red', mid = 'white', low = 'black') +
  labs(x = 'Year', y = 'Length Bin', fill = '2019 minus 2021',
       title = '2019 Female NWCBO Lcomps minus Jan 2021 pull',
       subtitle = paste0('maximum difference is ',
                         round(max(abs(lcompDiff[,c(1:37)][!is.na(lcompDiff[,c(1:37)])])),2)))

malDiff <- lcompDiff[,38:75] %>%
  melt(id = 'year') %>%
  mutate(Lbin = as.numeric(substr(variable,2,3))) %>%
  ggplot(., aes(x = year, y = Lbin, fill = value)) +
  geom_tile() +
  theme_sleek() +
  scale_fill_gradient2(high = 'red', mid = 'white', low = 'black') +
  labs(x = 'Year', y = 'Length Bin', fill = '2019 minus 2021',
       title = '2019 Male NWCBO Lcomps minus Jan 2021 pull',
       subtitle = paste0('maximum difference is ',
                         round(max(abs(lcompDiff[,38:74][!is.na(lcompDiff[,38:74])])),2)))
ggsave(femDiff /malDiff,
       file = here('dataprep','processed_data','survey','plots',
                   'Lcomp_residuals.png'),
       height = 10, width =8)

#* comm length comps ----
## LQ made the file commercial_lcomps.csv from PACFIN

#* discard length comps ----
## age comps ----
#* survey age comps ----


#Length Biological Data
load(here('dataprep','raw_data','survey','bio_all_nwfsc.combo_2021-02-08.rda')); bio = Data;rm(Data)
load(here('dataprep','raw_data','survey','Catch__nwfsc.combo_2021-02-08.rda')); catch = Out;rm(Out)
age = bio
age.bins = 0:60

n = GetN.fn( here('dataprep','processed_data','survey'), dat = age, type = "age", species = "others", printfolder = "forSS")

# Expand and format the marginal age composition data for SS
Ages <- SurveyAFs.fn( here('dataprep','processed_data','survey'), datA = age, datTows = catch,
                      strat.df = strata, ageBins = age.bins,
                      sexRatioStage = 2, sexRatioUnsexed = 0.50, maxSizeUnsexed = 100,
                      sex = 3, nSamps = n)
## The first file has the 999 column showing fish smaller or younger than the initial bin. 
PlotFreqData.fn( here('dataprep','processed_data','survey'), dat = Ages, main = "NWFSC Groundfish Bottom Trawl Survey", ylim=c(0, max(age.bins) + 2), yaxs="i", ylab="Age (yr)", dopng=TRUE)
PlotVarLengthAtAge.fn( here('dataprep','processed_data','survey'), dat = age, main = "NWFSC Groundfish Bottom Trawl Survey", dopng = TRUE)
PlotSexRatio.fn( here('dataprep','processed_data','survey'), dat = age, data.type = "age", dopng = TRUE, main = "NWFSC Groundfish Bottom Trawl Survey")

#* Conditional Ages ----
## note this uses the raw "age" df pulled from the warehouse which gets expanded within the func.
## I'm going to re-do this at 0:50 to match 2019
Ages <- SurveyAgeAtLen.fn ( here('dataprep','processed_data','survey'), 
                            datAL = age, datTows = catch,
                            strat.df = strata, 
                            lgthBins = len.bins,
                            ageBins = 0:50, partition = 0)
## bind into a master for SS
caalF <- read.csv(here('dataprep','processed_data','survey','forSS','survey_caal_female_bins_18_90_0_50.csv'))
caalM <- read.csv(here('dataprep','processed_data','survey','forSS','survey_caal_male_bins_18_90_0_50.csv'))

names(caalM) <- names(caalF)

rbind(caalF, caalM) %>% 
  arrange(year, sex, LbinLo) %>%
  write.csv(.,here('dataprep','processed_data','survey','forSS','survey_CAAL_bothsex_18_90_0_50.csv'),row.names = FALSE)


ncol(caalF) ## should be 111

## compare prev agecomps; make sure you don't use the CAALS!
## note that the datapull had bins 0:60 but the model is 0:50. to "collapse"
## we can just summ the proportions over bin 50 into the "50+" category.
ages <- 
  read.csv(here('dataprep','processed_data','survey','forSS','Survey_Sex3_Bins_0_60_AgeComps.csv'))

# For the NWFSC survey age com bin 60 plus group has, 
## when taking an average of the positive observations across all years, 
## 0.14 for females and 0.54 for males
mean(ages$F60[ages$F60 > 0])
mean(ages$M60[ages$M60 > 0])
# For the NWFSC survey age com bin 35 plus group has, 
## when taking an average of the positive observations across all years, 
## 2.14 for females and 5.57 for males
f35plus <- which(names(ages) == 'F35'):which(names(ages) == 'F60')
m35plus <- which(names(ages) == 'M35'):which(names(ages) == 'M60')
mean(rowSums(ages[,f35plus])); mean(rowSums(ages[,m35plus])) 

names(ages) <- tolower(names(ages))
f50idx <- which(names(ages) == 'f50') ## col position of f50
f60idx <- which(names(ages) == 'f60') ## col position of f60
m50idx <- which(names(ages) == 'm50')

ages[,f50idx] <- rowSums(ages[,c(f50idx:f60idx)]) ## sum 50:60 for fems
ages[,m50idx] <- rowSums(ages[,c(m50idx:ncol(ages))]) ## sum 50:60 for mals

## NEED TO CONFIRM HOW TO SANITY CHECK THESE; THEY DON'T SUM TO ONE

## drop columns for ages 51 and up
ages <- ages[,-c((f50idx+1):f60idx, c((m50idx+1):ncol(ages)))]

names(wc19dat$agecomp) <- names(ages$female) ## rename for ease

acompDiff = data.frame()
for(i in 1:nrow(ages)){
  for(j in 1:(ncol(ages)-9)){
    acompDiff[i,j] <- data.frame(wc19dat$agecomp)[i,j+9]-ages[i,j+9]
  }
}
names(acompDiff) <- names(ages)[10:ncol(ages)]
acompDiff$year <- 2003:2019

femDiff <- acompDiff[,c(1:47, ncol(acompDiff))] %>%
  melt(id = 'year') %>%
  mutate(Lbin = as.numeric(substr(variable,2,3))) %>%
  ggplot(., aes(x = year, y = Lbin, fill = value)) +
  geom_tile() +
  theme_sleek() +
  scale_fill_gradient2(high = 'red', mid = 'white', low = 'black') +
  labs(x = 'Year', y = 'Age Bin', fill = 'Old minus Recent',
       title = '2019 Female NWCBO acomps minus Jan 2021 pull',
       subtitle = paste0('maximum difference is ',
                         round(max(abs(acompDiff[,c(1:37)][!is.na(acompDiff[,c(1:37)])])),2)))

malDiff <- acompDiff[,48:ncol(acompDiff)] %>%
  melt(id = 'year') %>%
  mutate(Lbin = as.numeric(substr(variable,2,3))) %>%
  ggplot(., aes(x = year, y = Lbin, fill = value)) +
  geom_tile() +
  theme_sleek() +
  scale_fill_gradient2(high = 'red', mid = 'white', low = 'black') +
  labs(x = 'Year', y = 'Age Bin', fill = 'Old minus Recent',
       title = '2019 Male NWCBO acomps minus Jan 2021 pull',
       subtitle = paste0('maximum difference is ',
                         round(max(abs(acompDiff[,38:74][!is.na(acompDiff[,38:74])])),2)))
ggsave(femDiff /malDiff,
       file = here('dataprep','processed_data','survey','plots',
                   'Lcomp_residuals.png'),
       height = 10, width =8)
#* comm age comps ----
## lq in charge of this , not ready till march

## ASHOP discard lengths ----
## SSH (df1 of tide gauge data) ----

## use CSV BAYESIAN_SEA_LEVEL_TOMAIA.csv sent from MH on 17 Mar 2021.
