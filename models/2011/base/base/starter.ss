#############################
# 2011 sablefish starter file
#############################

# Input files
2011_sablefish_data.SS
2011_sablefish_control.SS

0 # Initial value switch: 0=control file,1=ss3.par
1 # DOS display detail: 0,1,2
1 # Detailed age-structured reports in REPORT.SSO: 0,1 
0 # Write checkup.sso file: 0,1
0 # Write ParmTrace.sso: 0=no,1=good+active,2=good+all,3=every_iter+all,4=every+active
0 # Write to cumreport.sso: 0=no,1=like+timeseries,2=add survey fits
0 # Include prior_like for non-estimated parameters: 0=no,1=yes 
0 # Use Soft Boundaries to aid convergence: 0=no,1=yes
0 # N new datafiles to produce: 1=input, 2=estimates, 3+ bootstraps

25 # Last phase for estimation

1 # MCeval burn-in
1 # MCeval thinning interval
0 # Jitter initial values by this fraction of bounds
-1 # Min yr for sdreport outputs (-1 for styr)
-2 # Max yr for sdreport outputs (-1 for endyr; -2 for endyr+Nforecastyrs
0 # N individual STD years 

0.00001 # Final convergence criteria

0 # Retrospective year relative to end year
4 # Min age for summary biomass
1 # Depletion basis:  denom is: 0=skip; 1=rel X*B0; 2=rel X*Bmsy; 3=rel X*B_styr
1.0 # Fraction (X) for Depletion denominator (e.g. 0.4)
1 # SPR_report_basis:  0=skip; 1=(1-SPR)/(1-SPR_tgt); 2=(1-SPR)/(1-SPR_MSY); 3=(1-SPR)/(1-SPR_Btarget); 4=rawSPR
1 # F_report_units: 0=skip; 1=exploitation(Bio); 2=exploitation(Num); 3=sum(Frates); 4=true F for range of ages
# If option 4 above, min and max age for avg F
0 # F_report_basis: 0=raw; 1=F/Fspr; 2=F/Fmsy ; 3=F/Fbtgt

999 # End of file
