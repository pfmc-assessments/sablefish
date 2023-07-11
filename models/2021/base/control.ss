#V3.30.16.00;_2020_09_03;_safe;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.2
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#_data_and_control_files: data.ss // control.ss
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns (Growth Patterns, Morphs, Bio Patterns, GP are terms used interchangeably in SS)
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Platoon_within/between_stdev_ratio (no read if N_platoons=1)
#_Cond  1 #vector_platoon_dist_(-1_in_first_val_gives_normal_approx)
#
4 # recr_dist_method for parameters:  2=main effects for GP, Area, Settle timing; 3=each Settle entity; 4=none (only when N_GP*Nsettle*pop==1)
1 # not yet implemented; Future usage: Spawner-Recruitment: 1=global; 2=by area
1 #  number of recruitment settlement assignments 
0 # unused option
#GPattern month  area  age (for each settlement assignment)
 1 1 1 0
#
#_Cond 0 # N_movement_definitions goes here if Nareas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
7 #_Nblock_Patterns
 1 5 5 3 3 1 1 #_blocks_per_pattern 
# begin and end years of blocks
 1995 2014
 1942 1946 1947 1996 1997 2010 2011 2018 2019 2020
 1942 1946 1947 1981 1982 2010 2011 2018 2019 2020
 1997 2002 2003 2010 2011 2020
 1982 2002 2003 2010 2011 2020
 1995 2014
 1890 1890
#
# controls for all timevary parameters 
1 #_time-vary parm bound check (1=warn relative to base parm bounds; 3=no bound check); Also see env (3) and dev (5) options to constrain with base bounds
#
# AUTOGEN
 1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen time-varying parms of this category; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
#_Available timevary codes
#_Block types: 0: P_block=P_base*exp(TVP); 1: P_block=P_base+TVP; 2: P_block=TVP; 3: P_block=P_block(-1) + TVP
#_Block_trends: -1: trend bounded by base parm min-max and parms in transformed units (beware); -2: endtrend and infl_year direct values; -3: end and infl as fraction of base range
#_EnvLinks:  1: P(y)=P_base*exp(TVP*env(y));  2: P(y)=P_base+TVP*env(y);  3: P(y)=f(TVP,env_Zscore) w/ logit to stay in min-max;  4: P(y)=2.0/(1.0+exp(-TVP1*env(y) - TVP2))
#_DevLinks:  1: P(y)*=exp(dev(y)*dev_se;  2: P(y)+=dev(y)*dev_se;  3: random walk;  4: zero-reverting random walk with rho;  5: like 4 with logit transform to stay in base min-max
#_DevLinks(more):  21-25 keep last dev for rest of years
#
#_Prior_codes:  0=none; 6=normal; 1=symmetric beta; 2=CASAL's beta; 3=lognormal; 4=lognormal with biascorr; 5=gamma
#
# setup for M, growth, wt-len, maturity, fecundity, (hermaphro), recr_distr, cohort_grow, (movement), (age error), (catch_mult), sex ratio 
#
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
  #_no additional input for selected M option; read 1P per morph
#
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_specific_K_incr; 4=age_specific_K_decr; 5=age_specific_K_each; 6=NA; 7=NA; 8=growth cessation
0.5 #_Age(post-settlement)_for_L1;linear growth below this
30 #_Growth_Age_for_L2 (999 to use as Linf)
-999 #_exponential decay for growth above maxage (value should approx initial Z; -999 replicates 3.24; -998 to not allow growth above maxage)
0  #_placeholder for future growth feature
#
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
#
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=disabled; 6=read length-maturity
3 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=female-to-male age-specific fxn; -1=male-to-female age-specific fxn
1 #_parameter_offset_approach for M, G, CV_G:  1- direct, no offset; 2- male=fem_parm*exp(male_parm); 3: male=female*exp(parm) then old=young*exp(parm)
#
#_growth_parms
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
# Sex: 1  BioPattern: 1  NatMort
 0.01 0.11 0.0725862 -2.93857 0.438 3 3 0 0 0 0 0 0 0 # NatM_p_1_Fem_GP_1
