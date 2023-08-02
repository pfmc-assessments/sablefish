# To Do

* write index data to a file bc right now it is just copy and pasted
* rerun sdmTMB to get north south instead of state stratification
* document that 2021 used season 1 for wcgbts index

## Bridging

* rename the fleets
* check that at-sea hake fishery bycatch are the correct values, emailed VT on
  2023-07-07
* update environmental index cv because the DFA analysis no longer works and
  Nick is using a Bayesian approach that now gives confidence intervals rather
  than an estimate of the uncertainty
* retention parameters in 2021 were fixed at the values estimated from early
  model exploration done in 2019
* Bias adjustment ramp is bogus with the environmental data in there

### Notes

* When adding at-sea catches to the base model from the last update assessment,
  the hessian is not invertible. The variance of parameter 212, which is
  Age_DblN_descend_se_NWSLP(6), was reported as -2108.27. Suggesting that this
  parameter is unstable and should be investigated later.

## Sensitivities

* Switch the recruitment deviations from being centered (option 1) to non-centered (option 2). Given that the 2020 and 2021 recruitment deviations are being estimated at relatively high values this is likely forcing earlier, less informed, deviations to be more negative to meet the centered at 0 requirement.  
* Remove the CAAL ages from the NWFSC WCGBT survey for 2021 and 2022 and replace them with the marginal ages from those years to explore the impact of these data on the growth estimates.
* Add growth parameter block for Lmin, k, and CV young for both sexes for 2022 only to see how the growth estimates vary.  Depending upon the uncertainty in the estimates we may want to explore adding 2020 to the same growth block (2021 2022) 

### Good Ideas

### Not So Good Ideas

* input commercial fishery lengths even though they are not typically used
  because there are no age data given that the ages have not been read.
* might need to run sdmTMB with only data up to 2021
