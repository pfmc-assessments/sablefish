#V3.30.13-safe;_2019_03_09;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_12.0
#Stock Synthesis (SS) is a work of the U.S. Government and is not subject to copyright protection in the United States.
#Foreign copyrights may apply. See copyright.txt for more information.
#_user_support_available_at:NMFS.Stock.Synthesis@noaa.gov
#_user_info_available_at:https://vlab.ncep.noaa.gov/group/stock-synthesis
#_data_and_control_files: data.ss // control.ss
0  # 0 means do not read wtatage.ss; 1 means read and use wtatage.ss and also read and use growth parameters
1  #_N_Growth_Patterns
1 #_N_platoons_Within_GrowthPattern 
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
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
 1 4 4 3 3 1 1 #_blocks_per_pattern 
# begin and end years of blocks
 1995 2014
 1942 1946 1947 1996 1997 2010 2011 2018
 1942 1946 1947 1981 1982 2010 2011 2018
 1997 2002 2003 2010 2011 2018
 1982 2002 2003 2010 2011 2018
 1995 2014
 1890 1890
#
# controls for all timevary parameters 
1 #_env/block/dev_adjust_method for all time-vary parms (1=warn relative to base parm bounds; 3=no bound check)
#
# AUTOGEN
1 1 1 1 1 # autogen: 1st element for biology, 2nd for SR, 3rd for Q, 4th reserved, 5th for selex
# where: 0 = autogen all time-varying parms; 1 = read each time-varying parm line; 2 = read then autogen if parm min==-12345
#
#_Available timevary codes
#_Block types: 0: P_block=P_base*exp(TVP); 1: P_block=P_base+TVP; 2: P_block=TVP; 3: P_block=P_block(-1) + TVP
#_Block_trends: -1: trend bounded by base parm min-max and parms in transformed units (beware); -2: endtrend and infl_year direct values; -3: end and infl as fraction of base range
#_EnvLinks:  1: P(y)=P_base*exp(TVP*env(y));  2: P(y)=P_base+TVP*env(y);  3: null;  4: P(y)=2.0/(1.0+exp(-TVP1*env(y) - TVP2))
#_DevLinks:  1: P(y)*=exp(dev(y)*dev_se;  2: P(y)+=dev(y)*dev_se;  3: random walk;  4: zero-reverting random walk with rho;  21-24 keep last dev for rest of years
#
#
#
# setup for M, growth, maturity, fecundity, recruitment distibution, movement 
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
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
#
#_growth_parms
#_ LO HI INIT PRIOR PR_SD PR_type PHASE env_var&link dev_link dev_minyr dev_maxyr dev_PH Block Block_Fxn
# Sex: 1  BioPattern: 1  NatMort
 0.01 0.11 0.0758634 -2.93857 0.438 3 3 0 0 0 0 0 0 0 # NatM_p_1_Fem_GP_1
# Sex: 1  BioPattern: 1  Growth
 22 35 25.1516 22 99 0 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 60 70 62.6737 66 99 0 2 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.15 0.55 0.34379 0.25 99 0 2 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.001 0.15 0.0606818 0.05 99 0 2 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.01 0.3 0.110045 0.11 99 0 2 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
# Sex: 1  BioPattern: 1  WtLen
 0 1 3.31546e-06 0 99 6 -50 0 0 0 0 0 0 0 # Wtlen_1_Fem_GP_1
 0 4 3.27264 3.3 99 6 -50 0 0 0 0 0 0 0 # Wtlen_2_Fem_GP_1
# Sex: 1  BioPattern: 1  Maturity&Fecundity
 53 59 55.19 55 99 6 -50 0 0 0 0 0 0 0 # Mat50%_Fem_GP_1
 -3 3 -0.421 -0.25 99 6 -50 0 0 0 0 0 0 0 # Mat_slope_Fem_GP_1
 -3 3 1 1 99 6 -50 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem_GP_1
 -3 3 0 0 99 6 -50 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem_GP_1
# Sex: 2  BioPattern: 1  NatMort
 0.01 0.11 0.0675262 -2.89857 0.438 3 3 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
