*set the working directory
cd "C:\stata\final2"
log using mylog.log,text replace

*input data
use final2,clear

* local xx "fine finedfirm laborinsec_a laborinsec_b so2 popu_a popu_b secgrp_a secgrp_b gov_a gov_b land_a land_b"
foreach v of local xx{
drop if `v'==.
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
xtsum id year fdi SO2 govcrime gdp popu wage pollctl
estpost tabstat fdi SO2 govcrime gdp popu wage pollctl , listwise statistics(mean min p25 p50 p75 max) columns(statistics)
esttab using xtsum1.xls, cells("mean min p25 p50 p75 max") replace
*Ln type
xtsum id year lfdi lSO2 lgovcrime lgdp lpopu lwage lpollctl
estpost tabstat lfdi lSO2 lgovcrime lgdp lpopu lwage lpollctl, listwise statistics(mean min p25 p50 p75 max) columns(statistics)
esttab using xtsum2.xls, cells("mean min p25 p50 p75 max") replace
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
local xx "lfdi lSO2 lgovcrime lwage lpopu lgdp lpollctl"
xtserial `xx'

*heteroskedastic test
local xx "lfdi lSO2 lgovcrime lwage lpopu lgdp lpollctl"
xtgls `xx',igls panels(heteroskedastic)
estimates store heter
xtgls `xx',igls
local df=e(N_g)-1
display e(N_g)-1
*result of 179 shows
lrtest heter ., df(179)
log close

log using mylog2.log,text replace
*System GMM
*Arellano and Bond

*Assume with L2.lfdi and lgdp, lwage,lpopu are endogenous (appliable)
local xx   "lfdi L.lfdi  L(0/4).lSO2 lgovcrime lpopu lwage lpollctl lgdp i.year"
local gmm1 "     L.lfdi       lgovcrime lpopu lwage lpollctl lgdp          "
local iv1  "            L(0/4).lSO2                                 i.year      "
xtabond2 `xx', gmm(`gmm1') iv(`iv1') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx   "lfdi L.lfdi  L(0/5).lSO2 lgovcrime lpopu lwage lpollctl lgdp i.year"
local gmm2 "     L.lfdi       lgovcrime lpopu lwage lpollctl lgdp          "
local iv2  "            L(0/5).lSO2                                 i.year      "
xtabond2 `xx', gmm(`gmm2') iv(`iv2') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx   "lfdi L.lfdi  lSO2 L(0/4).lgovcrime lpopu lwage lpollctl lgdp i.year"
local gmm3 "     L.lfdi   lSO2     lpopu lwage lpollctl lgdp          "
local iv3  "            L(0/4). lgovcrime                                i.year      "
xtabond2 `xx', gmm(`gmm3') iv(`iv3') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx   "lfdi L.lfdi  lSO2 L(0/5).lgovcrime lpopu lwage lpollctl lgdp i.year"
local gmm4 "     L.lfdi   lSO2     lpopu lwage lpollctl lgdp          "
local iv4  "            L(0/5). lgovcrime                                i.year      "
xtabond2 `xx', gmm(`gmm3') iv(`iv3') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)


local xx   "lfdi L.lfdi  lSO2 lgovcrime L(0/4).lpopu lwage lpollctl lgdp i.year"
local gmm5 "     L.lfdi   lSO2    lgovcrime   lwage lpollctl lgdp          "
local iv5  "            L(0/4).lpopu                               i.year      "
xtabond2 `xx', gmm(`gmm5') iv(`iv5') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)


local xx   "lfdi L.lfdi  lSO2 lgovcrime L(0/5).lpopu lwage lpollctl lgdp i.year"
local gmm6 "     L.lfdi   lSO2    lgovcrime   lwage lpollctl lgdp          "
local iv6  "            L(0/5).lpopu                               i.year      "
xtabond2 `xx', gmm(`gmm6') iv(`iv6') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)


