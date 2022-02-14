





*Assume with L2.lfdi and lgdp, lwage,lpopu are endogenous (appliable)

   local xx "lfine llaborinsec_b  lpopu_b lsecgrp_b  ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b lHMT_b lland_b lfdi_b lgov_b ) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data4,excel append ctitle ("total_a") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3) 

 
local xx " lpopu_c lland_c lsecgrp_c lland_c llaborinsec_c  ldelivery_c lwage_c seaside vice lfine year2-year8"
xtdpdsys lso2_c  `xx',endog(lfine ldomestic_c lHMT_c lfdi_c lland_c lgov_c ) twostep
est store dycs_2endog
estat abond 
estat sargan
 outreg2 using data4,excel append ctitle ("total_b") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3) 
*city center*

 local xx " llaborinsec_b  lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b  lgov_b lfine) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data4,excel append ctitle ("lso2_a") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)

 local xx "lfine llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(lHMT_b    lgov_b ) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data4,excel append ctitle ("lso2_a") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)
  
 local xx " llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(lfdi_b  lgov_b lfine) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data4,excel append ctitle ("lso2_a") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)

* suburban area
  
local xx "lfine lpopu_c  lsecgrp_c llaborinsec_c ldelivery_c lwage_c seaside vice  year2-year8"
xtdpdsys lso2_c  `xx',endog(ldomestic_c lland_c lgov_c ) twostep
est store dycs_2endog
estat abond 
estat sargan
 outreg2 using data4,excel append ctitle ("lso2_b") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)
   local xx "lfine lpopu_c llaborinsec_c lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtdpdsys lso2_c  `xx', endog (lHMT_c lland_c lgov_c ) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data4,excel append ctitle ("lso2_b") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)

   
   local xx "lfine llaborinsec_c  lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtdpdsys lso2_c  `xx', endog(lfdi_c lland_c lgov_c  lpopu_c) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
    outreg2 using data4,excel append ctitle ("lso2_b") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)
  

   