# Sex: 1  BioPattern: 1  Growth
 22 35 25.7207 22 99 0 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 60 70 62.4569 66 99 0 2 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.15 0.55 0.343282 0.25 99 0 2 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.001 0.15 0.0572535 0.05 99 0 2 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.3 0.109531 0.11 99 0 2 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 0 1 3.31546e-06 0 99 6 -50 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
 0 4 3.27264 3.3 99 6 -50 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 53 59 55.19 55 99 6 -50 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1
 -3 3 -0.421 -0.25 99 6 -50 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 1 99 6 -50 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 99 6 -50 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Sex: 2  BioPattern: 1  NatMort
 0.01 0.11 0.0604722 -2.89857 0.438 3 3 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
# Sex: 2  BioPattern: 1  Growth
 15 35 26.926 0 99 0 2 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
 50 60 56.6228 0 99 0 2 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
 0.2 0.55 0.371287 0 99 0 2 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
 0.001 0.15 0.0749236 0 99 0 2 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
 0.01 0.3 0.0783725 0 99 0 2 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
# Sex: 2  BioPattern: 1  WtLen
 0 1 3.37087e-06 0 99 6 -50 0 0 0 0 0 0 0 # Wtlen_1_Mal_GP_1
 0 4 3.27008 3.3 99 6 -50 0 0 0 0 0 0 0 # Wtlen_2_Mal_GP_1
# Hermaphroditism
#  Recruitment Distribution  
#  Cohort growth dev base
 0.1 10 1 1 1 0 -1 0 0 0 0 0 0 0 # CohortGrowDev
#  Movement
#  Age Error from parameters
#  catch multiplier
#  fraction female, by GP
 1e-06 0.999999 0.5 0.5 0.5 0 -99 0 0 0 0 0 0 0 # FracFemale_GP_1
#
#_no timevary MG parameters
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_ LO HI INIT PRIOR PR_SD PR_type PHASE
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
3 #_Spawner-Recruitment; Options: 1=NA; 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
             8            12       9.70454           9.8            99             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.2             1           0.7           0.6         0.223             2         -7          0          0          0          0          0          0          0 # SR_BH_steep
           0.2           1.5           1.4           0.6            99             0        -50          0          0          0          0          0          0          0 # SR_sigmaR
            -1             1             0             0            99             0        -50          0          0          0          0          0          0          0 # SR_regime
            -1             1             0             0            99             0        -50          0          0          0          0          0          0          0 # SR_autocorr
#_no timevary SR parameters
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1925 # first year of main recr_devs; early devs can preceed this era
2020 # last year of main recr_devs; forecast devs start in following year
3 #_recdev phase 
1 # (0/1) to read 13 advanced options
 1860 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 3 #_recdev_early_phase
 3 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1976 #_last_yr_nobias_adj_in_MPD; begin of ramp
 1980 #_first_yr_fullbias_adj_in_MPD; begin of plateau
 2019 #_last_yr_fullbias_adj_in_MPD
 2020 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
 0.93 #_max_bias_adj_in_MPD (typical ~0.8; -3 sets all years to 0.0; -2 sets all non-forecast yrs w/ estimated recdevs to 1.0; -1 sets biasadj=1.0 for all yrs w/ recdevs)
 0 #_period of cycles in recruitment (N parms read below)
 -4 #min rec_dev
 4 #max rec_dev
 0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#
