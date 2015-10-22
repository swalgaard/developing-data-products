library(shiny)

shinyUI(
      fluidPage(
            titlePanel("Data export"),
            sidebarLayout(
                  sidebarPanel(
                        
                        # UI control is build in the server part
                        uiOutput("files"),
                        uiOutput("colNames"),
                        
                        selectInput("start_format", label = h3("Define a time format"),
                                    choices = c("unix timestamp","yy-mm-dd HH:MM:SS")),
                        
                        downloadButton('downloadData','Export data')
                        
                  ),
                  
                  mainPanel(
                        fluidRow(
                              dataTableOutput(outputId="table")
                        )    
                  )
            )
      )  
)
