#### -----------------------------------------------------------------------------
#### IMPORTANT: This app is deployed as appName = mock. So, after setting up the account info
#### using rsconnect::setAcountInfo() with the token and secret in shinyapps.io, 
#### you have to run the command like this>
#### rsconnect::deployApp(appName = "mock", account = "iese")

#### -----------------------------------------------------------------------------
#### ----- PACKAGES 
#### Load these packages for the functions you need.
library(shiny)
library(googlesheets)
library(dplyr)

#### google authentification token...
gs_auth(token = "www/googlesheets_token.rds")

#### -----------------------------------------------------------------------------
#### ----- LOADING STATIC DATA
#### I will load the data that does not change with the app. 
#### It is data already stored in googlesheets. 
#### VERY IMPORTANT: DO NOT CHANGE THE NAMES OF COLUMNS OR WORKSHEETS IN EACH SHEET!!!

#### here are the keys for each googlesheet we will use. 
#### To get a key> go to the sheet and get the share link, then 
#### do> googlesheets::gs_url("url...")
#### that will give you a key to use... 
key_interviewers <- "1fcz_yJBUiHMGsnibUjCHsfbmUF8M6vF5TeDounbIAAU"
key_results <- "1nADMuhbIrIksbOLOyW2FkyEBgdk1C4c3RU65ZcAlfag"

button_choices <- c("Brainstorming",
                    "Chart Reading", 
                    "Estimating", 
                    "Energy and Enthusiasm", 
                    "Executive Summary", 
                    "Market Sizing", 
                    "MECE Structure")

#### Now, I am using the googlesheets package to load the interviewers sheet
mentors <- gs_key(key_interviewers, lookup = FALSE, visibility = "private") %>% 
  gs_read(ws = "Mentors") # only accessing one worksheet... 

mentees <- gs_key(key_interviewers, lookup = FALSE, visibility = "private") %>% 
  gs_read(ws = "Mentees") # accessing the other worksheet...

#### loading the results sheet (not reading, but keeping the connection open.)
results <- gs_key(key_results, lookup = FALSE, visibility = "private")

#### -----------------------------------------------------------------------------
##### ----------- SERVER
##### This is the collection of data that is "transmitted" in the shiny app to the 
##### user interface file (ui.R)
shinyServer(function(input, output) {
  
  #### ----- RENDERING PARTS OF THE UI 
  #### In this part, we will render some of the UI objects which depend on the information in the 
  #### google sheets (like interviewer email for example). 
  #### Once it is "rendered" in this server side, it will be shown in the UI side.
  #### I will name them "e+number" for element...
  #### -------------------
  
  #### e1 = interviewers drop-down menu
  output$e1 <- renderUI({
    shiny::selectizeInput(inputId = 'interviewer', 
                          choices = mentors$Email,
                          label = "Interviewer (person conducting the mock)")
  })
  #### e2 = interviewees drop-down menu
  output$e2 <- renderUI({
    shiny::selectizeInput(inputId = 'interviewee', 
                          choices = mentees$Email, 
                          label = "Interviewee")
  })
  #### e3 = button choices, I take from here so that when we filter to find exact matches to store, they are the same exact phrases
  output$e3 <- renderUI({
    shiny::checkboxGroupInput(inputId = "improvements", label = "Improvements",
                              choices = button_choices,
                              selected = ",")
  })
  
  
  #### ----- SAVING RESULTS
  #### When the submit botton is pressed, all the results in each UI element
  #### are recorded in a data.frame. Then that is added as a row in the results googlesheet.
 
  #### First, I will do a function to return a string of 
  
  observeEvent(input$submit, {
    
   button_vector <- button_choices %in% c(unlist(input$improvements))
   results_vector <- c(as.character(Sys.time()), input$interviewee,input$interviewer,
                        input$type_interviewer, input$case_type, 
                        input$Industry, input$understanding, input$structure,
                        input$creativity, input$quant, input$synthesis, input$communication, 
                        button_vector, input$other
                       )

    
    gs_add_row(gs_key(key_results, lookup = FALSE, visibility = "private"), ws = "Results", input = results_vector)
    # results_vector
  })
  
  ts <- eventReactive(input$submit, {"Sucess!"})
  output$submitsucess <- renderText(ts())

  #output$txt <- renderText({paste0(c(input$improvements), "-", button_choices %in% input$improvements)})
})


### new section after quantitative
### download when done 
### 1. new shinyapps account
### 2. other section at the end
### 3. delete synthesis in buttons


