*set the working directory
cd "C:\stata\final data"
log using mylognew.log,text replace

*input data
use citynew1,clear

*data summary
summarize
*declare individual identifier and time indentifier
xtset id year

*panel description of dataset
xtdescribe

xtsum id year *_a *_b delivery so2 tele mobile internet laborval busval
*panel summary statistics (within and between variation)
xtsum id year *_a *_b delivery so2 tele mobile internet 
estpost tabstat *_a *_b delivery so2 tele mobile internet laborval busval, listwise statistics(mean min p25 p50 p75 max) columns(statistics)
esttab using xtsum1.xls, cells("mean min p25 p50 p75 max") replace

shellout xtsum1.xls


*autocorrelation test 1
local xx "*_a delivery so2 tele mobile internet laborval busval"
xtserial `xx'
*autocorrelation test 2
local xx "*_b delivery so2 tele mobile internet laborval busval"
xtserial `xx'


*heteroskedastic test 1
local xx "*_a delivery so2 tele mobile internet laborval busval"
xtgls `xx',igls panels(heteroskedastic)
estimates store heter
xtgls `xx',igls
local df=e(N_g)-1
display e(N_g)-1
*result of 267 shows
lrtest heter ., df(267)

*heteroskedastic test 2
local xx "*_b delivery so2 tele mobile internet laborval busval"
xtgls `xx',igls panels(heteroskedastic)
estimates store heter
xtgls `xx',igls
local df=e(N_g)-1
display e(N_g)-1
*result of 267 shows
lrtest heter ., df(267)
log close

log using mylog2.log,text replace
*System GMM
*Arellano and Bond

