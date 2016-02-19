#' Converts data frame to hierarchical JSON
#'
#' @param d A length 1 character vector contain the name of the data frame to be converted
#' @return Hierarchical JSON object.
#' @details
#' Function assumes the order of the columns is the hierarchical order
#' @examples
#' data(mtcars)
#' nd = mtcars %>%
#'   dplyr::mutate(mpg = cut(mpg,c(floor(min(.$mpg)),15,20,25,ceiling(max(.$mpg))),include.lowest = T)) %>%
#'   dplyr::mutate(am = ifelse(am == 0, "Automatic","Manual")) %>%
#'   dplyr::select(am,gear,mpg,carb,cyl)

#' json = df2json("nd")
#' json
#' @export
df2json = function(d){
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
    dplyr::distinct()
  if(nrow(dframe) == 1){
    stop("Not enough data to make a tree")
  }
  n = names(dframe)
  command = paste0("dframe %<>% dplyr::arrange(",paste(n,collapse=","),")")
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
    json = sprintf("%s{'name':'%s','size':10}",json,dframe[[1]][1])
  }

  cr = 1
  cc = 2
  done = 0
  while(done == 0){
    if(cc == ncol(dframe)){
      json = sprintf("%s,{'name':'%s','size':10}",json,dframe[[cc]][cr])
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
  json = stringr::str_replace_all(json,pattern = "\\[,","\\[")
  json = stringr::str_replace_all(json,pattern = "'","\"")
  return(jsonlite::fromJSON(json) %>% jsonlite::toJSON(.))
}
