
proc import datafile = "C:\Users\NTPU\Downloads\statpack114fclass6.xlsx"
	out = class6 replace;
label
CHARTNO = '病歷號'
AGE = '年齡' 
SEX = '性別'
EXAMDATE = '檢查日期' 
CVADATE = '中風日期'
S0SBP = '收縮壓 (1)' 
S0DBP = '舒張壓 (1)' 
U1SBP = '收縮壓 (2)' 
U1DBP = '舒張壓 (2)' 
U3SBP = '收縮壓 (3)' 
U3DBP = '舒張壓 (3)' 
U5SBP = '收縮壓 (4)' 
U5DBP = '舒張壓 (4)'
U7SBP = '收縮壓 (5)' 
U7DBP = '舒張壓 (5)' 
U9SBP = '收縮壓 (6)' 
U9DBP = '舒張壓 (6)' 
U11SBP = '收縮壓 (7)' 
U11DBP = '舒張壓 (7)' 
U30SBP = '收縮壓 (8)'
U30DBP = '舒張壓 (8)' 
S99SBP = '收縮壓 (9)'
S99DBP = '舒張壓 (9)'
S99HR = '心跳 (9)' 
GRBED = '臥床'
PH_S = '姿態性低血壓' 
RISK_FACTO = '風險因子' 
DRUGS = '藥物'; 
run;
proc print data = class6; run;
proc format;
value dsbpf
low -< 140 = 0
140 - high = 1;
value ddbpf
low -< 90 = 0
90 - high = 1;
value $sexf
'M' = '男性'
'F' = '女性';
value $yesnof
'Y' = '有'
'N' = '沒有';
run;

data class6a;
set class6;
format s0sbp u1sbp u3sbp u5sbp u7sbp u9sbp u11sbp u30sbp
	s99sbp dsbpf.
	s0dbp u1dbp u3dbp u5dbp u7dbp u7dbp u11sbp u30dbp 
	s99dbp ddbpf.
	sex $sexf. ph_s $yesnof.;
run;

proc freq data= class6a;
	table s0sbp u1sbp u3sbp u5sbp u7sbp u11sbp u30sbp 
	s99sbp s0dbp u1dbp u3dbp u5dbp u7dbp u11dbp u30dbp s99dbp;
run;

/*數值的放進去才有意義!!*/
proc means data= class6;
	var s0sbp u1sbp u3sbp u5sbp u7sbp u11sbp u30sbp 
	s99sbp s0dbp u1dbp u3dbp u5dbp u7dbp u11dbp u30dbp s99dbp;
run;

/*這些放在裡面就沒有意義 因為她不能計算*/
proc means data=class6;
	var chartno examdate cvadate;
run;

/*根據有沒有低血壓的狀態去做分析*/
proc means data= class6;
class ph_s;
	var s0sbp u1sbp u3sbp u5sbp u7sbp u11sbp u30sbp 
	s99sbp s0dbp u1dbp u3dbp u5dbp u7dbp u11dbp u30dbp s99dbp;
run;

/*加上中位數 四分位數等等的*/
proc means data= class6 q1 median q3;
class ph_s;
	var s0sbp u1sbp u3sbp u5sbp u7sbp u11sbp u30sbp 
	s99sbp s0dbp u1dbp u3dbp u5dbp u7dbp u11dbp u30dbp s99dbp;
run;

/*想知道平躺的收縮壓*/
/*會給出各式各樣的分位數*/
proc univariate data=class6;
	var s0sbp;
run;

/*畫圖開始惹*/
proc univariate data=class6;
	var s0sbp;
	histogram s0sbp;
	qqplot s0sbp;
run;

/*想知道這個變數有沒有符合常態分配*/
/*提供四個常態檢定*/
proc univariate data=class6 normal;
	var s0sbp;
run;
/*
[ Shapiro-Wilk W ]
	檢測常態 可以看這個數值
	他的檢定力會比別人好
	檢定統計輛介於0跟1之間
	比較資料如果沒有常態的假設 他的變異量是多少
	在常態的假設底下 還可以有一個標準差的估計值 比較他們會不會差很多
	當他的統計值靠近1的時候 表示P值會是不顯著的
	如果遠離1用常態所算的標準差 差蠻多的 p<0.05 就沒有符合常態分布
*/

/*這裡是追蹤輸出的表格*/
ods trace on;
proc univariate data=class6 normal;
	var s0sbp;
run;
ods trace off;
/*在日誌的部分 就會有很多表格*/

/*這裡是整裡輸出的表格*/
/*之後還可以再使用他*/
proc univariate data=class6 normal;
	var s0sbp;
	ods output basicmeasures=s0sbp_cont;  /*希望輸出到哪一個檔案*/
run;
proc print data=s0sbp_cont;
run;

ods rtf file= "C:\Users\NTPU\Downloads\statpack114class6.doc";
proc print data=s0sbp_cont;
run;
ods rtf close;


/*對日期做加減 輸出欄位*/
data class6b;
	set class6;
	diffday = examdate - cvadate;
	meanbp = s0sbp/3 + s0dbp*2/3;  /*平均血壓值*/
/* 次方就是兩個* */
run;
proc print data=class6b;
var chartno examdate cvadate diffday meanbp;
run;

/* if else */
data class6c;
	set class6;
	if s0sbp<140 then ds0spb = 0;
	else ds0spb = 1;
/*換一個變數 做一樣的事情*/
/*
	if s99sbp<140 then ds99spb = 0;
	else ds99spb = 1;
	因為這個數據有遺失值 sas的遺失值就是負數 
	所以這裡遺失值 就會是 0
	所以要改成下面的寫法
*/
	if 0<s99sbp<140 then ds99spb = 0;
	else if s99sbp >= 140 then ds99spb = 1;
/*這樣才會讓 本來遺失值繼續遺失 不要讓他待在哪一類	*/

/*
	{ example }:  
	現在要以年紀為分割 64歲以下  正常<140
	65歲以上 正常<150
*/
	if age < 65 then do;
		if 0<s99sbp<140 then ds99spb1 = 0;
		else if s99sbp >= 140 then ds99spb1 = 1;
	end;
	else if age >= 65 then do;
		if 0<s99sbp<150 then ds99spb1 = 0;
		else if s99sbp >= 150 then ds99spb1 = 1;
	end;
run;
proc print data=class6c;
	var age s0sbp ds0spb s99sbp ds99spb ds99spb1;
run;

