library(shiny)

# Define a server for the Shiny app
shinyServer(function(input, output) 
{
      currFiles <- list.files("data/")
      
      # UI for showing data files. The UI must be in the server part, because it depends on the directory of the R file.
      output$files <- renderUI(
            {
                  selectInput("file", label = h3("Select a file"),
                              choices = currFiles)
            })
      
      
      df <- reactive(
            {
                  filename <- paste(getwd(),"data",input$file,sep = "/") 
                  get(load(filename))
            })
      
      
      # UI for showing columns, this should be in server, because the UI does not know the df beforehand.
      output$colNames <- renderUI(
            {
                  checkboxGroupInput('show_vars', label = h3('Columns to show'),
                                     names(df()), selected = names(df()))
            })
      
      # Render the table according to selected columns
      output$table <- renderDataTable(
            {
                  dataFrame <- df()
                  if (input$start_format == "unix timestamp")
                  {
                        if (length(dataFrame$end) != 0)
                        {
                        dataFrame$end <- as.numeric(dataFrame$end)
                        }
                        dataFrame$start <- as.numeric(dataFrame$start)
                  }
                  dataFrame[, input$show_vars, drop = FALSE]
            })
      
      # Download the data as a csv file
      output$downloadData <- downloadHandler(
            filename = function() 
            { 
                  paste("df", ".csv", sep = "") 
            },
            content = function(file) 
            {
                  write.csv(df()[, input$show_vars, drop = FALSE], file, row.names = FALSE)
            })
      
})

