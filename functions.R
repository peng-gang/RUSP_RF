#RF functions
library(randomForest)
library(ggplot2)

plotBox <- function(prob, prob.train, y.train, cutoff){
  dplot <- data.frame(group = y.train, p = prob.train)
  dplot.point <- data.frame(
    group = ifelse(prob>cutoff, "MMA.TP", "MMA.FP"),
    p = prob
  )
  gp <- ggplot(dplot, aes(x=group, y=p)) + 
    geom_boxplot(aes(color = group, fill = group), outlier.colour = NULL, outlier.fill = NULL) + 
    #geom_boxplot(aes(fill = group))+
    labs(x = "", y = "Probability") + 
    scale_fill_manual(values=c("#00A1D599", "#B2474599")) + 
    scale_color_manual(values = c("#00A1D599", "#B2474599")) +
    theme_bw() +
    theme(legend.title=element_blank())
  gp <- gp + geom_point(data = dplot.point[dplot.point$group=="MMA.TP",], 
                        aes(x=group, y=p), color = "#B24745FF", size = 3) +
    geom_point(data = dplot.point[dplot.point$group=="MMA.FP",], 
               aes(x=group, y=p), color = "#6A6599FF", size = 3) +
    theme(axis.text = element_text(size = 15), axis.title = element_text(size=18),
          legend.text = element_text(size=18))
  gp <- gp + geom_hline(yintercept = cutoff, color = "brown", size = 2)
  gp
}