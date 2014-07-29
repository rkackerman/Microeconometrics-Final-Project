**** ECON 873 ************************************************************************************
**** Spring 2014 *********************************************************************************
**** Robert Ackerman *****************************************************************************
**** Final Project********************************************************************************
**** Usig the American Community Survey to Explore the Employment-to-Population Ratio ************
**** Puzzle of the Great Recession ***************************************************************

**** Initial Settings ****

clear
clear matrix
capture cd "/Users/robertackerman/Desktop/School/Econ 873"
* log using "Econ873_Final_Project_Ackerman_v2.log", replace

*load 2011 ACS Data
use ACS_2001_2012.dta
set more off


**** employment ****
gen employed = 0
replace employed=1 if empstat==1

**** educational attainment ****
 replace educd=. if educd==1
gen educatt=.
label var educatt "Educational Attainment"
replace educatt=1 if educd<=100
replace educatt=2 if educd==101
replace educatt=3 if educd>101
label define educatt_lbl 1 `"Less Than Bachelors"'
label define educatt_lbl 2 `"Bachelors"', add
label define educatt_lbl 3 `"More Than Bachelors"', add
label values educatt educatt_lbl

gen educattd=.
label var educattd "Educational Attainment-Detailed"
replace educattd=1 if educd<=61
replace educattd=2 if educd==62 | educd==63 | educd==64
replace educattd=3 if educd==65 | educd==71
replace educattd=4 if educd==81 | educd==82 | educd==83
replace educattd=5 if educd==101
replace educattd=6 if educd==114
replace educattd=7 if educd==115
replace educattd=8 if educd==116
label define educattd_lbl 1 `"Less Than High School"'
label define educattd_lbl 2 `"High School"', add
label define educattd_lbl 3 `"Some College"', add
label define educattd_lbl 4 `"Associates Degree"', add
label define educattd_lbl 5 `"Bachelors Degree"', add
label define educattd_lbl 6 `"Masters Degree"', add
label define educattd_lbl 7 `"Professional Degree"', add
label define educattd_lbl 8 `"Doctoral Degree"', add
label values educattd educattd_lbl

**** race/ethnicity ****
gen racesimp=.
label var racesimp "Race/Ethnicity Simplified Version"
replace racesimp=1 if hispan==0 & race==1
replace racesimp=2 if hispan==0 & race==2
replace racesimp=4 if hispan==0 & race==4 | race==5 | race==6
replace racesimp=5 if hispan==0 & race==3 | race==7 | race==8 | race==9
replace racesimp=3 if hispan!=0
label define racesimp_lbl 1 `"White"'
label define racesimp_lbl 2 `"Black"', add
label define racesimp_lbl 3 `"Hispanic or Latino"', add
label define racesimp_lbl 4 `"Asian or Pacific Islander"', add
label define racesimp_lbl 5 `"Other Race"', add
label values racesimp racesimp_lbl 

gen white = 0
replace white = 1 if racesimp==1
gen black = 0
replace black = 1 if racesimp==2
gen hispanic = 0
replace hispanic = 1 if racesimp==3
gen asian = 0
replace asian = 1 if racesimp==4
gen other = 0
replace other = 1 if racesimp==5

**** gender ****
gen female=0
replace female=1 if sex==2

**** married ****
gen married=.
replace married=1 if marst==1 | marst==2
replace married=0 if marst==3 | marst==4 | marst==5 | marst==6

**** kids ****
gen kids=0
replace kids=1 if nchild>=1

gen kidslt5=0
replace kidslt5=1 if nchlt5>=1

**** educ attainment indicators ****

*required education variable 2
gen educattd3=.
label var educattd3 "Educational Attainment-Detailed Version 3"
replace educattd3=1 if educattd==1 | educattd==2
replace educattd3=2 if educattd==3 | educattd==4
replace educattd3=3 if educattd==5
replace educattd3=4 if educattd==6 |educattd==7 | educattd==8
label define educattd3_lbl 1 `"High School or Less"'
label define educattd3_lbl 2 `"Some College"', add
label define educattd3_lbl 3 `"Bachelors"', add
label define educattd3_lbl 4 `"More Than Bachelors"', add
label values educattd3 educattd3_lbl

