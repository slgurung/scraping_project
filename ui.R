
navbarPage(strong("S&P 500 Stocks Rating By Brokerge Firms: "), id="nav",
           
    tabPanel("Stock Chart",
        div(class="outer",
                        
            tags$head(
                # connecting to custom CSS
                tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
                        
            ),
                        
            #leafletOutput("map", width="100%", height="100%"),
           
                     fluidRow(
                         class = 'ggPlot',
                         
                         
                         box(width = 12, background = 'blue',
                             height = 650,
                             plotOutput("mainPlot", height = 600)
                         )
                         
                     ),
        
            absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                    draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                    width = 350, height = "350",
                                      
                    h2("Stock Search"),
                                  
                    selectInput(inputId="selectTicker", 
                                label="Ticker", 
                                choices = tickers 
                            ),
                    selectInput(inputId = "selectRating", 
                                label = "Rating", 
                                choices = ratings, 
                                selected = ratings[1]),
                    selectInput(inputId = "selectBrokerage", 
                                label = "Brokerage", 
                                choices = brokerage, 
                                selected = 'All')
                            
                    # plotOutput("histPlt", height = 200),
                    # plotOutput("scatterPlt", height = 250),
                    
            )
            
        )
    ),
           
    tabPanel("Dataset",
             
            class = "dataset",
            fluidRow(
                    
                    
                    column(3,
                        selectInput("displayTicker", "Tickers", tickers, selected = 'AAPL')
                    ),
                    column(3,
                        selectInput("displayRating", "Ratings", ratings, selected = 'Buy')
                        
                    ),
                    column(3,
                           selectInput("displaySector", "Sector", sectors, selected = 'Financials')
                    ),
                    column(3,
                            selectInput("displayBroker", "Broker", brokerage, selected = 'Goldman')
                    )
                           
            ),
            fluidRow(
                width = '500px',
                box(width = 12, 
                    height = "570px",
                    DT::dataTableOutput("stockRatingTable")
                )
                
            )
    ),
    
    
           
    conditionalPanel("false", icon("crosshair"))
)


