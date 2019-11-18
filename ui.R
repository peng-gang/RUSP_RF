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
        width = 3,
        tabsetPanel(
          id="tabset",
          tabPanel(
            "Data Input",
            value = "data",
            
            tags$div(
              title = "Which disorder do you want to check?",
              selectInput("disorder", label = h4("Disorder"), 
                          choices = disorder.all, 
                          selected = 1)
            ),
            
            tags$div(
              title = "Which state/NBS program does the data come from",
              selectInput("state", label = h4("NBS Program"),
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
                # label = h5("Choose Input File"),
                multiple = FALSE,
                accept = c("text", "csv file", ".txt", ".csv")
              )
            ),
            
            p(a("Example of input file", href="sample_input_file.csv", download="sample_input_file.csv")),
            # actionLink("link_to_tabpanel_about", "Details about input file format"),
            p(a("Description of file format",
                href = "https://peng-gang.github.io/RUSP_RF_UserGuide/dataformat.html#metabolic-information",
                target = "_blank")),
            
            tags$div(
              title = "Which delimiter is used in the input file",
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
            uiOutput("ui.specificity"),
            # uiOutput("ui.cutoff.legend"),
            uiOutput("ui.render.divider"),
            
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
<<<<<<< HEAD
        plotOutput("plot", width = 515, height = 460),
=======
        plotOutput("plot", width = 515, height = 400),
>>>>>>> 76eb275980f47acc8c3065f5ba186111fbe241ea
        fluidRow(column(6, align="right",
                        uiOutput('ui.download.figure'))),
        hr(),
        DT::dataTableOutput("table", width = 515),
        br(),
        fluidRow(column(6, align="right",
                        uiOutput('ui.download.table')))
      )
    )
  )
)