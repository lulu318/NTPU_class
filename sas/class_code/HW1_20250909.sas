ods pdf file="Z:\sas\HW1\HW1_result.pdf";

title1 "711378912 蔡宜諠  2025/09/09 HW1";  
/* 第一部分 */
data HW1_1;
input race $ AZT $ side_effect $ count;
/*
	- race: 種族 ( white=是, black=否  )
	- AZT: 使用新藥 ( yes=是, no=否  )
	- side_effect: 副作用( yes=有, no=沒有  )
	- count: 人數
*/
cards;
white yes yes 5
white yes no 414
white no yes 11
white no no 37
black yes yes 0
black yes no 16
black no yes 4
black no no 139
run;
title2 " 第一部分 - HW1_1 資料表";  
proc print data = HW1_1; run;
title2;

/*第二部分*/
data HW1_2;
informat op_date mmddyy8. fu_date mmddyy8.; 
format   op_date date9.   fu_date date9.;   /*這裡給他一個漂亮的長相*/
/*
	- id:  編號 ( 第1-2欄 )
	- sex 性別(第5欄  1 = 女生; 2 = 男生 )
	- age: 年齡(第10-11欄 )
	- onset : 發病天數(第14-19欄 )
	- site: 位置(第20-29欄 )
	- stage : 期別(第30-33欄 )
	- op_date : 手術日期(第35-42欄 )
	- fu_date : 追蹤日期(第45-52欄 )
	- status : 狀態(第55欄  1 = 追蹤; 5 = 復發; 6 =死亡 )
*/
input id 1-2 @5  sex @10  age @14 onset @20 site $ @30 stage $ @35 op_date @45 fu_date @55 status;
cards;
1   1     22  2     6-P       IIB  8/1/83    3/8/99    1                                                                                
2   1     12  6     24-P      IIB  4/17/8    9/2/84    5                                                                                
3   2     17  14    22-D      IIB  6/26/84   11/18/84  5                                                                                
4   2     12  1     22-D      IIIB 7/31/84   12/15/84  5                                                                                
5   1     22  4     24-P      IIB  8/11/84   3/13/89   6                                                                                
6   1     13  1     22-M+D    IIB  9/20/84   10/27/85  5                                                                                
7   2     12  1     22-D      IIB  10/9/84   5/6/85    5                                                                                
9   1     20  4     6-P       IIIB 12/6/85   3/1/87    5                                                                                
10  1     22  3     22-D      IIB  12/19/85  6/26/86   5   
run;
title2 " 第二部分 - HW1_2 資料表";  
proc print data=HW1_2;run;
title2;
ods pdf close;
