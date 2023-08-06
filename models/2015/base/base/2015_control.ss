#V3.24U
#_data_and_control_files: 2011_sablefish_data.SS // 2011_sablefish_control.SS
#_SS-V3.24U-safe;_08/29/2014;_Stock_Synthesis_by_Richard_Methot_(NOAA)_using_ADMB_11.2_Win64
1  #_N_Growth_Patterns
1 #_N_Morphs_Within_GrowthPattern
#_Cond 1 #_Morph_between/within_stdev_ratio (no read if N_morphs=1)
#_Cond  1 #vector_Morphdist_(-1_in_first_val_gives_normal_approx)
#
#_Cond 0  #  N recruitment designs goes here if N_GP*nseas*area>1
#_Cond 0  #  placeholder for recruitment interaction request
#_Cond 1 1 1  # example recruitment design element for GP=1, seas=1, area=1
#
#_Cond 0 # N_movement_definitions goes here if N_areas > 1
#_Cond 1.0 # first age that moves (real age at begin of season, not integer) also cond on do_migration>0
#_Cond 1 1 1 2 4 10 # example move definition for seas=1, morph=1, source=1 dest=2, age1=4, age2=10
#
4 #_Nblock_Patterns
 1 1 1 1 #_blocks_per_pattern
# begin and end years of blocks
 1900 1996
 1982 2010
 1942 1946
 1900 2002
#
0.5 #_fracfemale
0 #_natM_type:_0=1Parm; 1=N_breakpoints;_2=Lorenzen;_3=agespecific;_4=agespec_withseasinterpolate
  #_no additional input for selected M option; read 1P per morph
1 # GrowthModel: 1=vonBert with L1&L2; 2=Richards with L1&L2; 3=age_speciific_K; 4=not implemented
0.5 #_Growth_Age_for_L1
30 #_Growth_Age_for_L2 (999 to use as Linf)
0 #_SD_add_to_LAA (set to 0.1 for SS2 V1.x compatibility)
0 #_CV_Growth_Pattern:  0 CV=f(LAA); 1 CV=F(A); 2 SD=F(LAA); 3 SD=F(A); 4 logSD=F(A)
1 #_maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity by GP; 4=read age-fecundity by GP; 5=read fec and wt from wtatage.ss; 6=read length-maturity by GP
#_placeholder for empirical age- or length- maturity by growth pattern (female only)
3 #_First_Mature_Age
1 #_fecundity option:(1)eggs=Wt*(a+b*Wt);(2)eggs=a*L^b;(3)eggs=a*Wt^b; (4)eggs=a+b*L; (5)eggs=a+b*W
0 #_hermaphroditism option:  0=none; 1=age-specific fxn
1 #_parameter_offset_approach (1=none, 2= M, G, CV_G as offset from female-GP1, 3=like SS2 V1.x)
1 #_env/block/dev_adjust_method (1=standard; 2=logistic transform keeps in base parm bounds; 3=standard w/ no bound check)
#
#_growth_parms
#_LO HI INIT PRIOR PR_type SD PHASE env-var use_dev dev_minyr dev_maxyr dev_stddev Block Block_Fxn
 0.01 0.11 0.0757999 -2.1791 3 0.3384 3 0 0 0 0 0 0 0 # NatM_p_1_Fem_GP_1
 22 30 26.149 22 -1 99 2 0 0 0 0 0 0 0 # L_at_Amin_Fem_GP_1
 60 70 64.2267 66 -1 99 2 0 0 0 0 0 0 0 # L_at_Amax_Fem_GP_1
 0.15 0.35 0.326784 0.25 -1 99 2 0 0 0 0 0 0 0 # VonBert_K_Fem_GP_1
 0.03 0.15 0.078497 0.05 -1 99 2 0 0 0 0 0 0 0 # CV_young_Fem_GP_1
 0.03 0.15 0.118391 0.11 -1 99 2 0 0 0 0 0 0 0 # CV_old_Fem_GP_1
 0.01 0.11 0.0615699 -2.0565 3 0.3375 3 0 0 0 0 0 0 0 # NatM_p_1_Mal_GP_1
 -3 3 0 0 -1 99 -50 0 0 0 0 0 0 0 # L_at_Amin_Mal_GP_1
 50 60 56.2739 0 -1 99 2 0 0 0 0 0 0 0 # L_at_Amax_Mal_GP_1
 0.2 0.5 0.415657 0 -1 99 2 0 0 0 0 0 0 0 # VonBert_K_Mal_GP_1
 -3 3 0 0 -1 99 -50 0 0 0 0 0 0 0 # CV_young_Mal_GP_1
 0.03 0.15 0.0779401 0 -1 99 2 0 0 0 0 0 0 0 # CV_old_Mal_GP_1
 0 1 3.26728e-006 0 0 99 -50 0 0 0 0 0 0 0 # Wtlen_1_Fem
 0 4 3.27596 3.3 0 99 -50 0 0 0 0 0 0 0 # Wtlen_2_Fem
 57 59 58 55 0 99 -50 0 0 0 0 0 0 0 # Mat50%_Fem
 -3 3 -0.13 -0.25 0 99 -50 0 0 0 0 0 0 0 # Mat_slope_Fem
 -3 3 1 1 0 99 -50 0 0 0 0 0 0 0 # Eggs/kg_inter_Fem
 -3 3 0 0 0 99 -50 0 0 0 0 0 0 0 # Eggs/kg_slope_wt_Fem
 0 1 3.32942e-006 0 0 99 -50 0 0 0 0 0 0 0 # Wtlen_1_Mal
 0 4 3.27292 3.3 0 99 -50 0 0 0 0 0 0 0 # Wtlen_2_Mal
 -4 4 0 0 -1 99 -50 0 0 0 0 0 0 0 # RecrDist_GP_1
 -4 4 0 0 -1 99 -50 0 0 0 0 0 0 0 # RecrDist_Area_1
 -4 4 0 0 -1 99 -50 0 0 0 0 0 0 0 # RecrDist_Seas_1
 -4 4 0 0 -1 99 -50 0 0 0 0 0 0 0 # CohortGrowDev