gen highschoolorless=.
replace highschoolorless=0 if educattd3!=.
replace highschoolorless=1 if educattd3==1 
gen somecollege=.
replace somecollege=0 if educattd3!=.
replace somecollege=1 if educattd3==2
gen college=.
replace college=0 if educattd3!=.
replace college=1 if educattd3==3
gen morecollege=.
replace morecollege=0 if educattd3!=.
replace morecollege=1 if educattd3==4

**** ages ****

tab age, gen (age)


**** unemployed ****
gen unemployed=.
replace unemployed = 1 if 
**** table 1 ****
mean female, over(year)
mean white, over(year)
mean black, over(year)
mean hispanic, over(year)
mean asian, over(year)
mean other, over(year)
mean age, over(year)
mean married, over(year)
mean nchild if age>=25, over(year)
mean incwage if age>16 & employed==1
mean highschoolorless if age>=25, over(year)
mean somecollege if age>=25, over(year)
mean college if age>=25, over(year)
mean morecollege if age>=25, over(year)
count if year==2008
count if year==2009
count if year==2010
count if year==2011
count if year==2012


**** 2012 *****

clear
clear matrix
set matsize 11000
capture cd "/Users/robertackerman/Desktop/School/Econ 873"
* log using "Econ873_Final_Project_Ackerman_v2.log", replace

*load 2011 ACS Data
use ACS_2001_2012.dta
set more off

** drop other years***
drop if year==2009 | year==2010 | year==2011
drop datanum serial hhwt gq pernum nchild nchlt5 sex marst birthyr race raced hispan hispand educ educd empstat empstatd occ1990 incwage educatt educattd racesimp dummy2011 dummy2010 dummy2009 educattd3

** 2008 OLS Alt **
reg employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2008 & age>=16

predict ols2008
su ols2008 if age>=16 & year==2008

** 2008 Probit Alt ***
probit employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2008 & age>=16

predict probit2008
su probit2008 if age>=16 & year==2008
estat classification

** 2012 OLS **
reg employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2012 & age>=16

predict ols2012
su ols2012 if age>=16 & year==2012

** 2012 Probit **
probit employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2012 & age>=16

predict probit2012
su probit2012 if age>=16 & year==2012
estat classification

** 2012 OB linear Alt **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if age>=16, by(dummy2012) omega


** 2012 OB probit Alt **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if age>=16, by(dummy2012) probit omega

**** 2011 ****
clear
clear matrix
set matsize 11000
capture cd "/Users/robertackerman/Desktop/School/Econ 873"
* log using "Econ873_Final_Project_Ackerman_v2.log", replace

*load 2011 ACS Data
use ACS_2001_2012.dta
set more off

** drop other years***
drop if year==2009 | year==2010 | year==2012
drop datanum serial hhwt gq pernum nchild nchlt5 sex marst birthyr race raced hispan hispand educ educd empstat empstatd occ1990 incwage educatt educattd racesimp dummy2012 dummy2010 dummy2009 educattd3

** 2011 OLS **
reg employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2011 & age>=16

predict ols2011
su ols2011 if age>=16 & year==2011

** 2011 Probit **
probit employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2011 & age>=16

predict probit2011
su probit2011 if age>=16 & year==2011
estat classification

** 2011 OB linear Alt **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if age>=16, by(dummy2011) omega


** 2011 OB probit Alt **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if age>=16, by(dummy2011) probit omega

**** 2010 ****
clear
clear matrix
set matsize 11000
capture cd "/Users/robertackerman/Desktop/School/Econ 873"
* log using "Econ873_Final_Project_Ackerman_v2.log", replace

*load 2011 ACS Data
use ACS_2001_2012.dta
set more off

** drop other years***
drop if year==2009 | year==2011 | year==2012
drop datanum serial hhwt gq pernum nchild nchlt5 sex marst birthyr race raced hispan hispand educ educd empstat empstatd occ1990 incwage educatt educattd racesimp dummy2012 dummy2011 dummy2009 educattd3

** 2010 OLS **
reg employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2010 & age>=16

predict ols2010
su ols2010 if age>=16 & year==2010

** 2010 Probit **
probit employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2010 & age>=16

predict probit2010
su probit2010 if age>=16 & year==2010
estat classification

** 2010 OB linear Alt **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if age>=16, by(dummy2010) omega


** 2010 OB probit Alt **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if age>=16, by(dummy2010) probit omega

