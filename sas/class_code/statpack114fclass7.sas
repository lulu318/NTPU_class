*%let dirclass6 = c:\users\hwang\dropbox\school\statpack\114fall\practice;
%let dirclass7 = C:\Users\NTPU\Downloads;
proc import datafile = "&dirclass7\statpack114fclass7.xlsx"
	out = class7 replace;
label
CHARTNO = '病歷號'
AGE = '年齡' 
SEX = '性別'
EXAMDATE = '檢查日期' 
CVADATE = '中風日期'
SBP1 = '收縮壓 (1)' 
DBP1 = '舒張壓 (1)' 
SBP2 = '收縮壓 (2)' 
DBP2 = '舒張壓 (2)' 
SBP3 = '收縮壓 (3)' 
DBP3 = '舒張壓 (3)' 
SBP4 = '收縮壓 (4)' 
DBP4 = '舒張壓 (4)'
SBP5 = '收縮壓 (5)' 
DBP5 = '舒張壓 (5)' 
SBP6 = '收縮壓 (6)' 
DBP6 = '舒張壓 (6)' 
SBP7 = '收縮壓 (7)' 
DBP7 = '舒張壓 (7)' 
SBP8 = '收縮壓 (8)'
DBP8 = '舒張壓 (8)' 
SBP9 = '收縮壓 (9)'
DBP9 = '舒張壓 (9)'
GRBED = '臥床'
PH_S = '姿態性低血壓' 
RISK_FACTO = '風險因子' 
DRUGS = '藥物'; 
run;
proc print data = class7; run;
proc format;
value dsbpf
low -< 140 = 0
140 - high = 1;
value ddbpf
low -< 90 = 0
90 - high = 1;
value $fsexf
'M' = '男性'
'F' = '女性';
value $yesnof
'Y' = '有'
'N' = '沒有';
run;
data class7a;
set class7;
format sbp1-sbp9 dsbpf. dbp1-dbp9 ddbpf. sex $fsexf. ph_s $yesnof.;
run;
proc print data = class7a; run;
data class7b;
	set class7;
	format dsbp1-dsbp9 $10.; /*最好還是習慣宣告變數 才比較不會有處理字串的問題*/
	if 120 <= sbp1 < 140 or 80 <= dbp1 <= 90 then dsbp1 = '高血壓前期';
		else if 140 <= sbp1 or 90 <= dbp1 then dsbp1 = '高血壓';
		else if sbp1 > 0 & dbp1 > 0 then dsbp1 = '正常';
	if 120 <= sbp2 < 140 or 80 <= dbp2 <= 90 then dsbp2 = '高血壓前期';
		else if 140 <= sbp2 or 90 <= dbp2 then dsbp2 = '高血壓';
		else if sbp2 > 0 & dbp2 > 0 then dsbp2 = '正常';
	if 120 <= sbp3 < 140 or 80 <= dbp3 <= 90 then dsbp3 = '高血壓前期';
		else if 140 <= sbp3 or 90 <= dbp3 then dsbp3 = '高血壓';
		else if sbp3 > 0 & dbp3 > 0 then dsbp3 = '正常';
	if 120 <= sbp4 < 140 or 80 <= dbp4 <= 90 then dsbp4 = '高血壓前期';
		else if 140 <= sbp4 or 90 <= dbp4 then dsbp4 = '高血壓';
		else if sbp4 > 0 & dbp4 > 0 then dsbp4 = '正常';
	if 120 <= sbp5 < 140 or 80 <= dbp5 <= 90 then dsbp5 = '高血壓前期';
		else if 140 <= sbp5 or 90 <= dbp5 then dsbp5 = '高血壓';
		else if sbp5 > 0 & dbp5 > 0 then dsbp5 = '正常';
	if 120 <= sbp6 < 140 or 80 <= dbp6 <= 90 then dsbp6 = '高血壓前期';
		else if 140 <= sbp6 or 90 <= dbp6 then dsbp6 = '高血壓';
		else if sbp6 > 0 & dbp6 > 0 then dsbp6 = '正常';
	if 120 <= sbp7 < 140 or 80 <= dbp7 <= 90 then dsbp7 = '高血壓前期';
		else if 140 <= sbp7 or 90 <= dbp7 then dsbp7 = '高血壓';
		else if sbp7 > 0 & dbp7 > 0 then dsbp7 = '正常';
	if 120 <= sbp8 < 140 or 80 <= dbp8 <= 90 then dsbp8 = '高血壓前期';
		else if 140 <= sbp8 or 90 <= dbp8 then dsbp8 = '高血壓';
		else if sbp8 > 0 & dbp8 > 0 then dsbp8 = '正常';
	if 120 <= sbp9 < 140 or 80 <= dbp9 <= 90 then dsbp9 = '高血壓前期';
		else if 140 <= sbp9 or 90 <= dbp9 then dsbp9 = '高血壓';
		else if sbp9 > 0 & dbp9 > 0 then dsbp9 = '正常';
/*等等等的 一直到9*/
		if ph_s = 'Y' then ph = 1;
			else if ph_s = 'N' then ph = 0;
			format ph nyesnof.;
run;
/*sas 裡面都是一列一列在處理 */

proc print data = class7b ( obs = 10 ) ;
run;
/*看成這樣就知道等等要 學for loop惹*/
/*為了要讓你方便很多*/

