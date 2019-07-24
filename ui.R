library(shiny)
library(DT)
library(markdown)

source("parameter.R")

shinyUI(
  fluidPage(
    titlePanel("RUSPtools",
               title = tags$strong("Newborn Screening with Random Forest")),
    
    sidebarLayout(
      sidebarPanel(
        tabsetPanel(
          id="tabset",
          tabPanel(
            "Data Input",
            value = "data",
            
            tags$div(
              title = "What kind of disorder do you want to check?",
              selectInput("disorder", label = h4("Disorder"), 
                          choices = disorder.all, 
                          selected = 1)
            ),
            
            tags$div(
              title = "Which state does the data come from",
              selectInput("state", label = h4("State"),
                          choices = list(
                            "California" = "california"
                          ),
                          selected = "california")
            ),
            
            
            tags$div(
              title = "Please select your input file",
              fileInput(
                "inputdata",
                "Choose Input File",
                multiple = FALSE,
                accept = c("text", "csv file", ".txt", ".csv")
              )
            ),
            
            p(a("Example of input File", href="sample_input_file.csv", download="sample_input_file.csv")),
            actionLink("link_to_tabpanel_about", "Details about input file format"),
            
            tags$div(
              title = "What kind of delimiter is used in input file",
              radioButtons(
                "delimiter",
                h4("Delimiters"),
                choices = list(
                  "Comma" = ",",
                  "Semicolon" = ";",
                  "Tab" = "\t",
                  "Space" = " "
                ),
                selected = ","
              )
            ),
            
            
            uiOutput('ui.action'),
            hr(),
            
            uiOutput("ui.cutoff"),
            
            p(
              "Copyright 2019 by ",
              a("Gang Peng ",
                href = "https://publichealth.yale.edu/people/gang_peng-1.profile",
                target = "_blank"),
              "and ",
              a("Curt Scharfe.",
                href = "https://medicine.yale.edu/genetics/people/curt_scharfe-2.profile",
                target = "_blank")
            ),
            p(
              "Report issues to the",
              a("developers.",
                href = "mailto:gang.peng@yale.edu")
            )
          ),
          
          tabPanel(
            "About",
            value = "about",
            includeMarkdown("content/About.md"),
            hr(),
            p(
              "Copyright 2019 by ",
              a("Gang Peng ",
                href = "https://publichealth.yale.edu/people/gang_peng-1.profile",
                target = "_blank"),
              "and ",
              a("Curt Scharfe.",
                href = "https://medicine.yale.edu/genetics/people/curt_scharfe-2.profile",
                target = "_blank")
            ),
            p(
              "Report issues to the",
              a("developers.",
                href = "mailto:gang.peng@yale.edu")
            )
            
            
          )
        )
      ),
      
      mainPanel(
        plotOutput("plot", width = 600, height = 600),
        fluidRow(column(7, align="right",
                        uiOutput('ui.download.figure'))),
        hr(),
        DT::dataTableOutput("table", width = 600),
        br(),
        fluidRow(column(7, align="right",
                        uiOutput('ui.download.table')))
      )
    )
  )
)