*1.Assume fdi as independent variable*
*1.1 fdi invested*
local xx1  " L(0/1).(lso2 gov_a)  secgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm1 " L.fdi_a L(0/1).(lso2 gov_a)  secgrp_a pgrp_a wage_a "
local iv1  "                                             laborinsec_a  delivery  density_a laborval busval i.year"
xtabond2 fdi_a L.fdi_a `xx1', gmm(`gmm1') iv(`iv1') twostep robust
est store panel1a
outreg2 panela using data1,word replace ctitle ("SYS-GMM1.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)


*1.2 HMT invested*
local xx1  " L(0/1).(lso2 gov_a)  secgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm1 " L.HMT_a L(0/1).(lso2 gov_a)  secgrp_a pgrp_a wage_a "
local iv1  "                                             laborinsec_a  delivery  density_a laborval busval i.year"
xtabond2 HMT_a L.HMT_a `xx1', gmm(`gmm1') iv(`iv1') twostep robust
est store panel1b
outreg2 panel1b using data1,word append ctitle ("SYS-GMM1.2") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*1.3 domestic invested*
local xx1  " L(0/1).(lso2 gov_a)  secgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm1 " L.domestic_a L(0/1).(lso2 gov_a)  secgrp_a pgrp_a wage_a "
local iv1  "                                             laborinsec_a  delivery  density_a laborval busval i.year"
xtabond2 domestic_a L.domestic_a `xx1', gmm(`gmm1') iv(`iv1') twostep robust
est store panelc
outreg2 panelc using data1,word append ctitle ("SYS-GMM1.3") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*1.4 fdi used*
local xx1  " L(0/2).(lso2 gov_a)  secgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm1 " L.rfdi_a L(0/2).(lso2 gov_a)  secgrp_a pgrp_a wage_a "
local iv1  "                                             laborinsec_a  delivery  density_a laborval busval i.year"
xtabond2 rfdi_a L.rfdi_a `xx1', gmm(`gmm1') iv(`iv1') twostep robust
est store paneld
outreg2 paneld using data1,word append ctitle ("SYS-GMM1.4") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*2.1 fdi invested*
local xx2  " L(0/1).(lso2 gov_b)  secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm2 " L.fdi_b L(0/1).(lso2 gov_b)  secgrp_b pgrp_b wage_b "
local iv2 "                                             laborinsec_b  delivery  density_b laborval busval i.year"
xtabond2 fdi_b L.fdi_b `xx2', gmm(`gmm2') iv(`iv2') twostep robust
est store panel2a
outreg2 panel2a using data2,word replace ctitle ("SYS-GMM2.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*2.2 HMT invested*
local xx2  " L(0/1).(lso2 gov_b)  secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm2 " L.HMT_b L(0/1).(lso2 gov_b)  secgrp_b pgrp_b wage_b "
local iv2 "                                             laborinsec_b  delivery  density_b laborval busval i.year"
xtabond2 HMT_b L.HMT_b `xx2', gmm(`gmm2') iv(`iv2') twostep robust
est store panel2b
outreg2 panel2b using data2,word append ctitle ("SYS-GMM2.2") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*2.3 domestic invested*
local xx2  " L(0/1).(lso2 gov_b)  secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm2 " L.domestic_b L(0/3).(lso2 gov_b)  secgrp_b pgrp_b wage_b "
local iv2 "                                             laborinsec_b  delivery  density_b laborval busval i.year"
xtabond2 domestic_b L.domestic_b `xx2', gmm(`gmm2') iv(`iv2') twostep robust
est store panel2c
outreg2 panel2c using data2,word append ctitle ("SYS-GMM2.3") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*2.4 fdi used*
local xx2  " L(0/2).(lso2 gov_b)  secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm2 " L.rfdi_b L(0/2).(lso2 gov_b)  secgrp_b pgrp_b wage_b "
local iv2 "                                             laborinsec_b  delivery  density_b laborval busval  i.year"
xtabond2 rfdi_b L.rfdi_b `xx2', gmm(`gmm2') iv(`iv2') twostep robust
est store panel2d
outreg2 panel2d using data2,word append ctitle ("SYS-GMM2.4") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*3 SO2 as independent variable
*3.1 fdi
local xx3  " L(0/1).(fdi_a gov_a ) pgrp_a secgrp_a  wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm3 " L.lso2    L(0/1).(fdi_a gov_a)   secgrp_a    pgrp_a laborinsec_a  "
local iv3  " L2.lso2                       delivery         wage_a  density_a busval  laborval         i.year"
xtabond2 lso2 L.lso2 L2.lso2 `xx3', gmm(`gmm3') iv(`iv3') twostep robust
est store panel3a
outreg2 panel3a using data7,word replace ctitle ("SYS-GMM3.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*3.2
local xx3  " L(0/1).(HMT_a gov_a ) pgrp_a secgrp_a  wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm3 " L.lso2    L(0/1).(HMT_a gov_a )   secgrp_a    pgrp_a laborinsec_a  "
local iv3  " L2.lso2                 delivery         wage_a  density_a busval    laborval       i.year"
xtabond2 lso2 L.lso2 L2.lso2 `xx3', gmm(`gmm3') iv(`iv3') twostep robust
est store panel3a
outreg2 panel3a using data7,word append ctitle ("SYS-GMM3.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*3.3
local xx3  " L(0/1).(domestic_a gov_a ) pgrp_a secgrp_a  wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm3 " L.lso2    L(0/1).(domestic_a gov_a )   secgrp_a    pgrp_a laborinsec_a  "
local iv3  " L2.lso2                 delivery         wage_a  density_a busval    laborval       i.year"
xtabond2 lso2 L.lso2 L2.lso2 `xx3', gmm(`gmm3') iv(`iv3') twostep robust
est store panel3a
outreg2 panel3a using data7,word append ctitle ("SYS-GMM3.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*3.4
local xx3  " L(0/1).(rfdi_a gov_a ) pgrp_a secgrp_a  wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm3 " L.lso2    L(0/1).(rfdi_a gov_a )   secgrp_a    pgrp_a laborinsec_a  "
local iv3  " L2.lso2                 delivery         wage_a  density_a busval    laborval       i.year"
xtabond2 lso2 L.lso2 L2.lso2 `xx3', gmm(`gmm3') iv(`iv3') twostep robust
est store panel3a
outreg2 panel3a using data7,word append ctitle ("SYS-GMM3.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*4.1 fdi
local xx4  " L(0/1).(fdi_b gov_b ) pgrp_b secgrp_b  wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm4 " L.lso2    L(0/1).(fdi_b gov_b)   secgrp_b    pgrp_b laborinsec_b  "
local iv4  " L2.lso2                       delivery         wage_a  density_b busval  laborval         i.year"
xtabond2 lso2 L.lso2 L2.lso2 `xx4', gmm(`gmm4') iv(`iv4') twostep robust
est store panel4b
outreg2 panel4b using datab,word replace ctitle ("SYS-GMM4.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*4.2
local xx4  " L(0/1).(HMT_b gov_b ) pgrp_b secgrp_b  wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm4 " L.lso2    L(0/1).(HMT_b gov_b)   secgrp_b    pgrp_b laborinsec_b  "
local iv4  " L2.lso2                       delivery         wage_a  density_b busval  laborval         i.year"
xtabond2 lso2 L.lso2 L2.lso2 `xx4', gmm(`gmm4') iv(`iv4') twostep robust
est store panel4b
outreg2 panel4b using datab,word append ctitle ("SYS-GMM4.2") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*4.3
local xx4  " L(0/1).(domestic_b gov_b ) pgrp_b secgrp_b  wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm4 " L.lso2    L(0/1).(domestic_b gov_b)   secgrp_b    pgrp_b laborinsec_b  "
local iv4  " L2.lso2                       delivery         wage_a  density_b busval  laborval         i.year"
xtabond2 lso2 L.lso2 L2.lso2 `xx4', gmm(`gmm4') iv(`iv4') twostep robust
est store panel4b
outreg2 panel4b using datab,word append ctitle ("SYS-GMM4.3") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*4.4
local xx4  " L(0/1).(rfdi_b gov_b ) pgrp_b secgrp_b  wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm4 " L.lso2    L(0/1).(rfdi_b gov_b)   secgrp_b    pgrp_b laborinsec_b  "
local iv4  " L2.lso2                       delivery         wage_a  density_b busval  laborval         i.year"
xtabond2 lso2 L.lso2 L2.lso2 `xx4', gmm(`gmm4') iv(`iv4') twostep robust
est store panel4b
outreg2 panel4b using datab,word append ctitle ("SYS-GMM4.4") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*5.1
local xx5  " L(0/1).(fdi_a lso2 ) pgrp_a secgrp_a  wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm5 " L.gov_a    L(0/1).(fdi_a lso2)   secgrp_a    pgrp_a laborinsec_a  "
local iv5  "                       delivery         wage_a  density_a busval  laborval         i.year"
xtabond2 gov_a L.gov_a  `xx5', gmm(`gmm5') iv(`iv5') twostep robust
est store panel5a
outreg2 panel5a using data9,word replace ctitle ("SYS-GMM5.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*5.2
local xx5  " L(0/1).(HMT_a lso2) pgrp_a secgrp_a  wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm5 " L.gov_a   L(0/1).(HMT_a lso2)   secgrp_a  density_a laborinsec_a  "
local iv5  "                    delivery         wage_a   busval  laborval    pgrp_a       i.year"
xtabond2 gov_a L.gov_a  `xx5', gmm(`gmm5') iv(`iv5') twostep robust
est store panel5a
outreg2 panel5a using data9,word replace ctitle ("SYS-GMM5.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*5.3
local xx5  " L(0/1).(domestic_a lso2) pgrp_a secgrp_a  wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm5 " L.gov_a   L(0/1).(domestic_a lso2)   secgrp_a  density_a laborinsec_a  "
local iv5  "                      delivery         wage_a   busval  laborval    pgrp_a       i.year"
xtabond2 gov_a L.gov_a  `xx5', gmm(`gmm5') iv(`iv5') twostep robust
est store panel5c
outreg2 panel5c using data9,word replace ctitle ("SYS-GMM5.3") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)