**** 2009 ****
clear
clear matrix
set matsize 11000
capture cd "/Users/robertackerman/Desktop/School/Econ 873"
* log using "Econ873_Final_Project_Ackerman_v2.log", replace

*load 2011 ACS Data
use ACS_2001_2012.dta
set more off

** drop other years***
drop if year==2010 | year==2011 | year==2012
drop datanum serial hhwt gq pernum nchild nchlt5 sex marst birthyr race raced hispan hispand educ educd empstat empstatd occ1990 incwage educatt educattd racesimp dummy2012 dummy2011 dummy2010 educattd3

** 2009 OLS **
reg employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2009 & age>=16

predict ols2009
su ols2009 if age>=16 & year==2009

** 2009 Probit **
probit employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if year==2009 & age>=16

predict probit2009
su probit2009 if age>=16 & year==2009
estat classification

** 2009 OB linear Alt **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if age>=16, by(dummy2009) omega


** 2009 OB probit Alt **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege twenties thirties forties fifties age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 seventies eighties nineties regionS regionMW regionW if age>=16, by(dummy2009) probit omega

** states **
replace stateicp=. if stateicp==99

/* gen state1=0
label var state1 "Connecticut"
replace state1=1 if stateicp==1 

gen state2=0
label var state2 "Maine"
replace state2=1 if stateicp==2

gen state3=0
label var state3 "Massachusetts"
replace state3=1 if stateicp==3

gen state4=0
label var state4 "New Hampshire"
replace state4=1 if stateicp==4

gen state5=0
label var state5 "Rhode Island"
replace state5=1 if stateicp==5

gen state6=0
label var state6 "Vermont"
replace state6=1 if stateicp==6

gen state7=0
label var state7 "Delaware"
replace state7=1 if stateicp==11

gen state8=0
label var state8 "New Jersey"
replace state8=1 if stateicp==12

gen state9=0
label var state9 "New York"
replace state9=1 if stateicp==13

gen state10=0
label var state10 "Pennsylvania"
replace state10=1 if stateicp==14

gen state11=0
label var state11 "Illinois"
replace state11=1 if stateicp==21

gen state12=0
label var state12 "Indiana"
replace state12=1 if stateicp==22

gen state13=0
label var state13 "Michigan"
replace state13=1 if stateicp==23

gen state14=0
label var state14 "Ohio"
replace state14=1 if stateicp==24

gen state15=0
label var state15 "Wisconsin"
replace state15=1 if stateicp==25

gen state16=0
label var state16 "Iowa"
replace state16=1 if stateicp==31

gen state17=0
label var state17 "Kansas"
replace state17=1 if stateicp==32

gen state18=0
label var state18 "Minnesota"
replace state18=1 if stateicp==33

gen state19=0
label var state19 "Missouri"
replace state19=1 if stateicp==34

gen state20=0
label var state20 "Nebraska"
replace state20=1 if stateicp==35

gen state21=0
label var state21 "North Dakota"
replace state21=1 if stateicp==36

gen state22=0
label var state22 "South Dakota"
replace state22=1 if stateicp==37

gen state23=0
label var state23 "Virginia"
replace state23=1 if stateicp==40

gen state24=0
label var state24 "Alabama"
replace state24=1 if stateicp==41

gen state25=0
label var state25 "Arkansas"
replace state25=1 if stateicp==42

gen state26=0
label var state26 "Florida"
replace state26=1 if stateicp==43

gen state27=0
label var state27 "Georgia"
replace state27=1 if stateicp==44

gen state28=0
label var state28 "Louisiana"
replace state28=1 if stateicp==45

gen state29=0
label var state29 "Mississippi"
replace state29=1 if stateicp==46

gen state30=0
label var state30 "North Carolina"
replace state30=1 if stateicp==47

gen state31=0
label var state31 "South Carolina"
replace state31=1 if stateicp==48

gen state32=0
label var state32 "Texas"
replace state32=1 if stateicp==49

gen state33=0
label var state33 "Kentucky"
replace state33=1 if stateicp==51

gen state34=0
label var state34 "Maryland"
replace state34=1 if stateicp==52

gen state35=0
label var state35 "Oklahoma"
replace state35=1 if stateicp==53

gen state36=0
label var state36 "Tennessee"
replace state36=1 if stateicp==54

gen state37=0
label var state37 "West Virginia"
replace state37=1 if stateicp==56

gen state38=0
label var state38 "Arizona"
replace state38=1 if stateicp==61

gen state39=0
label var state39 "Colorado"
replace state39=1 if stateicp==62

gen state40=0
label var state40 "Idaho"
replace state40=1 if stateicp==63

gen state41=0
label var state41 "Montana"
replace state41=1 if stateicp==64

gen state42=0
label var state42 "Nevada"
replace state42=1 if stateicp==65

gen state43=0
label var state43 "New Mexico"
replace state43=1 if stateicp==66

gen state44=0
label var state44 "Utah"
replace state44=1 if stateicp==67

gen state45=0
label var state45 "Wyoming"
replace state45=1 if stateicp==68

gen state46=0
label var state46 "California"
replace state46=1 if stateicp==71

gen state47=0
label var state47 "Oregon"
replace state47=1 if stateicp==72

gen state48=0
label var state48 "Washington"
replace state48=1 if stateicp==73

gen state49=0
label var state49 "Alaska"
replace state49=1 if stateicp==81

gen state50=0
label var state50 "Hawaii"
replace state50=1 if stateicp==82

gen state51=0
label var state51 "District of Columbia"
replace state51=1 if stateicp==98 */

