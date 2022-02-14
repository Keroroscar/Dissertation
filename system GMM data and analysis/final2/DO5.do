*diff gmm(appliable)

 local xx "lfine llaborinsec_b  lpopu_b lsecgrp_b  ldelivery_b lwage_b seaside vice year1-year8"
xtdpd lso2_b L.lso2_b `xx' ldomestic_b lHMT_b lland_b lfdi_b lgov_b, dgmmiv(ldomestic_b lHMT_b lland_b lfdi_b lgov_b ) div(year1-year8) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data333,excel replace ctitle ("total_a") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3) 

 
local xx " lpopu_c lland_c lsecgrp_c lland_c llaborinsec_c  ldelivery_c lwage_c seaside vice lfine year2-year8"
xtdpd lso2_c L.lso2_c `xx' lfine ldomestic_c lHMT_c lfdi_c lland_c lgov_c,dgmmiv(lfine ldomestic_c lHMT_c lfdi_c lland_c lgov_c ) div(year1-year8) twostep
est store dycs_2endog
estat abond 
estat sargan
 outreg2 using data333,excel append ctitle ("total_b") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3) 
*city center*

 local xx " llaborinsec_b  lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpd lso2_b L.lso2_b ldomestic_b  lgov_b lfine `xx',dgmmiv(ldomestic_b lgov_b lfine)  div(year1-year8) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data333,excel append ctitle ("lso2_a") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)

 local xx "lfine llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpd lso2_b L.lso2_b lHMT_b  lgov_b `xx', dgmmiv(lHMT_b  lgov_b ) div(year1-year8) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data333,excel append ctitle ("lso2_a") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)
  
 local xx " llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpd lso2_b L.lso2_b lfdi_b  lgov_b lfine `xx', dgmmiv(lfdi_b  lgov_b lfine) div(year1-year8) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data333,excel append ctitle ("lso2_a") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)

* suburban area
  
local xx "lfine lpopu_c  lsecgrp_c llaborinsec_c ldelivery_c lwage_c seaside vice  year2-year8"
xtdpd lso2_c L.lso2_c ldomestic_c lland_c lgov_c `xx',dgmmiv(ldomestic_c lpopu_c lgov_c ) div(year2-year8) twostep
est store dycs_2endog
estat abond 
estat sargan
 outreg2 using data333,excel append ctitle ("lso2_b") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)
  
local xx "lfine lpopu_c llaborinsec_c lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtdpd lso2_c L.lso2_c lHMT_c lland_c lgov_c `xx', dgmmiv (lHMT_c lland_c lgov_c ) div(year1-year8) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data333,excel append ctitle ("lso2_b") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)

   
 local xx "lfine llaborinsec_c  lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtdpd lso2_c L.lso2_c lfdi_c lland_c lgov_c  lpopu_c `xx', dgmmiv(lfdi_c lland_c lgov_c  lpopu_c) div(year1-year8) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data333,excel append ctitle ("lso2_b") drop(year1-year8) e(arm1 arm2 artests sargan sarganp  N N_g)  noobs bdec(3) sdec(3)
  
