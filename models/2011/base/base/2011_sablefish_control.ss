#######################################
# 2011 sablefish control file
#######################################

## General controls ##
1 # N growth patterns
1 # N sub morphs within patterns

## Time block setup ##
4 # Number of block designs for time varying parameters
1 1 1 1 # Number of blocks for each
# Block definitions
1900 1996 # 1: Retention asymptote - HKL+POT
1900 1981 # 2: Retention asymptote - TWL
1942 1946 # 3: WWII retention L50 - HKL,POT+TWL
1900 2002 # 4: Pre-RCA selectivity parameters - HKL,POT+TWL

# Mortality and growth specifications
0.5	# Fraction female at birth
0	# M setup: 0=single parameter,1=breakpoints,2=Lorenzen,3=age-specific;4=age-specific,seasonal interpolation
1 	# Growth model: 1=VB (L1, L2),2=VB (A0,Linf),3=Richards,4=Read vector of L@A 
0.5	# Age for growth Lmin
30	# Age for growth Lmax
0.0	# Constant added to SD of LAA (0.1 mimics SS2v1 for compatibility only) 
0 	# Variability of growth: 0=CV~f(LAA), 1=CV~f(A), 2=SD~f(LAA), 3=SD~f(A), 4=Lognormal growth and SD~f(A)
1 	# Maturity_option:  1=length logistic; 2=age logistic; 3=read age-maturity matrix by growth_pattern; 4=read age-fecundity; 5=read fec and wt from wtatage.ss
3	# First age allowed to mature
1 	# Fecundity option:(1)eggs=Wt*(a+b*Wt),(2)eggs=a*L^b,(3)eggs=a*Wt^b
0  	# Hermaphroditism option:  0=none; 1=age-specific fxn
1	# MG parm offset option: 1=none, 2= M,G,CV_G as offset from GP1, 3=like SS2v1
1	# MG parm env/block/dev_adjust_method: 1=standard; 2=logistic transform keeps in base bounds; 3=standard w/ no bound check

# Lo	Hi	Init	Prior	Prior	Prior	Param	Env	Use	Dev	Dev	Dev	Block	block
# bnd	bnd 	value	mean	type	SD	phase	var	dev	minyr	maxyr	SD	design	switch
# Females
  0.01  0.11    0.087	-2.1791 3	0.3384 	8	0       0       0       0       0     	0       0    # M with 2011 prior from Owen
  22    30      25   	22	-1     	99      2       0       0       0       0       0     	0       0    # Lmin
  60    70      64	66	-1     	99      2       0       0       0       0       0     	0       0    # Lmax
  0.15	0.35    0.33	0.25    -1     	99      2       0       0       0       0       0     	0       0    # VBK
  0.03  0.15    0.08	0.05    -1     	99      2       0       0       0       0       0     	0       0    # CV-young
  0.03  0.15    0.12	0.11	-1     	99      2       0       0       0       0       0     	0       0    # CV-old
# Males
  0.01  0.11    0.071   -2.0565 3	0.3375  8	0       0       0       0       0     	0       0    # M with 2011 prior from Owen
  -3    3       0.0	0.0     -1     	99      -50     0       0       0       0       0     	0       0    # Lmin (set equal to females)
  50    60      56.0	0.0	-1     	99      2       0       0       0       0       0     	0       0    # Lmax
  0.2	0.5	0.41	0.0	-1     	99      2       0       0       0       0       0     	0       0    # VBK
  -3    3       0.0	0.0	-1     	99      -50     0       0       0       0       0     	0       0    # CV-young (set equal to females)
  0.03  0.15    0.08	0.0	-1      99      2       0       0       0       0       0     	0       0    # CV-old
# Female weight-length updated for 2011 
  0     1 	0.0000034487 0  0       99     	-50     0       0       0       0       0     	0       0    # W-L 1
  0     4 	3.266810 3.3 	0     	99     	-50     0       0       0       0       0     	0       0    # W-L exponent
# Female maturity updated for 2011
  57    59      58.0	55.0	0     	99     	-50     0       0       0       0       0     	0       0    # L50
  -3    3   	-0.13   -0.25   0     	99     	-50     0       0       0       0       0     	0       0    # Slope