/*宣告變數的名稱 不能是後面的變數名稱*/
data class7c;
	set class7;
	
	/*收縮壓 > 140 異常 ( 1 )*/
/*	if sbp1 >= 140 then dspb1 = 1;*/
/*		else if 0 < sbp1 < 140 then dsbp1 = 0;*/

	/*宣告 這個程式需要兩個變數 本來有的變數 跟 輸出 */
	array aysbp sbp1-sbp9; /*ay 就是 array 現在是宣告陣列的時間*/
	array aydsbp dspb1-dspb9;
	/*迴圈開始*/
	do i = 1 to 9 ; /*現在有9個變數*/
		if aysbp[i] >= 140 then aydsbp[i] = 1;
			else if 0 < aysbp[i] < 140 then aydsbp[i] = 0;
	end;

	/*舒張壓 > 90 異常*/
	format ddbp1-ddbp9 $4.;  /*如果沒有宣告 這裡會抱錯 因為它會認成數字*/
	array aydbp dbp1-dbp9;
	array ayddbp ddbp1-ddbp9;
	do i = 1 to 9 ;
		if aydbp[i] >= 90 then ayddbp[i] = '異常';
			else if 0 < aydbp[i] < 90 then ayddbp[i] = '正常';
	end;
run;
proc print data = class7c;
run;

/*統整一下 就變方便惹*/
data class7d;
	set class7;
	format bbp1-bbp9 $10.;
	array aysbp sbp1-sbp9;  /*收縮壓*/
	array aydbp dbp1-dbp9;  /*舒張壓*/
	array aybp $ bbp1-bbp9;  /*血壓的狀態*/
	do i = 1 to 9 ;
		if 120 <= aysbp[i] < 140 or 80 <= aydbp[i] <= 90 then aybp[i] = '高血壓前期';
			else if 140 <= aysbp[i] or 90 <= aydbp[i] then aybp[i] = '高血壓';
			else if aysbp[i] > 0 & aydbp[i] > 0 then aybp[i] = '正常';
	end;
run;
proc print data = class7d;
run;

data class7e;
	set class7d;
	nspb = n ( of sbp1 - sbp9 ); /* 這一row 字串變數沒有遺失值的column 數量 */
	cspb = cmiss ( of bbp1 - bbp9 );  /* 這一row 字串變數有遺失值的column 數量 */
	mnsbp = mean ( of sbp8 - sbp9 ); /* 平均 */
	mnsbp1 = ( sbp8 + sbp9 ) / 2 ;/*跟上面其實是一樣的*/
	/*從這個例子可以知道 用函數算的 他會忽略遺失值 會用以有的資料去算平均*/
run;
proc print data = class7e;
var nspb cspb mnsbp mnsbp1;
run;

/*現在是要分割字串 然後再進行搜尋*/
data class7f;
	set class7;
/*=======分割字串=========*/
/* [ 法一 ] */
/*	r1 = scan( RISK_FACTO, 1, ' ' );*/
/*	r2 = scan( RISK_FACTO, 2, ' ' );*/
/*想要執行全部 可以再用loopㄌ*/
	format r1 - r7 $30.;
	array ayrisk r1 - r7 ;
	do i = 1 to 7;
		ayrisk[i] = scan( RISK_FACTO, i, ' ' );
	end;

/* [ 法二 ] */
/*想要計算一下裡面到底有多少個這個字串*/
/*計算這個字串裡面的 子字串有多少 後續也可以忽略大小寫跟空白之類的*/
	rcount = count ( RISK_FACTO, 'DM' );  /* 預設是0 */
	wcount = countw ( RISK_FACTO, ' ' );  /* 這個預設就是 1 */
/*先計算我們有幾個 再去看你要*/
/*如果我確定要分割完 那我就要知道全部有幾個數值*/
	do i = 1 to wcount;
		ayrisk[i] = scan( RISK_FACTO, i, ' ' );
	end;

/*=======搜尋有幾個目標函數在字串裡面=========*/
/*[ 法一 ] 用index去搜尋*/
	/*會給 DM 的位置 如果沒有就會給0*/
	pos_dm = index ( RISK_FACTO, 'DM' );
	/* 所以我們就可以用這個方式 判斷有沒有DM*/
	if pos_dm > 0 then dm = 1;
		else dm = 0;
	if index ( RISK_FACTO, 'Smoking' ) > 0 then smoke = 1;
		else smoke = 0;

/*[ 法二 ] 把字串做拆解 然後搜尋這七個變數哪一個有DM*/
	adm = 0; /* 先預設他是0 後面如果有的話再去改變它	*/
	do i = 1 to 7;
		if ayrisk[i] = 'DM' then adm = 1;
	end;
/* dm adm 這兩個結果就會是一樣的了 */

	format lst1 - lst3 $10.;
	array ayrklst $ lst1 lst2 lst3 ('DM' 'Smoking' 'HT');
	array ayrk adm smoke ht ( 0 0 0 ); /*找到有疾病變數的代表 先定義從0開始*/
	do i = 1 to 7;
		do j = 1 to 3;
			if ayrklst[i] = ayrklst[j] then ayrk[j] = 1;
		end;
	end;
run;
proc print data = class7f;
/*var RISK_FACTO lst1 lst2 lst3 adm smoke ht;*/
run;

