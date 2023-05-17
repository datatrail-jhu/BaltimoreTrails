## app.R ##
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(DT)
library(ggplot2)
library(learnr)
library(esquisse)
library(fontawesome)
library(BaltimoreTrails)

# Pre-load all dataset names into app
data_names <- data(package = "BaltimoreTrails")

# Initializing Empty dataframe for esquisse transitions
data_rv <- reactiveValues(data = data.frame(), name = NULL)

ui <- dashboardPage(
  dashboardHeader(title = "DataTrail DataHub"),

  ## Sidebar content
  dashboardSidebar(
    sidebarMenu(
      menuItem("Data and Plotting Tools", tabName = "dataview", icon = icon("table")),
      menuItem(" Chapters 1-6", tabName = "1-6", icon = icon("network-wired")),
      menuItem(" Chapters 7-12", tabName = "7-12", icon = icon("question")),
      menuItem(" Chapters 13-19", tabName = "13-19", icon = icon("database")),
      menuItem(" Chapters 20-27", tabName = "20-27", icon = icon("database")),
      menuItem(" Chapters 28-32", tabName = "28-32", icon = icon("broom")),
      menuItem(" Chapters 33-37", tabName = "33-37", icon = icon("broom")),
      menuItem(" Chapters 38-43", tabName = "38-43", icon = icon("chart-simple")),
      menuItem(" Chapters 44-48", tabName = "44-48", icon = icon("chart-simple")),
      menuItem(" Chapters 49-54", tabName = "49-54", icon = icon("calculator")),
      menuItem(" Chapters 55-60", tabName = "55-60", icon = icon("calculator")),
      menuItem(" Chapters 61-66", tabName = "61-66", icon = icon("share-nodes")),
      menuItem(" Chapters 67-75", tabName = "67-75", icon = icon("share-nodes")),
      menuItem(" Chapters 76-82", tabName = "76-82", icon = icon("share-nodes")),
      menuItem(" Chapters 83-89", tabName = "83-89", icon = icon("file")),
      menuItem(" Chapters 90-96", tabName = "90-96", icon = icon("file"))

    )
  ),


  ## Body content
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(
        tabName = "dataview",
        h1("Data Viewing and Downloading Tool"),
        fluidRow(
          align = "center",
          box(
            status = "primary", height = 300,
            br(),
            selectizeInput(
              "data_select", h2("1. Select Dataset"),
              choices = data_names$results[, 3]
            ),
          ),
          box(
            status = "primary", height = 300,
            h2("2. Dataset Information"),
            uiOutput("dataset_information")
          ),
        ),
        fluidRow(
          box(
            width = 12, status = "primary",
            h2("3. Edit, Download, and Univariate Data Plots", align = "center"),
            uiOutput("modals"),
            dataTableOutput("mytable")
          ),
        ),
        fluidRow(
          box(
            width = 12, status = "primary",

            h2("4. Multivariate Data Plots with esquisse", align = "center"),
            esquisse_ui(id = "esquisse",
                        header = FALSE
            )
          ),
        ),
      ),

      tabItem(
        tabName = "1-6",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame")
        ),
      )




    )
  )
)

