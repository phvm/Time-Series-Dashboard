server <- function(input, output) {
    ################### Medidas ###################
    ################### INPUT ####################
    select_state <- eventReactive(input$go, {
        
        state_name <- input$state
        
        amazon <- master_df %>% 
            filter(state == state_name) 
        
        return(amazon)
    })
    
    select_date <- eventReactive(input$go, {
        
        state_year <- input$year
        
        amazon_date <- master_df %>%
            filter(year == year)
        
        return(amazon_date)
    })
    
    ################ OUTPUT #####################
    Info_DataTable <- eventReactive(input$go,{
        df <- select_state()
        getmode <- function(v) {
            uniqv <- unique(v)
            uniqv[which.max(tabulate(match(v, uniqv)))]
        }
        
        Queimadas <- df$number %>% na.omit() %>% as.numeric()
        
        Media <- mean(Queimadas)
        Moda <- getmode(Queimadas)
        Mediana <- median(Queimadas)
        DesvioPadrão <- sd(Queimadas)
        
        Estado <- input$state
        
        df_tb <-  data.frame(Estado, Media, Moda, Mediana, DesvioPadrão)
        
        df_tb <- as.data.frame(t(df_tb))
        
        return(df_tb)
    })
    
    output$timedate <- renderUI({
        
        state_name <- input$state
        
        df <- master_df %>% 
            filter(state == state_name)
        
        min_year <- min(df$year)
        max_year <- max(df$year)
        dateRangeInput("true_date", "Período de análise",
                       end = max_year,
                       start = min_year,
                       min  = min_year,
                       max  = max_year,
                       format = "yy",
                       separator = "-",
                       language='pt-BR')
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
            scale_x_date(date_breaks = "1 year",date_labels = "%Y")
        
        a
    })
    
    output$hist <- renderPlot({
        df <- select_date()
        
        Queimadas <- df$number %>% na.omit() %>% as.numeric()
        
        hist(Queimadas, main="Histograma", ylab= "Frequência", xlab= "Quantia de queimadas")
    })
    
    output$boxp <- renderPlot({
        df <- select_state()
        df$year <- ymd(df$year)
        aux <- df$number %>% na.omit() %>% as.numeric()
        
        df %>%
            ggplot(aes(x = year, y = number, gruop=1)) + geom_boxplot() + 
            labs(x='Anos', y='Numero de queimadas')
    })
    
    ################### Comparar ###################
    ################### INPUT ####################
    select_state_comp <- eventReactive(input$go_comp, {
        
        state_name <- input$state_comp
        
        amazon_comp <- master_df %>% 
            filter(state %in% state_name) 
        
        return(amazon_comp)
    })
    
    ################ OUTPUT #####################
    Comp_Info_DataTable <- eventReactive(input$go_comp,{
        df <- select_state_comp()
            
        getmode <- function(v) {
            uniqv <- unique(v)
            uniqv[which.max(tabulate(match(v, uniqv)))]
        }
        
        Queimadas <- df$number %>% na.omit() %>% as.numeric()
        
        Media <- mean(Queimadas)
        Moda <- getmode(Queimadas)
        Mediana <- median(Queimadas)
        DesvioPadrão <- sd(Queimadas)
        
        
        Estado <- input$state_comp
        
        df_comp <-  data.frame(Estado, Media, Moda, Mediana, DesvioPadrão)
        
        df_comp <- as.data.frame(t(df_comp))
        
        return(df_comp)
    })
    
    output$timedate_comp <- renderUI({
        
        state_name <- input$state_comp
        
        df <- master_df %>% 
            filter(state %in% state_name)
        
        maxmin_year <- df %>% 
            group_by(state) %>% 
            summarise(MD = min(year)) %>% 
            .$MD %>% 
            max()
        
        minmax_year <- df %>% 
            group_by(state) %>% 
            summarise(MD = max(year)) %>% 
            .$MD %>% 
            min()
        
        min_year <- maxmin_year
        max_year <- minmax_year
        
        dateRangeInput("true_date_comp", "Período de análise",
                       end = max_year,
                       start = min_year,
                       min    = min_year,
                       max    = max_year,
                       format = "yy",
                       separator = "-",
                       language='pt-BR')
    })
    
    output$info_comp <- renderDT({
        Comp_Info_DataTable() %>%
            as.data.frame() %>% 
            DT::datatable(options=list(
                language=list(
                    url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Portuguese-Brasil.json'
                )
            ))
    })
    
    output$barr <- renderPlot({
        df <- select_state_comp()
        df$year <- ymd(df$year)
        ggplot(df)+
            geom_col(aes(x = year, y = number))+
            labs(x='Anos', y="Numero de queimadas")
    })
    
    output$line_comp <- renderPlot({
        df <- select_state_comp()
        df$year <- ymd(df$year)
        ggplot(df, aes(x = df$year))+
            geom_line(aes(y=df$number))+
            geom_line(aes(y=df$number))+
            labs(x='Anos', y='Numero de queimadas')+
            scale_x_date(date_breaks = "1 year",date_labels = "%Y")
    })
}