# all recruitment deviations
#  1860E 1861E 1862E 1863E 1864E 1865E 1866E 1867E 1868E 1869E 1870E 1871E 1872E 1873E 1874E 1875E 1876E 1877E 1878E 1879E 1880E 1881E 1882E 1883E 1884E 1885E 1886E 1887E 1888E 1889E 1890E 1891E 1892E 1893E 1894E 1895E 1896E 1897E 1898E 1899E 1900E 1901E 1902E 1903E 1904E 1905E 1906E 1907E 1908E 1909E 1910E 1911E 1912E 1913E 1914E 1915E 1916E 1917E 1918E 1919E 1920E 1921E 1922E 1923E 1924E 1925R 1926R 1927R 1928R 1929R 1930R 1931R 1932R 1933R 1934R 1935R 1936R 1937R 1938R 1939R 1940R 1941R 1942R 1943R 1944R 1945R 1946R 1947R 1948R 1949R 1950R 1951R 1952R 1953R 1954R 1955R 1956R 1957R 1958R 1959R 1960R 1961R 1962R 1963R 1964R 1965R 1966R 1967R 1968R 1969R 1970R 1971R 1972R 1973R 1974R 1975R 1976R 1977R 1978R 1979R 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016R 2017R 2018R 2019R 2020R 2021F 2022F 2023F 2024F 2025F 2026F 2027F 2028F 2029F 2030F 2031F 2032F
#  -0.0118125 -0.0126185 -0.0134818 -0.0144022 -0.015398 -0.0164266 -0.0175576 -0.0187584 -0.020024 -0.021388 -0.0228348 -0.0243848 -0.0260382 -0.0277919 -0.0296628 -0.0316792 -0.0337943 -0.0360575 -0.0384606 -0.0410015 -0.0437128 -0.0465536 -0.0495622 -0.0526811 -0.0559477 -0.0592831 -0.0627043 -0.0661561 -0.0697989 -0.0735989 -0.0773617 -0.0815566 -0.0859292 -0.0905285 -0.0953343 -0.100361 -0.105643 -0.111142 -0.116917 -0.122956 -0.129266 -0.135872 -0.142745 -0.149927 -0.157422 -0.165206 -0.173346 -0.181763 -0.190476 -0.199456 -0.208657 -0.218083 -0.227863 -0.238173 -0.249091 -0.260275 -0.271502 -0.283218 -0.294744 -0.306372 -0.318902 -0.331915 -0.344648 -0.358061 -0.371934 -0.486171 -0.469853 -0.51159 -0.5345 -0.510469 -0.516654 -0.536356 -0.576223 -0.575064 -0.583467 -0.40784 -0.67974 -0.666413 -0.4196 -0.45364 -0.512468 -0.635758 -0.622111 -0.583215 -0.571239 -0.483243 -0.610223 -0.555931 -0.587709 -0.455872 -0.364649 -0.386134 -0.157799 -0.387728 -0.217598 0.2216 0.0372357 0.0900005 0.000613906 0.377112 -0.0249969 0.066703 0.377752 -0.100271 0.387793 0.0304046 2.67078 -0.353603 0.00652589 -0.42092 -0.102633 -0.422297 -0.33642 0.0750287 -0.167984 0.225667 0.717257 0.0322997 -0.16421 1.96058 0.487968 1.11812 0.62504 -0.44765 1.3602 1.29145 0.911218 -0.62054 1.05855 0.612256 1.67455 -1.49531 0.180901 -0.472396 0.467421 1.37677 -2.15892 -2.41271 -0.015909 1.28184 2.46455 1.09842 0.628581 -0.937715 0.201088 -2.48991 -1.06046 -2.07128 1.9261 -1.08988 0.999094 0.0896358 -0.75597 1.76345 0.129988 1.11888 2.24867 0.59796 0.323552 0.0540755 -0.186434 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0 0 0 0 0 0 0 0 0 0 0 0
#
#Fishing Mortality info 
0.02 # F ballpark value in units of annual_F
-2000 # F ballpark year (neg value to disable)
3 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
3 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
4  # N iterations for tuning F in hybrid method (recommend 3 to 7)
#
#_initial_F_parms; count = 0
#_ LO HI INIT PRIOR PR_SD  PR_type  PHASE
#2032 2071
# F rates by fleet
# Yr:  1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2032
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# FIX 1.95172e-05 5.62126e-05 6.26356e-05 9.35331e-05 0.000114371 0.000155999 0.000175619 0.000195417 0.000215402 0.000235579 0.000476926 0.000732804 0.00099134 0.00125276 0.00151733 0.0013549 0.0013342 0.00140972 0.00085685 0.00141765 0.00198661 0.00256474 0.00315303 0.00375241 0.00436369 0.00498612 0.0137531 0.0183837 0.0296825 0.0103341 0.00711935 0.00970373 0.00823562 0.0147484 0.01825 0.0226107 0.0201725 0.0276478 0.02326 0.0236762 0.0281111 0.0146622 0.0189361 0.015769 0.0288847 0.0376455 0.0314317 0.0367436 0.0363041 0.040697 0.0315175 0.0282908 0.037453 0.0300485 0.0244783 0.0284436 0.0485209 0.0322769 0.0363434 0.0389083 0.032045 0.0450204 0.029763 0.0193242 0.0259708 0.0246868 0.0179969 0.0286265 0.0133169 0.0202011 0.0252668 0.0149676 0.0135178 0.0119311 0.0119048 0.0104651 0.0081801 0.0262757 0.0149612 0.0335689 0.0113833 0.00579828 0.0125308 0.00574921 0.0223847 0.0517235 0.126954 0.0399124 0.0681607 0.169056 0.0468468 0.0582805 0.0862176 0.0721094 0.049602 0.0643703 0.0645002 0.0659581 0.0616796 0.0534573 0.0462903 0.0562155 0.0538635 0.0441941 0.0507312 0.0532345 0.0601079 0.0787022 0.0398853 0.0676324 0.0787751 0.0739391 0.0495944 0.0479232 0.0409231 0.039557 0.0363923 0.0288205 0.0328717 0.0524318 0.0646299 0.110452 0.0703135 0.0495885 0.0513773 0.0646506 0.0720527 0.0591993 0.0593563 0.0528954 0.0301606 0.0475424 0.044525 0.0937398 0.0928808 0.0920024 0.0911051 0.0902002 0.0892985 0.0885139 0.087622 0.0867318 0.0867316
# NONE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1.05468e-07 1.04493e-07 1.03513e-07 1.02526e-07 1.01535e-07 1.0054e-07 9.96698e-08 9.8676e-08 9.76831e-08 9.76819e-08
# TWL 0 0 0 0 0 0 0 0 0 0 0 1.7343e-05 3.4877e-05 5.25789e-05 7.04628e-05 8.85398e-05 0.00010682 0.00012532 0.000144044 0.000162639 0.000181513 0.000200687 0.000220182 0.000240021 0.00026023 0.00027624 0.000364696 0.00401429 0.00223164 0.00151674 0.003573 0.00472979 0.00125558 0.00254465 0.00446921 0.00350883 0.000866141 0.00500272 0.00474651 0.0078357 0.00762776 0.00574687 0.00534129 0.00767816 0.0124671 0.0169027 0.00642362 0.00444408 0.00501857 0.00600156 0.00610654 0.00976165 0.0173194 0.04012 0.0599357 0.0556389 0.0344276 0.0133792 0.0246421 0.0262576 0.0274283 0.0550247 0.0316512 0.0186503 0.0265269 0.0233921 0.0645588 0.0237632 0.0177254 0.0227483 0.0267975 0.0163352 0.0327612 0.018225 0.0204304 0.0191443 0.0215198 0.0297029 0.0125985 0.0121052 0.0349863 0.0284995 0.0405888 0.0483971 0.0406191 0.0467502 0.046768 0.0437758 0.0540687 0.0858095 0.0631765 0.0699495 0.0992702 0.0712424 0.0853173 0.0830289 0.0836276 0.0859166 0.0703178 0.073658 0.0706682 0.072477 0.0776266 0.0678019 0.0544493 0.0614299 0.0760401 0.0717782 0.0398713 0.0596864 0.0564882 0.0581378 0.027662 0.013906 0.0138203 0.0132042 0.0139933 0.0140944 0.0172331 0.0195663 0.0169744 0.00821739 0.00726194 0.00685341 0.00623875 0.00699534 0.00693652 0.0073472 0.00608525 0.00684871 0.00450586 0.00710611 0.00645012 0.0115561 0.0114494 0.011342 0.0112339 0.0111251 0.0110161 0.0109206 0.0108115 0.0107026 0.0107025
#
#_Q_setup for fleets with cpue or survey data
#_1:  fleet number
#_2:  link type: (1=simple q, 1 parm; 2=mirror simple q, 1 mirrored parm; 3=q and power, 2 parm; 4=mirror with offset, 2 parm)
#_3:  extra input for link, i.e. mirror fleet# or dev index number
#_4:  0/1 to select extra sd parameter
#_5:  0/1 for biasadj or not
#_6:  0/1 to float
#_   fleet      link link_info  extra_se   biasadj     float  #  fleetname
         4         1         0         1         0         0  #  ENV
         5         1         0         1         0         0  #  AKSHLF
         6         1         0         1         0         1  #  AKSLP
         7         1         0         1         0         1  #  NWSLP
         8         1         0         1         0         1  #  NWCBO