# Female fecundity (no fecundity relationship as in 2007)
  -3    3       1       1       0     	99     	-50     0       0       0       0       0     	0       0    # Eggs/gm intercept
  -3    3       0       0       0     	99     	-50     0       0       0       0       0     	0       0    # Eggs per gram slope
# Male weight-length updated for 2011
  0     1 	0.0000036724 0 	0     	99     	-50     0       0       0       0       0     	0       0    # W-L 1
  0     4 	3.250904 3.3 	0     	99     	-50     0       0       0       0       0     	0       0    # W-L exponent
# Unused recruitment and growth distribution parameters                                                                      
  -4    4       0       0      	-1     	99     	-50     0       0       0       0       0     	0       0   # Rec distribution by growth pattern
  -4    4       0       0      	-1     	99     	-50     0       0       0       0       0     	0       0   # Rec distribution
  -4    4       0       0      	-1     	99     	-50     0       0       0       0       0     	0       0   # Rec distribution
  -4    4       0       0      	-1     	99     	-50     0       0       0       0       0     	0       0   # Cohort growth deviation
 0 0 0 0 0 0 0 0 0 0 # MGparm seasonal effects setup array

### Spawner-recruit section ###
3 # S-R function: 1=B-H w/flat top, 2=Ricker, 3=standard B-H, 4=no steepness or bias adjustment
# Lo	Hi	Init	Prior	Prior	Prior	Param
# bnd	bnd	value	mean	type	SD	phase
  8.0   12    	10.6    9.8     -1	99     	7   # R0
  0.20  1.0    	0.6	0.6	2     	0.223 	-9  # Steepness (h) - He et al. prior
  0.2   1.5    	1.1     0.6	-1     	99    	-50 # Sigma-r

  -1    1    	0       0       -1     	99    	-50 # Environmental coefficient
  -1    1    	0       0       -1     	99    	-50 # Non-equlibrium recruitment (R1)
  -1    1    	0       0       -1     	99    	-50 # Autocorrelation (not implemented)
0 # Index of environmental variable to be used
0 # SR environmental target: 0=none;1=devs;_2=R0;_3=steepness
1 # Recruitment deviation type: 0=none; 1=devvector; 2=simple deviations

# Recruitment deviations
###2011### Retune this section
1965	# Start year standard recruitment devs
2010	# End year standard recruitment devs
6	# Rec Dev phase

1 # Read 11 advanced recruitment options: 0=no, 1=yes
1851	# Start year for early rec devs
6 	# Phase for early rec devs
6	# Phase for forecast recruit deviations
1 	# Lambda for forecast rec devs before endyr+1
1974 	# Last recruit dev with no bias_adjustment
1980 	# First year of full bias correction (linear ramp from year above)
2010 	# Last year for full bias correction in_MPD
2011 	# First_recent_yr_nobias_adj_in_MPD
0.95 	# Maximum bias adjustment in MPD
0 	# Period of cycles in recruitment (N parms read below)
-4	# Lower bound rec devs
4	# Upper bound rec devs
0 	# Read init values for rec devs

# Fishing mortality setup 
0.02 	# F ballpark for tuning early phases
2000 	# F ballpark year
1 	# F method:  1=Pope's; 2=Instan. F; 3=Hybrid
0.9 	# Max F or harvest rate (depends on F_Method)

# Init F parameters by fleet
# Lo	Hi	Init	Prior	Prior	Prior	Param
# bnd	bnd 	value	mean	type	SD	phase
  -1   	1  	0.0   	0.0    	-1      99   	-1  # HKL
  -1   	1  	0.0   	0.0    	-1      99   	-1  # POT
  -1   	1  	0.0   	0.0    	-1      99   	-1  # TWL

# Catchability setup
# A=do power: 0=skip, survey is prop. to abundance, 1= add par for non-linearity
# B=env. link: 0=skip, 1= add par for env. effect on Q
# C=extra SD: 0=skip, 1= add par. for additive constant to input SE (in ln space)
# D=type: <0=mirror lower abs(#) fleet, 0=no par Q is median unbiased, 1=no par Q is mean unbiased, 2=estimate par for ln(Q)
# 	   3=ln(Q) + set of devs about ln(Q) for all years. 4=ln(Q) + set of devs about Q for indexyr-1
# A   B   C   D		
# Create one par for each entry > 0 by column
  0   0	  0   0	  # HKL
  0   0	  0   0	  # POT
  0   0	  0   0	  # TWL
  0   0	  0   0	  # ENV
  0   0	  1   4	  # AKSHLF
  0   0	  1   0	  # AKSLP
  0   0	  1   0	  # NWSLP
  0   0	  1   0	  # NWCBO

