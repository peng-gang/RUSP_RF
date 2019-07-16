library(shiny)
library(DT)

source("functions.R")

load("www/mma.RData")

#input.data <- read.table("www/mma.new.csv",header = TRUE,sep = ",",stringsAsFactors = FALSE)

shinyServer(function(input, output, session) {
  
  prob <- NULL
  cutoff <- 0.5
  rlt <- NULL
  
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
    if (is.null(inputdata())) return()
    actionButton("action", "Run RUSP_RF")
  })
  
  output$ui.cutoff <- renderUI({
    if (is.null(input$action) ) return()
    if (input$action==0) return()
    
    sliderInput("cutoff", "Cutoff for probability",
                min=0, max=1, value = 0.5, step = 0.05)
  })
  
  output$ui.download <- renderUI({
    if (is.null(input$action)) return()
    if (input$action==0) return()
    downloadButton('download', "Download Results")
  })
  
  observeEvent(input$link_to_tabpanel_about, {
    newvalue <- "about"
    updateTabsetPanel(session, "tabset", newvalue)
  })
  
  observeEvent(
    eventExpr = input$action,
    handlerExpr = {
      output$plot <- renderPlot({
        isolate({
          input.data <- inputdata()
          prob <<- predict(rf.model.mma, input.data, type = "prob")[,2]
          plotBox(prob, prob.mma, y.train, cutoff)
        })
      })
      
      output$table <- DT::renderDataTable({
        DT::datatable({
          isolate({
            input.data <- inputdata()
            rlt <<- data.frame(
              ID = input.data$id,
              Probability = prob,
              Suggestion = ifelse(prob>cutoff, "MMA.TP", "MMA.FP"))
            rlt
          })
        }) %>%
          DT::formatRound('Probability', 2)
      })
    }
  )
  
  observeEvent(
    eventExpr = input$cutoff, handlerExpr = {
      cutoff <<- input$cutoff
      
      output$plot <- renderPlot({
        plotBox(prob, prob.mma, y.train, cutoff)
      })
    }
  )
  
  output$download <- downloadHandler('MMA.rlt.csv', content = function(file) {
    write.csv(rlt, file, row.names = FALSE)
  })
  
  
})