#
#_Cond 0  #custom_MG-env_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no MG-environ parameters
#
#_Cond 0  #custom_MG-block_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no MG-block parameters
#_Cond No MG parm trends
#
#_seasonal_effects_on_biology_parms
 0 0 0 0 0 0 0 0 0 0 #_femwtlen1,femwtlen2,mat1,mat2,fec1,fec2,Malewtlen1,malewtlen2,L1,K
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no seasonal MG parameters
#
#_Cond -4 #_MGparm_Dev_Phase
#
#_Spawner-Recruitment
3 #_SR_function: 2=Ricker; 3=std_B-H; 4=SCAA; 5=Hockey; 6=B-H_flattop; 7=survival_3Parm; 8=Shepard_3Parm
#_LO HI INIT PRIOR PR_type SD PHASE
 8 12 9.75254 9.8 -1 99 7 # SR_LN(R0)
 0.2 1 0.6 0.6 2 0.223 -9 # SR_BH_steep
 0.2 1.5 0.95 0.6 -1 99 -50 # SR_sigmaR
 -1 1 0 0 -1 99 -50 # SR_envlink
 -1 1 0 0 -1 99 -50 # SR_R1_offset
 -1 1 0 0 -1 99 -50 # SR_autocorr
0 #_SR_env_link
0 #_SR_env_target_0=none;1=devs;_2=R0;_3=steepness
1 #do_recdev:  0=none; 1=devvector; 2=simple deviations
1965 # first year of main recr_devs; early devs can preceed this era
2014 # last year of main recr_devs; forecast devs start in following year
6 #_recdev phase
1 # (0/1) to read 13 advanced options
 1851 #_recdev_early_start (0=none; neg value makes relative to recdev_start)
 6 #_recdev_early_phase
 6 #_forecast_recruitment phase (incl. late recr) (0 value resets to maxphase+1)
 1 #_lambda for Fcast_recr_like occurring before endyr+1
 1971.37 #_last_early_yr_nobias_adj_in_MPD
 1980.72 #_first_yr_fullbias_adj_in_MPD
 2014 #_last_yr_fullbias_adj_in_MPD
 2014.96 #_first_recent_yr_nobias_adj_in_MPD
 0.9253 #_max_bias_adj_in_MPD (-1 to override ramp and set biasadj=1.0 for all estimated recdevs)
 0 #_period of cycles in recruitment (N parms read below)
 -4 #min rec_dev
 4 #max rec_dev
 0 #_read_recdevs