-9999 0 0 0 0 0
#
#_Q_parms(if_any);Qunits_are_ln(q)
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
           -15            15     0.0861419             0             1             0          1          0          0          0          0          0          0          0  #  Q_base_ENV(4)
           0.1           1.3      0.309322             0            99             0          2          0          0          0          0          0          0          0  #  Q_extraSD_ENV(4)
           -15            15      0.325075             0            99             0          1          0          0          0          0          0          1          2  #  LnQ_base_AKSHLF(5)
         0.025           1.3      0.178521             0            99             0          2          0          0          0          0          0          0          0  #  Q_extraSD_AKSHLF(5)
           -15             5     -0.417466             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_AKSLP(6)
         0.001           0.7     0.0361518             0            99             0          2          0          0          0          0          0          0          0  #  Q_extraSD_AKSLP(6)
           -15            15     -0.735051             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_NWSLP(7)
         0.001           0.8      0.162325             0            99             0          2          0          0          0          0          0          0          0  #  Q_extraSD_NWSLP(7)
           -15            15      -0.52908             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_NWCBO(8)
         0.001           0.4             0             0            99             0         -2          0          0          0          0          0          0          0  #  Q_extraSD_NWCBO(8)
# timevary Q parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type     PHASE  #  parm_name
           -15            15    -0.0716196             0            99             0      2  # LnQ_base_AKSHLF(5)_BLK1repl_1995
