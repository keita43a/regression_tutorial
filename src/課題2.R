# 課題２

# library読み込み
# install.packages("tidyverse")
library(tidyverse)

# データ読み込み
dataves2 <- read_csv("r_basics/data/FEH_00500210_230529214946.csv")

names(dataves2)

# カンマ取り除く string str_remove(string,pattern)
dataves2$vessels1 <- str_remove(dataves2$`漁船_無動力漁船隻数【隻】`,",")

# 数値に変換する
dataves2$vessels2 <- as.numeric(dataves2$vessels1)



# 描画
ggplot(data=dataves2) + 
  geom_bar(aes(x=`(J117-30-2-001)経営体階層`,y=vessels2),stat="identity") + 
  theme_bw(base_family = "HiraKakuPro-W3")