*5.4
local xx5  " L(0/1).(rfdi_a lso2) pgrp_a secgrp_a  wage_a laborinsec_a  delivery  density_a laborval busval i.year"
local gmm5 " L.gov_a   L(0/1).(rfdi_a lso2)   secgrp_a  density_a laborinsec_a  "
local iv5  "                      delivery         wage_a   busval  laborval    pgrp_a       i.year"
xtabond2 gov_a L.gov_a  `xx5', gmm(`gmm5') iv(`iv5') twostep robust
est store panel5d
outreg2 panel5d using data9,word replace ctitle ("SYS-GMM5.4") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)



*6.1 fdi
local xx6  " L(0/1).(fdi_b lso2 ) pgrp_b secgrp_b  wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm6 " L.lso2    L(0/1).(fdi_b lso2)   secgrp_b    pgrp_b laborinsec_b  "
local iv6  "                       delivery         wage_a  density_b busval  laborval         i.year"
xtabond2 gov_b L.gov_b `xx6', gmm(`gmm6') iv(`iv6') twostep robust
est store panel6a
outreg2 panel6a using datab,word replace ctitle ("SYS-GMM6.1") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*6.2
local xx6  " L(0/1).(HMT_b lso2 ) pgrp_b secgrp_b  wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm6 " L.lso2    L(0/1).(HMT_b lso2)   secgrp_b   pgrp_b     laborinsec_b  "
local iv6  "                       delivery      wage_a  density_b busval  laborval         i.year"
xtabond2 gov_b L.gov_b `xx6', gmm(`gmm6') iv(`iv6') twostep robust
est store panel6b
outreg2 panel6b using datab,word replace ctitle ("SYS-GMM6.2") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*6.3
local xx6  " L(0/1).(domestic_b lso2 ) pgrp_b secgrp_b  wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm6 " L.lso2    L(0/1).(domestic_b lso2)   secgrp_b   laborinsec_b  "
local iv6  "                       delivery        pgrp_b   wage_a  density_b busval  laborval         i.year"
xtabond2 gov_b L.gov_b `xx6', gmm(`gmm6') iv(`iv6') twostep robust
est store panel6c
outreg2 panel6c using datab,word append ctitle ("SYS-GMM6.3") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)