# Q parameters
1 # Par setup: 0=read one par for each fleet with random q; 1=read a parm for each year of index

# Lo	Hi	Init	Prior	Prior	Prior	Param
# bnd	bnd 	value	mean	type	SD	phase
  0.1	1.3	0.15 	0.0    	-1    	99      3   # AKSHLF extra SD
  0.001	0.7	0.05 	0.0    	-1    	99      3   # AKSLP extra SD
  0.001	0.8	0.05 	0.0    	-1    	99      3   # NWSLP extra SD
  0.001	0.4	0.002 	0.0    	-1    	99      3   # NWCBO extra SD 

  -3	0.5	-0.2	0	-1	99	1   # Early period AKSHLF log(q) base parameter (1980)
  -2	2	0	0	-1	99	-50 # AKSHLF 1983 deviation
  -2	2	0	0	-1	99	-50 # AKSHLF 1986 deviation
  -2	2	0	0	-1	99	-50 # AKSHLF 1989 deviation
  -2	2	0	0	-1	99	-50 # AKSHLF 1992 deviation
  -2	3	0.6	0	-1	99	1   # Late period AKSHLF 1995 deviation
  -2	2	0	0	-1	99	-50 # AKSHLF 1998 deviation
  -2	2	0	0	-1	99	-50 # AKSHLF 2001 deviation
  -2	2	0	0	-1	99	-50 # AKSHLF 2004 deviation

 # Q AKSLP is analytically calculated 
 # Q NWSHLF is analytically calculated 
 # Q NWCBO is analytically calculated 

#_SELEX_&_RETENTION_PARAMETERS
# Size-based setup
# A=Selex option: 1-24
# B=Do_retention: 0=no, 1=yes
# C=Male offset to female: 0=no, 1=yes
# D=Extra input (#)
#  A 	B   C	D
# Size selectivity
   0    2   0   0    # HKL
   0    2   0   0    # POT
   0    2   0   0    # TWL
   31   0   0   0    # ENV
   0    0   0   0    # AKSHLF
   0    0   0   0    # AKSLP
   0    0   0   0    # NWSLP
   0    0   0   0    # NWCBO
# Age selectivity
   27   0   1   4    # HKL
   27   0   1   4    # POT
   27   0   1   5    # TWL
   11   0   0   0    # ENV
   20   0   0   0    # AKSHLF
   20   0   0   0    # AKSLP
   20   0   0   0    # NWSLP
   20   0   0   0    # NWCBO

# Selectivity parameters
# Lo	Hi	Init	Prior	Prior	Prior	Param	Env	Use	Dev	Dev	Dev	Block	block
# bnd	bnd 	value	mean	type	SD	phase	var	dev	minyr	maxyr	SD	design	switch

### Length-based selectivity, retention and discard mortality section ###
# HKL Length-based retention                                             
  25    45    	39      30      -1     	99      6      0   	0     	0       0     	0     	3    	2   # Retention L50 
  0.001 4.0	1.0	1       -1     	99      -6      0   	0     	0       0     	0     	0    	0   # slope_for_retention      
  0.7   1.0   	0.8	1       -1     	99      6       0   	0     	0       0     	0     	1    	2   # asymptotic_retention     
  -10   10    	0.0	0       -1     	99      -50     0   	0     	0       0     	0     	0    	0   # male_offset_on_inflection
# HKL Length-based discard mortality 
  8     70      28      18      -1     	99      -50    	0   	0     	0       0     	0     	0    	0   # inflection_for_discard mortality                
  0.001  2.0    0.01	1       -1     	99      -50    	0   	0     	0       0     	0     	0    	0   # slope_for_discard mortality                     
  0.01	0.8	0.20   	0.1	-1     	99      -50    	0   	0     	0       0     	0     	0    	0   # asymptotic discard mortality (mortality rate)   
  -10   10      0.0	0.0	-1     	99      -50    	0   	0     	0       0     	0     	0    	0   # male_offset_discard mortality                   