#_end of advanced SR options
#
#_placeholder for full parameter lines for recruitment cycles
# read specified recr devs
#_Yr Input_value
#Fishing Mortality info
0.02 # F ballpark for annual F (=Z-M) for specified year
-2000 # F ballpark year (neg value to disable)
1 # F_Method:  1=Pope; 2=instan. F; 3=hybrid (hybrid is recommended)
0.9 # max F or harvest rate, depends on F_Method
# no additional F input needed for Fmethod 1
# if Fmethod=2; read overall start F value; overall phase; N detailed inputs to read
# if Fmethod=3; read N iterations for tuning for Fmethod 3
#
#_initial_F_parms
#_LO HI INIT PRIOR PR_type SD PHASE
 -1 1 0 0 -1 99 -1 # InitF_1HKL
 -1 1 0 0 -1 99 -1 # InitF_2POT
 -1 1 0 0 -1 99 -1 # InitF_3TWL
#
#_Q_setup
 # Q_type options:  <0=mirror, 0=float_nobiasadj, 1=float_biasadj, 2=parm_nobiasadj, 3=parm_w_random_dev, 4=parm_w_randwalk, 5=mean_unbiased_float_assign_to_parm
#_for_env-var:_enter_index_of_the_env-var_to_be_linked
#_Den-dep  env-var  extra_se  Q_type
 0 0 0 0 # 1 HKL
 0 0 0 0 # 2 POT
 0 0 0 0 # 3 TWL
 0 0 0 0 # 4 ENV
 0 0 1 4 # 5 AKSHLF
 0 0 1 0 # 6 AKSLP
 0 0 1 0 # 7 NWSLP
 0 0 1 0 # 8 NWCBO
#
1 #_0=read one parm for each fleet with random q; 1=read a parm for each year of index
#_Q_parms(if_any);Qunits_are_ln(q)
# LO HI INIT PRIOR PR_type SD PHASE
 0.1 1.3 0.346255 0 -1 99 3 # Q_extraSD_5_AKSHLF
 0.001 0.7 0.0652329 0 -1 99 3 # Q_extraSD_6_AKSLP
 0.001 0.8 0.0942713 0 -1 99 3 # Q_extraSD_7_NWSLP
 0.001 0.4 0 0 -1 99 -3 # Q_extraSD_8_NWCBO
 -3 0.5 -1.14156 0 -1 99 1 # LnQ_base_5_AKSHLF
 -2 2 0 0 -1 99 -50 # Q_walk_5y_1983
 -2 2 0 0 -1 99 -50 # Q_walk_5y_1986
 -2 2 0 0 -1 99 -50 # Q_walk_5y_1989
 -2 2 0 0 -1 99 -50 # Q_walk_5y_1992
 -2 3 0.666567 0 -1 99 1 # Q_walk_5y_1995
 -2 2 0 0 -1 99 -50 # Q_walk_5y_1998
 -2 2 0 0 -1 99 -50 # Q_walk_5y_2001
 -2 2 0 0 -1 99 -50 # Q_walk_5y_2004
#
#_size_selex_types
#discard_options:_0=none;_1=define_retention;_2=retention&mortality;_3=all_discarded_dead
#_Pattern Discard Male Special
 0 2 0 0 # 1 HKL
 0 2 0 0 # 2 POT
 0 2 0 0 # 3 TWL
 31 0 0 0 # 4 ENV
 0 0 0 0 # 5 AKSHLF
 0 0 0 0 # 6 AKSLP
 0 0 0 0 # 7 NWSLP
 0 0 0 0 # 8 NWCBO
#
#_age_selex_types
#_Pattern ___ Male Special
 27 0 1 4 # 1 HKL
 27 0 1 4 # 2 POT
 27 0 1 5 # 3 TWL
 11 0 0 0 # 4 ENV
 20 0 0 0 # 5 AKSHLF
 20 0 0 0 # 6 AKSLP
 20 0 0 0 # 7 NWSLP
 20 0 0 0 # 8 NWCBO
