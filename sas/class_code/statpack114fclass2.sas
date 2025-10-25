/*顏色很重要!! 顏色對了就會對了! 這個編輯器就是主要因為可以用顏色去做區分~*/
data class2a;
infile "\statpack114fclass2.dat";
/*老師說這個建議使用雙引號比較好 他說因為後面聚集的關係*/
input @1 tdate yymmdd9. sex $ 16-17 age $ 24-33 live $ 40-51
	q1 58 q2 65 q3 72 q4 79 q5 86;
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

proc print data = class2a;
format tdate date9.;
run;
