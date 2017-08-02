# server.R

# shinyServer(
function(input, output, session) {
   
    observe({
        oneStock <- df %>% filter(ticker == input$selectTicker)
        ratingNames <- oneStock %>% filter(rating != "-1") 
        ratings <- append(unique(ratingNames$rating), "All")
        
        brokerageNames <- oneStock %>% filter(brokerage_firm != "-1") 
        brokerage <- append(unique(brokerageNames$brokerage_firm), "All")
        updateSelectInput(
            session, "selectRating",
            choices = ratings,
            selected = 'All'
        )
        updateSelectInput(
            session, "selectBrokerage",
            choices = brokerage,
            selected = 'All'
        )
    })
    # observe({
    #     oneStock1 <- df %>% filter(rating == input$selectRating)
    #    
    #     brokerageNames <- oneStock1 %>% filter(brokerage_firm != "-1") 
    #     brokerage <- append(unique(brokerageNames$brokerage_firm), "All")
    #    
    #     updateSelectInput(
    #         session, "selectBrokerage",
    #         choices = brokerage,
    #         selected = 'All'
    #     )
    # })
    
    oneStockDf <- reactive({
        #if (input$selectRating == 'All' & input$selectBrokerage == 'All'){
            df %>%
                filter(ticker == input$selectTicker)  
        # } else if (input$selectRating != 'All' & input$selectBrokerage == 'All'){
        #     df %>%
        #         filter(ticker == input$selectTicker & rating == input$selectRating ) 
        # } else if (input$selectRating == 'All' & input$selectBrokerage != 'All'){
        #     df %>%
        #         filter(ticker == input$selectTicker & brokerage_firm == input$selectBrokerage ) 
        # } else{
        #     df %>%
        #         filter(ticker == input$selectTicker & rating == input$selectRating & brokerage_firm == input$selectBrokerage ) 
        # }
            
            # group_by(carrier) %>%
            # summarise(n = n(),
            #           departure = mean(dep_delay),
            #           arrival = mean(arr_delay))
    })
    oneStockDf1 <- reactive({
        df %>%
            filter(rating == input$selectRating & ticker == input$selectTicker)
        # group_by(carrier) %>%
        # summarise(n = n(),
        #           departure = mean(dep_delay),
        #           arrival = mean(arr_delay))
    })
    
    output$mainPlot <- renderPlot({
        #oneStockDf2() <- df %>% filter(ticker == input$selectTicker) %>% 
        df1 <- oneStockDf() %>%  select(date, adj_close, rating, daily_return) 
        df2 <- df1 %>% filter(rating != -1)
            ggplot() +
            geom_line(data=df1, aes(x = as.Date(date), y = adj_close, color = adj_close))  +
                scale_color_gradient(low = 'red', high = 'green') +
            geom_point(data=df2, aes(x = as.Date(date), y = adj_close, shape = rating, size = rating)) 
                
    })
    
    output$stockRatingTable <- DT::renderDataTable({
        df  %>% filter(ticker == input$displayTicker)  %>% 
            select(c(1,23,14,2,3,8, 6,12,7,25)) %>% 
            arrange(desc(cum_daily_return))
    })
    # & rating == input$displayRating & 
    # input$displaySector == sector & input$displayBroker == brokerage_firm)
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    