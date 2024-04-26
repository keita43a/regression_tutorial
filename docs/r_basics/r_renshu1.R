x <- 6
y <- 7
z <- x + y

#  ベクトル
v <- c(1,2,3,4,5)
v

goukei <- sum(v)
goukei

# meanは平均の関数
heikin <- mean(v)
heikin

sqrt(2)

# na.rmはNAを含めるか含めないか決める引数
v2 <- c(1,2,3,NA,6)
v2

heikin2 <- mean(v2)
heikin2

# heikin3 <- mean(v2, na.rm = TRUE)
heikin3


#これは練習

# ワーキングディレクトリの取得
getwd()

# ワーキングディレクトリの変更
setwd("j:/abezemi/r_renshu")

#　ワーキングディレクトリの再確認
getwd()

# (再)ベクトル
v3 <- c(1:10)
v3 

#  ベクトル
v4 <- seq(2,50,by=2)
v4

v5 <- seq(3,60,by=3)
v5

v6 <- rep(5,100)
v6

#  いくつ？
length(v6)

# リスト
a <- list(
  c("a", "b", NA, "d"),
  num = c(3, 1.1, 5),
  data = head(mtcars, 1))

a

# ベクトルの参照
v5[3]
v5[c(2,3,5)]

# リストの参照
a[1]
a[2]
a[3]

#  リストの内容だけを取り出したいとき
a[[1]]
a[[2]]
a[[3]]

#  データ
mtcars
data1 <- mtcars

# 燃費の平均
nenpi_heikin <- mean(data1$mpg)
nenpi_heikin

# データを見たい
# １．environmentの中のデータをクリックする
# ２．View(data1)
View(data1)
#  データの最初だけ見たいとき
head(data1)
#  データの最後だけ見たいとき 
tail(data1)
tail(data1, n=10) #  最後の10行だけ見る