# Sex: 2  BioPattern: 1  Growth
 15 35 25.5019 0 99 0 2 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
 50 60 56.3704 0 99 0 2 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
 0.2 0.55 0.400115 0 99 0 2 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
 0.001 0.15 0.0663632 0 99 0 2 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
 0.01 0.3 0.0796672 0 99 0 2 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
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
3 #_Spawner-Recruitment; Options: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepherd_3Parm; 9=RickerPower_3parm
0  # 0/1 to use steepness in initial equ recruitment calculation
0  #  future feature:  0/1 to make realized sigmaR a function of SR curvature
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type      PHASE    env-var    use_dev   dev_mnyr   dev_mxyr     dev_PH      Block    Blk_Fxn #  parm_name
             8            12       9.61725           9.8            99             0          1          0          0          0          0          0          0          0 # SR_LN(R0)
           0.2             1           0.7           0.6         0.223             2         -7          0          0          0          0          0          0          0 # SR_BH_steep
           0.2           1.5           1.4           0.6            99             0        -50          0          0          0          0          0          0          0 # SR_sigmaR
            -1             1             0             0            99             0        -50          0          0          0          0          0          0          0 # SR_regime
            -1             1             0             0            99             0        -50          0          0          0          0          0          0          0 # SR_autocorr
1 #do_recdev:  0=none; 1=devvector (R=F(SSB)+dev); 2=deviations (R=F(SSB)+dev); 3=deviations (R=R0*dev; dev2=R-f(SSB)); 4=like 3 with sum(dev2) adding penalty
1925 # first year of main recr_devs; early devs can preceed this era
2018 # last year of main recr_devs; forecast devs start in following year
3 #_recdev phase 
1 # (0/1) to read 13 advanced options
 1860 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 3 #_recdev_early_phase
 3 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1976 #_last_yr_nobias_adj_in_MPD; begin of ramp
 1980 #_first_yr_fullbias_adj_in_MPD; begin of plateau
 2017 #_last_yr_fullbias_adj_in_MPD
 2018 #_end_yr_for_ramp_in_MPD (can be in forecast to shape ramp, but SS sets bias_adj to 0.0 for fcast yrs)
 0.93 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
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
#  1860E 1861E 1862E 1863E 1864E 1865E 1866E 1867E 1868E 1869E 1870E 1871E 1872E 1873E 1874E 1875E 1876E 1877E 1878E 1879E 1880E 1881E 1882E 1883E 1884E 1885E 1886E 1887E 1888E 1889E 1890E 1891E 1892E 1893E 1894E 1895E 1896E 1897E 1898E 1899E 1900E 1901E 1902E 1903E 1904E 1905E 1906E 1907E 1908E 1909E 1910E 1911E 1912E 1913E 1914E 1915E 1916E 1917E 1918E 1919E 1920E 1921E 1922E 1923E 1924E 1925R 1926R 1927R 1928R 1929R 1930R 1931R 1932R 1933R 1934R 1935R 1936R 1937R 1938R 1939R 1940R 1941R 1942R 1943R 1944R 1945R 1946R 1947R 1948R 1949R 1950R 1951R 1952R 1953R 1954R 1955R 1956R 1957R 1958R 1959R 1960R 1961R 1962R 1963R 1964R 1965R 1966R 1967R 1968R 1969R 1970R 1971R 1972R 1973R 1974R 1975R 1976R 1977R 1978R 1979R 1980R 1981R 1982R 1983R 1984R 1985R 1986R 1987R 1988R 1989R 1990R 1991R 1992R 1993R 1994R 1995R 1996R 1997R 1998R 1999R 2000R 2001R 2002R 2003R 2004R 2005R 2006R 2007R 2008R 2009R 2010R 2011R 2012R 2013R 2014R 2015R 2016R 2017R 2018R 2019F 2020F 2021F 2022F 2023F 2024F 2025F 2026F 2027F 2028F 2029F 2030F
#  -0.011604 -0.0124676 -0.0133953 -0.0143911 -0.0154603 -0.0166078 -0.017839 -0.0191602 -0.0205771 -0.0220971 -0.0237269 -0.0254742 -0.027345 -0.0293504 -0.0314972 -0.0337947 -0.0362511 -0.0388752 -0.041676 -0.0446598 -0.0478337 -0.0511979 -0.054751 -0.0584839 -0.0623757 -0.066393 -0.0705002 -0.0747116 -0.0791151 -0.0837588 -0.0883627 -0.0934789 -0.0988624 -0.104522 -0.11047 -0.116717 -0.123271 -0.130151 -0.137368 -0.14494 -0.15288 -0.1612 -0.169905 -0.179002 -0.188487 -0.198358 -0.208622 -0.21928 -0.230316 -0.241719 -0.253461 -0.265509 -0.277941 -0.290947 -0.304572 -0.31882 -0.333279 -0.348104 -0.362531 -0.376954 -0.392456 -0.408514 -0.424218 -0.440642 -0.457481 -0.57443 -0.569556 -0.607458 -0.630665 -0.611005 -0.620438 -0.638494 -0.680411 -0.679558 -0.683417 -0.595223 -0.774667 -0.773343 -0.579889 -0.608521 -0.648075 -0.724535 -0.708285 -0.649284 -0.634793 -0.56809 -0.650335 -0.583122 -0.730811 -0.47235 -0.387244 -0.351122 -0.167392 -0.340144 -0.136039 0.222056 0.198812 0.362246 0.0880824 1.80681 -0.00550459 0.155764 0.423339 -0.160036 1.57553 0.00115274 2.08431 -0.354231 0.00184118 -0.5292 0.259805 -0.381254 -0.223599 1.02591 -0.17418 0.691487 0.394636 0.578792 0.0541656 1.65128 0.819552 1.06965 0.233559 -0.317082 1.37108 1.39632 0.941186 0.6932 0.451502 1.26358 1.40683 -0.341099 -0.315125 -0.356801 0.623891 1.12488 -1.67536 -1.41731 -0.0870656 1.96248 1.88406 1.13361 0.165037 -0.718405 0.0336948 -2.95542 -1.48856 -2.48204 1.71303 -1.8656 1.05772 -0.0634913 -0.291948 1.76808 0.00395903 0.834045 2.41069 -1.12726 -1.2284 0 0 0 0 0 0 0 0 0 0 0 0
# implementation error by year in forecast:  0 0 0 0 0 0 0 0 0 0 0 0
#
#Fishing Mortality info 
0.02 # F ballpark
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
#2030 2039
# F rates by fleet
# Yr:  1890 1891 1892 1893 1894 1895 1896 1897 1898 1899 1900 1901 1902 1903 1904 1905 1906 1907 1908 1909 1910 1911 1912 1913 1914 1915 1916 1917 1918 1919 1920 1921 1922 1923 1924 1925 1926 1927 1928 1929 1930 1931 1932 1933 1934 1935 1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 1947 1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030
# seas:  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
# FIX 1.82789e-05 5.26711e-05 5.87198e-05 8.77373e-05 0.000107354 0.000146519 0.000165056 0.000183792 0.00020274 0.000221915 0.000449673 0.000691619 0.000936639 0.00118502 0.00143707 0.00128494 0.00126709 0.00134079 0.000816216 0.0013526 0.00189865 0.00245552 0.00302442 0.00360651 0.00420297 0.00481348 0.0133113 0.0178491 0.0289295 0.010112 0.00699326 0.00957008 0.00815375 0.0146548 0.0182015 0.0226378 0.0202749 0.027907 0.0236094 0.0241705 0.0288059 0.0150865 0.0195277 0.0162929 0.0299697 0.0393127 0.0330496 0.0388586 0.0386079 0.0437252 0.0343829 0.0309413 0.041181 0.0335681 0.0277402 0.0325543 0.0557129 0.0369974 0.0413763 0.0440956 0.0362837 0.0509141 0.0337838 0.0218462 0.0291363 0.0274149 0.019804 0.0314006 0.0142347 0.0211356 0.026105 0.0148554 0.012198 0.00885598 0.00786463 0.00677283 0.00528752 0.0168028 0.0087916 0.0187491 0.00840879 0.00608111 0.0136256 0.00644594 0.0250612 0.0552291 0.123794 0.0339563 0.0517142 0.120206 0.0338682 0.0449318 0.0667386 0.0591697 0.0458077 0.060434 0.0632634 0.0650799 0.0589522 0.0513644 0.0447369 0.0532487 0.0498095 0.0406652 0.0468895 0.052603 0.0589392 0.0773807 0.0415638 0.0677708 0.0791177 0.076262 0.0493645 0.0541798 0.0486335 0.0490222 0.0461604 0.0374509 0.0429527 0.0671822 0.080997 0.111695 0.0812231 0.0600251 0.0625656 0.0804932 0.0865338 0.069311 0.067854 0.0714148 0.0547715 0.0722277 0.0714676 0.0707938 0.0701215 0.0694479 0.0687723 0.0680947 0.0675007 0.0668215 0.0661425
# NONE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
# TWL 0 0 0 0 0 0 0 0 0 0 0 1.80963e-05 3.64293e-05 5.49797e-05 7.3767e-05 9.28068e-05 0.000112114 0.000131709 0.000151603 0.000171427 0.000191625 0.000212226 0.000233262 0.000254765 0.000276772 0.000294419 0.000389662 0.004302 0.00240033 0.00163674 0.00386597 0.00513185 0.00136615 0.00277707 0.00489419 0.0038569 0.000955319 0.00553653 0.00527237 0.00874714 0.00854694 0.0064678 0.00603877 0.00871294 0.0142015 0.0193531 0.00740386 0.00517412 0.00589635 0.00701425 0.00722257 0.0116899 0.0208976 0.0483481 0.0722419 0.0674382 0.0419862 0.0163051 0.0300951 0.0319652 0.0335713 0.0680102 0.0387389 0.0227106 0.0319677 0.0280953 0.0763921 0.0279085 0.0205308 0.0249313 0.0279034 0.0134446 0.020538 0.0159708 0.0174072 0.0160762 0.0154129 0.0190897 0.0136802 0.0158343 0.0321714 0.0271275 0.0389756 0.0460782 0.0397013 0.0432832 0.0402059 0.0411878 0.0501092 0.0845635 0.0566606 0.0703229 0.099537 0.0752759 0.0919478 0.0894914 0.0888341 0.0899571 0.0736813 0.0760969 0.0713651 0.0712976 0.0788194 0.0706694 0.0571847 0.0646147 0.0803536 0.0767095 0.0440772 0.067114 0.0635152 0.0608208 0.0289421 0.0178964 0.0181372 0.0176561 0.019037 0.0195407 0.0242915 0.028213 0.0251567 0.0128032 0.011414 0.0107924 0.00971977 0.010735 0.0106431 0.0108669 0.00895109 0.010344 0.010534 0.0145903 0.0144384 0.0143027 0.0141672 0.0140317 0.0138961 0.0137605 0.0136417 0.0135059 0.0133701
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
           -15            15      0.125554             0             1             0          1          0          0          0          0          0          0          0  #  Q_base_ENV(4)
           0.1           1.3      0.729614             0            99             0          2          0          0          0          0          0          0          0  #  Q_extraSD_ENV(4)
           -15            15      0.448715             0            99             0          1          0          0          0          0          0          1          2  #  LnQ_base_AKSHLF(5)
           0.1           1.3      0.155084             0            99             0          2          0          0          0          0          0          0          0  #  Q_extraSD_AKSHLF(5)
           -15             5     -0.474247             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_AKSLP(6)
         0.001           0.7     0.0540733             0            99             0          2          0          0          0          0          0          0          0  #  Q_extraSD_AKSLP(6)
           -15            15     -0.643706             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_NWSLP(7)
         0.001           0.8      0.162636             0            99             0          2          0          0          0          0          0          0          0  #  Q_extraSD_NWSLP(7)
           -15            15     -0.221788             0             1             0         -1          0          0          0          0          0          0          0  #  LnQ_base_NWCBO(8)
         0.001           0.4             0             0            99             0         -2          0          0          0          0          0          0          0  #  Q_extraSD_NWCBO(8)
