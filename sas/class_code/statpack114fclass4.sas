%let dirclass = C:\Users\hwang\Dropbox\School\statpack\114fall\project;
data class4;
infile "&dirclass\statpack114fhw3.txt"
	firstobs = 32;
input id group $ lead0 lead1 lead4 lead6;
run;
proc format; 
value leadgpf
low- <18 = 1
18 - <25 = 2
25 - high = 3;
run;
proc print data = class4 (obs =10);
format lead0 lead1 lead4 lead6 leadgpf.;
run;
proc tabulate data = class4;
class group;
var lead0 lead1 lead4 lead6;
table group, all * (lead0 lead1 lead4 lead6) * (mean = 'キА' std = '夹非畉');
run;
proc tabulate data = class4;
class group lead0;
var lead1 lead4 lead6;
table group, lead0 * (lead1 lead4 lead6) * (mean = 'キА' std = '夹非畉');
format lead0 leadgpf.;
run;
proc tabulate data = class4;
class group lead0 lead1;
var lead4 lead6;
table group * lead0, lead1 * (lead4 lead6) * (mean = 'キА' std = '夹非畉');
format lead0 lead1 leadgpf.;
run;
proc tabulate data = class4;
class group lead0 lead1;
var lead4 lead6;
table group * lead0 group * all, lead1 * (lead4 lead6) * (mean = 'キА' std = '夹非畉');
format lead0 lead1 leadgpf.;
run;
proc tabulate data = class4;
class group lead0 lead1;
var lead4 lead6;
table group * (lead0  all), lead1 * (lead4 lead6) * (mean = 'キА' std = '夹非畉');
format lead0 lead1 leadgpf.;
run;
proc tabulate data = class4;
class group lead0 lead1;
var lead4 lead6;
table group, lead0 * lead1 * (n = '计' pctn = 'κだゑ');
format lead0 lead1 leadgpf.;
run;
proc tabulate data = class4;
class group lead0 lead1;
var lead4 lead6;
table group, lead0 * lead1 * (lead4 lead6) * (mean = 'キА' std = '夹非畉');
format lead0 lead1 leadgpf.;
run;
proc tabulate data = class4;
class group lead0 lead1;
var lead4 lead6;
table group, lead0 * lead1 * (lead6) * (mean = 'キА' std = '夹非畉')
	all * (n = '计');
format lead0 lead1 leadgpf.;
run;
proc tabulate data = class4;
class group lead0 lead1;
var lead4 lead6;
table group, lead0 * (lead1  all)* (lead6) * (mean = 'キА' std = '夹非畉')
	all * (n = '计');
format lead0 lead1 leadgpf.;
run;

proc tabulate data = class4;
class group lead0;
var lead1 lead4 lead6;
table group, lead0 * (lead1 lead4 lead6) * (mean = 'キА' std = '夹非畉')
	all * (lead1 lead4 lead6) * (n = '计' mean = 'キА' std = '夹非畉');
format lead0 leadgpf.;
run;

proc tabulate data = class4;
class group lead0;
var lead1 lead4 lead6;
table group, (lead0 all) * (lead1 lead4 lead6) * (mean = 'キА' std = '夹非畉');
format lead0 leadgpf.;
run;

proc print data = class4 (obs = 10); run;
proc sort data = class4;
by id;
proc transpose data = class4 out = tclass4;
by id;
var lead0 lead1 lead4 lead6;
run;
proc print data = tclass4 (obs = 10); run;
proc sort data = class4;
by id;
proc transpose data = class4 out = tclass4b;
by id;
copy group;
var lead0 lead1 lead4 lead6;
run;
proc print data = tclass4b (obs = 10); run;
proc sort data = class4;
by id group;
proc transpose data = class4 out = tclass4c;
by id group;
var lead0 lead1 lead4 lead6;
run;
proc print data = tclass4c (obs = 10); run;
proc transpose data = class4 out = tclass4d prefix = y;
by id group;
var lead0 lead1 lead4 lead6;
run;
proc print data = tclass4d (obs = 10); run;
proc format;
value $timef
'lead0' = '膀非'
'lead1' = '材秅'
'lead4' = '材秅'
'lead6' = '材せ秅';
run;
proc print data = tclass4d (obs = 10); 
format _name_ $timef.;
run;
data ch2d4;
input student $ studentid $ section $ test1 test2 final;
cards;
Capalleti 0545 1  94 91 87
Dubose    1252 2  51 65 91
Engles    1167 1  95 97 97
Grant     1230 2  63 75 80
Krupski   2527 2  80 76 71
Lundsford 4860 1  92 40 86
McBane    0674 1  75 78 72
run;
proc print; run;
proc transpose data = ch2d4 out= ch2d4a;
run;
proc print data = ch2d4a; run;
proc transpose data = ch2d4 out= ch2d4b prefix = sn;
id studentid;
run;
proc print data = ch2d4b; run;
proc transpose data = ch2d4 out= ch2d4c prefix = sn;
id studentid;
idlabel student;
run;
proc print data = ch2d4c label; run;
proc print data = ch2d4c  noobs; 
var _name_ sn0545 sn1252;
label
_name_ = '代喷';
run;
proc print data = ch2d4; run;
proc sort data = ch2d4;
by section;
proc print data = ch2d4; run;
proc print data = ch2d4 sumlabel = '痁' 
	grandtotal_label = '羆㎝'
	n = '痁厩ネ计 = ' '羆厩ネ计 = '; 
by section;
sum test1 test2 final;
run;
proc freq data = ch2d4;
tables section;
run;
proc format;
value $sectionf
'1' = 'B 痁'
'2' = 'A 痁';
run;
proc freq data = ch2d4 order = formatted;
tables section;
format section $sectionf.;
run;
proc print data = ch2d4;
run;
proc sort data = ch2d4;
by descending section;
run;
proc print data = ch2d4;
run;
proc freq data = ch2d4 order = data;
tables section;
run;
proc means data = ch2d4;
var test1 test2 final;
run;













