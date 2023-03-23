## app.R ##
library(shinydashboard)
library(shinyjs)
library(shinyBS)
library(DT)
library(ggplot2)
library(radiant)
library(learnr)

# Pre-load all dataset names into app
data_names <- data(package = "BaltimoreTrails")

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
      tabItem(
        tabName = "dataview",
        h1("Data Viewing and Downloading Tool"),
        fluidRow(
          align = "center",
          box(
            status = "primary", height = 200,
            br(),
            selectizeInput(
              "data_select", h2("1. Select Dataset"),
              choices = data_names$results[, 3]
            ),
          ),
          box(
            status = "primary", height = 200,
            h2("2. Dataset Information"),
          ),
        ),
        fluidRow(
          box(
            width = 12, status = "primary",
            h2("2. Edit, Download, and Univariate Data Plots", align = "center"),
            uiOutput("modals"),
            dataTableOutput("mytable")
          ),
        ),
        fluidRow(
          box(
            width = 12, status = "primary",
            h2("3. Multivariate Data Plots", align = "center"),

            # Select input for x-axis variable
            selectInput("xvar", "X-axis variable:", choices = c()),

            # Select input for plot type
            selectInput("type", "Plot type:", choices = c("scatter", "density")),

            # Select input for y-axis variable
            selectInput("yvar", "Y-axis variable (Optional):", choices = c()),

            # Select input for facet rows by variable
            selectInput("facet_row", "Facet rows by variable (Optional):", choices = c()),

            # Select input for color by variable
            selectInput("color", "Color by variable (Optional):", choices = c()),

            # Output radiant plot
            plotOutput("radiant_plot")
          ),
        ),
      ),

      # Second tab content
      tabItem(
        tabName = "map",
        h1("Interactive Baltimore City Map")
      ),

      # Third tab content
      tabItem(
        tabName = "learning",
        h1("Interactive Learning"),
        selectInput(
          "chapter_select", "Select Chapter to Practice",
          c(
            "Chapter 1: BLA" = "ch1",
            "Chapter 2: BLABLA" = "ch2",
            "Chapter 3: BLABLABLA" = "ch3"
          )
        ),
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


          # Have Selectinputs for xvar and plot type be updated when new dataset is selected
          # (but have other inputs be seperately reactively dependent of xvar)
          updateSelectInput(session, "xvar", choices = colnames(Dat))

          if (!is.null(Dat)) {
            if (length(Dat) > 0) {
              if (input$yvar == "") {
                updateSelectInput(session, "type", choices = c(
                  "Distribution" = "dist",
                  "Density" = "density"
                ))
              } else if (input$facet_row == "" && input$color == "") {
                updateSelectInput(session, "type", choices = c(
                  "Scatter" = "scatter",
                  "Line" = "line",
                  "Bar" = "bar",
                  "Box-plot" = "box"
                ))
              } else if (input$facet_row != "" && input$color == "") {
                updateSelectInput(session, "type", choices = c(
                  "Scatter" = "scatter",
                  "Line" = "line",
                  "Bar" = "bar",
                  "Box-plot" = "box"
                ))
              } else if (input$facet_row == "" && input$color != "") {
                updateSelectInput(session, "type", choices = c(
                  "Scatter" = "scatter",
                  "Line" = "line",
                  "Bar" = "bar",
                  "Box-plot" = "box"
                ))
              }
            }
          }

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

  output$radiant_plot <- renderPlot({
    Dat <- dat()

    if (nrow(Dat) > 1000) {
      Dat <- Dat[sample(nrow(Dat), 1000), ]
    }

    # Create a scatterplot using the visualize() function
    if (!is.null(Dat)) {
      if (length(Dat) > 0) {
        # Call visualize function from radiant package

        # Cases of different optional parameters left out
        if (input$yvar == "") {
          visualize(
            dataset = Dat,
            xvar = input$xvar,
            type = input$type,
            shiny = TRUE
          )
        } else if (input$facet_row == "" && input$color == "") {
          visualize(
            dataset = Dat,
            xvar = input$xvar,
            yvar = input$yvar,
            type = input$type,
            shiny = TRUE
          )
        } else if (input$facet_row != "" && input$color == "") {
          visualize(
            dataset = Dat,
            xvar = input$xvar,
            yvar = input$yvar,
            type = input$type,
            facet_row = input$facet_row,
            shiny = TRUE
          )
        } else if (input$facet_row == "" && input$color != "") {
          visualize(
            dataset = Dat,
            xvar = input$xvar,
            yvar = input$yvar,
            type = input$type,
            color = input$color,
            shiny = TRUE
          )
        }
      }
    }
  })

  # Generate Multivariate Plot based on inputs
  observeEvent(input$generate_plot_button, {
    updateSelectInput(session, "xvar", choices = colnames(Dat))
    updateSelectInput(session, "yvar", choices = c("", colnames(Dat)))
    updateSelectInput(session, "facet_row", choices = c("", colnames(Dat)))
    updateSelectInput(session, "color", choices = c("", colnames(Dat)))

    if (!is.null(Dat)) {
      if (length(Dat) > 0) {
        if (input$yvar == "") {
          updateSelectInput(session, "type", choices = c(
            "Distribution" = "dist",
            "Density" = "density"
          ))
        } else if (input$facet_row == "" && input$color == "") {
          updateSelectInput(session, "type", choices = c(
            "Scatter" = "scatter",
            "Line" = "line",
            "Bar" = "bar",
            "Box-plot" = "box"
          ))
        } else if (input$facet_row != "" && input$color == "") {
          updateSelectInput(session, "type", choices = c(
            "Scatter" = "scatter",
            "Line" = "line",
            "Bar" = "bar",
            "Box-plot" = "box"
          ))
        } else if (input$facet_row == "" && input$color != "") {
          updateSelectInput(session, "type", choices = c(
            "Scatter" = "scatter",
            "Line" = "line",
            "Bar" = "bar",
            "Box-plot" = "box"
          ))
        }
      }
    }
  })

  ##### TAB 2 -- Data and Plotting Tools #####

  ##### TAB 3 -- Data and Plotting Tools #####
  # Generate Tab 3 Interactive LearnR frame (based on input selection later)
  output$frame <- renderUI({
    tags$iframe(
      src = "https://jjallaire.shinyapps.io/learnr-tutorial-03a-data-manip-filter/", width = 1280, height = 720
    )
  })
}

shinyApp(ui, server)
