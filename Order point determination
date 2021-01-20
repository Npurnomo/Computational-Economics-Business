Title Order point determination ;
		
data inven;
r_p = 30;
	do o_s = 5 to 30 by 5; 
		do it = 1 to 1000; *Re run the model a number of times;
	   	 	nday = 30 ; * Number of days considered ;
			inv = 50  ; * starting inventory ;
      		inv_p=50 ; * Inventory position ;
		do ii = 1 to nday ;
			b_inv = inv;  *Beginning of the day inventory; 
			if ii= or_time then inv = inv + o_s; *if day of the orders arrive from suppliers;

		demand = rantbl (9897653, .01, .02, .04, .06, .09, .14, .18, .22, .16, .06, .02) - 1;

*Sell the demanded items where there is sufficient inventory or all invesntory;

		if demand <= inv then sales = demand; else sales = inv;

*Define Unment sales as the absolute value of the difference between demand and sales;
			unmet_d = abs(sales-demand);
*Remove the items from inventory;
			Inv = inv-sales;

*Remove items from inventory position;
			inv_p = inv_p - sales ;

 * When inventory goes below reorder point determine when order will arrive.
 Add the new items to the inventory position immeadiately
Note the new items cannot be stocked for one day;

 				if inv_p <= r_p then do;
				 or_time = ii + rantbl(9897653,.2,.6,.2) + 3 ;
				 inv_p = inv_p + o_s ;
				 
				 end;
 output ;
 		end;
 	end; * end of daily loop ;
 end; * end of iteration loop ;

	label
	ii = day of month
	r_p = Order Point
	nday = Total Number of Days
	inv = Inventory at end of day
	b_inv = Inventory at beginning of day
	demand = # of Demand
	sales = # sold
	unmet_d = Unmet demand
	inv_p = Inventory Position;
	run;
   
	
	
data inven ; set inven ;
   numberoforder = (inv<=30) ;

proc summary data= inven; by o_s it; var inv sales demand unmet_d numberoforder inv_p;
output out=inv_tot sum= ; run;

proc print data = inv_tot;

data inv_tot; set inv_tot ;
serv_lev = sales / demand ; 
label
serv_lev = Service level;

ods graphics off; title 'Box Plot for Inventory Position';
proc boxplot data=inv_tot; 
plot inv_p*o_s ;
insetgroup mean stddev /pos=topoff 
header = 'Statistics by Order Point';
run;

ods graphics off; 
title 'Box Plot for service level'; 
proc boxplot data=inv_tot; 
plot serv_lev*o_s ; 
insetgroup mean stddev /pos=topoff
header = 'Statistics by Order Point';
run;

ods graphics off; title 'Box Plot for Number of Order';
proc boxplot data=inv_tot; 
plot numberoforder*o_s ;
insetgroup mean stddev /pos=topoff 
header = 'Statistics by Order Point';
run;
