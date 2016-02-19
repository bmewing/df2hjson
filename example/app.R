library(shiny)
library(dndTree)
library(dplyr)

ui <- bootstrapPage(
  column(3,p("What is going on here?")),
  column(9, p("What happens here?"),dndTreeOutput("test",width = '400px'))
)

server <- function(input, output, session) {
 output$test = renderDndTree({
   data(mtcars)
   nd = mtcars %>%
     dplyr::mutate(mpg = cut(mpg,c(floor(min(.$mpg)),15,20,25,ceiling(max(.$mpg))),include.lowest = T)) %>%
     dplyr::mutate(am = ifelse(am == 0, "Automatic","Manual")) %>%
     dplyr::select(am,gear,mpg,carb,cyl)

   json = dndTree::df2json("nd")
   dndTree::dndTree(json,fHeight= 400)
 })
}

shinyApp(ui, server)