*6.4
local xx6  " L(0/1).(rfdi_b lso2 ) pgrp_b secgrp_b  wage_b laborinsec_b  delivery  density_b laborval busval i.year"
local gmm6 " L.lso2    L(0/1).(rfdi_b lso2)   secgrp_b    laborinsec_b  "
local iv6  "                       delivery       pgrp_b   wage_a  density_b busval  laborval         i.year"
xtabond2 gov_b L.gov_b `xx6', gmm(`gmm6') iv(`iv6') twostep robust
est store panel6d
outreg2 panel6d using datab,word replace ctitle ("SYS-GMM6.4") e(ar1 ar1p ar2 ar2p sargan sarganp hansen hansenp N)  noobs bdec(3) sdec(3) drop(i.year)



*comparison with different model
*Fixed effect model 1.1
local xx  "lso2 L.lso2 gov_a L.gov_a  secgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
xtreg fdi_a L.fdi_a `xx',fe cluster(id)
est store fe1a
outreg2 using data3,word append ctitle ("Fixed effect1.1") drop(i.year)

*Fixed effect model 1.2
local xx  "lso2 L.lso2 gov_a L.gov_asecgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
xtreg HMT_a L.HMT_a `xx',fe cluster(id)
est store fe1b
outreg2 using data3,word append ctitle ("Fixed effect1.2") drop(i.year)
*Fixed effect model 1.3
local xx  "lso2 L.lso2 gov_a L.gov_a  secgrp_a pgrp_a wage_a laborinsec_a  delivery laborval busval density_a  i.year"
xtreg domestic_a L.domestic_a `xx',fe cluster(id)
est store fe1c
outreg2 using data3,word append ctitle ("Fixed effect1.3") drop(i.year)
*Fixed 1.4
local xx  "lso2 L.lso2 gov_a L.gov_a  secgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
xtreg rfdi_a L.rfdi_a `xx',fe cluster(id)
est store fe1a
outreg2 using data3,word append ctitle ("Fixed effect1.4") drop(i.year)