# info on dev vectors created for Q parms are reported with other devs after tag parameter section 
#
#_size_selex_patterns
#Pattern:_0;  parm=0; selex=1.0 for all sizes
#Pattern:_1;  parm=2; logistic; with 95% width specification
#Pattern:_5;  parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_11; parm=2; selex=1.0  for specified min-max population length bin range
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6;  parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8;  parm=8; double_logistic with smooth transitions and constant above Linf option
#Pattern:_9;  parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
#Pattern:_21; parm=2+special; non-parm len selex, read as pairs of size, then selex
#Pattern:_22; parm=4; double_normal as in CASAL
#Pattern:_23; parm=6; double_normal where final value is directly equal to sp(6) so can be >1.0
#Pattern:_24; parm=6; double_normal with sel(minL) and sel(maxL), using joiners
#Pattern:_25; parm=3; exponential-logistic in size
#Pattern:_27; parm=3+special; cubic spline 
#Pattern:_42; parm=2+special+3; // like 27, with 2 additional param for scaling (average over bin range)
#_discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead;_4=define_dome-shaped_retention
#_Pattern Discard Male Special
 0 2 0 0 # 1 FIX
 0 0 0 0 # 2 NONE
 0 2 0 0 # 3 TWL
 0 0 0 0 # 4 ENV
 0 0 0 0 # 5 AKSHLF
 0 0 0 0 # 6 AKSLP
 0 0 0 0 # 7 NWSLP
 0 0 0 0 # 8 NWCBO
#
#_age_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for ages 0 to maxage
#Pattern:_10; parm=0; selex=1.0 for ages 1 to maxage
#Pattern:_11; parm=2; selex=1.0  for specified min-max age
#Pattern:_12; parm=2; age logistic
#Pattern:_13; parm=8; age double logistic
#Pattern:_14; parm=nages+1; age empirical
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_16; parm=2; Coleraine - Gaussian
#Pattern:_17; parm=nages+1; empirical as random walk  N parameters to read can be overridden by setting special to non-zero
#Pattern:_41; parm=2+nages+1; // like 17, with 2 additional param for scaling (average over bin range)
#Pattern:_18; parm=8; double logistic - smooth transition
#Pattern:_19; parm=6; simple 4-parm double logistic with starting age
#Pattern:_20; parm=6; double_normal,using joiners
#Pattern:_26; parm=3; exponential-logistic in age
#Pattern:_27; parm=3+special; cubic spline in age
#Pattern:_42; parm=2+special+3; // cubic spline; with 2 additional param for scaling (average over bin range)
#Age patterns entered with value >100 create Min_selage from first digit and pattern from remainder
#_Pattern Discard Male Special
 20 0 1 0 # 1 FIX
 0 0 0 0 # 2 NONE
 20 0 0 0 # 3 TWL
 0 0 0 0 # 4 ENV
 20 0 1 0 # 5 AKSHLF
 20 0 0 0 # 6 AKSLP
 20 0 0 0 # 7 NWSLP
 20 0 0 0 # 8 NWCBO