# POT Length-based retention                                                                                                                                         
  35    60      45      30      -1     	99      6    	0   	0     	0       0     	0     	3    	2   # inflection_for_retention                        
  3     20	5.0	1       -1     	99      6    	0   	0     	0       0     	0     	0    	0   # slope_for_retention                             
  0.6   1.0	1.0	1       -1     	99      -6    	0   	0     	0       0     	0     	1    	2   # asymptotic_retention                            
  -10   10      0.0	0       -1     	99      -50    	0   	0     	0       0     	0     	0    	0   # male_offset_on_inflection                       
# POT Length-based discard mortality
  8     70      28      18      -1     	99      -50    	0   	0     	0       0     	0     	0    	0   # inflection_for_discard mortality                
  0.001  2.0     0.01	1       -1     	99      -50    	0   	0     	0       0     	0     	0    	0   # slope_for_discard mortality                     
  0.01	0.8	0.20   	0.1	-1     	99      -50    	0   	0     	0       0     	0     	0    	0   # asymptotic discard mortality (mortality rate)   
  -10   10      0.0	0.0	-1     	99      -50    	0   	0     	0       0     	0     	0    	0   # male_offset_discard mortality                   
# TWL Length-based retention                                                                                                                                                      
  35    55      40      32      -1      99      6    	0    	0     	0       0     	0     	3    	2   # inflection_for_retention                             
  1	5.0	3.3	1       -1      99      6    	0    	0     	0       0     	0     	0    	0   # slope_for_retention                                  
  0.7   1.0	0.9	1       -1      99      6    	0    	0     	0       0     	0     	2    	2   # asymptotic_retention                                 
  -10   10      0.0	0       -1      99      -50    	0    	0     	0       0     	0     	0    	0   # male_offset_on_inflection                            
# TWL Length-based discard mortality
  8     70      28      18      -1      99      -50    	0    	0     	0       0     	0     	0    	0   # inflection_for_discard mortality                     
  0.001  2.0     0.01	1       -1      99      -50    	0    	0     	0       0     	0     	0    	0   # slope_for_discard mortality                          
  0.1   0.8     0.50    0.5	-1      99      -50    	0    	0     	0       0     	0     	0    	0   # asymptotic discard mortality (mortality rate)        
  -10   10      0.0	0       -1      99      -50    	0    	0     	0       0     	0     	0    	0   # male_offset_discard mortality                        

### Age-based selectivity section ###
# HKL Age-based cubic spline selectivity
 -2 	2 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Auto generate switch
 -5	5.0 	1 	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Gradient at first node
 -5 	2.0 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Gradient at last node
 0 	35 	2	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 1
 0 	35 	6	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 2
 0 	35 	9	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 3
 0 	35 	13	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 4
 -5 	3 	-0.5 	0 	-1 	99 	5 	0 0 0 0 0 0 0 # log(unscaled sel) at node 1
 -5 	3 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # log(unscaled sel) at node 3
 -5 	3 	0	0 	-1 	99 	5 	0 0 0 0 0 4 2 # log(unscaled sel) at node 2
 -5 	3 	-0.6 	0 	-1 	99 	5 	0 0 0 0 0 4 2 # log(unscaled sel) at node 4
# HKL Age-based male offset selectivity
 1 	25 	10 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age at dogleg
 -1	1 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Log(relative selectivity) at age 0
 -3	1 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Log(relative selectivity) at dogleg
 -4 	1 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Log(relative selectivity) at max age
# POT Age-based cubic spline selectivity
 -2 	2 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Auto generate switch
 -2	5.0 	1 	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Gradient at first node
 -5 	2.0 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Gradient at last node
 0 	35 	2	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 1
 0 	35 	4	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 2
 0 	35 	8	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 3
 0 	35 	12	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 4
 -5 	3 	-0.5 	0 	-1 	99 	5 	0 0 0 0 0 0 0 # log(unscaled sel) at node 1
 -5 	3 	0	0 	-1 	99 	5 	0 0 0 0 0 4 2 # log(unscaled sel) at node 2
 -5 	3 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # log(unscaled sel) at node 3
 -5 	3 	-0.6 	0 	-1 	99 	5 	0 0 0 0 0 4 2 # log(unscaled sel) at node 4
