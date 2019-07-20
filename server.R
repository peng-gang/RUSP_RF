library(shiny)
library(shinyjs)
library(DT)

source("functions.R")
source("parameter.R")

load("www/models.RData")
cutoff.suggest <- rep(0.5, 4)

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
    
    cutoff <<- cutoff.suggest[idx.disorder]
    sliderInput("cutoff", "Cutoff for probability",
                min=0, max=1, value = cutoff.suggest[idx.disorder], step = 0.01)
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
      idx.disorder <- as.integer(input$disorder)
      
      output$plot <- renderPlot({
        isolate({
          input.data <- inputdata()
          cname <- colnames(input.data)
          tmp <- colname.format(cname)
          if(!is.null(tmp$cname.notfount)){
            
          }
          colnames(input.data) <- tmp$cname.new
          
          prob <<- predict(models[[idx.disorder]], input.data, type = "prob")[,2]
          plotBox(prob, train.rlt[[idx.disorder]]$prob, train.rlt[[idx.disorder]]$y, 0.5, cutoff)
        })
      })
      
      output$table <- DT::renderDataTable({
        DT::datatable({
          isolate({
            input.data <- inputdata()
            cname <- colnames(input.data)
            tmp <- colname.format(cname)
            colnames(input.data) <- tmp$cname.new
            rlt <<- data.frame(
              ID = input.data$id,
              Probability = prob,
              Suggestion = ifelse(prob>=cutoff.suggest[idx.disorder], "TP", "FP"),
              Selected = ifelse(prob>=cutoff, "TP", "FP"))
            rlt
          })
        }, rownames = FALSE) %>%
          DT::formatRound('Probability', 2)
      })
    }
  )
  
  observeEvent(
    eventExpr = input$cutoff, handlerExpr = {
      cutoff <<- input$cutoff
      idx.disorder <- as.integer(input$disorder)
      
      output$plot <- renderPlot({
        plotBox(prob, train.rlt[[idx.disorder]]$prob, train.rlt[[idx.disorder]]$y, 0.5, cutoff)
      })
      
      output$table <- DT::renderDataTable({
        DT::datatable({
          isolate({
            input.data <- inputdata()
            cname <- colnames(input.data)
            tmp <- colname.format(cname)
            colnames(input.data) <- tmp$cname.new
            rlt <<- data.frame(
              ID = input.data$id,
              Probability = prob,
              Suggestion = ifelse(prob>=cutoff.suggest[idx.disorder], "TP", "FP"),
              Selected = ifelse(prob>=cutoff, "TP", "FP"))
            rlt
          })
        }, rownames = FALSE) %>%
          DT::formatRound('Probability', 2)
      })
    }
  )
  
  observeEvent(
    eventExpr = input$disorder, handlerExpr = {
      if(!is.null(input$action) && input$disorder != disorder.sel){
        showModal(
          modalDialog(
            p("If you choose to continue, the current input file and the results will be cleared. Please download the results beforehand if you prefer to keep a record."),
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
      output$plot <- NULL
      output$table <- NULL
      prob <<- NULL
      rlt <<- NULL
      
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
        plotBox(prob, train.rlt[[idx.disorder]]$prob, train.rlt[[idx.disorder]]$y, 0.5, cutoff, s)
      })
    }
  )
  
  output$downloadtable <- downloadHandler('rlt.csv', content = function(file) {
    write.csv(rlt, file, row.names = FALSE)
  })
  
  output$downloadfigure <- downloadHandler("figure.pdf", content = function(file) {
    pdf(file)
    idx.disorder <- as.integer(input$disorder)
    print(plotBox(prob, train.rlt[[idx.disorder]]$prob, train.rlt[[idx.disorder]]$y, 0.5, cutoff))
    dev.off()
  })
  
})



