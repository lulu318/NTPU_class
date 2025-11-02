/*這裡要設定他的格式 格式的名稱起頭跟結尾都是文字 不能是數字*/
/*這裡的0是 否 1是 是*/
proc format;
value q1_q5f
0 = '否'
1 = '是';
run;
/*這個設定好之後 可以在檔案總管-work-format裡面看的到他 他會是一個資料夾可以點兩下在output裡面看到 */

/*顏色很重要!! 顏色對了就會對了! 這個編輯器就是主要因為可以用顏色去做區分~*/
data class2a;
infile "\statpack114fclass2.dat";
/*老師說這個建議使用雙引號比較好 他說因為後面聚集的關係*/
input @1 tdate yymmdd9. sex $ 16-17 age $ 24-33 live $ 40-51
	q1 58 q2 65 q3 72 q4 79 q5 86;
format tdate date9. q1 q2 q3 q4 q5 q1_q5f.; /*之後會設定在這裡才是跟著資料集的部分*/
label

tdate = '訪問日期'
sex = '性別'
age = '年齡'
live = '主要居住型態'
q1 = '生活大致滿意'
q2 = '常常感到厭煩'
q3 = '常常感到無論做什麼都沒有用'
q4 = '大部分時間都感到快樂'
q5 = '覺得現在情況沒有希望';
run; 

proc print data = class2a label;  /*這裡加上label就會是出現上面設定的那些中文字*/
format tdate date9. q1 q2 q3 q4 q5 q1_q5f.;
/*這裡就是使用他的格式 要記得他是使用那個格式並沒有改變他的資料*/
/*這個格式 是設定(proc)在程序裡面 他也可以設定在資料集 這樣之後就都可以是這個格式 ( 就是放在上面大概input下面的地方 )*/
run;

/*希望sas產出七個freq的table*/
proc freq data = class2a;
table sex live q1 q2 q3 q4 q5;
run;

/*現在是要定義他的格式 就是要加上一個$*/
proc format;
value $sexf
'男' = 'Male'
'女' = 'Female';
run;
proc freq data = class2a;
table sex;
format sex $sexf.;
run;

/*現在要匯入CSV*/
data class2b;
infile ".\statpack114fclass2b.csv" delimiter=',' firstobs=2;
input tdate $ sex $ q1 $ q2 $ q3 $ q4 $ q5 $ age $ live $;
/*匯入csv主要就是 給他input column的型態就行了*/
run;
proc print data = class2b;
run;

/*設定library*/
libname class2b "C:\Users\NTPU\Downloads";
data class2b.class2b;
set class2b;
run;
/*然後就可以從永久的資料夾裡面找出資料惹*/
proc print data = class2b.class2b;
run;
data temp;
set class2b.class2b;
run;

proc freq data = class2c;
tables _col2;
run;
/*我現在要合併其中的欄位 變成只有row*/
proc format;
value $agef
'55 - 59 歲', '60 - 64 歲' = '64歲以下'
'65 - 69 歲', '70 - 74 歲', '75 - 79 歲', '80 歲及以上' = '65歲以上';
run;
proc freq data = class2c;
tables _col2;
format _col2 $agef.;
run; 

proc print data = class2c (obs=10);
/*這就是指輸出10行*/
run;
