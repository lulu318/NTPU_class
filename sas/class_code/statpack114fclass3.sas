%let dirclass = C:\Users\hwang\Dropbox\School\statpack\114fall\practice;


data class3a;
Infile "&dirclass\statpack114fclass3a.txt";
   input customer 7-14 
    state $ 15-16 
    zipcode 17-21 
    country $ 22-41 
    tel_no $ 42-53 
    name $ 54-107;
run;

data class3b;
infile "&dirclass\statpack114fclass3b.txt" missover;
input order_num $ 7-11 
      cust_id $12-19 
	  amount 20-32 region $ 33-41 
      prepay 42-52 emp_id $ 53-58 
      @59 bill_date date9. 
      @68 due_date date9.;
run;
data class3c;
Infile "&dirclass\statpackch1d4.dat";
input #1 id $ 1-4 lastname $ 9-19 firstname $ 20-29
	     city $ 30-42 state $ 43-44 
        #2 sex $ 1-1 jobcode $9-11 @20 salary 
            @30 bdy date7. @43 hiredate date7. 
             homephone $ 54-65;
run;