# timevary Q parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type     PHASE  #  parm_name
           -15            15      0.203242             0            99             0      2  # LnQ_base_AKSHLF(5)_BLK1repl_1995
# info on dev vectors created for Q parms are reported with other devs after tag parameter section 
#
#_size_selex_patterns
#Pattern:_0; parm=0; selex=1.0 for all sizes
#Pattern:_1; parm=2; logistic; with 95% width specification
#Pattern:_5; parm=2; mirror another size selex; PARMS pick the min-max bin to mirror
#Pattern:_15; parm=0; mirror another age or length selex
#Pattern:_6; parm=2+special; non-parm len selex
#Pattern:_43; parm=2+special+2;  like 6, with 2 additional param for scaling (average over bin range)
#Pattern:_8; parm=8; New doublelogistic with smooth transitions and constant above Linf option
#Pattern:_9; parm=6; simple 4-parm double logistic with starting length; parm 5 is first length; parm 6=1 does desc as offset
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
            25            60            41            30            99             0         -5          0          0          0          0          0          2          2  #  Retain_L_infl_FIX(1)
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
             2            20             5             1            99             0         -4          0          0          0          0          0          4          2  #  Age_DblN_peak_FIX(9)
           -20             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_FIX(9)
           -10            10      0.937309             5            99             0          4          0          0          0          0          0          4          2  #  Age_DblN_ascend_se_FIX(9)
           -10            10       3.98234             4            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_descend_se_FIX(9)
            -5             5            -5            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_FIX(9)
            -5             5          -1.5            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_FIX(9)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  AgeSel_1MaleDogleg_FIX
           -15            15     0.0935753             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_1MaleatZero_FIX
           -15            15      -1.03213             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_1MaleatDogleg_FIX
           -15            15     -0.601926             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_1MaleatMaxage_FIX
