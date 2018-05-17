#### ----- PACKAGES 
#### Load these packages for the functions you need.
library(shiny)
library(googlesheets)
library(dplyr)

#### ----- LOADING STATIC DATA
#### I will load the data that does not change with the app. 
#### It is data already stored in googlesheets. 
#### VERY IMPORTANT: DO NOT CHANGE THE NAMES OF COLUMNS OR WORKSHEETS IN SHEET!!!


#### here are the keys for each googlesheet we will use. 
key_interviewers <- "1PCvpwZvn27zrktaInSs0XobnOY2DLu93behI_Iy4big"
key_results <- "16q9rU-uiDZXxiLbH9NY9Mv_N_2PNsBkPVozItCQGHqM"

#### Now, I am using the googlesheets package to load the interviewers sheet
interviewers <- gs_key(key_interviewers, lookup = FALSE, visibility = "private") %>% 
  gs_read(ws = "Interviewers") # only accessing one worksheet... 

interviewees <- gs_key(key_interviewers, lookup = FALSE, visibility = "private") %>% 
  gs_read(ws = "Interviewed") # accessing the other worksheet...

#### loading the results sheet (not reading, but keeping the connection open.)
results <- gs_key(key_results, lookup = FALSE, visibility = "private")

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
                          choices = interviewers$Email,
                          label = "Interviewer (person conducting the mock)")
  })
  #### e2 = interviewees drop-down menu
  output$e2 <- renderUI({
    shiny::selectizeInput(inputId = 'interviewee', 
                          choices = interviewees$Email, 
                          label = "Interviewee (person under fire)")
  })
  
  #### ----- SAVING RESULTS
  #### When the submit botton is pressed, all the results in each UI element
  #### are recorded in a data.frame. Then that is added as a row in the results googlesheet.
 
  eventReactive(input$submit, {
    ####     results_df <- data.frame("TimeStamp" = Sys.time(), 
    ####                           "Interviewee" = 1,
    ####                          "Interviewere" = 2,
    ####                            "TypeInterviewer" = 3, 
    ####                          "CaseType" = 4, 
    ####                          "Industry" = 5, 
    ####                          "ProblemUnderstanding" = 5, 
    ####                          "Structure" = 3,
    ####                          "Creativity" = 2, 
    ####                          "Quant" = 4,
    ####                         "Communication" = 4, 
    ####                          "GeneralText" = 2, 
    ####                          "ImproveBrainstorm" = 3, 
    ####                          "ImproveChart" = "test", 
    ####                          "ImproveEstimating" = "test", 
    ####                          "ImproveEnergy" = "test", 
    ####                          "ImproveExecSum" = "test", 
    ####                            "ImproveMarketSize" = "test", 
    ####                          "ImproveMECE" = "test", 
    ####                          "ImproveSynthesis" = "test"
                             ####   )
    
    results_vector <- c(Sys.time(), input$interviewee,input$interviewer,
                        input$type_interviewer, input$case_type, 
                        input$Industry, input$understanding, input$structure,
                        input$creativity, input$quant, input$communication, 
                        input$other, input$improvements, "test",  "test", "test", 
                        "test", "test","test","test")
    
   
    gs_add_row(gs_key(key_results, lookup = FALSE, visibility = "private"), ws = "Results", input = results_vector)
    # results_vector
  })

  ts <- eventReactive(input$submit, {"Sucess!"})
  output$submitsucess <- renderText(ts())
  
  
})
