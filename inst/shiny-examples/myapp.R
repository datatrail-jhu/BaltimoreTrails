## app.R ##
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(DT)
library(ggplot2)
library(learnr)
library(esquisse)
library(fontawesome)

#Install Deployment Shiny Version BaltimoreTrails locally for Shinyapps.IO
#devtools::install_github("datatrail-jhu/BaltimoreTrails", dependencies = FALSE)
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
      menuItem(" Chapters 14-27", tabName = "14-27", icon = icon("database")),
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
        h1("Data Viewing, Plotting, and Downloading Tool"),
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
            h2("3. Edit Data , Download Data, and Univariate Data Plotting", align = "center"),
            uiOutput("modals"),
            dataTableOutput("mytable")
          ),
        ),
        fluidRow(
          box(
            width = 12, status = "primary",

            h2("4. Multivariate Data Plotting and Code Generation", align = "center"),
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
      ),
      tabItem(
        tabName = "7-12",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame1")
        ),
      ),
      tabItem(
        tabName = "14-27",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame2")
        ),
      ),
      tabItem(
        tabName = "28-32",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame3")
        ),
      ),
      tabItem(
        tabName = "33-37",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame4")
        ),
      ),
      tabItem(
        tabName = "38-43",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame5")
        ),
      ),
      tabItem(
        tabName = "44-48",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame6")
        ),
      ),
      tabItem(
        tabName = "49-54",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame7")
        ),
      ),
      tabItem(
        tabName = "55-60",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame8")
        ),
      ),
      tabItem(
        tabName = "61-66",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame9")
        ),
      ),
      tabItem(
        tabName = "67-75",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame10")
        ),
      ),
      tabItem(
        tabName = "76-82",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame11")
        ),
      ),
      tabItem(
        tabName = "83-89",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame12")
        ),
      ),
      tabItem(
        tabName = "90-96",
        h1("Interactive Learning"),
        fluidRow(
          htmlOutput("frame13")
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

    selected_dataset <- metadata_full[metadata_full$dataset == input$data_select,]

    if(nrow(selected_dataset)>1){
      selected_dataset <-  selected_dataset[1,]
    }

    output$dataset_info <- renderText({
      paste0("Title: ", selected_dataset[,"title"],"\n\n",
             "Dataset : ", input$data_select, "\n\n",
             "Source: ", selected_dataset[,"source"], "\n\n",
             "Column/Structure Information: ", selected_dataset[,"information"])
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
      src = " https://fuchsfranklin23.shinyapps.io/chapter_1_to_6_learning/", width = 1280, height = 720
    )
  })
  output$frame1 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin23.shinyapps.io/chapter_7_to_12_learning/", width = 1280, height = 720
    )
  })
  output$frame2 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin23.shinyapps.io/chapter_14_to_27_learning/", width = 1280, height = 720
    )
  })
  output$frame3 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin23.shinyapps.io/chapter_28_to_32_learning/", width = 1280, height = 720
    )
  })
  output$frame4 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin23.shinyapps.io/chapter_33_to_37_learning/", width = 1280, height = 720
    )
  })
  output$frame5 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin24.shinyapps.io/chapter_38_to_43_learning/", width = 1280, height = 720
    )
  })
  output$frame6 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin24.shinyapps.io/chapter_44_to_48_learning/", width = 1280, height = 720
    )
  })
  output$frame7 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin24.shinyapps.io/chapter_49_to_54_learning/", width = 1280, height = 720
    )
  })
  output$frame8 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin24.shinyapps.io/chapter_55_to_60_learning/", width = 1280, height = 720
    )
  })
  output$frame9 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin24.shinyapps.io/chapter_61_to_66_learning/", width = 1280, height = 720
    )
  })
  output$frame10 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin25.shinyapps.io/chapter_67_to_75_learning/", width = 1280, height = 720
    )
  })
  output$frame11 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin25.shinyapps.io/chapter_76_to_82_learning/", width = 1280, height = 720
    )
  })
  output$frame12 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin25.shinyapps.io/chapter_83_to_89_learning/", width = 1280, height = 720
    )
  })
  output$frame13 <- renderUI({
    tags$iframe(
      src = " https://fuchsfranklin25.shinyapps.io/chapter_90_to_96_learning/", width = 1280, height = 720
    )
  })
}

shinyApp(ui, server)