local xx   "lfdi L.lfdi  lSO2 lgovcrime lpopu L(0/4).lwage lpollctl lgdp i.year"
local gmm7 "     L.lfdi   lSO2    lgovcrime  lpopu lpollctl lgdp          "
local iv7  "            L(0/4).lwage                               i.year      "
xtabond2 `xx', gmm(`gmm7') iv(`iv7') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx   "lfdi L.lfdi  lSO2 lgovcrime lpopu lwage L(0/5).lpollctl lgdp i.year"
local gmm8 "     L.lfdi   lSO2    lgovcrime  lpopu lwage   lgdp          "
local iv8  "            L(0/5).lpollctl                              i.year      "
xtabond2 `xx', gmm(`gmm8') iv(`iv8') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx   "lfdi L.lfdi  lSO2 lgovcrime lpopu lwage lpollctl L(0/4).lgdp i.year"
local gmm9 "     L.lfdi   lSO2    lgovcrime  lpopu lwage  lpollctl            "
local iv9  "            L(0/4).lgdp                             i.year      "
xtabond2 `xx', gmm(`gmm9') iv(`iv9') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx   "lfdi L.lfdi  lSO2 lgovcrime lpopu lwage lpollctl L(0/5).lgdp i.year"
local gmm9 "     L.lfdi   lSO2    lgovcrime  lpopu lwage  lpollctl            "
local iv9  "            L(0/5).lgdp                             i.year      "
xtabond2 `xx', gmm(`gmm9') iv(`iv9') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx   "lfdi L.lfdi  lSO2 lgovcrime lpopu lwage lpollctl lgdp i.year"
local gmm9 "     L.lfdi  lSO2 lgovcrime lpopu lwage lpollctl lgdp         "
local iv9  "            L(0/5).                             i.year      "
xtabond2 `xx', gmm(`gmm9') iv(`iv9') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

*Lag of more than two variable
local xx    "lfdi L.lfdi  L(0/4).(lSO2 lwage)lgovcrime lpopu  lpollctl lgdp i.year"
local gmm10 "     L.lfdi  lSO2 lgovcrime lpopu lpollctl lgdp       "
local iv10  "             L(0/4).(lSO2 lwage )                               i.year"
xtabond2 `xx', gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx    "lfdi L.lfdi  L(0/4).(lSO2 lpollctl )lgovcrime lpopu lwage lgdp i.year"
local gmm10 "     L.lfdi  lSO2 lgovcrime lpopu lwage lgdp       "
local iv10  "             L(0/4).(lSO2 lpollctl )                               i.year"
xtabond2 `xx', gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx    "lfdi L.lfdi  lSO2 L(0/4).( lgovcrime   lwage)lpopu lpollctl lgdp i.year"
local gmm10 "     L.lfdi  lSO2   lpollctl lgdp  lpopu     "
local iv10  "              L(0/4).( lgovcrime lwage )                               i.year"
xtabond2 `xx', gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)



local xx    "lfdi L.lfdi  L(0/4).( lSO2 lgovcrime lwage lpopu)  lpollctl lgdp i.year"
local gmm10 "     L.lfdi  lSO2   lpollctl lgdp                       "
local iv10  "             L(0/4).( lSO2 lgovcrime lwage lpopu)                  i.year"
xtabond2 `xx', gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

*Add variables one by one (4 or 5 both fine)
local xx    "lfdi L.lfdi  L(0/4).(lSO2 lgovcrime)  i.year"
local gmm10 "     L.lfdi                       "
local iv10  "             L(0/4).(lSO2 lgovcrime) i.year"
xtabond2 `xx', gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx    "lfdi L.lfdi  L(0/4).(lSO2 lgovcrime) lwage i.year"
local gmm10 "     L.lfdi                       "
local iv10  "             L(0/4).(lSO2 lgovcrime) lwage i.year"
xtabond2 `xx', gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx    "lfdi L.lfdi  L(0/4).(lSO2 lgovcrime )lwage lpopu i.year"
local gmm10 "     L.lfdi  lwage lpopu                     "
local iv10  "             L(0/4).(lSO2 lgovcrime ) i.year"
xtabond2 `xx', gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx    "lfdi L.lfdi  L(0/4).(lSO2 lgovcrime )lwage lpopu lpollctl i.year"
local gmm10 "     L.lfdi  lwage lpopu   lpollctl                  "
local iv10  "             L(0/4).(lSO2 lgovcrime ) i.year"
xtabond2 `xx', gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)


