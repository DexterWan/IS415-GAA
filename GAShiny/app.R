#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

pacman::p_load(sf, tidyverse, tmap)

hunan = st_read(dsn = "data/geospatial", layer = "Hunan")
hunan_2012 = read.csv("data/aspatial/Hunan_2012.csv")
hunan_data = left_join(hunan, hunan_2012)

# Define UI for application that draws a histogram  
ui <- fluidPage(
  titlePanel("Choropleth Mapping"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "variable",
                  label = "Mapping variable",
                  choices = list("Gross Domestic Product, GDP" = "GDP",
                                 "Gross Domestic Product Per Capita" = "GDPPC",
                                 "Gross Industry Output" = "GIO",
                                 "Output Value of Agriculture" = "Agri",
                                 "Output Value of Service" = "Service"),
                  selected = "GDPPC"),
      sliderInput(inputId = "classes",
                  label = "Number of classes",
                  min = 5,
                  max = 10,
                  value = c(6))
    ),
    mainPanel(tmapOutput("mapPlot",
                         width = "100%",
                         height = 580))
  )
  
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  output$mapPlot = renderTmap({
    tmap_options(check.and.fix = TRUE) +
      tm_shape(hunan_data) +
      tm_fill(input$variable, 
              n = input$classes,
              style = "quantile",
              palette = "Oranges") +
      tm_borders(alpha = 1, lwd = 0.1)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
