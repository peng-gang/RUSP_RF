library(shiny)
library(shinyjs)
library(DT)

source("functions.R")
source("parameter.R")

load("www/models.RData")
load("www/cutoff.RData")
#cutoff.suggest <- c(0.01, 0.08, 0.01, 0.1)

#input.data <- read.table("www/mma.new.csv",header = TRUE,sep = ",",stringsAsFactors = FALSE)

shinyServer(function(input, output, session) {
  
  prob <- NULL
  cutoff <- 0.5
  rlt <- NULL
  disorder.sel <- "1"
  
  inputdata <- reactive({
    infile <- input$inputdata
    if (is.null(infile)){
      return(NULL)
    }
    read.table(
      infile$datapath,
      header = TRUE,
      sep = input$delimiter,
      stringsAsFactors = FALSE)
  })
  
  output$ui.action <- renderUI({
    #if (is.null(inputdata())) return()
    if (is.null(input$inputdata)) return()
    actionButton("action", "Run RUSP_RF")
  })
  
  output$ui.cutoff <- renderUI({
    #if (is.null(inputdata())) return()
    if (is.null(input$inputdata)) return()
    if (is.null(input$action) ) return()
    if (input$action==0) return()
    
    idx.disorder <- as.integer(input$disorder)
    
    step <- round(1.0/nrow(cutoff.all[[idx.disorder]]), digits = 2)
    cutoff <<- 1-num.TN.NBS[[idx.disorder]] * step
    sliderInput("cutoff", "Estimated Sensitivity",
                min=0, max=1, 
                value = 1-num.TN.NBS[[idx.disorder]] * step, 
                step = step)
  })
  
  output$ui.cutoff.legend <- renderUI({
    #if (is.null(inputdata())) return()
    if (is.null(input$inputdata)) return()
    if (is.null(input$action) ) return()
    if (input$action==0) return()
    
    fluidRow(tags$img(style="height:30 px; width:45%", src='cutoff_legend.png'))
  })
  
  output$ui.specificity <- renderUI({
    if (is.null(input$inputdata)) return()
    if (is.null(input$action) ) return()
    if (input$action==0) return()
    
    idx.disorder <- as.integer(input$disorder)
    
    verbatimTextOutput("specificity")
  })
  
  output$ui.render.divider <- renderUI({
    #if (is.null(inputdata())) return()
    if (is.null(input$inputdata)) return()
    if (is.null(input$action) ) return()
    if (input$action==0) return()
    
    hr()
  })
  
  output$ui.download.table <- renderUI({
    #if (is.null(inputdata())) return()
    if (is.null(input$inputdata)) return()
    if (is.null(input$action)) return()
    if (input$action==0) return()
    downloadButton('downloadtable', "Download Results")
  })
  
  
  output$ui.download.figure <- renderUI({
    #if (is.null(inputdata())) return()
    if (is.null(input$inputdata)) return()
    if (is.null(input$action)) return()
    if (input$action==0) return()
    downloadButton('downloadfigure', "Download Figure")
  })
  
  observeEvent(input$link_to_tabpanel_about, {
    newvalue <- "about"
    updateTabsetPanel(session, "tabset", newvalue)
  })
  
  observeEvent(
    eventExpr = input$action,
    handlerExpr = {
      disorder.sel <<- input$disorder
      idx.disorder <- as.integer(input$disorder)
      
      idx.cutoff <- round((1-cutoff) * nrow(cutoff.all[[idx.disorder]]))
      output$specificity <- renderText(
        paste0("Estimated Specificity: ", 
               round(cutoff.all[[idx.disorder]][idx.cutoff+1, "specificity"], 2))
      )
      
      output$plot <- renderPlot({
        isolate({
          input.data <- inputdata()
          cname <- colnames(input.data)
          tmp <- colname.format(cname)
          if(!is.null(tmp$cname.notfount)){
            showModal(modalDialog(
              title = "Column Name",
              paste0("The following column(s) in the input file cannot be matched to the model:\n",
                     paste(tmp$cname.notfount, collapse = "\n"))
            ))
          }
          
          colnames(input.data) <- tmp$cname.new
          
          prob <<- predict(models[[idx.disorder]], input.data, type = "prob")[,2]
          #idx.cutoff <- round((1-cutoff) * nrow(cutoff.all[[idx.disorder]]))
          #print(cutoff)
          # print(idx.cutoff)
          # print(idx.disorder)
          # print(prob)
          # print(train.rlt[[idx.disorder]]$prob)
          # print(train.rlt[[idx.disorder]]$y)
          # print(cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"])
          #print(cutoff.all[[idx.disorder]][ idx.cutoff+1, "cutoff"])
          
          plotBox(prob, train.rlt[[idx.disorder]]$prob, train.rlt[[idx.disorder]]$y, 
                  cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"], 
                  cutoff.all[[idx.disorder]][idx.cutoff+1, "cutoff"])
        })
      })
      
      output$table <- DT::renderDataTable({
        DT::datatable({
          isolate({
            input.data <- inputdata()
            cname <- colnames(input.data)
            tmp <- colname.format(cname)
            colnames(input.data) <- tmp$cname.new
            #idx.cutoff <- round((1-cutoff) * nrow(cutoff.all[[idx.disorder]]))
            rlt <<- data.frame(
              ID = input.data$id,
              Probability = prob,
              Default_Cutoff = ifelse(prob>=cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"], "TP", "FP"),
              User_Cutoff = ifelse(prob>=cutoff.all[[idx.disorder]][idx.cutoff+1, "cutoff"], "TP", "FP"))
            rlt
          })
        }, 
        rownames = FALSE,
        options = list(
          pageLength= 10, lengthMenu = c(5, 10, 20, 50, 100, 200),
          columnDefs = list(list(className = 'dt-center', targets = '_all')))) %>%
          DT::formatRound('Probability', 2) %>% formatStyle(columns = c('Default_Cutoff', 'User_Cutoff'),
                                                            color = styleEqual(c("TP","FP"),
                                                                               c("#F46A4E", "#043D8C")))
      })
    }
  )
  
  observeEvent(
    eventExpr = input$cutoff, handlerExpr = {
      cutoff <<- input$cutoff
      idx.disorder <- as.integer(input$disorder)
      idx.cutoff <- round((1-cutoff) * nrow(cutoff.all[[idx.disorder]]))
      
      output$specificity <- renderText(
        paste0("Estimated Specificity: ", 
               round(cutoff.all[[idx.disorder]][idx.cutoff+1, "specificity"], 2))
      )
      
      output$plot <- renderPlot({
        #idx.cutoff <- round((1-cutoff) * nrow(cutoff.all[[idx.disorder]]))
        plotBox(prob, train.rlt[[idx.disorder]]$prob, train.rlt[[idx.disorder]]$y, 
                cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"], 
                cutoff.all[[idx.disorder]][idx.cutoff+1, "cutoff"])
      })
      
      output$table <- DT::renderDataTable({
        DT::datatable({
          isolate({
            input.data <- inputdata()
            cname <- colnames(input.data)
            tmp <- colname.format(cname)
            colnames(input.data) <- tmp$cname.new
            #idx.cutoff <- round((1-cutoff) * nrow(cutoff.all[[idx.disorder]]))
            rlt <<- data.frame(
              ID = input.data$id,
              Probability = prob,
              Default_Cutoff = ifelse(prob>=cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"], "TP", "FP"),
              User_Cutoff = ifelse(prob>=cutoff.all[[idx.disorder]][idx.cutoff+1, "cutoff"], "TP", "FP"))
            rlt
          })
        }, rownames = FALSE,
        options = list(
          pageLength= 10, lengthMenu = c(5, 10, 20, 50, 100, 200),
          columnDefs = list(list(className = 'dt-center', targets = '_all')))) %>%
          DT::formatRound('Probability', 2) %>% formatStyle(columns = c('Default_Cutoff', 'User_Cutoff'),
                                                            color = styleEqual(c("TP","FP"),
                                                                               c("#F46A4E", "#043D8C")))
      })
    }
  )
  
  observeEvent(
    eventExpr = input$disorder, handlerExpr = {
      if(is.null(input$action)){
        idx.disorder <- as.integer(input$disorder)
        
        output$plot <- renderPlot({
          plotBoxDefault(train.rlt[[idx.disorder]]$prob, 
                         train.rlt[[idx.disorder]]$y, 
                         cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"])
        })
      }
      
      if(!is.null(input$action) && input$disorder != disorder.sel){
        showModal(
          modalDialog(
            p("If you choose to continue, the current results will be cleared. Please download the results beforehand if you prefer to keep a record."),
            title = "You are navigating to a different disease type",
            footer = tagList(
              actionButton("no", "Cancel"),
              actionButton("yes", "Continue")
            )
          )
        )
      }
    }
  )
  
  observeEvent(
    eventExpr = input$yes, handlerExpr = {
      disorder.sel <<- input$disorder
      # clean results
      idx.disorder <- as.integer(input$disorder)
      output$plot <- renderPlot({
        plotBoxDefault(train.rlt[[idx.disorder]]$prob, 
                       train.rlt[[idx.disorder]]$y, 
                       cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"])
      })
      output$table <- NULL
      prob <<- NULL
      rlt <<- NULL
      
      #step <- round(1.0/nrow(cutoff.all[[idx.disorder]]), digits = 2)
      #cutoff <<- num.TN.NBS[[idx.disorder]] * step
      #print(cutoff)
      
      # output$ui.action <- NULL
      # output$ui.cutoff <- NULL
      # output$ui.download.figure <- NULL
      # output$ui.download.table <- NULL
      shinyjs::reset("inputdata")
      removeModal()
    }
  )
  
  observeEvent(
    eventExpr = input$no, handlerExpr = {
      updateSelectInput(session, "disorder",
                        selected = disorder.sel)
      removeModal()
    }
  )
  
  observeEvent(
    eventExpr = input$table_rows_selected, handlerExpr = {
      idx.disorder <- as.integer(input$disorder)
      output$plot <- renderPlot({
        s <- input$table_rows_selected
        idx.cutoff <- round((1-cutoff) * nrow(cutoff.all[[idx.disorder]]))
        plotBox(prob, train.rlt[[idx.disorder]]$prob, train.rlt[[idx.disorder]]$y, 
                cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"], 
                cutoff.all[[idx.disorder]][idx.cutoff+1, "cutoff"], s)
      })
    }
  )
  
  output$downloadtable <- downloadHandler('rlt.csv', content = function(file) {
    write.csv(rlt, file, row.names = FALSE)
  })
  
  output$downloadfigure <- downloadHandler("figure.pdf", content = function(file) {
    pdf(file)
    idx.disorder <- as.integer(input$disorder)
    idx.cutoff <- round( (1-cutoff) * nrow(cutoff.all[[idx.disorder]]))
    print(plotBox(prob, train.rlt[[idx.disorder]]$prob, train.rlt[[idx.disorder]]$y, 
                  cutoff.all[[idx.disorder]][num.TN.NBS[[idx.disorder]]+1, "cutoff"], 
                  cutoff.all[[idx.disorder]][idx.cutoff+1, "cutoff"]))
    dev.off()
  })
  
})



