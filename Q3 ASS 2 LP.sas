options nocenter ;
*	This program is based on LP_example2.sas 
	Nico Purnomo 

;

	Title Q3 ASS 2 ;

	proc iml;
*
	Define cost source as 2 types of workers
;
	a_names={'High Skilled' 'Low Skilled'};
*
	Define the 3 constraints 
; 
	c_names = {'Glass' 'Rubber' 'Minimum Low Skillled Workers'};

*
	Define the linear objective function as the cost of paying a combination of low skilled 
	& high skilled workers 
; 
	c = {8 4} ; 

	print c[c=a_names l={'Objective Function'}] ;
*
	Define the constraint matrix for the minimum rubber produced, glass produced and regulation.
;
	a =  { 1 1 ,
           1 1 ,
           0 1};

	b =  { 1 4 ,
           1 1 ,
           1 1};
	A = a/b; 

	print A;
	n=nrow(A);                            /* number of variables */
*
	Define the limits for the constraints as to how many units are needed
	for each constraint
;
      b = {20, 30, 10} ;
*
     Define the direction of the constraints
	operators: 'L' for <=, 'G' for >=, 'E' for =       
;
	 ops = j(n,1,'G') ; 			* all directions are >= ; 

	print a[R=c_names C=a_names L={'Constraint matrix'}] ops[C={'Type'}] b[C={'limit'}];

	cntl = j(1,7,.);            * control vector ;
	cntl[1] = 1;                * 1 for minimum; 
*
	Call the linear programming routine - specify a minimum to be found
;
	call lpsolve(rc, value, x, dual, redcost,
             c, A, b, cntl, ops);

	if rc = 0 then do ; 

		print "************************************************", "Results"; 

		print value[L='Minimum Cost'];
		print 'Number of Workers' (sum(x)) ; 
		print x[r=a_names L='Optimal Workers'];
		print 'Reduced cost' redcost;
	
		lhs = A*x;
		print lhs [R=c_names C={'Numbers' } L={'Limits'}] ops[C={'Direction'}] b[C={'Minimun'}];
		end ; 

	else  print 'Solution not found return code = ' rc ; 
	
	quit; 
	run; 
