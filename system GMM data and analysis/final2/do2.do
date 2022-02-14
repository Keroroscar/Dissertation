*Assume with L2.lfdi and lgdp, lwage,lpopu are endogenous (appliable)

   local xx " llaborinsec_b  lpopu_b lsecgrp_b  ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b lHMT_b lland_b lfdi_b lgov_b lfine) nolevel
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data1,excel replace ctitle ("total") drop(year1-year8) e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) 

 
 local xx " llaborinsec_b  lpopu_b lsecgrp_b  ldelivery_b lwage_b seaside vice year1-year8"
 xtreg lso2_b ldomestic_b lHMT_b lland_b lfdi_b lgov_b lfine `xx', cluster(id)
 outreg2 using data11,excel replace ctitle ("total ") drop(year1-year8) e( N) 

 
 local xx " lpopu_c  lsecgrp_c lland_c llaborinsec_c  ldelivery_c lwage_c seaside vice lfine year2-year8"
xtdpdsys lso2_c  `xx',endog(ldomestic_c lHMT_c lfdi_c lland_c lgov_c lfine) twostep
est store dycs_2endog
estat abond 
estat sargan
outreg2 using data1,excel append ctitle ("total ") drop(year1-year8) e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N) 
*city center*

 local xx " lpopu_c  lsecgrp_c lland_c llaborinsec_c  ldelivery_c lwage_c seaside vice lfine year1-year8"
xtreg lso2_c ldomestic_c lHMT_c lfdi_c lgov_c lfine `xx', fe cluster(id)
outreg2 using data11,excel append ctitle ("suburban ") drop(year1-year8) e( N) 

 local xx " llaborinsec_b  lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b  lgov_b lfine) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data1,excel append ctitle ("lso2_b") drop(year1-year8) e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) 

  local xx " llaborinsec_b  lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtreg lso2_b ldomestic_b  lgov_b lfine `xx',fe cluster(id)
 
 outreg2 using data11,excel append ctitle ("domestic ") drop(year1-year8) e( N) 
 
 
 local xx " llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(lHMT_b    lgov_b lfine) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data1,excel append ctitle ("lpso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
 
 local xx " llaborinsec_b  lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtreg lso2_b lHMT_b lgov_b lfine `xx', fe cluster(id)
outreg2 using data11,excel append ctitle ("HMT ") drop(year1-year8) e( N)  
 
 local xx " llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(lfdi_b  lgov_b lfine) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data1,excel append ctitle ("lpso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)

   local xx " llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtreg lso2_b lfdi_b  lgov_b lfine `xx', fe cluster(id)
outreg2 using data11,excel append ctitle ("fdi_b ") drop(year1-year8) e( N)  
* suburban area
  
local xx " lpopu_c  lsecgrp_c llaborinsec_c ldelivery_c lwage_c seaside vice  year2-year8"
xtdpdsys lso2_c  `xx',endog(ldomestic_c lland_c lgov_c lfine) twostep
est store dycs_2endog
estat abond 
estat sargan
outreg2 using data1,excel append ctitle ("lso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)

local xx " lpopu_c  lsecgrp_c llaborinsec_c ldelivery_c lwage_c  year2-year8"
xtreg lso2_c ldomestic_c lland_c lgov_c lfine `xx' ,re cluster(id)
outreg2 using data11,excel append ctitle ("domestic_b ") drop(year1-year8) e( N)

   local xx "lpopu_c llaborinsec_c lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtdpdsys lso2_c  `xx', endog (lHMT_c lland_c lgov_c lfine) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data1,excel append ctitle ("lso2_b") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
  
  local xx "lpopu_c llaborinsec_c lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtreg lso2_c lHMT_c lland_c lgov_c lfine `xx', re cluster(id)
 outreg2 using data11,excel append ctitle ("HMT_b ") drop(year1-year8) e( N)
 
 
   local xx " llaborinsec_c  lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtdpdsys lso2_c  `xx', endog(lfdi_c lland_c lgov_c lfine lpopu_c) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data1,excel append ctitle ("lso2_c") drop(year1-year8)e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3)
  
   local xx " llaborinsec_c  lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtreg lso2_c lfdi_c lland_c lgov_c lfine lpopu_c `xx',fe cluster(id)
outreg2 using data11,excel append ctitle ("fdi_b ") drop(year1-year8) e( N)
 