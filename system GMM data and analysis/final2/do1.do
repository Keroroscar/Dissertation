*set the working directory
cd "C:\stata\final2"
log using mylog.log,text replace

*input data
use final2,clear

* local xx "fine finedfirm laborinsec_a laborinsec_b so2 popu_a popu_b secgrp_a secgrp_b gov_a gov_b land_a land_b"
foreach v of local xx{
drop if `v' ==.
}

* local xx "delivery wage_a wage_b domestic_a domestic_b HMT_a HMT_b fdi_a fdi_b tele mobile dfiirm_a dfirm_b Hfirm_a Hfirm_b ffirm_a ffirm_b"

foreach v of local xx{
drop if `v'==.
}


*data summary
summarize
*declare individual identifier and time indentifier
xtset id year

*panel description of dataset
xtdescribe

*panel summary statistics (within and between variation)
xtsum id year seaside vice fine finedfirm energy *_a
estpost tabstat seaside vice fine finedfirm energy *_a , listwise statistics(mean min p25 p50 p75 max) columns(statistics)
esttab using xtsum1.xls, cells("mean min p25 p50 p75 max") replace

*panel summary statistics (within and between variation)
xtsum id year *_b
estpost tabstat *_b lfine, listwise statistics(mean min p25 p50 p75 max) columns(statistics)
esttab using xtsum2.xls, cells("mean min p25 p50 p75 max") replace
xtsum id year *_c
estpost tabstat *_c lfine , listwise statistics(mean min p25 p50 p75 max) columns(statistics)
esttab using xtsum2.xls, cells("obs mean min p25 p50 p75 max") append


shellout xtsum1.xls
shellout xtsum2.xls

*test for unitroot*
*Harris-Tzavalis test*
local xx "lfdi lSO2 lgovcrime lwage lpopu lgdp lpollctl"
local replace replace
foreach v of local xx {
    xtunitroot ht `v'
}

*Levin-Lin-Chu test*
local xx "lfdi lSO2 lgovcrime lwage lpopu lgdp lpollctl"
local replace replace
foreach v of local xx {
    xtunitroot llc `v'
}

*ipshin test
local xx "lfdi lSO2 lgovcrime lwage lpopu lgdp lpollctl"
foreach v of local xx {
    ipshin `v',lag(1)
}

*xtfisher test
local xx "lfdi lSO2 lgovcrime lwage lpopu lgdp lpollctl"
foreach v of local xx {
    xtfisher `v',lag(1) trend
}

*autocorrelation test 
local xx "lso2_b llaborinsec_b lpopu_b lsecgrp_b lgov_b ldelivery_b lwage_b ldomestic_b lHMT_b lfdi_b lfine"
xtserial `xx'

*autocorrelation test 
local xx "lso2_c llaborinsec_c lpopu_c lsecgrp_c lgov_c ldelivery_c lwage_c ldomestic_c lHMT_c lfdi_c lfine"
xtserial `xx'

*heteroskedastic test
local xx "lso2_b  lpopu_b lsecgrp_b lland_b  lwage_b ldomestic_b lHMT_b "
xtgls `xx',igls panels(heteroskedastic)
estimates store heter
xtgls `xx',igls
local df=e(N_g)-1
display e(N_g)-1
*result of 238 shows
lrtest heter ., df(238)


*autocorrelation test 
local xx "lso2_c llaborinsec_c lpopu_c lsecgrp_c lgov_c ldelivery_c lwage_c  lHMT_c "
xtgls `xx',igls panels(heteroskedastic)
estimates store heter
xtgls `xx',igls
local df=e(N_g)-1
display e(N_g)-1
*result of 238 shows
lrtest heter ., df(238)
log close

log using mylog2.log,text replace
*System GMM
*Arellano and Bond

*Assume with L2.lfdi and lgdp, lwage,lpopu are endogenous (appliable)

   local xx " llaborinsec_b  lgov_b  lpopu_b lsecgrp_b  lgov_b  ldelivery_b lwage_b seaside vice lfine  year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b lHMT_b lfdi_b lland_b) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data2,excel replace ctitle ("lpso2_a") drop(year1-year8) e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) 

    local xx " llaborinsec_b  lgov_b  lpopu_b lsecgrp_b lland_b lfine lgov_b  ldelivery_b lwage_b seaside vice lfine  year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b lHMT_b lfdi_b  lgov_b ) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data2,excel replace ctitle ("lpso2_a") drop(year1-year8) e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) 

 
 
 
 
 
