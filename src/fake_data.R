# fake data generator

# 
pacman::p_load(
  tidyverse,
  readxl,
  ggpmisc,
  ggdist
)


# 身長と体重
# https://excelmath.atelierkobato.com/height/

dat1 = read_excel("data/weight_height.xlsx")

ggplot(dat1, aes(x=weight_kg,y=height_cm)) + 
  geom_point()+
  labs(x="体重", y="身長") + 
  theme_bw(base_family = "HiraKakuPro-W3")

mod1 <- lm(weight_kg ~ height_cm, data=dat1)
sd(mod1$residuals)

set.seed(3)

dat2 = tibble(
  height_cm = rnorm(500, mean=170,sd=10)
) %>%
  mutate(weight_kg = predict(mod1,newdata=.) + rnorm(n(),0,15))

ggplot(dat2, aes(x=weight_kg,y=height_cm)) + 
  geom_point()+
  geom_smooth(method="lm") +
  stat_poly_eq(aes(label = paste(after_stat(eq.label),
                                 after_stat(rr.label), sep = "*\", \"*"))) +
  labs(x="体重", y="身長") + 
  theme_bw(base_family = "HiraKakuPro-W3") +
  theme(text = element_text(size=15))

# data two groups comparison

data(PlantGrowth)

ggplot(PlantGrowth %>% filter(group != "trt1"), aes(x=group,y=weight))+ 
  ## add half-violin from {ggdist} package
  ggdist::stat_halfeye(
    ## custom bandwidth
    adjust = .5, 
    ## adjust height
    width = .6, 
    ## move geom to the right
    justification = -.2, 
    ## remove slab interval
    .width = 0, 
    point_colour = NA
  ) + 
  geom_boxplot(
    width = .12, 
    ## remove outliers
    outlier.color = NA ## `outlier.shape = NA` works as well
  ) +
  ## add dot plots from {ggdist} package
  ggdist::stat_dots(
    ## orientation to the left
    side = "left", 
    ## move geom to the left
    justification = 1.1, 
    ## adjust grouping (binning) of observations 
    binwidth = .05
  ) + 
  ## remove white space on the left
  coord_cartesian(xlim = c(1.2, NA))+ 
  labs(x="グループ", y="重さ", title="植物の成長：肥料による違い") + 
  theme_bw(base_family = "HiraKakuPro-W3") +
  theme(text = element_text(size=15))
