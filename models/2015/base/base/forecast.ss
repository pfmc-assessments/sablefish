#C forecast file written by R function SS_writeforecast
#C rerun model to get more complete formatting in forecast.ss_new
#C should work with SS version: SSv3.21_or_later
#C file write time: 2015-06-02 21:25:04
#
1 #_benchmarks
2 #_MSY
0.45 #_SPRtarget
0.4 #_Btarget
#_Bmark_years: beg_bio end_bio beg_selex end_selex beg_alloc end_alloc
2012 2014 2012 2014 2012 2014
2 #_Bmark_relF_Basis
1 #_Forecast
12 #_Nforecastyrs
1 #_F_scalar
#_Fcast_years:  beg_selex, end_selex, beg_relF, end_relF
2012 2014 2012 2014
1 #_ControlRuleMethod
0.4 #_BforconstantF
0.1 #_BfornoF
0.913 #_Flimitfraction
3 #_N_forecast_loops
3 #_First_forecast_loop_with_stochastic_recruitment
-1 #_Forecast_loop_control_3
0 #_Forecast_loop_control_4
0 #_Forecast_loop_control_5
2017 #_FirstYear_for_caps_and_allocations
0 #_stddev_of_log_catch_ratio
0 #_Do_West_Coast_gfish_rebuilder_output
1999 #_Ydecl
2002 #_Yinit
1 #_fleet_relative_F
2 #_basis_for_fcast_catch_tuning
# max totalcatch by fleet (-1 to have no max)
-1 -1 -1
# max totalcatch by area (-1 to have no max)
-1
# fleet assignment to allocation group (enter group ID# for each fleet, 0 for not included in an alloc group)
1 1 1
# allocation fraction for each of: 1  allocation groups
1
6 #_Ncatch
2 #_InputBasis
 #_Year Seas Fleet Catch_or_F
   2015    1     1       3021
   2015    1     2       1474
   2015    1     3       2017
   2016    1     1       3304
   2016    1     2       1612
   2016    1     3       2205
#
999 # verify end of input 