# 2   NONE AgeSelex
# 3   TWL AgeSelex
          0.01            20             1             1            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_peak_TWL(11)
           -20             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_TWL(11)
           -20            10      -3.08552             5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_TWL(11)
           -10            10            -9             4            99             0         -4          0          0          0          0          0          5          2  #  Age_DblN_descend_se_TWL(11)
            -5             5      -4.02671            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_TWL(11)
            -5             5      -1.38018            -5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_TWL(11)
# 4   ENV AgeSelex
# 5   AKSHLF AgeSelex
             1            12             1             1            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_peak_AKSHLF(13)
            -5             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_AKSHLF(13)
           -10            10      -7.76305             5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_AKSHLF(13)
           -10            10      -6.55305             4            99             0          4          0          0          0          0          0          6          2  #  Age_DblN_descend_se_AKSHLF(13)
           -10             5          -2.5            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_AKSHLF(13)
           -10             5      -3.63971            -5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_AKSHLF(13)
           -15            15             0             0             0             0         -4          0          0          0          0          0          0          0  #  AgeSel_5MaleDogleg_AKSHLF
           -15            15      0.653485             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_5MaleatZero_AKSHLF
           -15            15    -0.0534667             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_5MaleatDogleg_AKSHLF
           -15            15      -8.20707             0             0             0          4          0          0          0          0          0          0          0  #  AgeSel_5MaleatMaxage_AKSHLF
