library(dplyr)
library(shiny)
library(shinydashboard)

# Prepare data
# trade_mem1 <- manytrade::memberships$GPTAD_MEM %>%
#     dplyr::select(manyID, CountryID, Title, Beg)
# trade_mem2 <- manytrade::memberships$DESTA_MEM %>%
#     dplyr::select(manyID, CountryID, Title, Beg)
# trade_mem <- dplyr::full_join(trade_mem1, trade_mem2) %>%
#     unique() %>% dplyr::arrange(Beg) %>%
#     dplyr::filter(Beg != "NA")
# write.csv(trade_mem, "trade_mem.csv")

# Get data
trade_mem <- read.csv("trade_mem.csv") %>%
    dplyr::select(manyID, CountryID, Title, Beg)

# Define dashboard interface
ui <- dashboardPage(
    dashboardHeader(title = "Trade treaties by year from 1948 to 2020", titleWidth = "450px"),
    dashboardSidebar(
        width = 350,
        sidebarMenu(
            selectInput("country",
                        "Select country(s):",
                        choices = c("choose" = "", trade_mem$CountryID),
                        selected = "choose",
                        multiple = T),
            menuItem(sliderInput("num", "Dates", value = 1980, min = 1948, max = 2020, width = 350))
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
            dplyr::filter(CountryID %in% input$country) %>%
            migraph::as_tidygraph()
    })
    output$distPlot <- renderPlot({
        if(is.null(input$country)){
            migraph::autographr(filteredData())
        }
        else if(!is.null(input$country)){
            migraph::autographr(filteredData2())
        }
        else {}
    })
}

# I will add an interactive map here later, for reference see:
# https://www.r-bloggers.com/2020/04/hands-on-how-to-build-an-interactive-map-in-r-shiny-an-example-for-the-covid-19-dashboard/
# ui<- fluidPage(
#     #Assign Dasbhoard title 
#     titlePanel("Trade Agreements per Country"),
#     sliderInput(inputId = "date", "Date:", min = 1948, max = 2021, 
#                 value = 1989, width = "600px"),
#     # plot leaflet object (map) 
#     leafletOutput(outputId = "distPlot", width = "700px", 
#                   height = "300px"),
#     #End:  the First Block
#     #Start: the second Block
#     sidebarLayout(
#         #Sidebar Panel: the selected country, history and 
#         #whether to plot daily new confirmed cases.
#         sidebarPanel(
#             selectInput("selectedcountry", h4("Country"), choices 
#                         =list("China","US","United_Kingdom","Italy","France",
#                               "Germany", "Spain"), selected = "US"),
#             selectInput("selectedhistoricwindow", h4("History"), 
#                         choices = list("the past 10 days", "the past 20 
#       days"), selected = "the past 10 days"),
#             checkboxInput("dailynew", "Daily new infected", 
#                           value = TRUE),
#             width = 3  
#         ),
#         #Main Panel: plot the selected values
#         mainPanel (
#             plotOutput(outputId = "Plotcountry", width = "500px", 
#                        height = "300px")
#         )
#     ),
#     #End: the second Block 
# )
# server <- function(input, output){
#     #Assign output$distPlot with renderLeaflet object
#     output$distPlot <- renderLeaflet({
#         # row index of the selected date (from input$date)
#         rowindex = which(as.Date(as.character(daten$Date), 
#                                  "%d.%m.%Y") ==input$date)
#         # initialise the leaflet object
#         basemap= leaflet()  %>%
#             addProviderTiles(providers$Stamen.TonerLite,
#                              options = providerTileOptions(noWrap = TRUE)) 
#         # assign the chart colors for each country, where those 
#         # countries with more than 500,000 cases are marked 
#         # as red, otherwise black
#         chartcolors = rep("black",7)
#         stresscountries 
#         = which(as.numeric(daten[rowindex,c(2:8)])>50000)
#         chartcolors[stresscountries] 
#         = rep("red", length(stresscountries))
#         
#         # add chart for each country according to the number of 
#         # confirmed cases to selected date 
#         # and the above assigned colors
#         basemap %>%
#             addMinicharts(
#                 citydaten$long, citydaten$Lat,
#                 chartdata = as.numeric(daten[rowindex,c(2:8)]),
#                 showLabels = TRUE,
#                 fillColor = chartcolors,
#                 labelMinSize = 5,
#                 width = 45,
#                 transitionTime = 1
#             ) 
#     })
#     #Assign output$Plotcountry with renderPlot object
#     output$Plotcountry <- renderPlot({
#         #the selected country 
#         chosencountry = input$selectedcountry
#         #assign actual date
#         today = as.Date("2020/04/02")
#         #size of the selected historic window
#         chosenwindow = input$selectedhistoricwindow
#         if (chosenwindow == "the past 10 days")
#         {pastdays = 10}
#         if (chosenwindow  == "the past 20 days")
#         {pastdays = 20}
#         #assign the dates of the selected historic window
#         startday = today-pastdays-1
#         daten$Date=as.Date(as.character(daten$Date),"%d.%m.%Y")
#         selecteddata 
#         = daten[(daten$Date>startday)&(daten$Date<(today+1)), 
#                 c("Date",chosencountry)]
#         #assign the upperbound of the y-aches (maximum+100)
#         upperboundylim = max(selecteddata[,2])+100
#         #the case if the daily new confirmed cases are also
#         #plotted
#         if (input$dailynew == TRUE){
#             plot(selecteddata$Date, selecteddata[,2], type = "b", 
#                  col = "blue", xlab = "Date", 
#                  ylab = "number of infected people", lwd = 3, 
#                  ylim = c(0, upperboundylim))
#             par(new = TRUE)
#             plot(selecteddata$Date, c(0, diff(selecteddata[,2])), 
#                  type = "b", col = "red", xlab = "", ylab = 
#                      "", lwd = 3,ylim = c(0,upperboundylim))
#             #add legend
#             legend(selecteddata$Date[1], upperboundylim*0.95, 
#                    legend=c("Daily new", "Total number"), 
#                    col=c("red", "blue"), lty = c(1,1), cex=1)
#         }
#         #the case if the daily new confirmed cases are 
#         #not plotted
#         if (input$dailynew == FALSE){
#             plot(selecteddata$Date, selecteddata[,2], type = "b", 
#                  col = "blue", xlab = "Date", 
#                  ylab = "number of infected people", lwd = 3,
#                  ylim = c(0, upperboundylim))
#             par(new = TRUE)
#             #add legend
#             legend(selecteddata$Date[1], upperboundylim*0.95, 
#                    legend=c("Total number"), col=c("blue"), 
#                    lty = c(1), cex=1)
#         }
#     })
# }

# Run the application
shinyApp(ui = ui, server = server)