#_LO HI INIT PRIOR PR_type SD PHASE env-var use_dev dev_minyr dev_maxyr dev_stddev Block Block_Fxn
 25 45 31.3007 30 -1 99 6 0 0 0 0 0 3 2 # Retain_1P_1_HKL
 0.001 4 1 1 -1 99 -6 0 0 0 0 0 0 0 # Retain_1P_2_HKL
 0.7 1 0.864362 1 -1 99 6 0 0 0 0 0 1 2 # Retain_1P_3_HKL
 -10 10 0 0 -1 99 -50 0 0 0 0 0 0 0 # Retain_1P_4_HKL
 8 70 28 18 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_1P_1_HKL
 0.001 2 0.01 1 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_1P_2_HKL
 0.01 0.8 0.2 0.1 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_1P_3_HKL
 -10 10 0 0 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_1P_4_HKL
 35 60 50.548 30 -1 99 6 0 0 0 0 0 3 2 # Retain_2P_1_POT
 3 20 6.80474 1 -1 99 6 0 0 0 0 0 0 0 # Retain_2P_2_POT
 0.6 1 1 1 -1 99 -6 0 0 0 0 0 1 2 # Retain_2P_3_POT
 -10 10 0 0 -1 99 -50 0 0 0 0 0 0 0 # Retain_2P_4_POT
 8 70 28 18 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_2P_1_POT
 0.001 2 0.01 1 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_2P_2_POT
 0.01 0.8 0.2 0.1 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_2P_3_POT
 -10 10 0 0 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_2P_4_POT
 35 55 44.9488 32 -1 99 6 0 0 0 0 0 3 2 # Retain_3P_1_TWL
 1 5 2.58835 1 -1 99 6 0 0 0 0 0 0 0 # Retain_3P_2_TWL
 0.7 1 1 1 -1 99 -99 0 0 0 0 0 2 2 # Retain_3P_3_TWL
 -10 10 0 0 -1 99 -50 0 0 0 0 0 0 0 # Retain_3P_4_TWL
 8 70 28 18 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_3P_1_TWL
 0.001 2 0.01 1 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_3P_2_TWL
 0.1 0.8 0.5 0.5 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_3P_3_TWL
 -10 10 0 0 -1 99 -50 0 0 0 0 0 0 0 # DiscMort_3P_4_TWL
 -2 2 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Code_HKL_1
 -5 5 0.854638 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_GradLo_HKL_1
 -5 2 -0.651292 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_GradHi_HKL_1
 0 35 2 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_1_HKL_1
 0 35 6 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_2_HKL_1
 0 35 9 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_3_HKL_1
 0 35 13 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_4_HKL_1
 -5 3 -0.793301 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_Val_1_HKL_1
 -5 3 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Val_2_HKL_1
 -5 3 0.101271 0 -1 99 5 0 0 0 0 0 4 2 # AgeSpline_Val_3_HKL_1
 -5 3 -0.840225 0 -1 99 5 0 0 0 0 0 4 2 # AgeSpline_Val_4_HKL_1
 1 25 10 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSel_1MaleDogleg_HKL
 -1 1 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSel_1MaleatZero_HKL
 -3 1 -1.26337 0 -1 99 5 0 0 0 0 0 0 0 # AgeSel_1MaleatDogleg_HKL
 -4 1 -1.32376 0 -1 99 5 0 0 0 0 0 0 0 # AgeSel_1MaleatMaxage_HKL
 -2 2 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Code_POT_2
 -2 5 0.70058 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_GradLo_POT_2
 -5 2 -0.225742 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_GradHi_POT_2
 0 35 2 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_1_POT_2
 0 35 4 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_2_POT_2
 0 35 8 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_3_POT_2
 0 35 12 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_4_POT_2
 -5 3 -1.53901 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_Val_1_POT_2
 -5 3 -0.999956 0 -1 99 5 0 0 0 0 0 4 2 # AgeSpline_Val_2_POT_2
 -5 3 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Val_3_POT_2
 -5 3 -1.15464 0 -1 99 5 0 0 0 0 0 4 2 # AgeSpline_Val_4_POT_2
 1 25 10 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSel_2MaleDogleg_POT
 -1 1 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSel_2MaleatZero_POT
 -3 1 -1.19601 0 -1 99 5 0 0 0 0 0 0 0 # AgeSel_2MaleatDogleg_POT
 -4 1 -1.42383 0 -1 99 5 0 0 0 0 0 0 0 # AgeSel_2MaleatMaxage_POT
 -2 2 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Code_TWL_3
 -1 5 0.708636 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_GradLo_TWL_3
 -5 2 -0.244502 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_GradHi_TWL_3
 0 35 1 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_1_TWL_3
 0 35 2 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_2_TWL_3
 0 35 4 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_3_TWL_3
 0 35 8 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_4_TWL_3
 0 35 12 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Knot_5_TWL_3
 -5 3 0.186149 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_Val_1_TWL_3
 -5 3 0.0210982 0 -1 99 5 0 0 0 0 0 4 2 # AgeSpline_Val_2_TWL_3
 -5 3 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSpline_Val_3_TWL_3
 -5 3 -0.168647 0 -1 99 5 0 0 0 0 0 4 2 # AgeSpline_Val_4_TWL_3
 -5 3 -0.764385 0 -1 99 5 0 0 0 0 0 0 0 # AgeSpline_Val_5_TWL_3
 1 25 4 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSel_3MaleDogleg_TWL
 -1 1 0 0 -1 99 -99 0 0 0 0 0 0 0 # AgeSel_3MaleatZero_TWL
 -3 1 0.0410431 0 -1 99 5 0 0 0 0 0 0 0 # AgeSel_3MaleatDogleg_TWL
 -1 1 -0.250315 0 -1 99 5 0 0 0 0 0 0 0 # AgeSel_3MaleatMaxage_TWL
 0 5 0.1 3 -1 99 -99 0 0 0 0 0 0 0 # AgeSel_4P_1_ENV
 1 60 50 3 -1 99 -99 0 0 0 0 0 0 0 # AgeSel_4P_2_ENV
 1 12 1.5 1 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_5P_1_AKSHLF
 -5 5 -4 0.3 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_5P_2_AKSHLF
 0.001 10 0.5 5 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_5P_3_AKSHLF
 0.001 10 1.80892 4 -1 99 4 0 0 0 0 0 0 0 # AgeSel_5P_4_AKSHLF
 -5 5 -3.82624 -5 -1 99 4 0 0 0 0 0 0 0 # AgeSel_5P_5_AKSHLF
 -5 5 -4.99 -5 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_5P_6_AKSHLF
 1 12 2.75844 1 -1 99 4 0 0 0 0 0 0 0 # AgeSel_6P_1_AKSLP
 -5 5 -4 0.3 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_6P_2_AKSLP
 0.001 10 0.1 5 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_6P_3_AKSLP
 0.001 10 0.988977 4 -1 99 4 0 0 0 0 0 0 0 # AgeSel_6P_4_AKSLP
 -5 5 -1.1497 -5 -1 99 4 0 0 0 0 0 0 0 # AgeSel_6P_5_AKSLP
 -5 5 -0.682197 -5 -1 99 4 0 0 0 0 0 0 0 # AgeSel_6P_6_AKSLP
 1 12 3 1 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_7P_1_NWSLP
 -5 5 -4 0.3 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_7P_2_NWSLP
 0.001 10 1.4297 5 -1 99 4 0 0 0 0 0 0 0 # AgeSel_7P_3_NWSLP
 0.001 10 0.924864 4 -1 99 4 0 0 0 0 0 0 0 # AgeSel_7P_4_NWSLP
 -5 5 -3.96896 -5 -1 99 4 0 0 0 0 0 0 0 # AgeSel_7P_5_NWSLP
 -5 5 0.27261 -5 -1 99 4 0 0 0 0 0 0 0 # AgeSel_7P_6_NWSLP
 0.1 5 1.5 1 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_8P_1_NWCBO
 -5 5 -4 0.3 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_8P_2_NWCBO
 0.001 5 0.5 5 -1 99 -4 0 0 0 0 0 0 0 # AgeSel_8P_3_NWCBO
 0.001 10 3.19634 4 -1 99 4 0 0 0 0 0 0 0 # AgeSel_8P_4_NWCBO
 -5 5 -1.10598 -5 -1 99 4 0 0 0 0 0 0 0 # AgeSel_8P_5_NWCBO
 -5 5 -0.949029 -5 -1 99 4 0 0 0 0 0 0 0 # AgeSel_8P_6_NWCBO
