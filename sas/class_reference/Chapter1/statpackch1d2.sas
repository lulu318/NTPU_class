data ch1d2;
informat Tdate mmddyy10. Tamount  comma8.2;   /*這個設定過一次就不用ㄌ*/
input ID 1-6   @13 Tdate @29 Tamount ;
/*一個@是位置的部分*/
cards;   
124325      08/10/2003      1,250.03                                                                                                     
7           08/11/2003      12,500.02                                                                                                    
114565      08/11/2003      5.11                                                                                                                                
run;  
/*這個看起來雖然沒有對準 但是如果把它貼到程式編輯器就會是對其的
程式編輯器：顯示-> 程式編輯器*/
proc print; 
format tdate date9. tamount dollar10.2;
/*格式的目的 就是輸出資料呈現的方式*/
run;

/*0908小總結*/
/*輸入的部分可以有文字的*/
/*可以有不同的數值格式的*/
/*日期的部分*/