** ages **

tab age, gen (age)


** ages alt 1 **
gen teens=0
replace teens=1 if age>=16 & age<=19
gen twenties=0
replace twenties=1 if age>=20 & age<=29
gen thirties=0
replace thirties=1 if age>=30 & age<=39
gen forties=0
replace forties=1 if age>=40 & age<=49
gen fifties=0
replace fifties=1 if age>=50 & age<=59
gen sixties=0
replace sixties=1 if age>=60 & age<=69
gen seventies=0
replace seventies=1 if age>=70 & age<=79
gen eighties=0
replace eighties=1 if age>=80 & age<=89
gen nineties=0
replace nineties=1 if age>=90 & age<=99

** ages alt 2 **
gen teens=0
replace teens=1 if age>=16 & age<=19
gen twenties=0
replace twenties=1 if age>=20 & age<=29
gen thirties=0
replace thirties=1 if age>=30 & age<=39
gen forties=0
replace forties=1 if age>=40 & age<=49
gen fifties=0
replace fifties=1 if age>=50 & age<=59
gen seventies=0
replace seventies=1 if age>=70 & age<=79
gen eighties=0
replace eighties=1 if age>=80 & age<=89
gen nineties=0
replace nineties=1 if age>=90 & age<=99

gen age60=0
replace age60=1 if age==60
gen age61=0
replace age61=1 if age==61
gen age62=0
replace age62=1 if age==62
gen age63=0
replace age63=1 if age==63
gen age64=0
replace age64=1 if age==64
gen age65=0
replace age65=1 if age==65
gen age66=0
replace age66=1 if age==66
gen age67=0
replace age67=1 if age==67
gen age68=0
replace age68=1 if age==68
gen age69=0
replace age69=1 if age==69

** regions ** 
replace stateicp=. if stateicp==99

gen regionNE = .
replace regionNE=0 if stateicp==21 | stateicp==22 | stateicp==23 | stateicp==24 | stateicp==25 | stateicp==31 | stateicp==32 | stateicp==33 | stateicp==34 | stateicp==35 | stateicp==36 | stateicp==37 | stateicp==11 | stateicp==40 | stateicp==98 | stateicp==41  | stateicp==42 | stateicp==43 | stateicp==44 | stateicp==45 | stateicp==46 | stateicp==47 | stateicp==48 | stateicp==49 | stateicp==51 | stateicp==52 | stateicp==53 | stateicp==54 | stateicp==56 | stateicp==61 | stateicp==62 | stateicp==63 | stateicp==64 | stateicp==65 | stateicp==66 | stateicp==67 | stateicp==68 | stateicp==71 | stateicp==72 | stateicp==73 | stateicp==81 | stateicp==82

replace regionNE=1 if stateicp==1 | stateicp==2 | stateicp==3 | stateicp==4 | stateicp==5 | stateicp==6 | stateicp==12 | stateicp==13 | stateicp==14