#_Cond 0 #_custom_sel-env_setup (0/1)
#_Cond -2 2 0 0 -1 99 -2 #_placeholder when no enviro fxns
1 #_custom_sel-blk_setup (0/1)
 25 45 25 30 -1 99 -99 # Retain_1P_1_HKL_BLK3repl_1942
 0.7 1 1 1 -1 99 -99 # Retain_1P_3_HKL_BLK1repl_1900
 25 45 25 30 -1 99 -99 # Retain_2P_1_POT_BLK3repl_1942
 0.7 1 1 1 -1 99 -99 # Retain_2P_3_POT_BLK1repl_1900
 25 45 25 30 -1 99 -99 # Retain_3P_1_TWL_BLK3repl_1942
 0.7 1 0.923736 1 -1 99 6 # Retain_3P_3_TWL_BLK2repl_1982
 -5 3 -0.274532 0 -1 99 5 # AgeSpline_Val_3_HKL_1_BLK4repl_1900
 -5 3 -0.712287 0 -1 99 5 # AgeSpline_Val_4_HKL_1_BLK4repl_1900
 -5 3 0.0757188 0 -1 99 5 # AgeSpline_Val_2_POT_2_BLK4repl_1900
 -5 3 -0.134174 0 -1 99 5 # AgeSpline_Val_4_POT_2_BLK4repl_1900
 -5 3 0.155211 0 -1 99 5 # AgeSpline_Val_2_TWL_3_BLK4repl_1900
 -5 3 -0.765513 0 -1 99 5 # AgeSpline_Val_4_TWL_3_BLK4repl_1900