*Fixed effect model 2.1
local xx  "lso2 L2.lso2 gov_b L.gov_b secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
xtreg fdi_b L.fdi_b `xx',fe cluster(id)
est store fe2a 
outreg2 using data4,word append ctitle ("Fixed effect2.1") drop(i.year)

*Fixed effect model 2.2
local xx  "lso2 L.lso2 gov_b L.gov_b secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
xtreg HMT_b L.HMT_b `xx',fe cluster(id)
est store fe2b
outreg2 using data4,word append ctitle ("Fixed effect2.2") drop(i.year)
*Fixed effect model 2.3
local xx  "lso2 L.lso2 gov_b L.gov_b secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
xtreg domestic_b L.domestic_b `xx',fe cluster(id)
est store fe2c
outreg2 using data4,word append ctitle ("Fixed effect2.3") drop(i.year)

local xx  "lso2 L2.lso2 gov_b L.gov_b secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
xtreg rfdi_b L.rfdi_b `xx',fe cluster(id)
est store fe2a 
outreg2 using data4,word append ctitle ("Fixed effect2.4") drop(i.year)


*Random effect model
*comparison with different model
*Random effect model 1.1
local xx  "lso2 L.lso2  gov_a L.gov_asecgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
xtreg fdi_a L.fdi_a `xx',re cluster(id)
est store re1a 
outreg2 using data5,word append ctitle ("Random effect1.1") drop(i.year)

*Random effect model 1.2
local xx  "lso2 L.lso2  gov_a L.gov_a secgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
xtreg HMT_a L.HMT_a `xx',re cluster(id)
est store re1b
outreg2 using data5,word append ctitle ("Random effect1.2") drop(i.year)
*Random effect model 1.3
local xx  "lso2 L.lso2  gov_a L.gov_a  secgrp_a pgrp_a wage_a laborinsec_a  delivery laborval busval density_a  i.year"
xtreg domestic_a L.domestic_a `xx',re cluster(id)
est store re1c
outreg2 using data5,word append ctitle ("Random effect1.3") drop(i.year)

*Random effect model 1.4
local xx  "lso2 L.lso2  gov_a L.gov_asecgrp_a pgrp_a wage_a laborinsec_a  delivery  density_a laborval busval i.year"
xtreg rfdi_a L.rfdi_a `xx',re cluster(id)
est store re1a 
outreg2 using data5,word append ctitle ("Random effect1.4") drop(i.year)

*Random effect model 2.1
local xx  "lso2 L.lso2 gov_b L.gov_b  secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
xtreg fdi_b L.fdi_b `xx',re cluster(id)
est store re2a 
outreg2 using data6,word append ctitle ("Random effect2.1") drop(i.year)

*Random effect model 2.2
local xx  "lso2 L.lso2 gov_b L.gov_b  secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
xtreg HMT_b L.HMT_b `xx',re cluster(id)
est store re2b
outreg2 using data6,word append ctitle ("Random effect2.2") drop(i.year)
*Random effect model 2.3
local xx  "lso2 L.lso2 gov_b L.gov_bsecgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
xtreg domestic_b L.domestic_b `xx',re cluster(id)
est store re2c
outreg2 using data6,word append ctitle ("Random effect2.3") drop(i.year)

*Random effect model 2.4*
local xx  "lso2 L.lso2 gov_b L.gov_b  secgrp_b pgrp_b wage_b laborinsec_b  delivery  density_b laborval busval i.year"
xtreg rfdi_b L.rfdi_b `xx',re cluster(id)
est store re2a 
outreg2 using data6,word append ctitle ("Random effect2.4") drop(i.year)

log close
shellout mylog.log
shellout mylog2.log






