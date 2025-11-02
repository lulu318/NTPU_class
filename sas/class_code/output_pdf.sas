/* === 通用 Driver 程式 === */
/* 設定作業編號與主程式檔名 */
%let hw_no = 1;                           /* 作業編號，例如 1 表示 HW1 */
%let main_file = Z:\sas\HW1\HW1_20250909.sas;  /* 主程式路徑 */

/* === 輸出程式碼 PDF === */
ods pdf file="Z:\sas\HW1\HW&hw_no._code.pdf" style=journal;
options orientation=portrait papersize=a4 linesize=120 pagesize=60;

data code_lines;
    infile "&main_file" lrecl=500 truncover;
    input line $char500.;
    /* 過濾掉控制語句，不輸出 */
    if index(lowcase(line),"ods pdf")=0;
run;

title "SAS 原始程式碼 711378912 蔡宜諠 HW&hw_no";
proc report data=code_lines nowd noheader;
    column line;
    define line / display style=[cellwidth=100% font_face="Courier New" fontsize=9pt];
run;
title;

ods pdf close;

/* === 執行主程式，產生結果 PDF === */
%include "&main_file";