local xx    "lfdi L.lfdi  L(0/4).(lSO2 lgovcrime )lwage lpopu lpollctl lgdp i.year"
local gmm10 "     L.lfdi  lwage lpopu   lpollctl  lgdp                "
local iv10  "             L(0/4).(lSO2 lgovcrime ) i.year"
xtabond2 `xx' if , gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)


local xx    "lfdi L.lfdi  lSO2 lgovcrime lwage lpopu lpollctl lgdp i.year"
local gmm10 "     L.lfdi      lgdp     lwage lpopu     "
local iv10  "             lSO2 lgovcrime  lpollctl i.year"
xtabond2 `xx' , gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)


local xx    "lfdi L.lfdi L.lgdp lSO2 lgovcrime L(0/4).(lpollctl ) lwage  i.year"
local gmm10 "     L.lfdi  L.lgdp   L(0/4).(  lpollctl  )  lwage        "
local iv10  "         lSO2 lgovcrime  i.year"
xtabond2 `xx' if  , gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)


local xx    "lfdi L.lfdi L2.lfdi L.lgdp lSO2 lgovcrime L(0/4).(lpollctl) lwage  i.year"
local gmm10 "     L.lfdi L2.lfdi L.lgdp   L(0/4).( lpollctl)             "
local iv10  "         lSO2 lgovcrime lwage i.year"
xtabond2 `xx' , gmm(`gmm10') iv(`iv10') twostep robust
store panel1
outreg2 panel1 using data1,word replace ctitle ("SYS-GMM1") e(ar1 ar1p ar2 ar2p sargan sarganp N)  noobs bdec(3) sdec(3) drop(i.year)

local xx    "lgdp L.lgdp   lfdi lSO2 lgovcrime L(0/4).(lpollctl)lwage   i.year"
local gmm10 "     L.lgdp   lfdi           "
local iv10  "         lSO2 lgovcrime  lwage i.year L(0/4).( lpollctl)   "
xtabond2 `xx' , gmm(`gmm10') iv(`iv10') twostep robust 
 
 

local xx    "lSO2 L.lSO2 lfdi   lgovcrime L(0/4).(lpollctl)lwage lgdp  i.year"
local gmm10 "     L.lSO2  lfdi    lgdp      "
local iv10  "        lgovcrime  lwage  i.year L(0/4).( lpollctl)   "
xtabond2 `xx' if seaside==1 , gmm(`gmm10') iv(`iv10') twostep robust 
 
 

local xx    "lfdi L.lfdi L2.lfdi L.lgdp lSO2 lgovcrime lpollctl lwage  i.year"
local gmm10 "     L.lfdi L2.lfdi L.lgdp   lpollctl             "
local iv10  "         lSO2 lgovcrime lwage i.year"
xtabond2 `xx' if seaside==1 , gmm(`gmm10') iv(`iv10') twostep robust


*comparison with different model
*Fixed effect model
local xx  "lfdi L.lfdi L2.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
xtreg `xx',fe cluster(id)
est store fe 
outreg2 using data1,word append ctitle ("Fixed effect") drop(i.year)

*Random effect model
local xx  "lfdi L.lfdi L2.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
xtreg `xx',re cluster(id)
est store re 
outreg2 using data1,word append ctitle ("random effect") drop(i.year)

*difference GMM
local xx  "lfdi L.lfdi L2.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm7 "     L.lfdi L2.lfdi L(0/2).(lgdp lwage lpopu lpollctl)                     "
local iv7  "            L(0/2).(lSO2 lgovcrime                       )i.year   "
xtabond2 `xx', gmm(`gmm7') iv(`iv7') nolevel robust
est store paneldi
outreg2 paneldi using data1,word append ctitle ("Difference GMM")drop(i.year)
shellout using `"data1.rtf"'

log close
shellout mylog.log
shellout mylog2.log

