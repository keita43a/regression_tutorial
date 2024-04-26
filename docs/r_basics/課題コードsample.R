# 課題サンプルコード

# 作業場所の確認と変更
# 以下の２行の ##を削除して使う。
## getwd()  # 現在の場所の確認
## setwd("j:/abezemi/r_renshu") # 場所をr_renshuフォルダに変更
# 自分のパソコンを使っている人は、必要に応じて中身を変更する

# ライブラリのインストール
install.packages("tidyverse") # 必要に応じてインストールする

# ライブラリを読み込み
library(tidyverse)


# データを読み込み
# readrというパッケージの中にあるread_csv()を使っている
# readrはtidyverseのパッケージ群の一つ

# Country_Dfという入れ物にデータを入れる
Country_df <- read_csv("data/Countries.csv")

# ステップ１：基本の描画
# 私たちのRにある|>というコードは、「パイプ」と呼ばれるもの
# これは|>の前にあるオブジェクトを|>の後ろに受け渡しますよ、という意味になる。

Country_df |>
  ggplot() +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018))

# これは下のコードと同じ意味になる
# ggplot()の1つ目の引数は、data=なので、dataにCountry_dfを入れる、という意味と同じ

ggplot(data=Country_df) +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018))

# ステップ２：ラベル
# x軸・y軸のラベルを変更する
ggplot(data = Country_df) +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018)) +
  labs(x = "一人当たり購買力平価GDP (USD)", y = "人間開発指数")

# ステップ３：テーマの変更
# テーマを白黒に変更する
ggplot(data = Country_df) +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018)) +
  labs(x = "一人当たり購買力平価GDP (USD)", y = "人間開発指数") +
  theme_bw()

# ステップ３.5：フォントの変更
# フォントを日本語フォントに変更する(Macを使う場合は必要)
ggplot(data = Country_df) +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018)) +
  labs(x = "一人当たり購買力平価GDP (USD)", y = "人間開発指数") +
  theme_bw(base_family = "HiraKakuPro-W3") # base_familyはMacのみ必要

# ステップ４：面積の大きさを追加する。
# ここまでは購買力平価と人間開発指数のみだった。
# 面積という変数を更に追加する
# 面積は大きさで表現するのでsize引数をaesの内側に入れる。

Country_df |>
  mutate(Area2 = Area / 1000000) |> # 面積を100万で割ることで、単位を調整
  ggplot() +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018, size = Area2)) + 
  labs(x = "一人あたり購買力平価GDP (USD)", y = "人間開発指数",
       size = "面積 (100万km2)") +
  theme_bw(base_family = "HiraKakuPro-W3") # base_familyはMacのみ必要

# ステップ５：透明度を調整
# 重なっていると見にくいので、透明度を調整する

Country_df |>
  mutate(Area2 = Area / 1000000) |> # 面積を100万で割ることで、単位を調整
  ggplot() +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018, size = Area2),
             alpha = 0.5) + 
  labs(x = "一人あたり購買力平価GDP (USD)", y = "人間開発指数",
       size = "面積 (100万km2)") +
  theme_bw(base_family = "HiraKakuPro-W3") # base_familyはMacのみ必要


# ステップ６：色分け
# OECDかどうかで色分けする
# colorをaes()の中に加える

Country_df |>
  mutate(Area2 = Area / 1000000) |>
  ggplot() +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018, 
                 size = Area, color = OECD)) +
  labs(x = "一人あたり購買力平価GDP (USD)", y = "人間開発指数",
       size = "面積 (100万km2)", color = "OECD加盟有無") +
  theme_bw(base_family = "HiraKakuPro-W3") # base_familyはMacのみ必要

# ステップ７：OECDをfactor型に変換する

Country_df |>
  mutate(Area2 = Area / 1000000,
         OECD2 = factor(OECD, levels = 0:1, 
                        labels = c("非加盟国", "加盟国"))) |>
  ggplot() +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018, 
                 size = Area2, color = OECD2)) +
  labs(x = "一人あたり購買力平価GDP (USD)", y = "人間開発指数",
       size = "面積 (100万km2)", color = "OECD加盟有無") +
  theme_bw(base_family = "HiraKakuPro-W3") # base_familyはMacのみ必要

# ステップ８：透明度を調整する

Country_df |>
  mutate(Area2 = Area / 1000000,
         OECD2 = factor(OECD, levels = 0:1, 
                        labels = c("非加盟国", "加盟国"))) |>
  ggplot() +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018, 
                 size = Area2, color = OECD2),
             alpha=0.5) +
  labs(x = "一人あたり購買力平価GDP (USD)", y = "人間開発指数",
       size = "面積 (100万km2)", color = "OECD加盟有無") +
  theme_bw(base_family = "HiraKakuPro-W3")  # base_familyはMacのみ必要


# ステップ９：作成した画像をオブジェクトに保存

Country_df |>
  mutate(Area2 = Area / 1000000,
         OECD2 = factor(OECD, levels = 0:1, 
                        labels = c("非加盟国", "加盟国"))) |>
  ggplot() +
  geom_point(aes(x = PPP_per_capita, y = HDI_2018, 
                 size = Area2, color = OECD2),
             alpha=0.5) +
  labs(x = "一人あたり購買力平価GDP (USD)", y = "人間開発指数",
       size = "面積 (100万km2)", color = "OECD加盟有無") +
  theme_bw(base_family = "HiraKakuPro-W3") ->  # base_familyはMacのみ必要
  plot_country 

# ステップ１０：保存

ggsave("kadai1_plot.png",plot=plot_country)
