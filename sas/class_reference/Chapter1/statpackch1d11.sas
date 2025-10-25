data ch1d10;
   input EmployeeId $ (Q1-Q4) ($1.,+1);
   datalines;
2355 S O O S                                                                                                                            
5889 2 . 2 2                                                                                                                            
3878 C E E E                                                                                                                            
4409 0 1 1 1                                                                                                                            
3985 3 3 3 2                                                                                                                            
0740 S E E S                                                                                                                            
2398 E E   C                                                                                                                            
5162 C C C E                                                                                                                            
4421 3 2 2 2                                                                                                                            
7385 C C C N
run;
proc print; run;