#
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn  #  parm_name
# 1   FIX LenSelex
            10            60            41            30            99             0         -5          0          0          0          0          0          2          2  #  Retain_L_infl_FIX(1)
           0.1            20       6.00519             1            99             0         -5          0          0          0          0          0          0          0  #  Retain_L_width_FIX(1)
           -10            10            10       2.18163            99             0         -5          0          0          0          0          0          2          2  #  Retain_L_asymptote_logit_FIX(1)
           -10            10             0             0            99             0        -50          0          0          0          0          0          0          0  #  Retain_L_maleoffset_FIX(1)
             8            70            28            18            99             0        -50          0          0          0          0          0          0          0  #  DiscMort_L_infl_FIX(1)
         0.001             2          0.01             1            99             0        -50          0          0          0          0          0          0          0  #  DiscMort_L_width_FIX(1)
          0.01           0.8           0.2           0.1            99             0        -50          0          0          0          0          0          0          0  #  DiscMort_L_level_old_FIX(1)
           -10            10             0             0            99             0        -50          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_FIX(1)
# 2   NONE LenSelex
# 3   TWL LenSelex
            15            55            41            32            99             0         -5          0          0          0          0          0          3          2  #  Retain_L_infl_TWL(3)
           0.1            20       2.89822             1            99             0         -5          0          0          0          0          0          0          0  #  Retain_L_width_TWL(3)
           -10            10            10            10            99             0         -5          0          0          0          0          0          3          2  #  Retain_L_asymptote_logit_TWL(3)
           -10            10             0             0            99             0        -50          0          0          0          0          0          0          0  #  Retain_L_maleoffset_TWL(3)
             8            70            28            18            99             0        -50          0          0          0          0          0          0          0  #  DiscMort_L_infl_TWL(3)
         0.001             2          0.01             1            99             0        -50          0          0          0          0          0          0          0  #  DiscMort_L_width_TWL(3)
           0.1           0.8           0.5           0.5            99             0        -50          0          0          0          0          0          0          0  #  DiscMort_L_level_old_TWL(3)
           -10            10             0             0            99             0        -50          0          0          0          0          0          0          0  #  DiscMort_L_male_offset_TWL(3)
# 4   ENV LenSelex
# 5   AKSHLF LenSelex
# 6   AKSLP LenSelex
# 7   NWSLP LenSelex
# 8   NWCBO LenSelex
# 1   FIX AgeSelex
             2            20             5             1            99             0         -4          0          0          0          0          0          4          2  #  Age_DblN_peak_FIX(1)
           -20             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_FIX(1)
           -15            10      0.194766             5            99             0          4          0          0          0          0          0          4          2  #  Age_DblN_ascend_se_FIX(1)
           -10            10       2.83982             4            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_descend_se_FIX(1)
            -5             5            -5            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_FIX(1)
            -5             5          -1.5            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_FIX(1)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  AgeSel_1MaleDogleg_FIX
           -15            15     0.0567747             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_1MaleatZero_FIX
           -15            15     -0.835168             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_1MaleatDogleg_FIX
           -15            15      -1.31113             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_1MaleatMaxage_FIX
# 2   NONE AgeSelex
# 3   TWL AgeSelex
          0.01            20             1             1            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_peak_TWL(3)
           -20             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_TWL(3)
           -20            10      -2.40262             5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_TWL(3)
           -10            10            -9             4            99             0         -4          0          0          0          0          0          5          2  #  Age_DblN_descend_se_TWL(3)
            -5             5      -4.02671            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_TWL(3)
            -5             5      -1.60114            -5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_TWL(3)
# 4   ENV AgeSelex
# 5   AKSHLF AgeSelex
             1            12             1             1            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_peak_AKSHLF(5)
            -5             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_AKSHLF(5)
           -10            10      -9.74336             5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_AKSHLF(5)
           -10            10      -1.01065             4            99             0          4          0          0          0          0          0          6          2  #  Age_DblN_descend_se_AKSHLF(5)
           -10             5          -2.5            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_AKSHLF(5)
           -10             5       -3.8559            -5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_AKSHLF(5)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  AgeSel_5MaleDogleg_AKSHLF
           -15            15     -0.544676             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_5MaleatZero_AKSHLF
           -15            15     -0.170609             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_5MaleatDogleg_AKSHLF
           -15            15      -6.15559             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_5MaleatMaxage_AKSHLF
