## app.R ##
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(DT)
library(ggplot2)

#Pre-load all dataset names into app
data_names <- data(package="BaltimoreTrails")

ui <- dashboardPage(
  dashboardHeader(title = "DataTrail DataHub"),

  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data and Plotting Tools", tabName = "dataview", icon = icon("table")),
      menuItem("Mapped Baltimore City Data", tabName = "map", icon = icon("map")),
      menuItem("Interactive Learning", tabName = "learning", icon = icon("hand"))
    )
  ),


  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "dataview",
              h1("Data Viewing and Downloading Tool"),
              fluidRow(align = "center",
                column(3),
                box(width = 6, align = "center", status = "primary", height = 200,
                  br(),
                  fluidRow(
                    column(2),
                    column(8,
                      selectizeInput(
                        'data_select', h2('1. Select Dataset'),
                         choices = data_names$results[,3]
                      ),
                    ),
                  ),
                ),
              ),

              fluidRow(
                box(width = 12, status = "primary",
                  h2('2. Edit, Download, and Univariate Data Plots', align = "center"),
                  uiOutput("modals"),
                  dataTableOutput("table")
                ),
              ),

              fluidRow(
                box(width = 12, status = "primary",
                    h2('3. Multivariate Data Plots', align = "center"),
                ),
              ),


      ),

      # Second tab content
      tabItem(tabName = "map",
              h1("Interactive Baltimore City Map")
      ),

      # Third tab content
      tabItem(tabName = "learning",
              h1("Interactive Learning")
      )
    )
  )

)

server <- function(input, output) {

  dat <- reactive({
      if (!is.null(input$data_select)){
        if(input$data_select != ""){
          dat<- eval(as.symbol(input$data_select))
          dat
        }
      }
  }
  )

  # Buttons for Creating Plots from DataTable

  observe(
    if(!is.null(dat())){
      if(ncol(dat()) > 0){

        Dat <- dat()

        buttons <- lapply(1:ncol(Dat), function(i){
          actionButton(
            paste0("this_id_is_not_used",i),
            "plot",
            class = "btn-secondary btn-sm",
            style = "border-radius: 50%;",
            onclick = sprintf(
              "Shiny.setInputValue('button', %d, {priority:'event'});
        $('#modal%d').modal('show');", i, i)
          )
        })

        output[["table"]] <- renderDT({
          sketch <- tags$table(
            class = "row-border stripe hover compact",
            tableHeader(c("", names(Dat))),
            tableFooter(c("", buttons))
          )
          datatable(
            Dat,
            editable = TRUE,
            extensions = "Buttons",
            container = sketch,
            class = "compact",
            options =
              list(
                paging = TRUE,
                scrollX=TRUE,
                searching = TRUE,
                ordering = TRUE,
                pageLength = 10,
                dom = 'Bfrtip',
                buttons = c('copy', 'csv', 'excel', 'pdf'),
                columnDefs = list(
                  list(
                    className = "dt-center",
                    targets = "_all"
                  )
                )
              )
          ) %>%
            formatRound(c(1:ncol(Dat)), 4) %>%
            formatStyle(columns = c(1:ncol(Dat)), 'text-align' = 'center')
        })

        # modals ####
        output[["modals"]] <- renderUI({
          lapply(1:ncol(Dat), function(i){
            bsModal(
              id = paste0("modal",i),
              title = names(Dat)[i],
              trigger = paste0("this_is_not_used",i),
              if(is.numeric(Dat[[i]]) && length(unique(Dat[[i]]))>19){
                fluidRow(
                  column(5, radioButtons(paste0("radio",i), "",
                                         c("density", "histogram"), inline = TRUE)),
                  column(7,
                         conditionalPanel(
                           condition = sprintf("input.radio%d=='histogram'",i),
                           sliderInput(paste0("slider",i), "Number of bins",
                                       min = 5, max = 100, value = 30)
                         ))
                )
              },
              plotOutput(paste0("plot",i))
            )
          })
        })

        # plots in modals ####
        for(i in 1:ncol(Dat)){
          local({
            ii <- i
            output[[paste0("plot",ii)]] <- renderPlot({
              if(is.numeric(Dat[[ii]]) && length(unique(Dat[[ii]]))>19){
                if(input[[paste0("radio",ii)]] == "density"){
                  ggplot(Dat, aes_string(names(Dat)[ii])) +
                    geom_density(fill = "seashell", color = "seashell") +
                    stat_density(geom = "line", size = 1) +
                    theme_bw() + theme(axis.title = element_text(size = 16))
                }else{
                  ggplot(Dat, aes_string(names(Dat)[ii])) +
                    geom_histogram(bins = input[[paste0("slider",ii)]]) +
                    theme_bw() + theme(axis.title = element_text(size = 16))
                }
              }else{
                Dat[[".x"]] <- factor(Dat[[ii]],
                                        levels = names(sort(table(Dat[[ii]]),
                                         decreasing=TRUE)))
                gg <- ggplot(Dat, aes(.x)) + geom_bar() +
                  geom_text(stat="count", aes(label=..count..), vjust=-0.5) +
                  xlab(names(Dat)[ii]) + theme_bw()
                if(max(nchar(levels(Dat$.x)))*nlevels(Dat$.x)>40){
                  gg <- gg + theme(axis.text.x =
                                     element_text(size = 12, angle = 45,
                                                  vjust = 0.5, hjust = 0.5))
                }else{
                  gg <- gg + theme(axis.text.x = element_text(size = 12))
                }
                gg + theme(axis.title = element_text(size = 16))
              }
            })
          })
        }

      }
    }
  )
}

shinyApp(ui, server)

