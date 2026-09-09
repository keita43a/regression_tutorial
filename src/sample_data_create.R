# sample data creation
# エクセルでデータ配布していたが、Windowsユーザーの方で問題が起こることがわかったので
# CSVで配布することにする。
# 自分でデータをダウンロードさせて、dataフォルダーに移動させるとそれだけで時間がかかる学生がいるため、あらかじめdata folderをR上で作成し、
# そこに直接ダウンロードさせるコードを実行する。

getwd()

# library
library(readr)
library(readxl)


# read the musashi students keizai data

data_keizai_2025 <- read_excel("docs/data/musashi_keizai_students_2025.xlsx")
data_jinbun_2025 <- read_excel("docs/data/musashi_jinbun_students_2025.xlsx")
data_teiin_2025 <- read_excel("docs/data/musashi_keizai_teiin_2025.xlsx")

# write out the data into csv
# docs/以下に保存すると、github pagesにアップされるのでURLからアクセスができる　
write_csv(data_keizai_2025, "docs/data/musashi_keizai_students_2025.csv")
write_csv(data_jinbun_2025, "docs/data/musashi_jinbun_students_2025.csv")
write_csv(data_teiin_2025, "docs/data/musashi_keizai_teiin_2025.csv")