# 6   AKSLP AgeSelex
             1            12       1.67174             1            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_peak_AKSLP(14)
           -20             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_AKSLP(14)
           -10            10            -4             5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_AKSLP(14)
           -20            10      -4.41193            -4            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_descend_se_AKSLP(14)
            -5             5      -1.33799            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_AKSLP(14)
            -5             5     0.0112243            -5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_AKSLP(14)
# 7   NWSLP AgeSelex
             1            12       3.84294             1            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_peak_NWSLP(15)
            -5             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_NWSLP(15)
           -10            10       1.81778             5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_NWSLP(15)
           -20            50      -13.0436             4            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_descend_se_NWSLP(15)
            -5             5        -4.565            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_NWSLP(15)
            -5             5      0.617542            -5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_NWSLP(15)
# 8   NWCBO AgeSelex
          0.01             5     0.0924171             1            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_peak_NWCBO(16)
           -20             5            -4           0.3            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_top_logit_NWCBO(16)
           -20            10      -9.40559             5            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_ascend_se_NWCBO(16)
           -10            10        3.1879             4            99             0          4          0          0          0          0          0          0          0  #  Age_DblN_descend_se_NWCBO(16)
            -5             5            -4            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_start_logit_NWCBO(16)
            -5             5     -0.320292            -5            99             0         -4          0          0          0          0          0          0          0  #  Age_DblN_end_logit_NWCBO(16)
