/* healthTrends.do               damiancclarke             yyyy-mm-dd:2016-05-14
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

The political economy of child health

*/

vers 11
clear all
set more off
cap log close

********************************************************************************
*** (1) globals locals
********************************************************************************
global BAS /media/ubuntu/Impar
global DAT $BAS/database/MinSal/Identified
global OUT $BAS/investigacion/2016/healthChile/results/trends

cap mkdir $OUT

********************************************************************************
*** (1) globals locals
********************************************************************************
insheet using "$DAT/nac 1992 a 2010.txt", delimit("|") clear names

replace peso=. if peso<500|peso>5000
drop if edad_m<10&edad_m>=50
keep if ano_nac>=1992&ano_nac<=2012
keep if mes_nac>=1&mes_nac<=12
gen time = ano_nac + ((mes_nac-1)/12)
exit
preserve
collapse peso edad_m, by(time)

