### 老師要教大家怎麼畫品質管制圖 ###

# 先下載套件惹 只需要一次
# install.packages("qcc")
# 導入他
library(qcc)

# 載入你的檔案
df <- read.csv("C:/Users/NTPU/Documents/data_set/Ex6-1.csv", header = TRUE)

# 首先他想要先把sample 這個column 去除了
df <- df[, 2:6]  # 行, 列

# 用一下qcc的程式畫 xbar的管制圖
q_xbar <- qcc( data = df, type = "xbar" )
# 這樣就會畫出跟投影片一樣圖形了
# 有幫你標註上屆UCL/下屆LCL 很貼心

# 如果你想要看你剛剛的詳細資訊
# 這樣又可以看的出來了
q_xbar

# 如果你要看中心線的話
q_xbar$center
# 如果你想要看他的上下屆
q_xbar$limits
# 如果你想要看每個點
q_xbar$statistics
# 如果你想要顯示表格的重要資訊
summary(q_xbar)

# R的管制圖
q_R <- qcc( data = df, type = "R" )
summary(q_R)
# 從這張圖可以看出來所有的點並沒有觀測到不在管制內的情況。
# 管制圖的形式沒有任何的形狀(pattern) 跟期望中差不多算是random 的


# 如果不小心有不在管制內的狀態，要怎麼處理???
# 老師說刪掉 對 就是刪掉
# 用程式讓他超過界線的數據消失 但老師竟然是說找到那筆資料去把它刪掉 


######## 自己計算統計相關資訊 #########
# 老師說研究生應該自己硬刻
# 老師想要給你一個手算的感覺 你才知道套件的美好 ^^
cf <- as.matrix(df)
x_bar <- numeric(); R <- numeric()
n <- 5; m <- 25
for (i in 1:25){
  x_bar[i] <- mean(cf[i, ])
  R[i] <- range(cf[i, ])[2] - range(cf[i, ])[1]
} # 每一列都去算他的平均 

# 看一下剛剛的結果
x_bar
R
# 回到公式的本體 自己計算一下到底怎麼計算
x_barbar <- mean(x_bar)
R_bar <- mean(R)

A2 <- 0.577  # Introduction_Statistical_Quality_Control-係數表 查表 n=5, A^2
xUSL <- x_barbar + A2*R_bar
xLSL <- x_barbar - A2*R_bar

### qcc 他沒有變異數的管制圖 所以如果要畫變異數的管制圖 要自己查表 並且計算
###################### 3/31 #######################
d2 <- 2.326  ## Introduction_Statistical_Quality_Control-係數表 查表 n=5, d^2
R_bar/d2  ## 估計標準差


# ========== 階段一 蒐集過往的資料 把以前的資料畫出來=========
## process capability analysis
q = qcc(df, type="xbar", nsigmas = 3, plot = FALSE)
process.capability(q_xbar, spec.limits = c(xUSL, xLSL),
                   target = c(1.50561))

process.capability(q_xbar, spec.limits = c(1, 2),  # 這個上下界線可以自己給和設定? 如果題目有給的話就給上下界線的地方
                   target = c(1.50561))
# 階段一你要先確定你的資料都在界線裡面


# ===========階段二 phase II 多收集了幾個點 所以有額外的資料 =========
# 把多的資料點放進來來判斷製成有沒有快速跑出去
# 他一定會快速跑出去 但你可以看看她會不會很快跑出去
# 這個在 [作業3-b] 會用到 就是加入資料去看看他哪一個點會跑出去

# 所以我們現在先把資料弄進來 6.1 extra
df_extra <- read.csv("C:/Users/NTPU/Documents/data_set/Ex6-1-extra.csv", header = TRUE)
df_extra <- df_extra[, 2:6]  # 第一行一樣不要

# 用一下qcc的程式畫 xbar的管制圖
q_xbar2 <- qcc( data = df, type = "xbar", newdata = df_extra)
# 一旦out control 後面就不用管它了
# 你就是持續監控 看看第幾個點會跑出去
# 這就叫做連串長度

# R的管制圖
q_R2 <- qcc( data = df, type = "R", newdata = df_extra)
# 但是在R chart不會跑出去


## ===================== 6.3 S 標準差 管制圖 ===========================
df_3 <- read.csv("C:/Users/NTPU/Documents/data_set/Ex6-3.csv", header = TRUE)
df_3 <- df_3[, 2:6]  # 第一行一樣不要

# x-bar & S chart
q3_xbar <- qcc( data = df_3, type = "xbar")
q3_s <- qcc( data = df_3, type = "S")
# 從圖中就可以看的出來sigma^2 就是0.01 ( 0.00939 ≈ 0.01 )


## === 6.3.3 S^2 變異數的管制圖=====
library(pbcc)
# set the process in-control time to signal is at least 100 sample
T1 <- 100  # 製成的時間 規定至少要100次
# set the probability of guaranteed in-control sigmals is 5%
p1 <- 0.05 # 設定 error的機率是5 趴 就是百分之95
q3_s2 <- pbcc(data = df_3, T1, p1, type = "S2")

# sample # 統計量 每一個標準差的數值 就是每一個點
q3_s2$statistics
q3_s2$LCL # 下界
q3_s2$UCL # 上界

###============我是畫圖的部分=============
options(scipen = 999)  # 加上這個等等才沒有科學記號
# 劃出主要的折線圖
plot(
  q3_s2$statistics,  # 直接把它畫出來
  type = "b", # type連起
  pch = 16,  #  pch不要空心
  ylim = c(-0.0001, 0.0007),  # y的範圍
  ylab = "S2",  # y軸名稱
  xlab = "Sample" # X軸名稱
  )
# 現在畫線了
abline(
  h=0, # 出現上界
  col = 2, # 上色的部分
  lwd = 2 # 寬度
  )
abline(
  h=q3_s2$UCL, # 出現下界
  col = 2, # 上色的部分
  lwd = 2 # 寬度
  )
# 我現在要標出我們的數值了
text(
  3, # x軸位置
  0.0006,  # y軸位置
  paste("UCL=", round(q3_s2$UCL, 5), sep = "")  # 我要放的上界的字
  )
text(
  3, # x軸位置
  -0.00005,  # y軸位置
  paste("LCL=", 0, sep = "")  # 我要放的下界的字
  )
# 作業 2-c 會用到


### =========== 6-6 個別管制圖 & 移動全距管制圖=========
df_6 <- read.csv("C:/Users/NTPU/Documents/data_set/Ex6-6.csv", header = TRUE)
df_6 <- df_6[, 2]  # 第一行一樣不要

# x-one chart 成本的個別觀測管制圖
q6_Xone <- qcc(data = df_6, type = "xbar.one")
q6_Xone$statistics
q6_Xone$limits
# 移動全距管制圖 MR chart
# 先算出移動全距 MR 再畫圖
df_MR <- matrix(cbind(df_6[1:19], df_6[2:20]), ncol = 2)
q6_MR <- qcc(data = df_MR, type = "R")
# 作業4 會用到


#################################################
## 作業2
# Q1-1：繪製xbar和R的管制圖，資料T6-2製成是否有在管制內
df_t62 <- read.csv("C:/Users/NTPU/Documents/data_set/T6-2.csv", header = TRUE)
q_R_t62r <- qcc( data = df_t62, type = "R" )
# 從這張圖可以看出來並沒有觀測到不在管制內的情況。
# 這張圖看起來稍微有往下，但還在可以接受的範圍，還可以算是 random 的狀態。

# Q1-2：繪製xbar和S的管制圖，資料T6-2製成是否有在管制內




