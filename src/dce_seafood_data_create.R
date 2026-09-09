# 選択実験（Discrete Choice Experiment）の演習用データを生成するスクリプト
#
# 第\@ref(dce)章で使う「水産物の選択実験」の**架空データ**を作成する。
# 実在の調査データではなく、あらかじめ決めた選好パラメータから
# 回答をシミュレートしたものである。真の値がわかっているので、
# 推定されたMWTPが真の値に近づくかを学生が確認できる。
#
# 出力:
#   data/dce_seafood_design.csv  … 選択肢集合のデザイン行列（24行）
#   data/dce_seafood_res.csv     … 回答データ（300人 × 8問）
#   docs/data/ にも同じものをコピー（受講生のダウンロード用）

pacman::p_load(support.CEs, tidyverse)

# ---- 1. 選択肢集合の設計 --------------------------------------------------

# 属性と水準。各属性の「最初の水準」が基準（ダミー変数の0）になるので、
# 望ましくない方の水準を先に置いておく。
attr_list <- list(
  production = c("天然", "養殖"),
  ecolabel   = c("なし", "あり"),
  origin     = c("輸入", "国産"),
  price      = c("400", "600", "800", "1000")
)

# seed = 1234 は、非価格属性が全く同じ（＝価格だけが違う支配的な）組み合わせが
# 発生しないものを選んである。
design <- rotation.design(
  attribute.names = attr_list,
  nalternatives   = 2,
  nblocks         = 1,
  row.renames     = FALSE,
  randomize       = TRUE,
  seed            = 1234
)

design_matrix <- make.design.matrix(
  choice.experiment.design = design,
  optout                   = TRUE,
  categorical.attributes   = c("production", "ecolabel", "origin"),
  continuous.attributes    = c("price"),
  unlabeled                = TRUE
)

# ---- 2. 真の選好パラメータ ------------------------------------------------

# ASC は「どちらかを買う」ことの効用（買わない=0 との差）。
# 真のMWTP = -β / β_price なので、
#   あり  :  -0.8  / -0.004 =  200円
#   国産  :  -0.6  / -0.004 =  150円
#   養殖  : -(-0.4)/ -0.004 = -100円
beta_true <- c(ASC = 3.0, `養殖` = -0.4, `あり` = 0.8, `国産` = 0.6, price = -0.004)

X <- as.matrix(design_matrix[, names(beta_true)])
V <- as.vector(X %*% beta_true)

# ---- 3. 回答のシミュレーション --------------------------------------------

set.seed(634)

n_respondents <- 300
n_questions   <- max(design_matrix$QES)

res <- data.frame(ID = 1:n_respondents, BLOCK = 1L)

for (q in 1:n_questions) {
  idx <- which(design_matrix$QES == q)  # 選択肢1・2・「どちらも買わない」の3行

  # 確定効用 + 第I型極値分布（Gumbel）誤差 → 効用最大の選択肢を選ぶ
  gumbel <- -log(-log(matrix(runif(n_respondents * 3), nrow = n_respondents)))
  utility <- matrix(V[idx], nrow = n_respondents, ncol = 3, byrow = TRUE) + gumbel

  res[[paste0("q", q)]] <- max.col(utility)
}

# ---- 4. 出力 --------------------------------------------------------------

fs::dir_create("data")
write_csv(design_matrix, "data/dce_seafood_design.csv")
write_csv(res,           "data/dce_seafood_res.csv")

# 受講生がダウンロードできるよう公開ディレクトリにも置く
fs::dir_create("docs/data")
write_csv(design_matrix, "docs/data/dce_seafood_design.csv")
write_csv(res,           "docs/data/dce_seafood_res.csv")

# ---- 5. 確認：真の値を回収できるか ----------------------------------------

pacman::p_load(survival)

dataset <- make.dataset(
  respondent.dataset = res,
  design.matrix      = design_matrix,
  choice.indicators  = paste0("q", 1:n_questions),
  detail             = FALSE
)

fm <- clogit(RES ~ ASC + `養殖` + `あり` + `国産` + price + strata(STR), data = dataset)

cat("\n---- 推定値と真の値 ----\n")
print(data.frame(
  推定値 = round(coef(fm), 4),
  真の値 = beta_true[names(coef(fm))]
))

cat("\n---- MWTP（真の値: 養殖 -100円, あり 200円, 国産 150円）----\n")
print(mwtp(
  output                = fm,
  monetary.variables    = "price",
  nonmonetary.variables = c("養殖", "あり", "国産"),
  seed                  = 1
))
