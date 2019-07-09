library(shiny)


shinyServer(function(input, output, session) {
  
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
  
  observeEvent(input$link_to_tabpanel_about, {
    newvalue <- "about"
    updateTabsetPanel(session, "tabset", newvalue)
  })
})