# 6   AKSLP AgeSelex
             1            12       1.46677             1            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_peak_AKSLP(6)
           -20             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_AKSLP(6)
           -10            10            -4             5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_AKSLP(6)
           -20            10      -5.96505            -4            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_descend_se_AKSLP(6)
            -5             5      -1.33799            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_AKSLP(6)
            -5             5     -0.530103            -5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_AKSLP(6)
# 7   NWSLP AgeSelex
             1            12       3.58736             1            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_peak_NWSLP(7)
            -5             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_NWSLP(7)
           -10            10       1.49463             5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_NWSLP(7)
           -20            50      -3.29711             4            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_descend_se_NWSLP(7)
            -5             5        -4.565            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_NWSLP(7)
            -5             5      0.189149            -5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_NWSLP(7)
# 8   NWCBO AgeSelex
          0.01             5     0.0909168             1            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_peak_NWCBO(8)
           -20             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_NWCBO(8)
           -20            10       -8.4499             5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_NWCBO(8)
           -10            10       3.47597             4            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_descend_se_NWCBO(8)
            -5             5            -4            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_NWCBO(8)
            -5             5     -0.320292            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_NWCBO(8)
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            25            60            25            30            99             0      -5  # Retain_L_infl_FIX(1)_BLK2repl_1942
            25            60       38.9601            30            99             0      -5  # Retain_L_infl_FIX(1)_BLK2repl_1947
            25            60        40.349            30            99             0      5  # Retain_L_infl_FIX(1)_BLK2repl_1997
            25            60       41.3726            30            99             0      5  # Retain_L_infl_FIX(1)_BLK2repl_2011
            10            60        35.921            30            99             0      5  # Retain_L_infl_FIX(1)_BLK2repl_2019
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_1942
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_1947
           -10            10       2.53757            10            99             0      5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_1997
           -10            10       4.00765            10            99             0      -5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_2011
           -10            10       2.13517            10            99             0      5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_2019
            15            55            25            32            99             0      -5  # Retain_L_infl_TWL(3)_BLK3repl_1942
            15            55       45.9292            32            99             0      -5  # Retain_L_infl_TWL(3)_BLK3repl_1947
            15            55       47.7536            32            99             0      5  # Retain_L_infl_TWL(3)_BLK3repl_1982
            15            55       33.7502            32            99             0      5  # Retain_L_infl_TWL(3)_BLK3repl_2011
            15            55       42.2739            32            99             0      5  # Retain_L_infl_TWL(3)_BLK3repl_2019
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_1942
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_1947
           -10            10        3.7424            10            99             0      5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_1982
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_2011
           -10            10       5.32636            10            99             0      5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_2019
             2            20       3.15072             1            99             0      4  # Age_DblN_peak_FIX(1)_BLK4repl_1997
             2            20       5.03792             1            99             0      4  # Age_DblN_peak_FIX(1)_BLK4repl_2003
             2            20       3.05793             1            99             0      4  # Age_DblN_peak_FIX(1)_BLK4repl_2011
           -10            20      -1.23983             4            99             0      -4  # Age_DblN_ascend_se_FIX(1)_BLK4repl_1997
           -10            20         1.852             4            99             0      4  # Age_DblN_ascend_se_FIX(1)_BLK4repl_2003
           -10            20      -8.20053             4            99             0      4  # Age_DblN_ascend_se_FIX(1)_BLK4repl_2011
           -10            10        2.0564             4            99             0      4  # Age_DblN_descend_se_TWL(3)_BLK5repl_1982
           -10            10         6.599             4            99             0      4  # Age_DblN_descend_se_TWL(3)_BLK5repl_2003
           -10            10       9.17751             4            99             0      4  # Age_DblN_descend_se_TWL(3)_BLK5repl_2011
           -10            10       3.17048             4            99             0      4  # Age_DblN_descend_se_AKSHLF(5)_BLK6repl_1995
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1)
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read and autogen if tag data exist; 1=read
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# deviation vectors for timevary parameters
#  base   base first block   block  env  env   dev   dev   dev   dev   dev
#  type  index  parm trend pattern link  var  vectr link _mnyr  mxyr phase  dev_vector
#      3     3     1     1     2     0     0     0     0     0     0     0
#      5     1     2     2     2     0     0     0     0     0     0     0
#      5     3     7     2     2     0     0     0     0     0     0     0
#      5     9    12     3     2     0     0     0     0     0     0     0
#      5    11    17     3     2     0     0     0     0     0     0     0
#      5    17    22     4     2     0     0     0     0     0     0     0
#      5    19    25     4     2     0     0     0     0     0     0     0
#      5    30    28     5     2     0     0     0     0     0     0     0
#      5    36    31     6     2     0     0     0     0     0     0     0
     #
