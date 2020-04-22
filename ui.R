library(shiny)

shinyUI(pageWithSidebar(
  headerPanel(div(HTML("<em>Topological Scores:TopS"))),  
  sidebarPanel(
    fileInput('file1', 'Choose a CSV File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    tags$hr(),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator',
                 c(Comma=',',
                   Semicolon=';',
                   Tab='\t'),
                 'Comma'),
    radioButtons('quote', 'Quote',
                 c(None='',
                   'Double Quote'='"',
                   'Single Quote'="'"),
                 'Double Quote'),
    
    fileInput('file2', 'Choose a txt File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    tags$hr()
     
  ),
  
  mainPanel(
    h4("Summary of spectral counting"),
    tableOutput("view"),
    h4("Summary of topological scores"),
    tableOutput("view1"),
    plotOutput("newHist"),
    verbatimTextOutput("oid1"),
    verbatimTextOutput("oid2"),
    verbatimTextOutput("oid3"),
    verbatimTextOutput("oid4"),
    verbatimTextOutput("oid5"),
    tabPanel("Heatmap", plotOutput("plot1", height="600px")),
    verbatimTextOutput("oid6"),
    tabPanel("hclust",plotOutput("plot2", height="600px")),
    verbatimTextOutput("oid7"),
    tabPanel("hclust",plotOutput("plot3", height="600px"))    
    
  )
  
))