# POT Age-based male offset selectivity
 1 	25 	10 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age at dogleg
 -1	1 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Log(relative selectivity) at age 0
 -3	1 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Log(relative selectivity) at dogleg
 -4 	1 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Log(relative selectivity) at max age
# TWL Age-based cubic spline selectivity
 -2 	2 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Auto generate switch
 -1	5.0 	1 	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Gradient at first node
 -5 	2.0 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Gradient at last node
 0 	35 	1	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 1
 0 	35 	2	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 2
 0 	35 	4	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 3
 0 	35 	8	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 4
 0 	35 	12 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age for node 5
 -5 	3 	-0.5 	0 	-1 	99 	5 	0 0 0 0 0 0 0 # log(unscaled sel) at node 1
 -5 	3 	0	0 	-1 	99 	5 	0 0 0 0 0 4 2 # log(unscaled sel) at node 2
 -5 	3 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # log(unscaled sel) at node 3
 -5 	3 	-0.6 	0 	-1 	99 	5 	0 0 0 0 0 4 2 # log(unscaled sel) at node 4
 -5 	3 	-1.2	0 	-1 	99 	5 	0 0 0 0 0 0 0 # log(unscaled sel) at node 5
# TWL Age-based male offset selectivity
 1 	25 	4 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Age at dogleg
 -1	1 	0 	0 	-1 	99 	-99 	0 0 0 0 0 0 0 # Log(relative selectivity) at age 0
 -3	1 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Log(relative selectivity) at dogleg
 -1 	1 	0	0 	-1 	99 	5 	0 0 0 0 0 0 0 # Log(relative selectivity) at max age
# ENV series min and max age
  0.0	5.0	0.1	3    	-1      99     	-99    	0 0 0 0 0 0 0 # Min age     
  1	60	50	3    	-1      99     	-99    	0 0 0 0 0 0 0 # Max age
# AKSHLF Age-based cubic spline selectivity
  1   	12   	1.5    	1      	-1     	99     	-4     	0    	0     	0       0     	0     	0    	0   # PEAK     
  -5   	5      -4.0    	0.3     -1      99      -4     	0    	0     	0       0     	0     	0    	0   # TOP      
  0.001 10     	0.5   	5      	-1      99      -4     	0    	0     	0       0     	0     	0    	0   # ASC-WIDTH
  0.001 10     	0.6    	4     	-1      99      4     	0    	0     	0       0     	0     	0    	0   # DSC-WIDTH
  -5	5     	-3.2	-5      -1     	99     	4     	0    	0     	0       0     	0     	0    	0   # INIT     
  -5	5     	-4.99	-5      -1     	99     	-4     	0    	0     	0       0     	0     	0    	0   # FINAL
# AKSLP Age-based cubic spline selectivity
  1   	12   	4.0    	1      	-1     	99     	4     	0    	0     	0       0     	0     	0    	0   # PEAK     
  -5   	5      -4.0    	0.3     -1      99      -4     	0    	0     	0       0     	0     	0    	0   # TOP      
  0.001 10     	0.1    	5      	-1      99      -4     	0    	0     	0       0     	0     	0    	0   # ASC-WIDTH
  0.001 10     	0.1    	4     	-1      99      4     	0    	0     	0       0     	0     	0    	0   # DSC-WIDTH
  -5 	5    	0.0	-5      -1     	99     	4     	0    	0     	0       0     	0     	0    	0   # INIT     
  -5	5     	-0.2	-5      -1     	99     	4     	0    	0     	0       0     	0     	0    	0   # FINAL
# NWSLP Age-based cubic spline selectivity
  1   	12   	3.0    	1      	-1     	99     	-4     	0    	0     	0       0     	0     	0    	0   # PEAK     
  -5   	5      -4.0    	0.3     -1      99      -4     	0    	0     	0       0     	0     	0    	0   # TOP      
  0.001 10     	1.2    	5      	-1      99      4     	0    	0     	0       0     	0     	0    	0   # ASC-WIDTH
  0.001 10     	0.6    	4     	-1      99      4     	0    	0     	0       0     	0     	0    	0   # DSC-WIDTH
  -5 	5    	0.0	-5      -1     	99     	4     	0    	0     	0       0     	0     	0    	0   # INIT     
  -5	5     	-0.2	-5      -1     	99     	4     	0    	0     	0       0     	0     	0    	0   # FINAL
