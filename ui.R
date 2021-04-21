

header <- dashboardHeader(title = "Projeto de Estatística")

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Medidas", tabName = "med", icon = icon("chart-line")),
        menuItem('Comparar Estados', tabName = 'comp', icon = icon('chart-bar'))
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = 'med',
                fluidRow(
                    box(title = 'Selecione suas opções', width=12, solidHeader = TRUE, status='warning',
                        selectInput('state', 'Estado', state_list, multiple=FALSE),
                        uiOutput("timedate"),
                        actionButton('go', 'Buscar')
                        )
                ),
                fluidRow(
                    box(title = "Informações sobre o estado", width = 12, solidHeader = TRUE,
                        DTOutput('info')
                    )
                ),
                fluidRow(
                    box(title = "Gráfico em linha das queimadas", width = 12, solidHeader = TRUE,
                        plotOutput('sh')
                    )
                ),
                fluidRow(
                    box(title = "Histograma das queimadas", width = 12, solidHeader = TRUE,
                        plotOutput('hist')
                    )
                ),
                fluidRow(
                    box(title = "Boxplot das queimadas", width = 12, solidHeader = TRUE,
                        plotOutput('boxp')
                    )
                ),
        ),
        tabItem(tabName = 'comp',
                fluidRow(
                    box(title = 'Selecione suas opções', width=12, solidHeader = TRUE, status='warning',
                        selectInput('state_comp', 'Estado', state_list, multiple=TRUE),
                        uiOutput("timedate_comp"),
                        actionButton('go_comp', 'Buscar')
                    )
                ),            
        )
    )
)

ui <- dashboardPage(
    skin = 'purple',
    header, sidebar, body)
