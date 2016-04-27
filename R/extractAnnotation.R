#' Extract annotation from Inputs
#'
#'
#' @param pluginName path to yxmc file
#' @export
extractInputOutput <- function(pluginName, type = "input"){
  if (type == 'input'){
    y <- 'AlteryxBasePluginsGui.MacroInput.MacroInput'
  } else {
    y <- 'AlteryxBasePluginsGui.MacroOutput.MacroOutput'
  }
  xml <- xmlInternalTreeParse(pluginName)
  r <- xmlRoot(xml)
  query <- sprintf("//Node[GuiSettings[contains(@Plugin, '%s')]]", y)
  g <- getNodeSet(r, query)
  annotation <- sapply(g, function(d){
    x <- xmlToList(d)$Properties$Annotation$AnnotationText
  })
  d <- paste0(seq_along(annotation), ". ", annotation)
  cat(paste(d, collapse = '\n'))
}

#' Extract configuration annotation from macro
#' 
#' 
#' @param pluginName path to yxmc file
#' @export
extractConfig <- function(pluginName){
  xml <- xmlInternalTreeParse("Optimization.yxmc")
  r <- xmlRoot(xml)
  query <- "//Node[GuiSettings[contains(@Plugin, 'AlteryxGuiToolkit.Questions')]]"
  g <- getNodeSet(r, query)
  
  
  annotation_ <- Filter(function(d){ !is.null(d[[2]])}, lapply(g, function(d){
    xmlToList(d)$Properties$Annotation[c('Name', 'AnnotationText')]
  }))
  annotation <- sapply(annotation_, '[[', 'AnnotationText')
  names(annotation) <- sapply(annotation_, '[[', 'Name')
  
  d2 <- AlteryxRhelper:::yxmc2yaml('Optimization.yxmc')
  d3 <- lapply(names(d2), function(x){
    if (x %in% names(annotation)){
      d2[[x]]$note <- annotation[[x]]
    }
    return(d2[[x]])
  })
  
  d4 <- Filter(function(d){!is.null(d$note)}, d3)
  d5 <- sapply(seq_along(d4), function(i){
    x = d4[[i]]
    sprintf("%s. __%s__ %s", i, if (is.null(x$label)) x$text else x$label, x$note)
  })
  cat(paste(d5, collapse = "\n"))
}