# NWCBO Age-based cubic spline selectivity
  0.1   5     	1.5    	1      	-1     	99     	-4     	0    	0     	0       0     	0     	0    	0   # PEAK     
  -5   	5      -4.0    	0.3     -1      99      -4     	0    	0     	0       0     	0     	0    	0   # TOP      
  0.001 5     	0.5    	5      	-1      99      -4     	0    	0     	0       0     	0     	0    	0   # ASC-WIDTH
  0.001 10     	4     	4     	-1      99      4     	0    	0     	0       0     	0     	0    	0   # DSC-WIDTH
  -5 	5    	0.0    -5      -1     	99     	4     	0    	0     	0       0     	0     	0    	0   # INIT     
  -5 	5     	-1.9   	-5      -1     	99     	4     	0    	0     	0       0     	0     	0    	0   # FINAL
1 # Custom time-block setup - 1 = read one line for each parameter

# Lo	Hi	Init	Prior	Prior	Prior	Param
# bnd	bnd 	value	mean	type	SD	phase
# HKL Length-based retention L50
  25    45    	25      30      -1     	99      -99	# 1942-1946
# HKL Length-based retention asymptote
  0.7   1.0   	1.0	1       -1     	99      -99	# 1900-1996
# POT Length-based retention L50
  25    45    	25      30      -1     	99      -99	# 1942-1946
# POT Length-based retention asymptote
  0.7   1.0   	1.0	1       -1     	99      -99	# 1900-1996
# TWL Length-based retention L50
  25    45    	25      30      -1     	99      -99	# 1942-1946
# TWL Length-based retention asymptote
  0.7   1.0   	1.0	1       -1     	99      -99	# 1900-1981
# HKL Age-based cubic spline selectivity
 -5 	3 	0	0 	-1 	99 	5 	# 1900-2002
 -5 	3 	-0.6 	0 	-1 	99 	5 	# 1900-2002
# POT Age-based cubic spline selectivity
 -5 	3 	0	0 	-1 	99 	5 	# 1900-2002
 -5 	3 	-0.6 	0 	-1 	99 	5 	# 1900-2002
# TWL Age-based cubic spline selectivity
 -5 	3 	0	0 	-1 	99 	5 	# 1900-2002
 -5 	3 	-0.6 	0 	-1 	99 	5 	# 1900-2002

1 # Time-block adjust method - 1 = direct, no transformation 

0 # Tagging flag: 0=no tagging parameters,1=read tagging parameters

### Likelihood related quantities ###
1 # Do variance/sample size adjustments by fleet (1)
# # Component

###2011### Retune these
# HKL    POT    TWL    ENV AKSHLF AKSLP NWSLP NWCBO
  0      0      0      0   0      0     0     0       # Constant added to index CV                    
  0.015  0.024  0.097  0   0      0     0     0       # Constant added to discard SD                    
  0.657	 0.763	0.160  0   0      0     0     0       # Constant added to body weight SD                      
  0.25   1.00   0.19   1   0.18   1.00  1.00  0.68    # multiplicative scalar for length comps
  0.85   1.00   1.00   1   0.24   0.01  0.22  0.17    # multiplicative scalar for agecomps
  1      1      1      1   1      1     1     1       # multiplicative scalar for length at age obs               

1  # Lambda phasing: 1=none, 2+=change beginning in phase 1
1  # Growth offset likelihood constant for Log(s): 1=include, 2=not

1 # N changes to default Lambdas (1.0)
 # Component codes:  
 #  1=Survey, 2=discard, 3=mean body weight, 4=length frequency, 5=age frequency, 6=Weight frequency
 #  7=size at age, 8=catch, 9=initial equilibrium catch
 #  10=rec devs, 11=parameter priors, 12=parameter devs, 13=Crash penalty
 # Component fleet phase value wtfreq_method
1 4 1 0.0 1 # Turn off ENV

0 # Extra SD reporting switch

999 # End control file
