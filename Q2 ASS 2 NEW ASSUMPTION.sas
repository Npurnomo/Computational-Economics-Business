OPTIONS nocenter ;
*	Leslie1.sas										  ;
*----------------------------LESLIE--------------------------------*
*	      Leslie3_population_projection.sas					  *
*  USE THE LESLIE, OR AGE COHORT METHOD TO FORECAST THE Austraian  *
*  POPULATION.  THE LESLIE TRANSITION MATRIX IS FORMED FROM        *
*  THE BIRTH AND SURVIVAL RATES FOR EACH 5 YEAR AGE GROUP.         *
*   AGING THE POPULATION IS JUST MULTIPLYING THE POPULATION        *
*   BY THE LESLIE MATRIX.                                          *
*------------------------------------------------------------------*;
TITLE 'FEMALE POPULATION FORECASTING BY THE LESLIE MODEL';

	PROC IML ;

*
  Using the data for 2006 we first construct the vector of survival
;
	Mort ={ 0.00037 3.35E-05 3.28E-05 0.000119 0.000167 0.000163 0.000218
		0.000269 0.000401 0.00062 0.000903 0.001362 0.00216 0.00372
		0.006246 0.011512 0.020199 0.044852} ; 
	
  	SURVIVE = j(1,18,1) - ( 5#mort ) ;

PRINT 'SURVIVAL RATES FOR EVERY 5 YEAR AGE GROUP', SURVIVE  ;
*
	Fertility rates are defined below for daughters from overall fertilty
;
	fert = {15.3  51.4   101.0   120.4   63.4   11.3   0.6 } ; 

	birth = j(1,3,0) || (fert#5/1000)  || j(1,8,0) ; 
	birth = birth / 2 ;   * assume half are girls ; 
	
PRINT 'BIRTH RATES FOR EACH 5 YEAR AGE GROUP', BIRTH ;

	pop = {1333340 1341486 1400485 1440281 1494136 1444461 1468213 1564979
		1520046 1521896 1387160 1269078 1064370 807604 646297 552211
		414864 344135}` ;
	POP = POP / 2 ;  * Assume the same age distribution for females is half total ;

PRINT 'Australian 2006 FEMALE POPULATION IN MILLIONS',
      'BY 5 YEAR AGE GROUPS', POP;

*
	  MIGRATION
;
	  mig = J(18,1,15381.29); *This is the average of each age group over 5 years 
	  								interval from Migration data;
	  mig = (mig#5)/2;     			*5 years interval and assume women only;
	  mig = mig/sum(POP); 			*divide by total population fo find rate;
	  multi = 1; 
	  mig = mig # multi ;

	  print mig;

* CONSTRUCT THE LESLIE TRANSITION MATRIX;
	T =       BIRTH    //
    (DIAG(SURVIVE[1,1:17]) || J(17,1,0));
	T = DIAG(mig) + T;
  	
	PRINT 'LESLIE TRANSITION MATRIX', T [ FORMAT = 4.3 ] ;
 
*
   PROJECT THE FEMALE POPULATION FOR THE 100 YEARS FROM 2006 TO 2106
;
	FREE YEAR PT ; 
	POPYR = POP ; 
     DO YR = 2006 TO 2106 BY 5 ;
       POPYR = T * POPYR ;
       PT = PT // (POPYR ` || SUM(POPYR)) ;
	  YEAR = YEAR // YR ;
     END;
   XYT = YEAR || PT ;
     
   names = {'year' 'Age_0_4' 'Age_5_9' 'Age_10_14' 'Age_15_19' 'Age_20_24' 'Age_25_29'
		'Age_30_34' 'Age_35_39' 'Age_40_44' 'Age_45_49' 'Age_50_54' 'Age_55_59' 
		'Age_60_64' 'Age_65_69' 'Age_70_74' 'Age_75_79' 'Age_80_84' 'Age_85_p' 'total'} ;

*-----------------------------------------------------------------------;

     create result from xyt [colname=names] ; * Define the output data set ; 
	append from xyt ;  * Write out the matrix of results ; 
	
	quit; 
	run; 
*
	To compute the ratio of the working to retired
;
	data result ; set result ;
	total = sum(of Age_0_4--age_85_p) ; 
	working = sum(of age_20_24--age_60_64) ; 
	retired = sum(of age_65_69--age_85_p) ; 
	ratio = working/retired ; 
	label 
	ratio = "working to retired population" ; 
	run;  
*
	Plot the working and retired population and their ratio on the same plot
;
	proc sgplot data=result ; 
	series y=ratio x=year/y2axis ;
	series y=working x=year ;
	series y=retired x=year ; 
	xaxis values=(2006 TO 2101 BY 5) ; 
	yaxis label="Population" ;
	y2axis label="Working/Retired" ; 
	run; 

	
