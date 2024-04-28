library(shiny)
library(ggplot2)
library(aos)
library(SteamR)
library(gganimate)
library(gifski)
library(png)
library(gapminder)
library(plotly)

# Loading csv data
PCG <- read.csv("./data/PCGamers.csv")

gnews(gameid = "1174180", count = "3")

ui <- fluidPage(
  theme = "bootstrap.min.css",
  use_aos(
    duration = 1000,
    easing = "ease-in-out-back",
    delay = 0
  ),
  tags$head(
    tags$style(
      HTML("
        body {
          background-color: black;
          margin: 0;
          padding: 0;
          color: white;
        }
        
        .hero-section {
          height: 100vh;
          background-image: url('img/mario1.gif');
          background-size: cover;
          display: flex;
          justify-content: center;
          align-items: center;
          color: white;
          text-align: center;
        }
        
        .hero-title {
          font-size: 6rem;
          font-weight: bold;
        }
        
        .hero-subtitle {
          font-size: 3rem;
          font-weight: bold;
          margin-bottom: 2rem;
        }
        
        .scroll-indicator {
          font-size: 1.5rem;
          animation: bounce 2s infinite;
        }
        
        .section-content {
          padding: 50px;
        }
        
        @keyframes bounce {
          0%, 20%, 50%, 80%, 100% {
            transform: translateY(0);
          }
          
          40% {
            transform: translateY(-30px);
          }
          
          60% {
            transform: translateY(-15px);
          }
        }
      ")
    )
  ),
  aos(
    element = tags$div(
      class = "hero-section",
      tags$div(
        tags$h1(class = "hero-title", "Let's Explore the World of Gaming"),
        tags$p(class = "hero-subtitle", "With Harsh and Aradhya!"),
        tags$div(class = "scroll-indicator", "Scroll Down")
      )
    ),
    animation = "fade-in"
  ),
  tags$div(
    class = "section-content",
    aos(
      element = tags$div(
        tags$h3("Number of Gamers"),
        div(style = "display: flex; align-items: center;",
            
            tags$div(style = "margin-left: 00px;", "Take a look at the distribution of games across different genres."),
            tags$img(src = "img/character4.gif", style = "width: 200px; height: 200px; margin-top: 0px;"),
        ),
        aos(
          animation = "fade-left",
          delay = "10000",
          duration = "10000",
          element = tags$div(plotlyOutput("plot1"))
        )
      ),
      animation = "fade-up"
    ),
    aos(
      element = tags$div(
        tags$h3("Exploring Game Prices"),
        aos(
          duration = "1000",
          element = tags$p("Dive into the price distribution of games on Steam."),
          animation = "fade-left",
          delay = "1000"
        ),
        aos(
          duration = "1000",
          element = plotOutput("plot2"),
          animation = "fade-right",
          delay = "1000"
        )
      ),
      animation = "fade-up",
      delay = "5000"
    )
  )
)

server <- function(input, output, session) {
  # Render the GIF file in the plotOutput
  # making a continuous list of years from 2008 to 2024
  #Year2 <- seq(2008, 2024, by = 0.00001)
  
  
  accumulate_by <- function(dat, var) {
    var <- lazyeval::f_eval(var, dat)
    lvls <- plotly:::getLevels(var)
    dats <- lapply(seq_along(lvls), function(x) {
      cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
    })
    dplyr::bind_rows(dats)
  }
  
  # Load your data
  # PCG <- read.csv("./data/PCGamers.csv")
  
  output$plot1 <- renderPlotly({
    # Assuming your data is in 'PCG' dataframe
    fig <- PCG %>%
      accumulate_by(~Year)
    
    year2 <- seq(2008, 2024, by = 0.00001)
    
    fig <- fig %>%
      plot_ly(
        x = ~Year,
        y = ~NPCGM,
        frame = ~frame,
        type = 'bar',
        marker = list(color = "white", line = list(color = "black", width = 0.7)),
        showlegend = FALSE
      ) %>%
      add_trace(
        x = ~Year,
        y = ~NPCGM,
        mode = "lines",
        line = list(color = "rgb(255, 68, 204)", width = 2),
        frame = ~frame,
        type = 'scatter',
        showlegend = FALSE
      )
    
    fig <- fig %>%
      layout(
        xaxis = list(title = "Year", tickfont = list(color = "white")),
        yaxis = list(title = "Number of Gamers (in Millions)", tickfont = list(color = "white")),
        title = "Number of PC Gamers Over the Years",
        plot_bgcolor = "black",
        paper_bgcolor = "black",
        # changing height 
        #height = 600,
        
        font = list(color = "white"),
        updatemenus = list(
          list()
        )
      )
    
    fig <- fig %>%
      animation_opts(
        frame = 600,
        transition = 600,
        easing = "linear",
        redraw = FALSE,
        mode = "afterall"
      ) %>%
      animation_slider(
        currentvalue = list(prefix = "Year: ", font = list(color = "white"))
      )
    
    fig <- fig %>%
      animation_button(
        x = 1, xanchor = "right", y = -1, yanchor = "bottom"
      )
    
    fig
  })
  output$plot2 <- renderPlot({
    ggplot(mpg, aes(cty, hwy, color = class)) +
      geom_point()
  })
}

shinyApp(ui, server)