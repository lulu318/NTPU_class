data class8d1;
informat xyz $50.;
xyz='This is a thistle? Yes, this is a thistle.';
this = count(xyz, 'this');
this_all = count(xyz, 'this', 'i');
t_all = countc(xyz, 't');
lowcase = countc(xyz, 'l');  /*統計小寫的字母*/
upcase = countc(xyz, 'u'); /*統計大寫的字母*/
all_letter = countc(xyz, 'a');  /*統計所有大小寫的字母*/
run;
proc print data = class8d1; run;


proc print data = class8d1; run;
data class8d2;
input string $60.;
letter = countc(string, ,'a');
allletter = countc(string, ,'L');  /*計算小寫的字母*/
aletter = countc(string, 'a');  /*計算a這個字母出現的次數*/
digit = countc(string, ,  'd'); /*統計數字個數*/
sp_char = countc(string, ,'adtv');  /*計算特殊符號的個數*/
space = countw(string, ' '); /*以空白 ' ' 為分隔符。 例如："It's a pleasant day today" → 5 個字。*/
underline = countw(string, '_'); /*計算字串中用底線 _ 分隔的片段數。例如：I_am → 被算成 2 個詞。*/
datalines;
It's a pleasant day today
I_am yet to receive payment
352+20+2=374
Send to my address xyz_a@gmail
run;
proc print data = class8d2; run;

data class8d2a;
	set class8d2;
	remove_a = compress( string, 's' ); /*我要刪除英文字母s */
run;
proc print data = class8d2a; run;
/*大寫的還是會在唷~~*/

data class8d2a;
	set class8d2;
	remove_s = compress( string, 's' ); /*我要刪除英文字母s */
	remove_sS = compress( string, 's', 'i' ); /*我要刪除英文字母 大小寫s */
	keep_s = compress( string, 's', 'k' ); /*保留小寫的s*/
	keep_sS = compress( string, 's', 'ik' ); /*保留s 不分大小*/
	keep_digit = compress( string, , 'kd' ); /*保留數字的部分*/
	keep_leter =  compress( string, , 'ka' );  /*保留字母的部分*/
run;
proc print data = class8d2a; run;

%let dirclass = C:\Users\NTPU\Downloads\chapter4;
libname class8 "&dirclass";
data ch4d4;
	set class8.statpackch4d4;
run;
proc print data = ch4d4; run;

data ch4d4a;
	set ch4d4;
	dm = substr(dmtype, 1, 2);  /*型態*/
	/*position 擷取字串起始位置*/
	/* length 擷取的字串長度 */
	dmyear =  compress(dmtype, , 'dk');/* 數字的部分 對其左邊	*/
	/*	如果他要計算一定要是數值的結果 但今天用compress一定出來的是字串*/
	dmyear1 = input(dmyear, 8.);   /*這樣就會變成數值型的變數 對其右邊*/
	/*dmyear1 = input( compress(dmtype, , 'dk'), 8.);   這個就代替上面的兩件事 變成一行了*/  
	trimspace = compress(dmtype); /*把中間的空格都拿掉了*/
	status = compress(infect, 'PN', 'k');  /*只保留PN*/
	infect_dur = input(compress(infect, , 'kd'), 8.);   /*保留月份 且把它變成數值型的*/

run;
proc print data = ch4d4a;
	var dmtype dm dmyear dmyear1 trimspace infect status infect_dur;
run;

data ch4d4b;
	set ch4d4a;
	predbp = input(scan( preopbs, 1, '/' ), 8.);
	presbp = input(scan( preopbs, 2, '/' ), 8.);

	/*上面兩個可以變成下面這種寫法*/
	array aypostbp postdbp postsbp;
	do i = 1 to 2;
		aypostbp[i] = input(scan( postopbs, i, '/' ), 8.);
	end;
run;
proc print data = ch4d4b;
	var preopbs predbp presbp postopbs postdbp postsbp;
run;
/*這樣很快就可以把我們的字串去做切割*/

/*put 函數*/
proc format;
	value $sexf
		'F' = '女'
		'M' = '男';
	value absbpf
		low - 140 = '正常'
		140 - high  = '異常';
	value abdbpf
		low - 90 = '正常'
		90 - high = '異常';
run;
proc print data = ch4d4b(obs=10);
	format sex $sexf.;
run;

data ch4d4c;
	set ch4d4b;
	format gender abdbp absbp $10.;/*怕會超過位元*/
	gender = put( sex,  $sexf.);
	/*讓變數裡面的數據 依照sexf去呈現 呈現出來的結果放在 gender*/
	abdbp = put( postdbp,  abdbpf.);
	absbp = put( postsbp,  absbpf.);
	/*下面的效果跟上面的一樣*/
	if 0 < postdbp<=90 then abdbp1 = '正常';
		else if postdbp>90 then abdbp1= '異常';
run;
proc print data = ch4d4c(obs=10);
	var sex gender postdbp abdbp abdbp1 postsbp absbp;
run;

/*把剛剛拆開來的合併起來*/
data ch4d4d;
	set ch4d4c;
	postop = catx(':', of postdbp postsbp); /*他是字串的函數 所以放進去的都要是字串 他會幫轉乘字串*/
	dm_var = cat(dm, dmyear1);
	dm_var1 = dm || dmyear1 || ' yrs';  /* || 就是用來連結兩個想要的字串*/
run;
proc print data = ch4d4d(obs=10);
	var postopbs postop dm dmyear1 dm_var dm_var1;
run;

/*假設我只要保留基本變數*/
/*這個表示先讀近來 在抓取四個變數*/
data ch4d4e;
	set ch4d4d;
	keep id age sex dmtype;
run;
/*這個跟上面的最大差異在於 我在讀進來的時候只保留四個變數*/
data ch4d4f;
	set ch4d4d(keep =  id age sex dmtype);
run;

/*指丟掉四個變數*/
data ch4d4g;
	set ch4d4d;
	drop id age sex dmtype;
run;
/*這也是只丟掉四個變數*/
data ch4d4h;
	set ch4d4d(drop =  id age sex dmtype);
run;

/*修改變數名稱  輸出的時候才把改調*/
data ch4d4i;
	set ch4d4d;
	rename id = newid;
run;

/*進來的時候就直接把他變成newid了*/
data ch4d4j;
	set ch4d4d( rename = ( id = newid);
run;
/*依樣就是變動的過程不一樣*/

proc print data = ch4d4i(obs=10);
run;
