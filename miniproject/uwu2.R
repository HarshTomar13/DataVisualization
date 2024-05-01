library(shiny)
library(ggplot2)
library(aos)
library(gganimate)
library(gifski)
library(png)
library(gapminder)
library(plotly)
library(dplyr)
library(DT)
# Loading csv data
PCG <- read.csv("./data/PCGamers.csv")





# Load data for the new plot
yearly_data <- read.csv("./data/yearly_average_rating_top_genres.csv")
sorted_genres <- read.csv("./data/sorted_genres.csv")


# Filter top 5 genres
top_genres <- sorted_genres$Genres[1:5]
filtered_data <- yearly_data %>% filter(Genres %in% top_genres)

# Load the CSV file for consoles
consoles <- read.csv("./data/sorted_best-selling_game_consoles.csv")

# Filter data for the specified year range
consoles <- consoles[consoles$Released.Year >= 1976 & consoles$Released.Year <= 1990, ]

# Load the CSV file for video games
vgsales <- read.csv("./data/vgsales.csv")

# Filter data for the specified year range
vgsales <- vgsales[vgsales$Year >= 1976 & vgsales$Year <= 1990, ]

# Load data for consoles
consoles_1991_2000 <- read.csv("./data/sorted_best-selling_game_consoles.csv")
consoles_1991_2000 <- consoles_1991_2000[consoles_1991_2000$Released.Year >= 1991 & consoles_1991_2000$Released.Year <= 2000, ]

consoles_2001_2010 <- read.csv("./data/sorted_best-selling_game_consoles.csv")
consoles_2001_2010 <- consoles_2001_2010[consoles_2001_2010$Released.Year >= 2001 & consoles_2001_2010$Released.Year <= 2010, ]

consoles_2011_2020 <- read.csv("./data/sorted_best-selling_game_consoles.csv")
consoles_2011_2020 <- consoles_2011_2020[consoles_2011_2020$Released.Year >= 2011 & consoles_2011_2020$Released.Year <= 2020, ]

# Load data for video games
vgsales_1991_2000 <- read.csv("./data/vgsales.csv")
vgsales_1991_2000 <- vgsales_1991_2000[vgsales_1991_2000$Year >= 1991 & vgsales_1991_2000$Year <= 2000, ]

vgsales_2001_2010 <- read.csv("./data/vgsales.csv")
vgsales_2001_2010 <- vgsales_2001_2010[vgsales_2001_2010$Year >= 2001 & vgsales_2001_2010$Year <= 2010, ]

vgsales_2011_2020 <- read.csv("./data/vgsales.csv")
vgsales_2011_2020 <- vgsales_2011_2020[vgsales_2011_2020$Year >= 2011 & vgsales_2011_2020$Year <= 2020, ]

