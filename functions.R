#RF functions
library(randomForest)
library(ggplot2)

source("parameter.R")

percent.format <- function(pc, ns = 2){
  paste0(format(round(pc*100, ns), nsmall = ns), "%")
}


colname.format <- function(colnames.old){
  cname.new <- NULL
  cname.code <- names(colname.list)
  cname.notfount <- NULL
  for(cname in colnames.old){
    found <- FALSE
    for(i in 1:length(colname.list)){
      if(toupper(cname) %in% colname.list[[i]]){
        cname.new <- c(cname.new, cname.code[i])
        found <- TRUE
        next
      }
    }
    if(!found){
      cname.new <- c(cname.new, cname)
      cname.notfount <- c(cname.notfount, cname)
    }
  }
  rlt <- list(
    cname.new = cname.new,
    cname.notfount = cname.notfount
  )
  rlt
}



plotBox <- function(prob, prob.train, y.train, cutoff.suggest, cutoff.sel, point.sel=NULL){
  dplot <- data.frame(group = y.train, p = prob.train, stringsAsFactors = FALSE)
  dplot$group <- factor(dplot$group, levels = c("FP", "NewData", "TP"))
  dplot.point <- data.frame(
    group = factor(rep("NewData", length(prob)), levels = c("FP", "NewData", "TP")),
    p = prob
  )
  num.TP <- sum(dplot$group=="TP")
  num.FP <- sum(dplot$group=="FP")
  num.FN <- sum(dplot$p[dplot$group=="TP"]<cutoff.sel)
  num.FP.RF <- sum(dplot$p[dplot$group=="FP"]>=cutoff.sel)
  
  gp <- ggplot(dplot, aes(x=group, y=p)) + 
    geom_boxplot(aes(color = group, fill = group), outlier.colour = NULL, outlier.fill = NULL,
                 show.legend = FALSE) + 
    #geom_boxplot(aes(fill = group))+
    labs(x = "", y = "RF Score") + 
    scale_fill_manual(values=c("#00A1D599", "#B2474599")) + 
    scale_color_manual(values = c("#00A1D599", "#B2474599")) +
    theme_bw() +
    theme(legend.title=element_blank(), legend.position = "bottom",
          legend.key.width = unit(2,"cm"), legend.text = element_text(size=15))
  gp <- gp + geom_point(data = dplot.point[dplot.point$p>=cutoff.sel,], 
                        aes(x=group, y=p), color = "#B24745FF", size = 3) +
    geom_point(data = dplot.point[dplot.point$p<cutoff.sel,], 
               aes(x=group, y=p), color = "#00A1D5FF", size = 3) +
    theme(axis.text = element_text(size = 15), axis.title = element_text(size=16))
  gp <- gp + scale_x_discrete(labels=c("FP" = paste0("FP (",num.FP.RF, "/", num.FP, "=", 
                                                     percent.format(num.FP.RF/num.FP, 1), ")"), 
                                       "NewData" = paste0("NewData (", length(prob), ")"),
                                       "TP" = paste0("TP (", num.FN, "/", num.TP, "=",
                                                     percent.format(num.FN/num.TP, 1), ")")))
  
  
  if(!is.null(point.sel)){
    dplot.point.sel <- dplot.point[point.sel,]
    gp <- gp + geom_point(data = dplot.point.sel[dplot.point.sel$p>=cutoff.sel,], 
                          aes(x=group, y=p), color = "#B24745FF", size = 5, shape = 1) +
      geom_point(data = dplot.point.sel[dplot.point.sel$p<cutoff.sel,], 
                 aes(x=group, y=p), color = "#00A1D5FF", size = 5, shape = 1)
  }
  
  gp <- gp + 
    geom_hline(data = data.frame(y=c(cutoff.suggest, cutoff.sel),
                                 type = c("Default Cutoff", "User Cutoff")),
               aes(yintercept=y, linetype=type), 
               #yintercept = cutoff.suggest, 
               color = "#DF8F44FF", size = 2) + 
    scale_linetype_manual(values=c("solid", "dotted"))
  gp
}


plotBoxDefault <- function(prob.train, y.train, cutoff.suggest){
  dplot <- data.frame(group = y.train, p = prob.train, stringsAsFactors = FALSE)
  dplot$group <- factor(dplot$group, levels = c("FP", "NewData", "TP"))
  
  gp <- ggplot(dplot, aes(x=group, y=p)) + 
    geom_boxplot(aes(color = group, fill = group), outlier.colour = NULL, outlier.fill = NULL,
                 show.legend = FALSE) + 
    #geom_boxplot(aes(fill = group))+
    labs(x = "", y = "RF Score") + 
    scale_fill_manual(values=c("#00A1D599", "#B2474599")) + 
    scale_color_manual(values = c("#00A1D599", "#B2474599")) +
    theme_bw() +
    theme(legend.title=element_blank(), legend.position = "bottom",
          legend.key.width = unit(2,"cm"), legend.text = element_text(size=15))
  gp <- gp + theme(axis.text = element_text(size = 15), axis.title = element_text(size=16))
  gp <- gp + scale_x_discrete(labels=c("FP" = "FP", 
                                       "NewData" = "NewData",
                                       "TP" = "TP"))
  gp <- gp + 
    geom_hline(data = data.frame(y=c(cutoff.suggest, cutoff.suggest),
                                 type = c("Default Cutoff", "User Cutoff")),
               aes(yintercept=y, linetype=type), 
               #yintercept = cutoff.suggest, 
               color = "#DF8F44FF", size = 2) + 
    scale_linetype_manual(values=c("solid", "dotted"))
  gp
}