# Input variance adjustments factors: 
 #_1=add_to_survey_CV
 #_2=add_to_discard_stddev
 #_3=add_to_bodywt_CV
 #_4=mult_by_lencomp_N
 #_5=mult_by_agecomp_N
 #_6=mult_by_size-at-age_N
 #_7=mult_by_generalized_sizecomp
#_Factor  Fleet  Value
      2      1         0
      2      3         0
      3      1  0.302786
      3      3         0
      4      1  0.095328
      4      3  0.044144
      4      8  0.032931
      5      1  0.101402
      5      3  0.193659
      5      5         1
      5      6  0.109196
      5      7   0.12705
      5      8  0.286539
 -9999   1    0  # terminator
#
1 #_maxlambdaphase
1 #_sd_offset; must be 1 if any growthCV, sigmaR, or survey extraSD is an estimated parameter
# read 0 changes to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch; 
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark; 18=initEQregime
#like_comp fleet  phase  value  sizefreq_method
-9999  1  1  1  1  #  terminator
#
# lambdas (for info only; columns are phases)
#  0 #_CPUE/survey:_1
#  0 #_CPUE/survey:_2
#  0 #_CPUE/survey:_3
#  1 #_CPUE/survey:_4
#  1 #_CPUE/survey:_5
#  1 #_CPUE/survey:_6
#  1 #_CPUE/survey:_7
#  1 #_CPUE/survey:_8
#  1 #_discard:_1
#  0 #_discard:_2
#  1 #_discard:_3
#  0 #_discard:_4
#  0 #_discard:_5
#  0 #_discard:_6
#  0 #_discard:_7
#  0 #_discard:_8
#  1 #_meanbodywt:1
#  1 #_meanbodywt:2
#  1 #_meanbodywt:3
#  1 #_meanbodywt:4
#  1 #_meanbodywt:5
#  1 #_meanbodywt:6
#  1 #_meanbodywt:7
#  1 #_meanbodywt:8
#  1 #_lencomp:_1
#  0 #_lencomp:_2
#  1 #_lencomp:_3
#  0 #_lencomp:_4
#  0 #_lencomp:_5
#  0 #_lencomp:_6
#  0 #_lencomp:_7
#  1 #_lencomp:_8
#  1 #_agecomp:_1
#  0 #_agecomp:_2
#  1 #_agecomp:_3
#  0 #_agecomp:_4
#  1 #_agecomp:_5
#  1 #_agecomp:_6
#  1 #_agecomp:_7
#  1 #_agecomp:_8
#  1 #_init_equ_catch1
#  1 #_init_equ_catch2
#  1 #_init_equ_catch3
#  1 #_init_equ_catch4
#  1 #_init_equ_catch5
#  1 #_init_equ_catch6
#  1 #_init_equ_catch7
#  1 #_init_equ_catch8
#  1 #_recruitments
#  1 #_parameter-priors
#  1 #_parameter-dev-vectors
#  1 #_crashPenLambda
#  0 # F_ballpark_lambda
0 # (0/1/2) read specs for more stddev reporting: 0 = skip, 1 = read specs for reporting stdev for selectivity, size, and numbers, 2 = add options for M and Dyn Bzero
 # 0 2 0 0 # Selectivity: (1) fleet, (2) 1=len/2=age/3=both, (3) year, (4) N selex bins
 # 0 0 # Growth: (1) growth pattern, (2) growth ages
 # 0 0 0 # Numbers-at-age: (1) area(-1 for all), (2) year, (3) N ages
 # -1 # list of bin #'s for selex std (-1 in first bin to self-generate)
 # -1 # list of ages for growth std (-1 in first bin to self-generate)
 # -1 # list of ages for NatAge std (-1 in first bin to self-generate)
999

