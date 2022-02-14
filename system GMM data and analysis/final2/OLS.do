*OLS
 
local xx " llaborinsec_b  lpopu_b lsecgrp_b  ldelivery_b lwage_b  year1-year8"
reg lso2_b L.lso2_b ldomestic_b lHMT_b lland_b lfdi_b lgov_b lfine `xx'
outreg2 using data66,excel replace ctitle ("total ") drop(year1-year8) e( N)


local xx " lpopu_c  lsecgrp_c lland_c llaborinsec_c  ldelivery_c lwage_c  lfine year1-year8"
reg lso2_c L.lso2_c ldomestic_c lHMT_c lfdi_c lgov_c lfine `xx',
outreg2 using data66,excel append ctitle ("suburban ") drop(year1-year8) e( N) 


local xx " llaborinsec_b  lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b year1-year8"
reg lso2_b L.lso2_b ldomestic_b  lgov_b lfine `xx'
outreg2 using data66,excel append ctitle ("domestic ") drop(year1-year8) e( N) 
 
 
local xx " llaborinsec_b  lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b  year1-year8"
reg lso2_b L.lso2_b lHMT_b lgov_b lfine `xx'
outreg2 using data66,excel append ctitle ("HMT ") drop(year1-year8) e( N)  
 
local xx " llaborinsec_b lland_b lpopu_b lsecgrp_b lland_b ldelivery_b lwage_b  year1-year8"
reg lso2_b L.lso2_b lfdi_b  lgov_b lfine `xx'
outreg2 using data66,excel append ctitle ("fdi_b ") drop(year1-year8) e( N)  
* suburban area
  
local xx " lpopu_c  lsecgrp_c llaborinsec_c ldelivery_c lwage_c  year2-year8"
reg lso2_c L.lso2_c ldomestic_c lland_c lgov_c lfine `xx'
outreg2 using data66,excel append ctitle ("domestic_b ") drop(year1-year8) e( N)


local xx "lpopu_c llaborinsec_c lsecgrp_c  ldelivery_c lwage_c   year1-year8"
reg lso2_c L.lso2_c lHMT_c lland_c lgov_c lfine `xx' 
outreg2 using data66,excel append ctitle ("HMT_b ") drop(year1-year8) e( N)

local xx " llaborinsec_c  lsecgrp_c  ldelivery_c lwage_c  year1-year8"
reg lso2_c L.lso2_c lfdi_c lland_c lgov_c lfine lpopu_c `xx'
outreg2 using data66,excel append ctitle ("fdi_b ") drop(year1-year8) e( N)
 