local xx " lpopu_c lland_c lsecgrp_c llaborinsec_c  lgov_c ldelivery_c lwage_c seaside vice lfine year2-year8"
xtdpdsys lso2_c  `xx',endog(ldomestic_c lHMT_b lfdi_b lgov_c ) twostep
est store dycs_2endog
estat abond 
estat sargan
outreg2 using data2,excel append ctitle ("lpso2_a") drop(year1-year8) e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N) 





   local xx "  lland_b lgov_b  lsecgrp_b ldelivery_b lwage_b seaside vice lfine  year1-year8"
xtdpdsys lpso2_b  `xx', endog(ldomestic_b llaborinsec_b lgov_b ) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data3,excel replace ctitle ("lpso2_a") drop(year1-year8) e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) 

 local xx " lpopu_b  lgov_b llaborinsec_b lsecgrp_b ldelivery_b lwage_b seaside vice lfine  year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b lpopu_b lland_b lgov_b ) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data1,excel replace ctitle ("lso2_b") drop(year1-year8) e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) 

   local xx "   lsecgrp_b  ldelivery_b lwage_b seaside vice lfine  year1-year8"
xtdpdsys lpso2_b  `xx', endog(lHMT_b lpopu_b lland_b llaborinsec_b lgov_b) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data3,excel append ctitle ("lpso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
 
 
   local xx "   lsecgrp_b  ldelivery_b lwage_b seaside vice lfine llaborinsec_b year1-year8"
xtdpdsys lso2_b  `xx', endog(lHMT_b lpopu_b lland_b  lgov_b) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data1,excel append ctitle ("lso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
 
   local xx " llaborinsec_b  lsecgrp_b ldelivery_b  seaside vice lfine  year1-year8"
xtdpdsys lpso2_b  `xx', endog(lfdi_b lland_b lgov_b lwage_b) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data3,excel append ctitle ("lpso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)

 
 local xx " llaborinsec_b  lsecgrp_b ldelivery_b lwage_b seaside vice lfine  year1-year8"
xtdpdsys lso2_b  `xx', endog(lfdi_b lpopu_b lland_b lgov_b) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data1,excel append ctitle ("lso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)


* suburban area
  
local xx " lpopu_c  lsecgrp_c llaborinsec_c ldelivery_c lwage_c seaside vice lfine year2-year8"
xtdpdsys lso2_c  `xx',endog(ldomestic_c lland_c lgov_c ) twostep
est store dycs_2endog
estat abond 
estat sargan
outreg2 using data1,excel append ctitle ("lso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
 
  
  local xx " lpopu_c lsecgrp_c llaborinsec_c ldelivery_c lwage_c seaside vice lfine year2-year8"
xtdpdsys lpso2_c  `xx',endog(ldomestic_c lland_c lgov_c ) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data3,excel append ctitle ("lpso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
 
 
   local xx "lpopu_c llaborinsec_c lpopu_c lsecgrp_c  ldelivery_c lwage_c seaside vice lfine year1-year8"
xtdpdsys lso2_c  `xx', endog (lHMT_c lland_c lgov_c) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data1,excel append ctitle ("lso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)

    local xx "lpopu_c llaborinsec_c lsecgrp_c ldelivery_c lwage_c seaside vice lfine year1-year8"
xtdpdsys lpso2_c  `xx', endog (lHMT_c lland_c lgov_c) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data2,excel append ctitle ("ldso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)

   
   local xx "lpopu_c llaborinsec_c  lsecgrp_c lgov_c ldelivery_c lwage_c seaside vice lfine  year1-year8"
xtdpdsys lso2_c  `xx', endog(lfdi_c lland_c ) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data1,excel append ctitle ("lso2_c") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
  

   
 
   local xx "lpopu_c llaborinsec_c  lsecgrp_c  ldelivery_c lwage_c seaside vice lfine  year1-year8"
xtdpdsys lpso2_c  `xx', endog(lfdi_c lland_c lgov_c) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data1,excel append ctitle ("lpso2_c") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)

   
*comparison with different model
*Fixed effect model
local xx  "lfdi L.lfdi L2.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
xtreg `xx',fe cluster(id)
est store fe 
outreg2 using data1,word append ctitle ("Fixed effect") drop(i.year)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)

*Random effect model
local xx  "lfdi L.lfdi L2.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
xtreg `xx',re cluster(id)
est store re e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
outreg2 using data1,word append ctitle ("random effect") drop(i.year)

*difference GMM
local xx  "lfdi L.lfdi L2.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm7 "     L.lfdi L2.lfdi L(0/2).(lgdp lwage lpopu lpollctl)                     "
local iv7  "            L(0/2).(lSO2 lgovcrime                       )i.year   "
xtabond2 `xx', gmm(`gmm7') iv(`iv7') nolevel robust
est store paneldi
outreg2 paneldi using data1,word append ctitle ("Difference GMM")drop(i.year)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)


log close
shellout mylog.log
shellout mylog2.log

