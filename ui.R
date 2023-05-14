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

steps <- fread("data/help.csv")
# intro <- read_csv2("intro.csv")


# Define UI
ui <- dashboardPage(
  skin = "black",
  title = "My Dashboard",

  # HEADER ------------------------------------------------------------------
  
  dashboardHeader(
    # title = "My Dashboard"
    title = span(img(src = "logo.png", height = 35, href='http://youneed.us.com'), 
                  "My Dashboard"
                ), 
    titleWidth = 300,
    dropdownMenu(
      type = "notifications", 
      headerText = strong("HELP"), 
      icon = icon("question"), 
      badgeStatus = NULL,
      notificationItem(
        text = (steps$text[1]),
        icon = icon("spinner")
      ),
      notificationItem(
        text = steps$text[2],
        icon = icon("address-card")
      ),
      notificationItem(
        text = steps$text[3],
        icon = icon("calendar")
      ),
      notificationItem(
        text = steps$text[4],
        icon = icon("user-md")
      ),
      notificationItem(
        text = steps$text[5],
        icon = icon("ambulance")
      ),
      notificationItem(
        text = steps$text[6],
        icon = icon("flask")
      ),
      notificationItem(
        text = strong(steps$text[7]),
        icon = icon("exclamation")
      )
    )
  ),

  # SIDEBAR -----------------------------------------------------------------
  
  dashboardSidebar(

    sidebarMenu(
      menuItem("Module 1", tabName = "Mod1", icon = icon("dashboard")),
      menuItem("Module 2", tabName = "Mod2", icon = icon("database")),
      menuItem("Module 3", tabName = "Mod3", icon = icon("chart-bar")),
      menuItem("About", tabName = "Mod4", icon = icon("question"))
    )
  ),

  # BODY --------------------------------------------------------------------
  
  dashboardBody(
    # tags$head(
    #   tags$link(
    #     rel = "stylesheet", 
    #     type = "text/css", 
    #     href = "radar_style.css")
    # ),
    
    # useShinyjs(),
    # introjsUI(),

    tabItems(
      # Module 1 ------------------------------  
      # Define Dashboard tab
      tabItem(tabName = "Mod1",
              # Indicators 1 to 3
              fluidRow(
                valueBoxOutput("Ind_1"),
                valueBoxOutput("Ind_2"),
                valueBoxOutput("Ind_3")
              ),

              # Boxes 1 to 2 same row
              fluidRow(
                box(title = "TimeLine",
                    footer = "Text Text Text ...",
                    solidHeader = FALSE,
                    width = 6,
                    height = 400,
                    #collapsible = T,
                    plotlyOutput("plot1", 
                                  #width = 5, 
                                  height = 300)
                    #div(plotlyOutput("plot1"), style = "font-size: 70%;")
                    ),

                box(title = "BarPlot",
                    footer = "Text Text Text ...",
                    solidHeader = FALSE,
                    width = 6,
                    height = 400,
                    #collapsible = T,
                    plotlyOutput("plot2", 
                                  #width = 5, 
                                  height = 300)
                    #div(plotlyOutput("plot1"), style = "font-size: 70%;")
                  )
              ),

              # Box 3 + table
              fluidRow(
                box(title = "Table XXX",
                    footer = "Text Text Text ...",
                    solidHeader = FALSE,
                    width = 12, 
                    height = 450, 
                    DTOutput("table_1")
                    )
              ),

      ),
 

      # Module 2 ------------------------------  
      # Define Dashboard tab
      tabItem(tabName = "Mod2",
              # Box 3 + table
              fluidRow(
                box(title = "Table XXX",
                    footer = "Text Text Text ...",
                    solidHeader = FALSE,
                    width = 12, 
                    height = 450, 
                    DTOutput("table_2")
                    )
              ),
      ),

      # Module 3 ------------------------------  
      # # Define Dashboard tab
      tabItem(tabName = "Mod3",
              # Box 3 + table
              fluidRow(
                box(title = "Form Example", width = 6,
                    textInput(inputId = "name_input", label = "Name", value = ""),
                    numericInput(inputId = "age_input", label = "Age", value = NULL, min = 0),
                    textInput(inputId = "email_input", label = "Email", value = ""),
                    actionButton(inputId = "submit", label = "Submit")
                    )
              ),
      ),


      # Module 4 ------------------------------  
      # Define Dashboard tab
      tabItem(tabName = "Mod4",
              # Box 3 + table
              fluidRow(
                box(title = "About My DashBoard",
                    #footer = "Text Text Text ...",
                    solidHeader = FALSE,
                    width = 12, 
                    #height = 400, 
                    htmlOutput("myHtmlOutput") 
                )
              )
      )

    )
  )
)