gen regionS=.
replace regionS=0 if stateicp==21 | stateicp==22 | stateicp==23 | stateicp==24 | stateicp==25 | stateicp==31 | stateicp==32 | stateicp==33 | stateicp==34 | stateicp==35 | stateicp==36 | stateicp==37 | stateicp==1 | stateicp==2 | stateicp==3 | stateicp==4 | stateicp==5 | stateicp==6 | stateicp==12 | stateicp==13 | stateicp==14  | stateicp==61 | stateicp==62 | stateicp==63 | stateicp==64 | stateicp==65 | stateicp==66 | stateicp==67 | stateicp==68 | stateicp==71 | stateicp==72 | stateicp==73 | stateicp==81 | stateicp==82

replace regionS=1 if stateicp==11 | stateicp==40 | stateicp==98 | stateicp==41  | stateicp==42 | stateicp==43 | stateicp==44 | stateicp==45 | stateicp==46 | stateicp==47 | stateicp==48 | stateicp==49 | stateicp==51 | stateicp==52 | stateicp==53 | stateicp==54 | stateicp==56

gen regionMW=.
replace regionMW=0 if stateicp==1 | stateicp==2 | stateicp==3 | stateicp==4 | stateicp==5 | stateicp==6 | stateicp==12 | stateicp==13 | stateicp==14 | stateicp==11 | stateicp==40 | stateicp==98 | stateicp==41  | stateicp==42 | stateicp==43 | stateicp==44 | stateicp==45 | stateicp==46 | stateicp==47 | stateicp==48 | stateicp==49 | stateicp==51 | stateicp==52 | stateicp==53 | stateicp==54 | stateicp==56 | stateicp==61 | stateicp==62 | stateicp==63 | stateicp==64 | stateicp==65 | stateicp==66 | stateicp==67 | stateicp==68 | stateicp==71 | stateicp==72 | stateicp==73 | stateicp==81 | stateicp==82

replace regionMW=1 if stateicp==21 | stateicp==22 | stateicp==23 | stateicp==24 | stateicp==25 | stateicp==31 | stateicp==32 | stateicp==33 | stateicp==34 | stateicp==35 | stateicp==36 | stateicp==37 

gen regionW=.
replace regionW=0 if stateicp==21 | stateicp==22 | stateicp==23 | stateicp==24 | stateicp==25 | stateicp==31 | stateicp==32 | stateicp==33 | stateicp==34 | stateicp==35 | stateicp==36 | stateicp==37 | stateicp==11 | stateicp==40 | stateicp==98 | stateicp==41  | stateicp==42 | stateicp==43 | stateicp==44 | stateicp==45 | stateicp==46 | stateicp==47 | stateicp==48 | stateicp==49 | stateicp==51 | stateicp==52 | stateicp==53 | stateicp==54 | stateicp==56 | stateicp==1 | stateicp==2 | stateicp==3 | stateicp==4 | stateicp==5 | stateicp==6 | stateicp==12 | stateicp==13 | stateicp==14

replace regionW=1 if stateicp==61 | stateicp==62 | stateicp==63 | stateicp==64 | stateicp==65 | stateicp==66 | stateicp==67 | stateicp==68 | stateicp==71 | stateicp==72 | stateicp==73 | stateicp==81 | stateicp==82
 
 
 ** 2008 OLS Full **
reg employed female married kids kidslt5 black hispanic asian other somecollege college morecollege age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 age57 age58 age59 age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 age70 age71 age72 age73 age74 age75 age76 age77 age78 age79 age80 age81 age82 age83 age84 age85 age86 age87 age88 age89 age90 age91 age92 age93 age94 age95 age96 state1 state2 state3 state4 state5 state6 state7 state8 state9 state10 state11 state12 state13 state14 state15 state16 state17 state18 state19 state20 state21 state22 state23 state24 state25 state26 state27 state28 state29 state30 state31 state32 state33 state34 state35 state36 state37 state38 state39 state40 state41 state42 state43 state44 state45 state46 state47 state48 state49 state50 if year==2008 & age>=16

predict ols2008

** 2008 Probit Full **
probit employed female married kids kidslt5 black hispanic asian other somecollege college morecollege age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 age57 age58 age59 age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 age70 age71 age72 age73 age74 age75 age76 age77 age78 age79 age80 age81 age82 age83 age84 age85 age86 age87 age88 age89 age90 age91 age92 age93 age94 age95 age96 state1 state2 state3 state4 state5 state6 state7 state8 state9 state10 state11 state12 state13 state14 state15 state16 state17 state18 state19 state20 state21 state22 state23 state24 state25 state26 state27 state28 state29 state30 state31 state32 state33 state34 state35 state36 state37 state38 state39 state40 state41 state42 state43 state44 state45 state46 state47 state48 state49 state50 if year==2008 & age>=16 