# Get the top 10 most sold video games
top_games <- vgsales[order(-vgsales$Global_Sales), ]






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
        tags$h1(class = "hero-title", "Let's Explore the History of Gaming"),
        tags$p(class = "hero-subtitle", "With Harsh and Aradhya!"),
        tags$div(class = "scroll-indicator", "Scroll Down")
      )
    ),
    animation = "fade-in"
  ),
  tags$div(
    id = "introsection",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h1("Introduction to the World of Gamers"),
        tags$div(style = "display: flex; align-items: center;",
                 
                 tags$div(style = "margin-left: 00px; font-size: 16px; font-weight: bold ", "Video Games 🎮 are something that all of us have played at least once in our lives! ", 
                          tags$span(style = "display: inline-block; margin-left: 100px;"),
                          tags$img(src = "img/sonic.gif", style = "width: 100px; height: 100px;"),
                          tags$br(), 
                          "People share their love ❤️ for this hobby worldwide!",
                          tags$br(),
                          "Whatever the age group be, everyone loves to play their favourite video game!",
                          tags$br(),
                          "In this journey, we will have a look at the History of Gaming and how it has evolved over the years!",)
                 #tags$img(src = "img/character4.gif", style = "width: 200px; height: 200px; margin-top: 0px;"),
        ),
        
        #aos(
        #  animation = "fade-left",
        #  delay = "10000",
        #  duration = "10000",
        #  element = tags$div(plotlyOutput("plot1"))
        #)
      ),
      animation = "fade-up"
    ),
    
  ),
  tags$span(style = "display: inline-block; margin-bottom: 10px;"),
  
  tags$div(
    id = "197090section",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h2("Gaming Era: 1970-1990's 🕹️"),
        div(style = "display: flex; align-items: center;",
            
            tags$div(style = "margin-left: 00px; font-size: 16px; font-weight: bold ",
                     "At the beginning of the 1970s, video games 🎮 existed almost entirely as novelties passed around by programmers and technicians with access to computers, primarily at research institutions and large companies.", 
                     tags$span(style = "display: inline-block; margin-left: 100px;"),
                     #tags$img(src = "img/sonic.gif", style = "width: 100px; height: 100px;"),
                     tags$br(), 
                     "1970 marked a crucial year in the transition of electronic games from academic to mainstream, with developments in chess artificial intelligence and in the concept of commercialized video games.",
                     
                     tags$br(),
                     "Thanks to AI, we got NPCs! 🤖",
                     tags$img(src = "img/ml.gif", style = "width: 100px; height: 100px;"),
                     
                     tags$br(),
                     tags$span(style = "display: inline-block; margin-bottom: 50px;"),
                     
                     "Major Events in The Golden Era: ",
                     
                     tags$ul(
                       tags$li("1972: The release of 'Pong' marks the beginning of the commercial video game industry.", tags$img(src = "img/pong.gif", style = "width: 100px; height: 100px;")),
                       
                       tags$li("1977: Atari releases the Atari 2600 home video game console, popularizing video gaming in homes.", tags$img(src = "img/atari2600.gif", style = "width: 100px; height: 100px;")),
                       tags$li("1983: The video game industry experiences a crash due to oversaturation of low-quality games and competition from home computers.", tags$img(src = "img/crash.gif", style = "width: 100px; height: 100px;")),
                       tags$li("1985: Nintendo releases the Nintendo Entertainment System (NES), revitalizing the video game industry with iconic games like Super Mario Bros.", tags$img(src = "img/supermario.gif", style = "width: 100px; height: 100px;")),
                       tags$li("1989: Nintendo releases the Game Boy, revolutionizing handheld gaming.", tags$img(src = "img/gameboy.gif", style = "width: 100px; height: 100px;")),
                       tags$li("1990: The release of Sonic the Hedgehog by Sega introduces a new era of mascot-based platformer games.", tags$img(src = "img/sonic.gif", style = "width: 100px; height: 100px;"))
                     ),
                     
                     "We are sure! that the Golden Era was an amazing time for Gamers who just got their hands on the world's first ever video games!",)
            
            
            
            #tags$img(src = "img/character4.gif", style = "width: 200px; height: 200px; margin-top: 0px;"),
        ),
        tags$span(style="display: inline-block; margin-bottom: 50px;"),
        aos(
          animation = "zoom-out-down",
          delay = "10000",
          duration = "10000",
          element = tags$div(tags$span(style="display: inline-block; margin-top: 20px;"),
                             tags$h4("We are in the Golden ERA, and you need to get a console!",
                                     tags$img(src = "img/giphy (1).gif", style = "width: 100px; height: 100px; margin-left: 100px; border-radius: 50%;"),
                                     tags$br(),
                                     
                                     tags$br(),
                                     "Let's look at some sales data and try to decide what's the most popular console these days!"),
                             tags$span(style="display: inline-block; margin-top: 20px;"),
                             plotlyOutput("console_plot"),
                             tags$span(style = "display: inline-block; margin-bottom: 20px; margin-top:10px"),
                             tags$h4("Well, you've got your console 🎮. Let's look at some great games you can play on it!"),
                             tags$span(style = "display: inline-block; margin-top: 10px;"),
                             tags$h4("Let's Look at their sales 💸 to determine which is selling the most!"),
                             tags$span(style= "display: inline-block; margin-bottom: 20px; margin-top:10px;"),
                             plotlyOutput("game_plot"),
                             tags$span(style = "display: inline-block; margin-top: 30px;"),
                             DTOutput("platform_table")
          )
        )
      ),
      animation = "zoom-in-left"
    ),
    
  ),
  tags$span(style = "display: inline-block; margin-top: 50px"),
  # Img Tag with long length
  tags$img(src = "img/running.gif", style = "width: 100px; height: 100px; margin-top: 0px; border-radius: 50%; margin-left: auto; margin-right: auto; display: block;"),
  
  
  
  tags$div(
    id = "Section2",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h2("Gaming Era: 1991-2000s 🎮"),
        div(style = "display: flex; align-items: center;",
            
            tags$div(style = "margin-left: 00px; font-size: 16px; font-weight: bold ",
                     "The 1990s marked a significant period of growth and innovation in the video game industry. With advancements in technology and the introduction of 3D graphics, video games became more immersive and visually stunning.", 
                     tags$span(style = "display: inline-block; margin-left: 100px;"),
                     tags$br(), 
                     "1991 saw the release of Sonic the Hedgehog for the Sega Genesis, becoming a major competitor to Nintendo's Mario franchise.",
                     
                     tags$br(),
                     "The mid-1990s witnessed the rise of 3D gaming with the release of consoles like the Sony PlayStation and the Nintendo 64, ushering in a new era of gaming experiences.",
                     tags$br(),
                     "1996 saw the release of Pokémon, which became a global phenomenon with its video games, trading card games, and animated series.",
                     tags$br(),
                     "The late 1990s saw the emergence of online gaming with the launch of services like Battle.net and the rise of massively multiplayer online role-playing games (MMORPGs) like Ultima Online and EverQuest.",
                     
                     tags$br(),
                     "The turn of the millennium brought about the release of the PlayStation 2, which became one of the best-selling consoles of all time, and the rise of Microsoft's Xbox as a major player in the console market."
            )    
        ),
        tags$span(style="display: inline-block; margin-bottom: 50px;"),
        aos(
          animation = "zoom-out-down",
          delay = "10000",
          duration = "10000",
          element = tags$div(tags$span(style="display: inline-block; margin-top: 20px;"),
                             tags$h4("Welcome to the 1990s and 2000s, the era of 3D gaming and online multiplayer!",
                                     tags$img(src = "img/cs1.6.gif", style = "width: 150px; height: 150px; margin-left: 100px;"),
                                     tags$br(),
                                     
                                     tags$br(),
                                     "Let's explore some iconic games and consoles from this era."),
                             tags$span(style="display: inline-block; margin-top: 20px;"),
                             #plotlyOutput("game_plot_1991_2000"),
                             tags$span(style = "display: inline-block; margin-bottom: 20px; margin-top:10px"),
                             tags$h4("Now, let's take a look at the top-selling games of this era!"),
                             tags$span(style = "display: inline-block; margin-top: 10px;"),
                             tags$h4("And let's analyze the sales figures to see which games dominated the market."),
                             tags$span(style= "display: inline-block; margin-bottom: 20px; margin-top:10px;"),
                             plotlyOutput("console_plot_1991_2000"),
                             tags$span(style = "display: inline-block; margin-top: 30px;"),
                             DTOutput("top_game_table")
          )
        )
      ),
      animation = "zoom-in-left"
    ),
    
  ),
  tags$span(style = "display: inline-block; margin-top: 50px"),
  # Img Tag with long length
  tags$img(src = "img/running.gif", style = "width: 100px; height: 100px; margin-top: 0px; border-radius: 50%; margin-left: auto; margin-right: auto; display: block;"),
  
  tags$div(
    id = "Section3",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h3("Gaming Era: 2000-2010 🕹️"),
        div(style = "display: flex; align-items: center;",
            
            tags$div(style = "margin-left: 00px; font-size: 16px; font-weight: bold ",
                     "The 2000s saw further advancements in video game technology and the expansion of gaming into mainstream culture. With the release of powerful consoles like the PlayStation 3, Xbox 360, and Nintendo Wii, gaming became more accessible and immersive than ever before.", 
                     tags$span(style = "display: inline-block; margin-left: 100px;"),
                     tags$br(), 
                     "The rise of online gaming continued, with multiplayer experiences becoming increasingly popular. Games like World of Warcraft and Call of Duty dominated the online gaming scene, attracting millions of players worldwide.",
                     
                     tags$br(),
                     "The introduction of motion control gaming with the Nintendo Wii revolutionized the way people interacted with video games, appealing to a broader audience beyond traditional gamers.",
                     tags$br(),
                     "2007 marked the release of the iPhone, which transformed mobile gaming with its App Store, offering a wide variety of games for users to enjoy on the go.",
                     
                     tags$br(),
                     "Overall, the 2000s were a transformative decade for the video game industry, laying the groundwork for the diverse and thriving gaming landscape we see today."
            )    
        ),
        tags$span(style="display: inline-block; margin-bottom: 50px;"),
        aos(
          animation = "zoom-out-down",
          delay = "10000",
          duration = "10000",
          element = tags$div(tags$span(style="display: inline-block; margin-top: 20px;"),
                             tags$h4("Welcome to the 2000s, a decade of innovation and expansion in gaming!",
                                     tags$img(src = "img/Vice_city.gif", style = "width: 150px; height: 150px; margin-left: 100px;"),
                                     tags$br(),
                                     
                                     tags$br(),
                                     "Let's explore some of the iconic consoles and games that defined this era."),
                             tags$span(style="display: inline-block; margin-top: 20px;"),
                             plotlyOutput("console_plot_2001_2010"),
                             tags$span(style = "display: inline-block; margin-bottom: 20px; margin-top:10px"),
                             #tags$h4("Now, let's take a look at some of the top-selling games of this decade!"),
                             tags$span(style = "display: inline-block; margin-top: 10px;"),
                             #tags$h4("And let's analyze the sales figures to see which consoles dominated the market."),
                             #tags$span(style= "display: inline-block; margin-bottom: 20px; margin-top:10px;"),
                             #plotlyOutput("top_games_sales_plot"),
                             #tags$span(style = "display: inline-block; margin-top: 30px;"),
                             #DTOutput("top_games_table")
          )
        )
      ),
      animation = "zoom-in-left"
    ),
    
  ),
  
  tags$span(style = "display: inline-block; margin-top: 50px"),
  # Img Tag with long length
  tags$img(src = "img/running.gif", style = "width: 100px; height: 100px; margin-top: 0px; border-radius: 50%; margin-left: auto; margin-right: auto; display: block;"),
  
  tags$div(
    id = "Section4",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h3("Gaming Era: 2011-2020 🕹️"),
        div(style = "display: flex; align-items: center;",
            
            tags$div(style = "margin-left: 00px; font-size: 16px; font-weight: bold ",
                     "The period from 2011 to 2020 witnessed significant advancements and innovations in the gaming industry. With the introduction of powerful gaming consoles like the PlayStation 4, Xbox One, and Nintendo Switch, gaming experiences became more immersive and visually stunning than ever before.", 
                     tags$span(style = "display: inline-block; margin-left: 100px;"),
                     tags$br(), 
                     "The rise of indie game development led to the creation of unique and innovative games, challenging the dominance of big-budget titles. Online gaming continued to thrive, with the popularity of esports soaring and streaming platforms like Twitch becoming mainstream.",
                     
                     tags$br(),
                     "The emergence of virtual reality (VR) technology provided gamers with entirely new ways to experience games, blurring the lines between reality and virtual worlds.",
                     tags$br(),
                     "Mobile gaming also experienced exponential growth, with smartphone gaming becoming a ubiquitous form of entertainment for people of all ages.",
                     
                     tags$br(),
                     "Overall, the 2010s were a transformative decade for the gaming industry, pushing the boundaries of technology and creativity to new heights."
            )    
        ),
        tags$span(style="display: inline-block; margin-bottom: 50px;"),
        aos(
          animation = "zoom-out-down",
          delay = "10000",
          duration = "10000",
          element = tags$div(tags$span(style="display: inline-block; margin-top: 20px;"),
                             tags$h4("Welcome to the 2010s, a decade of innovation and evolution in gaming!",
                                     tags$img(src = "img/mario_dance.gif", style = "width: 150px; height: 150px; margin-left: 100px;"),
                                     tags$br(),
                                     
                                     tags$br(),
                                     "Let's explore some of the groundbreaking consoles and games that defined this era."),
                             tags$span(style="display: inline-block; margin-top: 20px;"),
                             plotlyOutput("console_plot_2011_2020"),
                             tags$span(style = "display: inline-block; margin-bottom: 20px; margin-top:10px"),
                             #tags$h4("Now, let's take a look at some of the top-selling games of this decade!"),
                             #tags$span(style = "display: inline-block; margin-top: 10px;"),
                             #tags$h4("And let's analyze the sales figures to see which games dominated the market."),
                             #tags$span(style= "display: inline-block; margin-bottom: 20px; margin-top:10px;"),
                             #plotlyOutput("top_games_sales_plot"),
                             #tags$span(style = "display: inline-block; margin-top: 30px;"),
                             #DTOutput("top_games_table")
          )
        )
      ),
      animation = "zoom-in-left"
    ),
    
  ),
  
  tags$span(style = "display: inline-block; margin-top: 50px"),
  # Img Tag with long length
  tags$img(src = "img/running.gif", style = "width: 100px; height: 100px; margin-top: 0px; border-radius: 50%; margin-left: auto; margin-right: auto; display: block;"),
  
  tags$div(
    id = "Section5",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h3("Present Scenario 🌟🕹️"),
        div(style = "display: flex; align-items: center;",
            
            tags$div(style = "margin-left: 00px; font-size: 16px; font-weight: bold ",
                     "The gaming industry is currently experiencing unprecedented growth and innovation. With advancements in technology and the widespread availability of high-speed internet, gaming has become more accessible and diverse than ever before.", 
                     tags$span(style = "display: inline-block; margin-left: 100px;"),
                     tags$br(), 
                     "Esports has emerged as a major force in the gaming world, with professional gaming tournaments drawing millions of viewers worldwide. Streaming platforms like Twitch and YouTube Gaming have become hubs for gamers and content creators, fostering vibrant communities and new career opportunities.",
                     
                     tags$br(),
                     "The rise of cloud gaming services allows players to access high-quality games on any device with an internet connection, further expanding the reach of gaming.",
                     tags$br(),
                     "Virtual reality (VR) and augmented reality (AR) technologies continue to evolve, promising immersive gaming experiences that blur the lines between the real and virtual worlds.",
                     tags$br(),
                     "Mobile gaming remains a dominant force in the industry, with smartphones becoming powerful gaming devices capable of delivering console-quality experiences on the go.",
                     
                     tags$br(),
                     "Overall, the present scenario of the gaming industry is marked by innovation, inclusivity, and exponential growth, shaping the future of entertainment and interactive experiences."
            )    
        ),
        tags$span(style="display: inline-block; margin-bottom: 50px;"),
        aos(
          animation = "zoom-out-down",
          delay = "10000",
          duration = "10000",
          element = tags$div(tags$span(style="display: inline-block; margin-top: 20px;"),
                             tags$h4("Welcome to the future of gaming, where possibilities are endless!",
                                     tags$img(src = "img/future.gif", style = "width: 150px; height: 100px; margin-left: 150px; border-radius: 50%;"),
                                     tags$br(),
                                     
                                     tags$br(),
                                     "Let's continue to explore the ever-evolving landscape of gaming and embrace the exciting opportunities it brings."),
                             tags$span(style="display: inline-block; margin-top: 20px;"),
                             tags$div(style = "margin-left: 00px;", "Take a look at how Gamers are Rising!"),
                             tags$img(src = "img/character4.gif", style = "width: 200px; height: 200px; margin-top: 0px;"),
                             plotlyOutput("plot1"),
                             tags$span(style = "display: inline-block; margin-bottom: 20px; margin-top:10px"),
                             tags$h4("Here's a peek from where we started.", style = "font-weight:bold; text-align:center;"),
                             plotlyOutput("donutChart1980to1990"),
                             tags$span(style = "display: inline-block; margin-bottom: 20px; margin-top:10px"),
                             tags$h4("And this is what we love today!!", style = "font-weight:bold; text-align:center;"),
                             plotlyOutput("donutChart2020to2023"),
                             tags$span(style = "display: inline-block; margin-bottom: 20px; margin-top:10px"),
                             tags$h4("The top game genres of the present time not only reflect our diverse interests but also mirror the evolving landscape of interactive entertainment. Until next time, keep gaming, keep creating, and keep dreaming!!", style = "font-weight:bold; text-align:center;"),
                             #tags$h4("Now, let's take a look at some of the top-selling games of this decade!"),
                             #tags$span(style = "display: inline-block; margin-top: 10px;"),
                             #tags$h4("And let's analyze the sales figures to see which games dominated the market."),
                             #tags$span(style= "display: inline-block; margin-bottom: 20px; margin-top:10px;"),
                             #plotlyOutput("top_games_sales_plot"),
                             #tags$span(style = "display: inline-block; margin-top: 30px;"),
                             #DTOutput("top_games_table")
          )
        )
      ),
      animation = "zoom-in-left"
    ),
    
  ),
  tags$div(
    id = "gamers-section",
    class = "section-content",
    aos(
      element = tags$div(
        
        tags$h3("Thankyou ❤️ and happy gaming !!",style = "font-weight:bold; text-align:center;"),
        tags$span(style="display: inline-block; margin-bottom: 50px;"),
        aos(
          animation = "zoom-out-down",
          delay = "10000",
          duration = "10000",
          element = tags$div(tags$span(style="display: inline-block; margin-top: 20px;"),
                             #tags$h4("Welcome to the future of gaming, where possibilities are endless!",
                             tags$img(src = "img/thankyou.gif", style = "width: 700px; height: 500px; margin-left: 500px"),
          )
        )
      ),
      animation = "zoom-in-left"
    ),
    
  ),
  
  tags$span(style = "display: inline-block; margin-top: 50px"),
  
  
  tags$span(style = "display: inline-block; margin-top: 10px"),
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
             tags$li(tags$a(href = "#hero-section", "Banner!")),
             tags$li(tags$a(href = "#introsection", "Introduction")),
             tags$li(tags$a(href = "#197090section", "1970-1990 🪙")),
             tags$li(tags$a(href = "#Section2", "1991-2000 🎮")),
             tags$li(tags$a(href = "#Section3", "2001-2010 🐱")),
             tags$li(tags$a(href = "#Section4", "2011-2020 📈")),
             
             tags$li(tags$a(href = "#Section5", "The Present! 🎁")),
             
             tags$li(tags$a(href = "#gamers-section", "The End: ThankYou 🙏❤️")),
             #tags$li(tags$a(href = "#prices-section", "Exploring Game Prices")),
             #tags$li(tags$a(href = "#line-plot-section", "Line Plot"))
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
  
  
  
  
  
  output$console_plot <- renderPlotly({
    console_sales <- aggregate(consoles$Units.sold..million., by = list(Year = consoles$Released.Year, Console = consoles$Console.Name, Company = consoles$Company, ReleasedYear = consoles$Released.Year, DiscontinuedYear = consoles$Discontinuation.Year), FUN = sum)
    console_sales$Year <- as.factor(console_sales$Year)
    
    plot <- plot_ly(data = console_sales, x = ~Year, y = ~x, color = ~Console, type = 'scatter', mode = 'markers',
                    text = ~paste("Console: ", Console, "<br>", "Company: ", Company, "<br>", "Release Year: ", ReleasedYear, "<br>", "Discontinuation Year: ", DiscontinuedYear, "<br>", "Units Sold: ", x, " million"),
                    hoverinfo = "text") %>%
      layout(
        title = "Game Console Sales (1976-1990)",
        xaxis = list(title = "Year", tickfont = list(color = "white"), autorange = TRUE),
        yaxis = list(title = "Units Sold (million)", tickfont = list(color = "white"), autorange = TRUE),
        plot_bgcolor = "black",
        paper_bgcolor = "black",
        font = list(color = "white"),
        legend = list(font = list(color = "white")),
        #height = 500,
        margin = list(l = 50, r = 50, b = 50, t = -100) # Adjust margins as needed
      ) %>%
      add_markers(marker = list(size = 12))
    
    
    
    
    
    plot
  })
  
  # Server function for video games plot
  output$game_plot <- renderPlotly({
    plot <- plot_ly(data = top_games, x = ~Year, y = ~Global_Sales, color = ~Name, type = 'bar', mode = 'markers',
                    text = ~paste("Name: ", Name, "<br>",
                                  "Platform: ", Platform, "<br>",
                                  "Year: ", Year, "<br>",
                                  "Genre: ", Genre, "<br>",
                                  "Global Sales: ", Global_Sales), hoverinfo = "text", marker = list(size = 12, colorscale = "coolwarm")) %>%
      layout(title = "Video Games Sold(1976-1990)",
             xaxis = list(title = "Year", tickfont = list(color = "white"), autorange = TRUE),
             yaxis = list(title = "Global Sales", tickfont = list(color = "white"), autorange = TRUE),
             plot_bgcolor = "black",
             paper_bgcolor = "black",
             font = list(color = "white"),
             
             legend = list(font = list(color = "white")),
             barmode = "stack") %>% add_markers(marker = list(size = 12))
    
    plot
  })
  
  
  output$console_plot_1991_2000 <- renderPlotly({
    console_sales <- aggregate(consoles_1991_2000$Units.sold..million., by = list(Year = consoles_1991_2000$Released.Year, Console = consoles_1991_2000$Console.Name, Company = consoles_1991_2000$Company, ReleasedYear = consoles_1991_2000$Released.Year, DiscontinuedYear = consoles_1991_2000$Discontinuation.Year), FUN = sum)
    console_sales$Year <- as.factor(console_sales$Year)
    
    plot <- plot_ly(data = console_sales, x = ~Year, y = ~x, color = ~Console, type = 'scatter', mode = 'markers',
                    text = ~paste("Console: ", Console, "<br>", "Company: ", Company, "<br>", "Release Year: ", ReleasedYear, "<br>", "Discontinuation Year: ", DiscontinuedYear, "<br>", "Units Sold: ", x, " million"),
                    hoverinfo = "text") %>%
      layout(
        title = "Game Console Sales (1991-2000)",
        xaxis = list(title = "Year", tickfont = list(color = "white"), autorange = TRUE),
        yaxis = list(title = "Units Sold (million)", tickfont = list(color = "white"), autorange = TRUE),
        plot_bgcolor = "black",
        paper_bgcolor = "black",
        font = list(color = "white"),
        legend = list(font = list(color = "white")),
        height = 500,
        margin = list(l = 50, r = 50, b = 50, t = -100) # Adjust margins as needed
      ) %>%
      add_markers(marker = list(size = 12))
    
    plot
  })
  
  
  output$console_plot_2001_2010 <- renderPlotly({
    console_sales <- aggregate(consoles_2001_2010$Units.sold..million., by = list(Year = consoles_2001_2010$Released.Year, Console = consoles_2001_2010$Console.Name, Company = consoles_2001_2010$Company, ReleasedYear = consoles_2001_2010$Released.Year, DiscontinuedYear = consoles_2001_2010$Discontinuation.Year), FUN = sum)
    console_sales$Year <- as.factor(console_sales$Year)
    
    plot <- plot_ly(data = console_sales, x = ~Year, y = ~x, color = ~Console, type = 'scatter', mode = 'markers',
                    text = ~paste("Console: ", Console, "<br>", "Company: ", Company, "<br>", "Release Year: ", ReleasedYear, "<br>", "Discontinuation Year: ", DiscontinuedYear, "<br>", "Units Sold: ", x, " million"),
                    hoverinfo = "text") %>%
      layout(
        title = "Game Console Sales (2001-2010)",
        xaxis = list(title = "Year", tickfont = list(color = "white"), autorange = TRUE),
        yaxis = list(title = "Units Sold (million)", tickfont = list(color = "white"), autorange = TRUE),
        plot_bgcolor = "black",
        paper_bgcolor = "black",
        font = list(color = "white"),
        legend = list(font = list(color = "white")),
        height = 500,
        margin = list(l = 50, r = 50, b = 50, t = -100) # Adjust margins as needed
      ) %>%
      add_markers(marker = list(size = 12))
    
    plot
  })
  
  output$console_plot_2011_2020 <- renderPlotly({
    console_sales <- aggregate(consoles_2011_2020$Units.sold..million., by = list(Year = consoles_2011_2020$Released.Year, Console = consoles_2011_2020$Console.Name, Company = consoles_2011_2020$Company, ReleasedYear = consoles_2011_2020$Released.Year, DiscontinuedYear = consoles_2011_2020$Discontinuation.Year), FUN = sum)
    console_sales$Year <- as.factor(console_sales$Year)
    
    plot <- plot_ly(data = console_sales, x = ~Year, y = ~x, color = ~Console, type = 'scatter', mode = 'markers',
                    text = ~paste("Console: ", Console, "<br>", "Company: ", Company, "<br>", "Release Year: ", ReleasedYear, "<br>", "Discontinuation Year: ", DiscontinuedYear, "<br>", "Units Sold: ", x, " million"),
                    hoverinfo = "text") %>%
      layout(
        title = "Game Console Sales (2011-2020)",
        xaxis = list(title = "Year", tickfont = list(color = "white"), autorange = TRUE),
        yaxis = list(title = "Units Sold (million)", tickfont = list(color = "white"), autorange = TRUE),
        plot_bgcolor = "black",
        paper_bgcolor = "black",
        font = list(color = "white"),
        legend = list(font = list(color = "white")),
        height = 500,
        margin = list(l = 50, r = 50, b = 50, t = -100) # Adjust margins as needed
      ) %>%
      add_markers(marker = list(size = 12))
    
    plot
  })
  
  # Server function for platform table
  output$platform_table <- renderDT({
    # Filter data for the specified year range
    filtered_data <- vgsales[vgsales$Year >= 1976 & vgsales$Year <= 1990, ]
    
    # Calculate total video games sold for each platform and find top game and publisher
    platform_details <- data.frame(
      Rank = paste("#", seq(3)),
      Platform = names(head(table(filtered_data$Platform), 3)),
      Total_Global_Sales = head(sort(tapply(filtered_data$Global_Sales, filtered_data$Platform, sum), decreasing = TRUE), 3),
      Top_Game = "",
      Top_Publisher = "",
      Game_Global_Sales = ""
    )
    
    for (i in 1:3) {
      platform <- platform_details$Platform[i]
      top_game_row <- filtered_data[which.max(filtered_data$Global_Sales[filtered_data$Platform == platform]), ]
      platform_details[i, c("Top_Game", "Top_Publisher", "Game_Global_Sales")] <- 
        c(top_game_row$Name, top_game_row$Publisher, top_game_row$Global_Sales)
    }
    
    datatable(platform_details, 
              options = list(
                pageLength = 3,
                dom = 't',  # Only the table, no controls
                ordering = FALSE,
                searching = FALSE,
                columnDefs = list(list(className = 'dt-center', targets = "_all")),
                # Add style to make text white and brighter
                style = list(
                  "color" = "white",
                  "font-weight" = "bold"  # Adjust font weight as needed
                )
              ), 
              class = "compact hover cell-border stripe",
              rownames = FALSE)
  })
  
  # Read the CSV file
  data_do <- read.csv("./data/yearly_average_rating_top_genres.csv")
  
  # Filter data for years 2020 to 2023
  filtered_data_2020to2023 <- data_do %>%
    filter(Year >= 2020 & Year <= 2023)
  
  # Calculate average rating for each genre for years 2020 to 2023
  avg_ratings_2020to2023 <- filtered_data_2020to2023 %>%
    group_by(Genres) %>%
    summarise(AvgRating = mean(Rating))
  
  # Sort genres by average rating in descending order for years 2020 to 2023
  sorted_avg_ratings_2020to2023 <- avg_ratings_2020to2023 %>%
    arrange(desc(AvgRating))
  
  # Take top 5 genres for years 2020 to 2023
  top_genres_2020to2023 <- sorted_avg_ratings_2020to2023$Genres[1:5]
  
  # Filter data for top genres for years 2020 to 2023
  top_genres_data_2020to2023 <- filtered_data_2020to2023 %>%
    filter(Genres %in% top_genres_2020to2023)
  
  # Create donut chart for years 2020 to 2023
  output$donutChart2020to2023 <- renderPlotly({
    plot_ly(
      top_genres_data_2020to2023,
      labels = ~Genres,
      values = ~Rating,
      type = 'pie',
      hole = 0.6,
      textinfo = 'label+percent'
    ) %>%
      layout(
        title = "Top Genres by Average Rating (2020-2023)",
        plot_bgcolor = "black",
        paper_bgcolor = "black",
        font = list(color = "white"),
        legend = list(font = list(color = "white"))
      )
  })
  
  # Filter data for years 1980 to 1990
  filtered_data_1980to1990 <- data_do %>%
    filter(Year >= 1980 & Year <= 1990)
  
  # Calculate average rating for each genre for years 1980 to 1990
  avg_ratings_1980to1990 <- filtered_data_1980to1990 %>%
    group_by(Genres) %>%
    summarise(AvgRating = mean(Rating))
  
  # Sort genres by average rating in descending order for years 1980 to 1990
  sorted_avg_ratings_1980to1990 <- avg_ratings_1980to1990 %>%
    arrange(desc(AvgRating))
  
  # Take top 5 genres for years 1980 to 1990
  top_genres_1980to1990 <- sorted_avg_ratings_1980to1990$Genres[1:5]
  
  # Filter data for top genres for years 1980 to 1990
  top_genres_data_1980to1990 <- filtered_data_1980to1990 %>%
    filter(Genres %in% top_genres_1980to1990)
  
  # Create donut chart for years 1980 to 1990
  output$donutChart1980to1990 <- renderPlotly({
    plot_ly(
      top_genres_data_1980to1990,
      labels = ~Genres,
      values = ~Rating,
      type = 'pie',
      hole = 0.6,
      textinfo = 'label+percent'
    ) %>%
      layout(
        title = "Top Genres by Average Rating (1980-1990)",
        plot_bgcolor = "black",
        paper_bgcolor = "black",
        font = list(color = "white"),
        legend = list(font = list(color = "white"))
      )
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