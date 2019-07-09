library(shiny)

shinyUI(
  fluidPage(
    titlePanel("NBSRF",
               title = tags$strong("Newborn Screening with Random Forest")),
    
    sidebarLayout(
      sidebarPanel(
        tabsetPanel(
          id="tabset",
          tabPanel(
            "Data Input",
            value = "data",
            
            tags$div(
              title = "What kind of disease do you want to check?",
              selectInput("disease", label = h3("Disease"), 
                          choices = list(
                            "MMA" = "mma", 
                            "GA-1" = "ga1", 
                            "OTC" = "otc",
                            "VLCADD" = "vlcadd"), 
                          selected = "mma")
            ),
            
            tags$div(
              title = "Which state does the data come from",
              selectInput("state", label = h3("State"),
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
            
            p(a("Example of input File", href="mma.csv", download="mma.csv")),
            actionLink("link_to_tabpanel_about", "Details about input file format"),
            
            uiOutput('ui.action'),
            hr(),
            uiOutput("ui.cutoff")
          ),
          
          tabPanel(
            "About",
            value = "about",
            h4(tags$strong("About NBSRF")),
            p(
              "This web application shows the dynamic changes in newborn metabolism in relation to birth weight,
            gestational age, sex, and race/ethnicity and to assess variable levels of specific screening markers for
            inborn metabolic disorders."
            ),
            h4(tags$strong("Instructions")),
            h4(tags$strong("Data")),
            p("Input data format"),
            h4(tags$strong("Code")),
            p(
              a("Source Code",
                href = "https://github.com/peng-gang/RUSP_RF", target = "_blank")
            ),
            p(
              "Built with ",
              a("R",
                href = "https://www.r-project.org", target = "_blank"),
              "and the ",
              a("Shiny framework.",
                href = "http://shiny.rstudio.com", target = "_blank")
            )
          )
        )
      ),
      
      mainPanel(
        plotOutput("plot")
      )
    )
  )
)