#_Cond No selex parm trends
#_Cond -4 # placeholder for selparm_Dev_Phase
1 #_env/block/dev_adjust_method (1=standard; 2=logistic trans to keep in base parm bounds; 3=standard w/ no bound check)
#
# Tag loss and Tag reporting parameters go next
0  # TG_custom:  0=no read; 1=read if tags exist
#_Cond -6 6 1 1 2 0.01 -4 0 0 0 0 0 0 0  #_placeholder if no parameters
#
1 #_Variance_adjustments_to_input_values
#_fleet: 1 2 3 4 5 6 7 8
  0 0 0 0 0 0 0 0 #_add_to_survey_CV
  0.015 0.024 0.097 0 0 0 0 0 #_add_to_discard_stddev
  0.206 0.087 0 0 0 0 0 0 #_add_to_bodywt_CV
  0.1459 1.0423 0.2461 1 0.1843 1.2635 0.557 0.742 #_mult_by_lencomp_N
  0.8444 2.116 1.675 1 0.2735 0.0041 0.2011 0.2366 #_mult_by_agecomp_N
  1 1 1 1 1 1 1 1 #_mult_by_size-at-age_N
#
1 #_maxlambdaphase
1 #_sd_offset
#
1 # number of changes to make to default Lambdas (default value is 1.0)
# Like_comp codes:  1=surv; 2=disc; 3=mnwt; 4=length; 5=age; 6=SizeFreq; 7=sizeage; 8=catch; 9=init_equ_catch;
# 10=recrdev; 11=parm_prior; 12=parm_dev; 13=CrashPen; 14=Morphcomp; 15=Tag-comp; 16=Tag-negbin; 17=F_ballpark
#like_comp fleet/survey  phase  value  sizefreq_method
 1 4 1 0 1
#  0 # F_ballpark_lambda
0 # (0/1) read specs for more stddev reporting
 # 0 1 -1 5 1 5 1 -1 5 # placeholder for selex type, len/age, year, N selex bins, Growth pattern, N growth ages, NatAge_area(-1 for all), NatAge_yr, N Natages
 # placeholder for vector of selex bins to be reported
 # placeholder for vector of growth ages to be reported
 # placeholder for vector of NatAges ages to be reported
999

