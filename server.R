server <- function(input, output) {
    ################### INPUT ####################
    select_state <- eventReactive(input$go, {
        
        state_name <- input$state
        twin <- input$true_date
        
        amazon <- master_df %>% 
            filter(state == state_name) 
        ## FALTA -> FILTRAR O DF POR DATA!!
        
        return(amazon)
    })
    
    output$timedate <- renderUI({
        
        state_name <- input$state
        
        df <- master_df %>% 
            filter(state == state_name)
        
        min_time <- min(df$year)
        max_time <- max(df$year)
        dateRangeInput("true_date", "Período de análise",
                       end = max_time,
                       start = min_time,
                       min  = min_time,
                       max  = max_time,
                       format = "yy",
                       language='pt-BR')
    })
    
    output$timedate_comp <- renderUI({
        
        state_name <- input$stock_comp
        
        df <- master_df %>% 
            filter(state %in% state_name)
        
        maxmin_time <- df %>% 
            group_by(state) %>% 
            summarise(MD = min(year)) %>% 
            .$MD %>% 
            max()
        
        minmax_time <- df %>% 
            group_by(state) %>% 
            summarise(MD = max(year)) %>% 
            .$MD %>% 
            min()
        
        min_time <- maxmin_time
        max_time <- minmax_time
        
        dateRangeInput("true_date_comp", "Período de análise",
                       end = max_time,
                       start = min_time,
                       min    = min_time,
                       max    = max_time,
                       format = "yy",
                       separator = " - ",
                       language='pt-BR')
    })
    
    ################ OUTPUT #####################
    Info_DataTable <- eventReactive(input$go,{
        df <- select_state()
        
        mean <- df %>% select(number) %>% colMeans()
        Media <- mean[[1]]
        
        State <- input$state
        
        df_tb <-  data.frame(State, Media)
        
        df_tb <- as.data.frame(t(df_tb))
        
        # tb  <- as_tibble(cbind(nms = names(df_tb), t(df_tb)))
        # tb <- tb %>% 
        #     rename('Informações' = nms,
        #            'Valores' = V2)
        # 
        return(df_tb)
    })
    
    output$info <- renderDT({
        Info_DataTable() %>%
            as.data.frame() %>% 
            DT::datatable(options=list(
                language=list(
                    url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'
                )
            ))
    })
    
    output$sh <- renderPlot({
        df <- select_state()
        
        aux <- df$number %>% na.omit() %>% as.numeric()
        aux1 <- min(aux)
        aux2 <- max(aux)
        
        df$year <- ymd(df$year)
        a <- df %>% 
            ggplot(aes(year, number, group=1)) +
            geom_path() +
            ylab('Numero de queimadas') +
            coord_cartesian(ylim = c(aux1, aux2)) +
            theme_bw() +
            scale_x_date(date_labels = "%Y")
        
        a
    })
    
    output$hist <- renderPlot({
        df <- select_state()
        
    })
    
    output$boxp <- renderPlot({
        df <- select_state()
        
    })
}
