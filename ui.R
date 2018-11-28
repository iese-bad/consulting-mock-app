library(googlesheets)
library(shiny)
library(highcharter)
library(plotly)
###### ---------------------------------


shinyUI(

  navbarPage("",
             tabPanel("Interview Mock",  
                      img(src = "logo.jpg", height = 90, width = 267),
                      hr(),
  fluidRow(
    column(4,
           h2("General Data", icon("address-card-o")), 
           p("Fill in the general data related to this mock. You can search by typing directly in the box."), 
           hr(), 
           # interviees dropdown
           uiOutput('e2'), # SEE SERVER.R (it is constructed there and rendered here)
           # interviewers dropdown
           uiOutput('e1'), # SEE SERVER.R (it is constructed there and rendered here)
           shiny::selectInput(inputId = 'type_interviewer', 
                                 choices = c("First year", "Second year", "External", "Career Services"),
                                 label = "Type of interviewer"),
           shiny::selectInput(inputId = 'case_type', label = "Case Type", 
                              choices = c("Growth Strat", "Industry Landscape and Comp. Dynamics", 
                                          "M&A", "Market Sizing", "New product", "Operations", 
                                          "Pricing", "Profitability", "Valuation")),
           shiny::selectInput(inputId = 'Industry', label = "Industry", 
                              choices = c("Consumer Goods", "Energy", "Financial Services", 
                                          "Healthcare", "Manufacturing", "Media", "Private Equity", 
                                          "Travel", "Technology", "Telecom", "Other")),
           uiOutput('e4'), # SEE SERVER.R (it is constructed there and rendered here)
           shiny::textInput(inputId = "case_name", label = "Name of the case"),
           checkboxInput(inputId = "hasfit", label = "Did you do fit?", value = FALSE)
           ),
    column(4, 
           h2("Performance Metrics", icon("bar-chart-o")), 
           p("Helps this candidate understand his weak spots. Please be honest."), 
           hr(), 
           h3("Problem Understanding"),
           HTML("<strong>1 = Poor </strong>- didn't get all of the information, misunderstands the client's goal, and asked irrelevant questions.</br> 
              <strong>4 = Outstanding </strong> - clearly understands the problem, is aligned with the goal and asks questions that simplify the problem"),
           shiny::sliderInput(inputId = "understanding",
                              label = "",
                              min = 1,
                              max = 4,
                              value = 3),
           hr(), 
           h3("Structure"),
           HTML("<strong>1 = Poor</strong> - Convoluted and/or missing the point; approach is incoherent, confusing, uninsightful, boils the ocean without hitting the issues; no sense of how to tackle the issue; disorganized pages.</br> 
                <strong>4 = Outstanding </strong> - lear, insightful & impactful; approach focuses on MECE business drivers framed in highly relevant & insightful terms; significantly helps to advance the problem; organized pages"),
           shiny::sliderInput(inputId = "structure",
                              label = "",
                              min = 1,
                              max = 4,
                              value = 3),
           hr(),
           h3("Creativity"),
           HTML("<strong>1 = Poor</strong> - Lacks ideas, inspiration and approach to tackle the issue/question; struggles to think beyond the obvious.</br> 
                <strong>4 = Outstanding </strong> - Systematically generates wide range of conventional and nonconventional ideas & perspectives."),
           shiny::sliderInput(inputId = "creativity",
                              label = "",
                              min = 1,
                              max = 4,
                              value = 3),
           hr(),
           h3("Quantitative"),
           HTML("<strong>1 = Poor</strong> - Struggles to set up the problem, slow to calculate, error prone, fails to check for accuracy & common sense, does not reflect on answer; unable to understand or misinterprets charts/data.</br> 
                <strong>4 = Outstanding </strong> - Calculates correct answer quickly & comfortably, using a clear & robust approach; makes reasonable estimations, checks for accuracy & common sense, and reflects on answer; accurate description of chart before deriving key interpretations."),
           shiny::sliderInput(inputId = "quant",
                              label = "",
                              min = 1,
                              max = 4,
                              value = 3),
           hr(),
           h3("Synthesis"),
           HTML("<strong>1 = Poor</strong> - Forgot learning from case, rambling, does not draw new insights, no plan forward.</br> 
                <strong>4 = Outstanding </strong> - Summarizes info from case, draws conclusions from info, concise and structured, recommendation for future actions."),
           shiny::sliderInput(inputId = "synthesis",
                              label = ":",
                              min = 1,
                              max = 4,
                              value = 3),
           h3("Communication"),
           HTML("<strong>1 = Poor</strong> - Low energy, lacks confidence; mindset is passive, resistant and/or confrontational; missing or unstructured conclusion; never pauses to recap or preview making it difficult to follow.</br> 
                <strong>4 = Outstanding </strong> - High energy, confident, but humble; adopts a collaborative mindset; consistently communicates by first stating key message then outlining before diving into details; regularly recaps and previews as a transition between sections of the case."),
           shiny::sliderInput(inputId = "communication",
                              label = ":",
                              min = 1,
                              max = 4,
                              value = 3)
  ), 
    column(4, 
           h2("General improvements", icon("cogs")), 
           p("Please give any specific feedback which is relevant to this candidate. The text can be as long as you want."), 
           hr(), 
           uiOutput('e3'), # SEE SERVER.R (it is constructed there and rendered here)
           shiny::textInput(inputId = "other", label = "Other improvements"),
           shiny::actionButton(inputId = "submit", label = "Submit", icon = icon("refresh")), 
           textOutput('submitwait'),
           textOutput('submitsucess')
           
           # ,textOutput('txt')
           
           )
)),
tabPanel("Results",  
         img(src = "logo.jpg", height = 90, width = 267),
         hr(),
         
         sidebarLayout(
           sidebarPanel(
            # HTML('<h3 style="color:#265c80;">Índice de Atractividad     <i class = "fa fa-info"></i></h3>'),
            p("Compare your results here."),
             shiny::actionButton(inputId = "compare", label = "Compare", icon = icon("bullseye"))
             ),
           mainPanel(
             highchartOutput("hc_comparison")
           )
         )
) # tab panel

)
)