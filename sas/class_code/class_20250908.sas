data class1;
input trt status count;
cards;
0 3 18
0 2 171
0 1 10845
1 3 5
1 2 99
1 1 10933
run;

data class1a;
input trt $  status count;   * 老師說這個$是很重要的部分惹 ;
cards;
P 3 18
P 2 171
P 1 10845
A  3 5
A  2 99
A 1 10933
run;
proc print data = class1a;
run;


/*分隔符號的設定*/
/*這裡是說csv的檔案 所以要告訴他一下這裡的分隔方式是逗點*/
data class1a_csv;
infile cards delimiter  = ',';    /*如果是外部的檔案這裡就是要打file*/
input trt $  status count;
cards;
P, 3, 18
P, 2, 171
P, 1, 10845
A,  3,  5
A,  2, 99
A, 1, 10933
run;
proc print data = class1a_csv;
run;

/*老師說最重要的就是顏色的部分惹*/
data class1_2;
input cotton_content  freq strength;
cards;
15 1 7 
15 2 7 
15 3 15 
15 4 11 
15 5 9
20 1 12 
20 2 17 
20 3 12 
20 4 18 
20 5 18
25 1 14 
25 2 18 
25 3 18 
25 4 19 
25 5 19
30 1 19 
30 2 25 
30 3 22 
30 4 19 
30 5 23
35 1 7 
35 2 10 
35 3 11 
35 4 15 
35 5 11
run;
proc print data = class1_2;
run;


data class1c;
input trt status count  @@;   
/*加上@@ 就會讓他一直讀資料讀到沒有資料為止 要持續去讀資料*/
cards;
0 3 18 0 2 171 0 1 10845
1 3 5 1 2 99 1 1 10933
run;
proc print data = class1c;
run;

data class1_3;
infile "C:\Users\NTPU\Downloads\Chapter1\statpackch1d1.dat";
input trt status count;
run;
proc print data = class1_3;
run;
