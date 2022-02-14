*set the working directory
cd "C:\stata\personal"

*input data
use panel1,clear

*data summary
summarize
*declare individual identifier and time indentifier
xtset id year

*panel description of dataset
xtdescribe

*panel summary statistics (within and between variation)
xtsum id year fdi SO2 govcrime gdp popu wage pollctl
xtsum id year lfdi lSO2 lgovcrime lgdp lpopu lwage lpollctl


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
xtserial `xx'


*Arellano and Bond

*Assume all independed variables are exogenous
local xx  "lfdi L.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm1 "     L.lfdi                                                        "
local iv1  "           L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
xtabond2 `xx', gmm(`gmm1') iv(`iv1') twostep robust  

*Assume lgdp are endogenous
local xx  "lfdi L.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm2 "     L.lfdi L(0/2).(lgdp)                                          "
local iv2  "            L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl)    i.year "
xtabond2 `xx', gmm(`gmm2') iv(`iv2') twostep robust

*Assume lgdp, lwage are endogenous
local xx  "lfdi L.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm3 "    L.lfdi L(0/2).(                     lwage          lgdp)       "
local iv3  "           L(0/2).(lSO2 lgovcrime lpopu       lpollctl     ) i.year"
xtabond2 `xx', gmm(`gmm3') iv(`iv3') twostep robust

*Assume lgdp, lwage,lpopu are endogenous (appliable)
local xx   "lfdi L.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm4 "     L.lfdi L(0/2).(               lpopu lwage          lgdp)       "
local iv4  "            L(0/2).(lSO2 lgovcrime             lpollctl     ) i.year"
xtabond2 `xx', gmm(`gmm4') iv(`iv4') twostep robust

*Assume lgdp, lwage,lpopu are endogenous (appliable)
local xx   "lfdi L.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm4 "     L.lfdi L(0/2).(               lpopu lwage          lgdp)       "
local iv4  "            L(0/2).(lSO2 lgovcrime             lpollctl     ) i.year"
xtabond2 `xx', gmm(`gmm4') iv(`iv4') twostep robust

*Assume lgdp, lwage,lpopu lpollctl are endogenous (appliable)
local xx   "lfdi L.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm5 "     L.lfdi L(0/2).(lgdp           lpopu lwage lpollctl     )       "
local iv5  "            L(0/2).(lSO2 lgovcrime                          ) i.year"
xtabond2 `xx', gmm(`gmm5') iv(`iv5') twostep robust

*Assume with L2.lfdi and lgdp, lwage,lpopu lpollctl are endogenous (appliable)
local xx   "lfdi L.lfdi L2.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm6 "     L.lfdi L2.lfdi L(0/2).(               lpopu lwage lpollctl lgdp)       "
local iv6  "                    L(0/2).(lSO2 lgovcrime                        )   i.year"
xtabond2 `xx', gmm(`gmm6') iv(`iv6') twostep robust
est store panel1
outreg2 panel1 using data1,excel append title ("SYS-GMM")

*comparison with different model
*Fixed effect model
xtreg lfdi  `xx',fe
est store fe 
outreg2 using data1,excel append title ("Fixed effect")

*Random effect model
xtreg lfdi  `xx',re
est store re 
outreg2 using data1,excel append title ("random effect")

*difference GMM
local xx  "lfdi L.lfdi L2.lfdi L(0/2).(lSO2 lgovcrime lpopu lwage lpollctl lgdp) i.year"
local gmm7 "     L.lfdi L2.lfdi L(0/2).(lgdp lwage lpopu lpollctl)                     "
local iv7  "            L(0/2).(lSO2 lgovcrime                       )i.year   "
xtabond2 `xx', gmm(`gmm7') iv(`iv7') nolevel robust
est store paneldi
outreg2 paneldi using data1,excel append title ("Difference effect")