# timevary selex parameters 
#_          LO            HI          INIT         PRIOR         PR_SD       PR_type    PHASE  #  parm_name
            25            60            25            30            99             0      -5  # Retain_L_infl_FIX(1)_BLK2repl_1942
            25            60       38.9601            30            99             0      -5  # Retain_L_infl_FIX(1)_BLK2repl_1947
            25            60       37.3551            30            99             0      5  # Retain_L_infl_FIX(1)_BLK2repl_1997
            25            60       41.7205            30            99             0      5  # Retain_L_infl_FIX(1)_BLK2repl_2011
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_1942
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_1947
           -10            10       2.13704            10            99             0      5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_1997
           -10            10       4.00765            10            99             0      -5  # Retain_L_asymptote_logit_FIX(1)_BLK2repl_2011
            15            55            25            32            99             0      -5  # Retain_L_infl_TWL(3)_BLK3repl_1942
            15            55       45.9292            32            99             0      -5  # Retain_L_infl_TWL(3)_BLK3repl_1947
            15            55       48.0837            32            99             0      5  # Retain_L_infl_TWL(3)_BLK3repl_1982
            15            55       32.1994            32            99             0      5  # Retain_L_infl_TWL(3)_BLK3repl_2011
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_1942
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_1947
           -10            10        4.1173            10            99             0      5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_1982
           -10            10            10            10            99             0      -5  # Retain_L_asymptote_logit_TWL(3)_BLK3repl_2011
             2            20       3.41352             1            99             0      4  # Age_DblN_peak_FIX(9)_BLK4repl_1997
             2            20       5.06527             1            99             0      4  # Age_DblN_peak_FIX(9)_BLK4repl_2003
             2            20       3.05029             1            99             0      4  # Age_DblN_peak_FIX(9)_BLK4repl_2011
           -10            20      -1.23983             4            99             0      -4  # Age_DblN_ascend_se_FIX(9)_BLK4repl_1997
           -10            20       1.45359             4            99             0      4  # Age_DblN_ascend_se_FIX(9)_BLK4repl_2003
           -10            20      -8.83183             4            99             0      4  # Age_DblN_ascend_se_FIX(9)_BLK4repl_2011
           -10            10       2.33011             4            99             0      4  # Age_DblN_descend_se_TWL(11)_BLK5repl_1982
           -10            10       6.37816             4            99             0      4  # Age_DblN_descend_se_TWL(11)_BLK5repl_2003
           -10            10        7.3436             4            99             0      4  # Age_DblN_descend_se_TWL(11)_BLK5repl_2011
           -10            10       2.75949             4            99             0      4  # Age_DblN_descend_se_AKSHLF(13)_BLK6repl_1995
# info on dev vectors created for selex parms are reported with other devs after tag parameter section 
#
0   #  use 2D_AR1 selectivity(0/1):  experimental feature
#_no 2D_AR1 selex offset used
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
# deviation vectors for timevary parameters
#  base   base first block   block  env  env   dev   dev   dev   dev   dev
#  type  index  parm trend pattern link  var  vectr link _mnyr  mxyr phase  dev_vector
#      3     3     1     1     2     0     0     0     0     0     0     0
#      5     1     2     2     2     0     0     0     0     0     0     0
#      5     3     6     2     2     0     0     0     0     0     0     0
#      5     9    10     3     2     0     0     0     0     0     0     0
#      5    11    14     3     2     0     0     0     0     0     0     0
#      5    17    18     4     2     0     0     0     0     0     0     0
#      5    19    21     4     2     0     0     0     0     0     0     0
#      5    30    24     5     2     0     0     0     0     0     0     0
#      5    36    27     6     2     0     0     0     0     0     0     0
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
      3      2 0.0283904
      3      3         0
      4      8  0.291349
      5      1         1
      5      3         1
      5      5  0.103912
      5      6  0.316743
      5      7  0.440877
      5      8  0.246557
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
#  0 #_lencomp:_1
#  0 #_lencomp:_2
#  0 #_lencomp:_3
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
#  1 #_init_equ_catch
#  1 #_recruitments
#  1 #_parameter-priors
#  1 #_parameter-dev-vectors
#  1 #_crashPenLambda
#  0 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting 
 # 0 0 0 0 0 0 0 0 0 # placeholder for # selex_fleet, 1=len/2=age/3=both, year, N selex bins, 0 or Growth pattern, N growth ages, 0 or NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

