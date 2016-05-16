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
drop if edad_m<10|edad_m>=50
keep if ano_nac>=1992&ano_nac<=2012
keep if mes_nac>=1&mes_nac<=12
gen time = ano_nac + ((mes_nac-1)/12)
gen decade = floor(edad_m/10)
gen underweight = peso<2500

preserve
collapse peso underweight edad_m, by(time)
line peso time, lcolor(black) lwidth(thick) yaxis(1) || /*
*/ line edad_m time, yaxis(2) scheme(s1mono) lcolor(black) lpattern(dash)
graph export $OUT/pesoAge.eps, as(eps) replace
line underweight time, lcolor(black) lwidth(thick) yaxis(1) || /*
*/ line edad_m time, yaxis(2) scheme(s1mono) lcolor(black) lpattern(dash)
graph export $OUT/underweightAge.eps, as(eps) replace
restore

preserve
collapse peso underweight, by(time decade)
foreach var of varlist peso underweight {
	twoway line `var' time if decade==1, lcolor(black) /*
	*/ ||  line `var' time if decade==2, lcolor(red) /*
	*/ ||  line `var' time if decade==3, lcolor(blue) /*
	*/ ||  line `var' time if decade==4, lcolor(black) lpattern(dash) scheme(s1mono)
	graph export $OUT/`var'Decades.eps, as(eps) replace

	foreach num of numlist 1(1)4 {
		line `var' time if decade==`num', scheme(s1mono) lcolor(black)
		graph export $OUT/`var'Decade`num'.eps, as(eps) replace
	}
}
restore

areg peso, abs(edad_m)
predict pesoResid, resid
reg underweight i.edad_m
predict underweightResid, resid
preserve
collapse peso pesoResid underw* edad_m, by(ano_nac)
foreach var of varlist peso underweight {
	line `var' ano_nac, lcolor(black) lwidth(thick) scheme(s1mono) lcolor(black)
	graph export $OUT/`var'Year.eps, as(eps) replace
	line `var'Resid ano_nac, lcolor(black) lwidth(thick) scheme(s1mono) lcolor(black)
	graph export $OUT/`var'ResidYear.eps, as(eps) replace
}
restore

