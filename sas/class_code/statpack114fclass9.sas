data class9d1;
  input team $20.;
  datalines;
Fast Bees
Angry Hornets
Wild Mustangs
Fast Panthers
Fast Cobras
Wild Cheetahs
Wild Aardvarks
run;
data class9d1a;
set class9d1;
team1 = tranwrd(team, 'Fast', 'Slow');
/*
-- 置換文字 --
第二個位置 目標單字
第三個位置 要被置換的單字
*/
run;
proc print data = class9d1a; run;

data class9d2; 
Informat string $10.;
input string;
cards;
XYZW
AABBAABABB
1111111111
run;
data class9d2a;
set class9d2;
string1 = translate(string, 'AB', 'VW');
string2 = translate(string, '12', 'AB');
string3 = translate(string, '23', '11');
string4 = translate(string, 'A', 'VZ');     /*V會改成A，Z會改成空白的*/
string5 = translate(string, 'AB', 'Y');
run;
proc print data = class9d2a; run;

proc import out=hw6
    datafile="C:\Users\NTPU\Downloads\statpack114fHW6.xlsx"
    dbms=excel replace;
    getnames=no;  	/*因為是中文 討厭! 所以把它換成sas預設的*/
	dbdsopts = "firstobs=2";   /*選項設定 出來就會變成 F1 F2..... 不會把她讀進來了*/
run;
proc print data = hw6; run;

proc format;
	value $stringf
	'A' = 1
	'B' = 2
	'C' = 3
	'D' = 4
	'E' = 5;
run;
/*快速改變成數值*/
data hw6a;
	set hw6;
	array callques f2-f19;
	array nallques nf2 - nf19;
	do i  = 1 to dim(callques);   /*dim 提供陣列長度*/
		nallques[i] = input( put( callques[i], $stringf. ), 1. );
	end;

	/*反向題目的時候*/
	array arevers nf7 nf9 nf11 nf12 nf14 nf17 nf19;
	do i = 1 to dim(arevers);
		arevers[i] = 6 -arevers[i];  /*這樣子的計算就會得到反向的結果*/
	end;

	/*拆解複選題的部分*/
	/*先合併起來再拆開來 感覺多此一舉嗎*/
	allexp = catx( ' ', of f20 - f23 );
	expA = 0; expB = 0; expC = 0; expD = 0; 
	if index( allexp, 'A' ) then expA = 1; 
	if index( allexp, 'B' ) then expB = 1; 
	if index( allexp, 'C' ) then expC = 1; 
	if index( allexp, 'D' ) then expD = 1;

	/* 接下來因為它裡面程式都是一樣的所以可以把它變成陣列(? */
	format quesA quesB quesC quesD $1.;
	array allans quesA quesB quesC quesD ( 'A', 'B', 'C', 'D');  /*創一個陣列 原始數值都是自己本身的英文*/
	array alluse useA useB useC useD;
	do i = 1 to dim( allans );
		alluse[i] = 0 ;
		if index(allexp, allans[i]) then alluse[i] =1;  /*如果有出現的話就把它變成1*/
	end;
	/*結果就會跟剛剛的一樣*/

	/* 用函數的時候要確定一下有沒有遺失值 */
	meanscore = mean( of nf7 - nf19 );   /*計算 nf7 - nf19 的平均值*/
	nm_score = n ( of nf7 - nf19 );  /*看看 nf7 - nf19 變數裡面有沒有遺失直*/
run;
proc print data = hw6a; run;


data class9d3c;
infile cards missover;
input common $ animal $ number;
cards;
A Ant 5
B Bird
C Cat 17
D Dog 9
E Eagle
F Frog 76
run;
proc print data = class9d3c; run;

data class9d3d;
infile cards missover;
input common $ plan $ number;
cards;
G Grape 69
H Hazelnut 55
I Indigo
J Jicama 14
K Kale 5
L Lentil 77
run;
proc print data = class9d3d; run;


/*============  上下疊資料  ===========*/
/*如果欄位不一樣 就會多出來*/
data class9d3_1;
	set class9d3c class9d3d;
run;
/*上下疊資料的時候記得 變數名稱如果一樣屬性一定要一樣 才能上下合併*/
proc print data = class9d3_1; run;


data class9d4a;
input common $ animal $;
cards;
A Ant
B Bird
C Cat
D Dog
E Eagle
F Frog
run;
proc print data = class9d4a; run;
data class9d4b;
input common $ plant $;
cards;
A Apple
B Banana
C Coconut
D Dewberry
E Eggplant
G Fig
run;
proc print data = class9d4b; run;

/*===========  左右合併  ===========*/
data class9d4_ab;
	merge class9d4a class9d4b;
run;
proc print data = class9d4_ab; run;
/*前面會被後面蓋掉了 以現在來說b會蓋掉a */


/*如果不要被蓋掉就要針對 common 去做排序 */
/*設定共同的編號 會好把兩個檔案做合併*/
proc sort data = class9d4a;
by common;
proc sort data = class9d4b;
by common;
data class9d4_ab;
	merge class9d4a class9d4b;
	by common;
run;
proc print data = class9d4_ab; run;
/* 這樣F跟G就不會錯誤被蓋掉 */

/*IN 指標變數 可以看到我的觀察直在兩個檔案裡面分別有沒有*/
data class9d4_ab_1;
	merge class9d4a ( in = file1 ) class9d4b ( in = file2 ) ; 
	/*=== IN === 
		後面都是變數名稱 當資料及關起來的時候 他就會不見
		sas 是沒有把它存下來的
	*/
	by common;
	flag1 = file1;
	flag2 = file2;
	/*因為我想要看他 所以把它列印出來*/
run;
proc print data = class9d4_ab_1; run;


/* 我只想撈出來 在資料A裡面有的資料 */
data class9d4_ab_2;
	merge class9d4a ( in = file1 ) class9d4b ( in = file2 ) ; 
	by common;
	if file1 = 1 ;   /*if file1 是同樣的意思*/
	/* 就會保留在第一個檔案有的觀察直 */
run;
proc print data = class9d4_ab_2; run;
/*以這個範例來說G就會不建ㄌ*/

/* ========== OUTPUT 輸出觀察直 ==========*/
/* 把所有東西分成兩個檔案去儲存 */
data class9d4_ab_3a class9d4_ab_3b;
	merge class9d4a ( in = file1 ) class9d4b ( in = file2 ) ; 
	by common;
	if file1 = 1 and file2 = 1 then output  class9d4_ab_3a;  /*第一個是兩個條件都要滿足輸出到這*/
	else output class9d4_ab_3b;
run;
proc print data = class9d4_ab_3a; run;  /* 兩個都有數值得row 會出現在這 */
proc print data = class9d4_ab_3b; run;   /*如果只有一個有數值的row 會出現在這*/

/* =========== where ==========  */
/* 保留滿足的觀察直 比較會用在程序(proc print)裡面 因為程序裡面不能寫if */
proc print data = class9d4_ab_3a;
	where common in ( 'A', 'B' );
run;

data class9d4c;
input common $ plant $;
cards;
A Apple
B Banana
C Coconut
C Celery
D Dewberry
E Eggplant
run;