predict probit2008
estat classification

** 2012 OLS **
reg employed female married kids kidslt5 black hispanic asian other somecollege college morecollege age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 age57 age58 age59 age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 age70 age71 age72 age73 age74 age75 age76 age77 age78 age79 age80 age81 age82 age83 age84 age85 age86 age87 age88 age89 age90 age91 age92 age93 age94 age95 age96 state1 state2 state3 state4 state5 state6 state7 state8 state9 state10 state11 state12 state13 state14 state15 state16 state17 state18 state19 state20 state21 state22 state23 state24 state25 state26 state27 state28 state29 state30 state31 state32 state33 state34 state35 state36 state37 state38 state39 state40 state41 state42 state43 state44 state45 state46 state47 state48 state49 state50 if year==2012 & age>=16

predict ols2012

** 2012 Probit **
probit employed female married kids kidslt5 black hispanic asian other somecollege college morecollege age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 age57 age58 age59 age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 age70 age71 age72 age73 age74 age75 age76 age77 age78 age79 age80 age81 age82 age83 age84 age85 age86 age87 age88 age89 age90 age91 age92 age93 age94 age95 age96 state1 state2 state3 state4 state5 state6 state7 state8 state9 state10 state11 state12 state13 state14 state15 state16 state17 state18 state19 state20 state21 state22 state23 state24 state25 state26 state27 state28 state29 state30 state31 state32 state33 state34 state35 state36 state37 state38 state39 state40 state41 state42 state43 state44 state45 state46 state47 state48 state49 state50 if year==2012 & age>=16 

predict probit2012
estat classification

** 2012 OB linear Full **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 age57 age58 age59 age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 age70 age71 age72 age73 age74 age75 age76 age77 age78 age79 age80 age81 age82 age83 age84 age85 age86 age87 age88 age89 age90 age91 age92 age93 age94 age95 age96 state1 state2 state3 state4 state5 state6 state7 state8 state9 state10 state11 state12 state13 state14 state15 state16 state17 state18 state19 state20 state21 state22 state23 state24 state25 state26 state27 state28 state29 state30 state31 state32 state33 state34 state35 state36 state37 state38 state39 state40 state41 state42 state43 state44 state45 state46 state47 state48 state49 state50 if age>=16, by(dummy2012) vce(robust) omega

** 2012 OB Probit Full **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 age57 age58 age59 age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 age70 age71 age72 age73 age74 age75 age76 age77 age78 age79 age80 age81 age82 age83 age84 age85 age86 age87 age88 age89 age90 age91 age92 age93 age94 age95 age96 state1 state2 state3 state4 state5 state6 state7 state8 state9 state10 state11 state12 state13 state14 state15 state16 state17 state18 state19 state20 state21 state22 state23 state24 state25 state26 state27 state28 state29 state30 state31 state32 state33 state34 state35 state36 state37 state38 state39 state40 state41 state42 state43 state44 state45 state46 state47 state48 state49 state50 if age>=16, by(dummy2012) vce(robust) probit omega

** 2012 OB probit Full **
oaxaca employed female married kids kidslt5 black hispanic asian other somecollege college morecollege age18 age19 age20 age21 age22 age23 age24 age25 age26 age27 age28 age29 age30 age31 age32 age33 age34 age35 age36 age37 age38 age39 age40 age41 age42 age43 age44 age45 age46 age47 age48 age49 age50 age51 age52 age53 age54 age55 age56 age57 age58 age59 age60 age61 age62 age63 age64 age65 age66 age67 age68 age69 age70 age71 age72 age73 age74 age75 age76 age77 age78 age79 age80 age81 age82 age83 age84 age85 age86 age87 age88 age89 age90 age91 age92 age93 age94 age95 age96 state1 state2 state3 state4 state5 state6 state7 state8 state9 state10 state11 state12 state13 state14 state15 state16 state17 state18 state19 state20 state21 state22 state23 state24 state25 state26 state27 state28 state29 state30 state31 state32 state33 state34 state35 state36 state37 state38 state39 state40 state41 state42 state43 state44 state45 state46 state47 state48 state49 state50 if age>=16, by(dummy2012) vce(robust) probit omega
