*Assume with L2.lfdi and lgdp, lwage,lpopu are endogenous (appliable)

   local xx " llaborinsec_b  lpopu_b lsecgrp_b  ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b lHMT_b lland_b lfdi_b lgov_b lfine )maxlag(2)twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data666,excel replace ctitle ("total") drop(year1-year8) e(N N_g arm2 artest sargan) 


 local xx " lpopu_c  lsecgrp_c lland_c llaborinsec_c  ldelivery_c lwage_c seaside vice lfine year2-year8"
xtdpdsys lso2_c  `xx',endog(ldomestic_c lHMT_c lfdi_c lland_c lgov_c lfine) maxlag(2) twostep
est store dycs_2endog
estat abond 
estat sargan
outreg2 using data666,excel append ctitle ("total ") drop(year1-year8) e(N N_g arm2 artest sargan) 
*city center*

 local xx " llaborinsec_b  lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(ldomestic_b  lgov_b lfine) maxlag(2) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
 outreg2 using data666,excel append ctitle ("lso2_b") drop(year1-year8) e(N N_g arm2 artest sargan) 
 
 local xx " llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(lHMT_b    lgov_b lfine) maxlag(2) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data666,excel append ctitle ("lpso2_b") drop(year1-year8)e(N N_g arm2 artest sargan)
 

 local xx " llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b seaside vice year1-year8"
xtdpdsys lso2_b  `xx', endog(lfdi_b  lgov_b lfine) maxlag(2) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
  outreg2 using data666,excel append ctitle ("lpso2_b") drop(year1-year8)e(N N_g arm2 artest sargan)
 
* suburban area
  
local xx " lpopu_c  lsecgrp_c llaborinsec_c ldelivery_c lwage_c seaside vice  year2-year8"
xtdpdsys lso2_c  `xx',endog(ldomestic_c lland_c lgov_c lfine) twostep
est store dycs_2endog
estat abond 
estat sargan
outreg2 using data666,excel append ctitle ("lso2_b") drop(year1-year8) e(N N_g arm2 artest sargan)


   local xx "lpopu_c llaborinsec_c lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtdpdsys lso2_c  `xx', endog (lHMT_c lland_c lgov_c lfine) maxlag(2) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data666,excel append ctitle ("lso2_b") drop(year1-year8)e(N N_g arm2 artest sargan)

  
 
   local xx " llaborinsec_c  lsecgrp_c  ldelivery_c lwage_c seaside vice  year1-year8"
xtdpdsys lso2_c  `xx', endog(lfdi_c lland_c lgov_c lfine lpopu_c) maxlag(2) twostep
 est store dycs_2endog
 estat abond 
 estat sargan
   outreg2 using data666,excel append ctitle ("lso2_c") drop(year1-year8) e(N N_g arm2 artest sargan)


 