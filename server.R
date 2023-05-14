shhh <- suppressPackageStartupMessages # It's a library, so shhh!
shhh(library(shiny))
shhh(library(shinydashboard))
shhh(library(data.table))
shhh(library(dplyr))
shhh(library(plotly))
shhh(library(ggplot2))
shhh(library(DT))
shhh(library(openxlsx))
shhh(library(webshot))


# function to create timetables with 2 different variables
plot_lines <- function(data,
                   var_x ,
                   var1_y ,
                   var2_y ,
                   var_group,
                   tit ) {
  
  #db_pro[, COSECHA_CAT := as.factor(paste(COSECHA, CAT))]
  p <-
      ggplot(data) +
      geom_line(mapping = aes_string(x = var_x,
                                     y = var1_y,
                        color = var_group),
                linetype = "solid") +
      geom_line(mapping = aes_string(x = var_x,
                                     y = var2_y,
                        color = var_group),
                  linetype = "dotted") +
      geom_point(mapping = aes_string(x = var_x,
                                     y = var1_y,
                        color = var_group),
                shape = 21) +
      geom_point(mapping = aes_string(x = var_x,
                                     y = var2_y,
                        color = var_group),
                 shape = 21) +
      scale_color_viridis_d() +
      theme_light() 
      # +
      # labs(x = "Meses de maduración",
      #     y = variable,
      #     title = tit)
  return(p)
}


plot_bars <- function(data,
                   Val,
                   Cat,
                   tit ) {
  # Create the barplot using ggplot
  p <-  ggplot(data, aes(x = get(Cat), y = get(Val))) +
        geom_bar(stat = "identity", fill = "steelblue") +  # Barplot with identity statistics and blue color
        labs(title = tit,          # Set the title
             x = Cat,
             y = Val) +
        scale_color_viridis_d() +
        theme_light() 

  # Display the barplot
  return(p)
}


# DATA TRANSFORMATION AND NEW VARIABLES -----------------------------------

# Define sample data

#  - df1
df1 <- data.table(fread("data/sample.csv"))
df1[ , month:=as.Date(month, format = '%Y-%m-%d')]

#  - df2

df2 <- dcast(data = df1, Category ~ . , fun = sum,
                      value.var = c("Revenue"))
names(df2)[ncol(df2)] <- "Revenue"

#  - df3
df3 <- data.table(fread("data/people.csv"))

#  - df3
df4 <- data.table(fread("data/Employees.csv"))

# source()
# load()


############################################
############################################
############################################

# Define server
server <- function(input, output, session) {
  # Add server-side logic here

  # Render Value Ind_1
  output$Ind_1 <- renderValueBox({
    valueBox("Indicator 1", "Text Text Text", icon = icon("exclamation-triangle"), color = "green")
    # val <- dv_df() %>% 
    #   # filter(NutrientID %in% c(601, 204, 307, 269, 0)) %>% 
    #   tidyr::drop_na(pct_dv) %>% filter(pct_dv > 100)
    # val = 5
    # if(val > 0){
    #   valueBox("Over Daily Value", HTML(paste0(val$Nutrient, sep="<br>")), icon = icon("exclamation-triangle"), color = "red")
    # } else {
    #   valueBox("All nutrients", "below recommended DV", icon = icon("exclamation-triangle"), color = "green")
    # }
  })

  # Render Value Ind_2
  output$Ind_2 <- renderValueBox({
    valueBox("Indicator 2", "Text Text Text", icon = icon("exclamation-triangle"), color = "yellow")
  })

  # Render Value Ind_3
  output$Ind_3 <- renderValueBox({
    valueBox("Indicator 3", "Text Text Text", icon = icon("exclamation-triangle"), color = "orange")
  })

  # Render Graph 1
  output$plot1 <- renderPlotly({
    pl1 <- plot_lines(data = df1,
                   var_x = "month" ,
                   var1_y = "Revenue",
                   var2_y = "goal",
                   var_group = "Category",
                   tit = NULL)
    ggplotly(pl1)  
  })

  # # Render Graph 2
  output$plot2 <- renderPlotly({
    pl2 <- plot_bars(data = df2,
                Val = "Revenue",
                Cat = "Category",
                tit = NULL )
    ggplotly(pl2)
  })
  
  # Render the table_1
  output$table_1 <- renderDataTable(
     datatable(df1,
                rownames = FALSE,
                filter = c("top"),
                extensions = 'Buttons',
                options = list(
                               dom = 'Bfltp',# 'Bt', 
                               buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), #, pageLength = -1 
                               scrollX = TRUE,
                               #fixedColumns = list(leftColumns = 2),
                               autoWidth = FALSE,
                               pageLength = 5,
                               #lengthMenu = list(c(10,  -1), list('10', 'All')) ,
                               searchHighlight = TRUE
                               #search = list(regex = TRUE, caseInsensitive = FALSE )
                               )
              ) ,
                #colnames=c("HS codes", "Classification" ,'Value ($m)', 'Share of total imports','CAGR 1', 'CAGR 5', 'CAGR 10', 'ABS5', 'ABS10')
     )                                    


  # output$table_1 <- renderDT({
  #   datatable(df1, options = list(pageLength = 5))  # Render the data table with 5 rows per page
  # })

  # Reactive Values to Store Data
  data <- reactiveValues()
  data$name_input <- character(0)
  data$age_input <- numeric(0)
  data$email_input <- character(0)
  
  # Update Data on Submit
  observeEvent(input$submit, {
    data$name_input <- c(data$name_input, input$name_input)
    data$age_input <- c(data$age_input, input$age_input)
    data$email_input <- c(data$email_input, input$email_input)
    
    # Store Data in data.frame
    temp <- data.table(
      Name = data$name_input,
      Age = data$age_input,
      Email = data$email_input
    )
    
    # Save and include to a data base 
    df4 <- rbind(temp, df4)
    write.csv(df4, file = "data/Employees.csv", row.names = FALSE)

    # Show success message
    showModal(
      modalDialog(
        title = "Success",
        "Data saved successfully!",
        easyClose = TRUE,
        footer = modalButton("OK")
      )
    )
    
    # # Reset the form
    # updateTextInput(session, inputId = "names_input", value = "")
    # updateTextInput(session, inputId = "email_input", value = "")
    # updateNumericInput(session, inputId = "age_input", value = NULL)
  })


  # Render the table_2
  output$table_2 <- renderDataTable(
     datatable(df3,
                rownames = FALSE,
                filter = c("top"),
                extensions = 'Buttons',
                options = list(
                               dom = 'Bfltp',# 'Bt', # Define the table control elements to appear on the page and in what order
                               buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                               scrollX = TRUE, #Horizontal scrolling
                               #,fixedColumns = list(leftColumns = 2) 
                               autoWidth = FALSE,
                               pageLength = 5,
                               #lengthMenu = list(c(10,  -1), list('10', 'All')) ,
                               searchHighlight = TRUE
                               #search = list(regex = TRUE, caseInsensitive = FALSE )
                               )
              ) ,
                #colnames=c("HS codes", "Classification" ,'Value ($m)', 'Share of total imports','CAGR 1', 'CAGR 5', 'CAGR 10', 'ABS5', 'ABS10')
     )                                    

  # Module: About My DashBoard
  # Render the HTML document using renderUI
  output$myHtmlOutput <- renderUI({
    # Use includeHTML to include the HTML document
    includeHTML("data/intro_text.html")
  })





} # close the server
