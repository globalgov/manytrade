#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#HOW THE DATASET HAS BEEN PREPARED

# trade_mem1 <- manytrade::memberships$GPTAD_MEM %>%
#     dplyr::select(many_ID, Country_ID, Title, Beg)
#
# trade_mem2 <- manytrade::memberships$DESTA_MEM %>%
#     dplyr::select(many_ID, Country_ID, Title, Beg)
#
# trade_mem <- dplyr::full_join(trade_mem1, trade_mem2) %>%
#     unique() %>% dplyr::arrange(Beg) %>%
#     dplyr::filter(Beg != "NA")
#
# trade_mem$action <- manypkgs::code_domain(trade_mem$Title)
# trade_mem$areas <- manypkgs::code_entity(trade_mem$Title)
#
# trade_mem$Beg <- stringr::str_remove_all(trade_mem$Beg, "^[0-1]{2}-[0-1]{2}-")
#
# use of write.csv() function to download it in the package

# Step one: import data
library(tidyverse)
library(shiny)
library(shinydashboard)
trade_mem <- read.csv("trade_mem.csv") %>%
    dplyr::select(many_ID, Country_ID, Title, Beg, action, areas)


# Define dashboard interface
ui <- dashboardPage(
    dashboardHeader(title = "Memberships in trade treaties from 1970 to 2020", titleWidth = "450px"),
    dashboardSidebar(
        width = 350,
        sidebarMenu(
            selectInput("topic",
                        "Select treaty topic:",
                        choices = c("choose" = "", "Agriculture", "Climate Change",
                                    "Environment", "Peace", "Research", "Trade"),
                        selected = "choose",
                        multiple = T),
            selectInput("areas", "Select activity:",
                        choices = c("choose" = "" ,trade_mem$areas),
                        selected = "choose",
                        multiple = T),
            menuItem(sliderInput("num", "Dates", value = 1980, min = 1970, max = 2020, width = 350))
        )),
    dashboardBody(
        plotOutput("distPlot", height = "550px")
    )
)

# Connect the data with the interface
server <- function(input, output){
    filteredData <- reactive({
        trade_mem <- trade_mem %>%
            dplyr::filter(Beg %in% input$num) %>%
            migraph::as_tidygraph()
    })
    
    filteredData2 <- reactive({
        trade_mem <- trade_mem %>%
            dplyr::filter(Beg %in% input$num) %>%
            dplyr::filter(areas %in% input$areas) %>%
            migraph::as_tidygraph()
    })
    
    filteredData3 <- reactive({
        trade_mem <- trade_mem %>%
            dplyr::filter(Beg %in% input$num) %>%
            dplyr::filter(action %in% input$topic) %>%
            migraph::as_tidygraph()
    })
    
    
    output$distPlot <- renderPlot({
        if(is.null(input$topic) & is.null(input$areas)){
            migraph::autographr(filteredData())
        }
        
        else if(!is.null(input$topic) & is.null(input$areas)){
            migraph::autographr(filteredData3())
        }
        
        else if(is.null(input$topic) & !is.null(input$areas)){
            migraph::autographr(filteredData2())
        }
        
        else {}
    })
}

# Run the application
shinyApp(ui = ui, server = server)