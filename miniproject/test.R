library(shiny)
library(ggplot2)
library(aos)
library(gganimate)
library(gifski)
library(png)
library(gapminder)
library(plotly)
library(dplyr)

# Loading csv data
PCG <- read.csv("./data/PCGamers.csv")

# Load data for the new plot
yearly_data <- read.csv("./data/yearly_average_rating_top_genres.csv")
sorted_genres <- read.csv("./data/sorted_genres.csv")

# Filter top 5 genres
top_genres <- sorted_genres$Genres[1:5]
filtered_data <- yearly_data %>% filter(Genres %in% top_genres)

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
        
        #floating-list {
        position: fixed;
        top: 50%;
        right: 20px;
        transform: translateY(-50%);
        background-color: rgba(0, 0, 0, 0.5);
        padding: 10px;
        border-radius: 5px;
        z-index: 9999; 
      }

      #floating-list ul {
        list-style-type: none;
        padding: 0;
        margin: 0;
      }

      #floating-list li {
        margin-bottom: 5px;
      }

      #floating-list a {
        color: white;
        text-decoration: none;
        padding: 5px 10px;
        display: block;
        transition: background-color 0.3s ease;
      }

      #floating-list a:hover {
        background-color: rgba(255, 255, 255, 0.2);
      }

      #floating-list a.active {
        background-color: rgba(0, 128, 0, 0.4); /* Change the background color for active links */
        color: green;
        font-weight: bold; /* Add font weight for active links (optional) */
      }
        
        
      ")
    )
  ),
  tags$script(
    HTML("// JavaScript code to update section title on click
        function updateSectionTitle(title) {
          document.getElementById('current-section-title').innerText = title;
        }

        // Add event listeners to floating list links
        document.querySelectorAll('#floating-list a').forEach(function(link) {
          link.addEventListener('click', function(event) {
            event.preventDefault();
            var targetId = event.target.getAttribute('href');
            var targetSection = document.querySelector(targetId);
            targetSection.scrollIntoView({ behavior: 'smooth' });

            // Get the title of the clicked section
            var sectionTitle = event.target.innerText;

            // Update the section title instantly
            updateSectionTitle(sectionTitle);
          });
        });
         ")
  ),
  aos(
    element = tags$div(
      id = "hero-section",
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
    id = "Intro-section",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h1("Introduction to the World of Gamers"),
        tags$div(style = "display: flex; align-items: center;",
                 
                 tags$div(style = "margin-left: 00px; font-size: 14px", "Video Games are something that all of us have played at least once in our lives! ", 
                          tags$br(), 
                          "People share their love for this hobby worldwide!"),
                 #tags$img(src = "img/character4.gif", style = "width: 200px; height: 200px; margin-top: 0px;"),
        ),
        tags$span(style = "display: inline-block; margin-bottom: 200px;"),
        aos(
          animation = "fade-left",
          delay = "10000",
          duration = "10000",
          element = tags$div(plotlyOutput("plot1"))
        )
      ),
      animation = "fade-up"
    ),
    
  ),
  tags$div(
    id = "gamers-section",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h3("Number of Gamers"),
        div(style = "display: flex; align-items: center;",
            
            tags$div(style = "margin-left: 00px;", "Take a look at how Gamers are Rising!"),
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
    
  ),
  tags$div(
    id = "prices-section",
    class = "section-content",
    aos(
      element = tags$div(
        #  class = "section-content",
        #id = "prices-section",
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
  ),
  
  tags$div(id = "floating-list",
           tags$head(
             tags$style(
               HTML("#floating-list {
        position: fixed;
        top: 50%;
        right: 20px;
        transform: translateY(-50%);
        background-color: rgba(0, 0, 0, 0.5);
        padding: 10px;
        border-radius: 5px;
        z-index: 9999; 
      }

      #floating-list ul {
        list-style-type: none;
        padding: 0;
        margin: 0;
      }

      #floating-list li {
        margin-bottom: 5px;
      }

      #floating-list a {
        color: white;
        text-decoration: none;
        padding: 5px 10px;
        display: block;
        transition: background-color 0.3s ease;
      }

      #floating-list a:hover {
        background-color: rgba(255, 255, 255, 0.2);
      }

      #floating-list a.active {
        background-color: rgba(0, 100, 0, 0.4); /* Change the background color for active links */
        color: green;
        font-weight: bold; /* Add font weight for active links (optional) */
      }")
             )
           ),
           tags$ul(
             tags$li(tags$a(href = "#hero-section", "Introduction")),
             tags$li(tags$a(href = "#gamers-section", "Number of Gamers")),
             tags$li(tags$a(href = "#prices-section", "Exploring Game Prices")),
             tags$li(tags$a(href = "#line-plot-section", "Line Plot"))
           )
  ),
  #plotlyOutput("line_plot"),  # Add this line to include the new plot
  uiOutput("floating_list_js")
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
  
  output$line_plot <- renderPlotly({
    # Convert Year column to numeric
    filtered_data$Year <- as.numeric(as.character(filtered_data$Year))
    
    # Plot
    p <- ggplot(filtered_data, aes(x = Year, y = Rating, color = Genres)) +
      geom_line() +
      labs(title = "Yearly Average Ratings of Top 5 Genres",
           x = "Year", y = "Average Rating",
           color = "Genre") +
      theme_minimal()
    
    # Convert ggplot to plotly
    ggplotly(p)
  })
  
  
  
  # Add this JavaScript code at the end of your UI
  output$floating_list_js <- renderUI({
    tags$script(HTML(
      "
      function updateActiveSection() {
        var sections = document.querySelectorAll('.section-content');
        var links = document.querySelectorAll('#floating-list a');
        sections.forEach(function(section) {
          var sectionTop = section.offsetTop - window.innerHeight / 2;
          var sectionBottom = sectionTop + section.offsetHeight;
          var scrollPosition = window.pageYOffset + window.innerHeight / 2;
          if (scrollPosition >= sectionTop && scrollPosition < sectionBottom) {
            links.forEach(function(link) {
              link.classList.remove('active');
            });
            var sectionId = '#' + section.id;
            var activeLink = document.querySelector('#floating-list a[href=\"' + sectionId + '\"]');
            if (activeLink) {
              activeLink.classList.add('active');
            }
          }
        });
      }
      
      window.addEventListener('scroll', updateActiveSection);
      Shiny.addCustomMessageHandler('updateActiveSection', function() {
        updateActiveSection();
      });
      
      var links = document.querySelectorAll('#floating-list a');
      links.forEach(function(link) {
        link.addEventListener('click', function(event) {
          event.preventDefault();
          var targetId = event.target.getAttribute('href');
          var targetSection = document.querySelector(targetId);
          targetSection.scrollIntoView({ behavior: 'smooth' });
          updateActiveSection(); // Update the active section after scrolling
        });
      });
      
      updateActiveSection(); // Call the function initially
      "
    ))
  })
  
  
}
shinyApp(ui, server)