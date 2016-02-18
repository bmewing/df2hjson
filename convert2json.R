library(dplyr)
library(magrittr)
library(stringr)

convert2json = function(d){
  if(!is.character(d)){
    stop("Pass in the name of the data to use, not the data itself")
  }
  if(length(d) > 1){
    stop("Only one name at a time")
  }
  dframe = get(d)
  if(!any(class(dframe) == "data.frame")){
    stop("Only data frames are supported")
  }
  dframe %<>% 
    distinct()
  if(nrow(dframe) == 1){
    stop("Not enough data to make a tree")
  }
  n = names(dframe)
  command = paste0("dframe %<>% arrange(",paste(n,collapse=","),")")
  eval(parse(text = command))
  dframe <<- dframe
  
  json = sprintf("{'name':'%s','children':[",d)
  if(ncol(dframe)==1){
    json = sprintf("%s%s]}",json,paste("{'name':'",dframe[[1]],"'}",collapse=",",sep=""))
    return(json)
  }
  
  if(!all(is.na(dframe[[2]][dframe[[1]] == dframe[[1]][1]]))){
    json = sprintf("%s{'name':'%s','children':[",json,dframe[[1]][1])
  } else {
    json = sprintf("%s{'name':'%s'}",json,dframe[[1]][1])
  }
  
  cr = 1
  cc = 2
  done = 0
  while(done == 0){
    print(c(cr,cc))
    if(cc == ncol(dframe)){
      json = sprintf("%s,{'name':'%s'}",json,dframe[[cc]][cr])
      if(cr == nrow(dframe)){
        json = sprintf("%s%s",json,paste(rep("]}",ncol(dframe)),collapse=""))
        done = 1
      } else if(any(dframe[cr+1,1:(cc-1)] != dframe[cr,1:(cc-1)])){
        json = sprintf("%s]}",json)
        cc = cc - 1
        back = 0
        while(back == 0){
          if(cc == 1){
            back = 1
          } else if(any(dframe[cr+1,1:(cc-1)] != dframe[cr,1:(cc-1)])){
            json = sprintf("%s]}",json)
            cc = cc - 1
          } else {
            back = 1
          }
        }
      }
      cr = cr + 1
    } else {
      json = sprintf("%s,{'name':'%s','children':[",json,dframe[[cc]][cr])
      cc = cc + 1
    }
  }
  json = str_replace_all(json,pattern = "\\[,","\\[")
  return(json)
}

data(mtcars)
nd = mtcars %>%
  mutate(mpg = cut(mpg,c(floor(min(.$mpg)),15,20,25,ceiling(max(.$mpg))),include.lowest = T)) %>% 
  mutate(am = ifelse(am == 0, "Automatic","Manual")) %>% 
  select(am,gear,mpg,carb,cyl)

convert2json("nd")