server <- function(input, output, session) {
  ##### TAB 1 -- Data and Plotting Tools #####
  dat <- reactive({
    if (!is.null(input$data_select)) {
      if (input$data_select != "") {
        dat <- eval(as.symbol(input$data_select))
        dat
      }
    }
  })

  # Generate temporary dataset information
  observeEvent(input$data_select, {
    output$dataset_info <- renderText({
      paste0("Dataset: ", input$data_select, "\n\n",
             "Link: https://example.com/datasets/", tolower(input$data_select), "\n\n",
             "Title: Example Dataset Title\n\n",
             "Background: This is an example background of the selected dataset. ",
             "It contains information about the dataset's origin, collection methods, ",
             "and other relevant details. This section will be populated with the actual ",
             "information when the app is connected to the data source.\n\n",
             "Interesting aspects: This section highlights some interesting aspects of ",
             "the selected dataset, such as unique patterns, trends, or insights that ",
             "can be gained from the data.")
    })
  })

  # Display dataset information
  output$dataset_information <- renderUI({
    if (!is.null(input$data_select)) {
      verbatimTextOutput("dataset_info")
    }
  })

  # Buttons for Creating Plots from DataTable
  observe(
    if (!is.null(dat())) {
      if (ncol(dat()) > 0) {
        Dat <- dat()

        buttons <- lapply(1:ncol(Dat), function(i) {
          actionButton(
            paste0("this_id_is_not_used", i),
            "plot",
            class = "btn-secondary btn-sm",
            style = "border-radius: 50%;",
            onclick = sprintf(
              "Shiny.setInputValue('button', %d, {priority:'event'});
        $('#modal%d').modal('show');", i, i
            )
          )
        })

        output[["mytable"]] <- renderDT({
          sketch <- tags$table(
            class = "row-border stripe hover compact",
            tableHeader(c("", names(Dat))),
            tableFooter(c("", buttons))
          )

          # Quick fix for loading of large dataset by random sampling subset of 1000
          if (nrow(Dat) > 1000) {
            Dat <- Dat[sample(nrow(Dat), 1000), ]
          }

          data_rv <- reactiveValues(data = Dat, name = input$data_select)

          observeEvent(dat(), {
            data_rv$data <- dat()
            data_rv$name <- input$data_select
          })

        esquisse::esquisse_server(
          id = "esquisse",
          data = data_rv
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
                scrollX = TRUE,
                searching = TRUE,
                ordering = TRUE,
                pageLength = 10,
                dom = "Bfrtip",
                buttons = c("copy", "csv", "excel", "pdf"),
                columnDefs = list(
                  list(
                    className = "dt-center",
                    targets = "_all"
                  )
                )
              )
          ) %>%
            formatRound(c(1:ncol(Dat)), 4) %>%
            formatStyle(columns = c(1:ncol(Dat)), "text-align" = "center")
        })

        # modals ####
        output[["modals"]] <- renderUI({
          lapply(1:ncol(Dat), function(i) {
            bsModal(
              id = paste0("modal", i),
              title = names(Dat)[i],
              trigger = paste0("this_is_not_used", i),
              if (is.numeric(Dat[[i]]) && length(unique(Dat[[i]])) > 19) {
                fluidRow(
                  column(5, radioButtons(paste0("radio", i), "",
                    c("density", "histogram"),
                    inline = TRUE
                  )),
                  column(
                    7,
                    conditionalPanel(
                      condition = sprintf("input.radio%d=='histogram'", i),
                      sliderInput(paste0("slider", i), "Number of bins",
                        min = 5, max = 100, value = 30
                      )
                    )
                  )
                )
              },
              plotOutput(paste0("plot", i))
            )
          })
        })

        # plots in modals ####
        for (i in 1:ncol(Dat)) {
          local({
            ii <- i
            output[[paste0("plot", ii)]] <- renderPlot({
              if (is.numeric(Dat[[ii]]) && length(unique(Dat[[ii]])) > 19) {
                if (input[[paste0("radio", ii)]] == "density") {
                  ggplot(Dat, aes_string(names(Dat)[ii])) +
                    geom_density(fill = "seashell", color = "seashell") +
                    stat_density(geom = "line", size = 1) +
                    theme_bw() +
                    theme(axis.title = element_text(size = 16))
                } else {
                  ggplot(Dat, aes_string(names(Dat)[ii])) +
                    geom_histogram(bins = input[[paste0("slider", ii)]]) +
                    theme_bw() +
                    theme(axis.title = element_text(size = 16))
                }
              } else {
                Dat[[".x"]] <- factor(Dat[[ii]],
                  levels = names(sort(table(Dat[[ii]]),
                    decreasing = TRUE
                  ))
                )
                gg <- ggplot(Dat, aes(.x)) +
                  geom_bar() +
                  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) +
                  xlab(names(Dat)[ii]) +
                  theme_bw()
                if (max(nchar(levels(Dat$.x))) * nlevels(Dat$.x) > 40) {
                  gg <- gg + theme(
                    axis.text.x =
                      element_text(
                        size = 12, angle = 45,
                        vjust = 0.5, hjust = 0.5
                      )
                  )
                } else {
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




  ##### TAB 2 -- Data and Plotting Tools #####
  # Generate Tab 2 Interactive LearnR frame (based on input selection later)
  output$frame <- renderUI({
    tags$iframe(
      src = "https://posit.cloud/content/5964502", width = 1280, height = 720
    )
  })
}

shinyApp(ui, server)
