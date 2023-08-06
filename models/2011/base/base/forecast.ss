#############################
# 2011 sablefish forecast file
#############################

1 	# Do benchmarks: 0=no,1=calculate F_spr,F_btgt,F_msy 
2 	# MSY definition: 1=set to F(SPR), 2=calc F(MSY), 3=set to F(Btgt); 4=set to F(endyr) 
0.45 	# SPR target
0.4 	# Biomass target
# Benchmark years: beg_bio, end_bio, beg_selex, end_selex, beg_relF, end_relF
# Enter actual year, -999 for styr, 0 or -integer to be rel. endyr
 2005 2007 2005 2007 2005 2007
2 	# Benchmark relative F: 1=use year range, 2=set relF same as forecast below
1 	# Do forecast: 0=none,1=F(SPR), 2=F(MSY), 3=F(Btgt), 4=Avg F (uses first-last relF yrs), 5=input annual F scalar
3 	# N forecast years 
1 	# F scalar (only used for Do_Forecast==5)
# Forecast years: beg_selex, end_selex, beg_relF, end_relF
 2005 2007 2005 2007
1 	# Control rule method (1=catch=f(SSB) west coast; 2=F=f(SSB) ) 
0.4 	# Control rule Biomass level for constant F (as frac of Bzero, e.g. 0.40) 
0.1 	# Control rule Biomass level for no F (as frac of Bzero, e.g. 0.10) 
1 	# Control rule target as fraction of Flimit (e.g. 0.75) 
3 	# N forecast loops (1-3) (fixed at 3 for now)
3 	# First forecast loop with stochastic recruitment
-1 	# Forecast loop control #3 (reserved for future bells&whistles) 
0 	# Forecast loop control #4 (reserved for future bells&whistles) 
0 	# Forecast loop control #5 (reserved for future bells&whistles) 
2011	# FirstYear for caps and allocations (should be after years with fixed inputs) 
0 	# stddev of log(realized catch/target catch) in forecast (set value>0.0 to cause active impl_error)
0 	# Do West Coast gfish rebuilder output (0/1) 
1999 	# Rebuilder:  first year catch could have been set to zero (Ydecl)(-1 to set to 1999)
2002 	# Rebuilder:  year for current age structure (Yinit) (-1 to set to endyear+1)
1 	# fleet relative F:  1=use first-last alloc year; 2=read seas(row) x fleet(col) below
2 	# Forecast catch tuning, catch caps, allocation: 2=deadbio; 3=retainbio; 5=deadnum; 6=retainnum
   # Conditional input if relative F choice = 2
   # Fleet relative F:  rows are seasons, columns are fleets
   #_Fleet:  HKL POT TWL
   #  0.690803 0.0885779 0.22062
-1 -1 -1 # max totalcatch by fleet (-1 to have no max) enter value for each fleet
-1       # max totalcatch by area (-1 to have no max) enter value for each area 
 1  1  1 # fleet assignment to allocation group (enter group ID# for each fleet, 0 for not included in an alloc group)
1 	# allocation fraction for each of: 1 allocation groups
0 	# Number of forecast catch levels to input (else calc catch from forecast F) 
2 	# basis for input Fcast catch:  2=dead catch; 3=retained catch; 99=input Hrate(F) (units are from fleetunits; note new codes in SSV3.20)

999 # End of file 
