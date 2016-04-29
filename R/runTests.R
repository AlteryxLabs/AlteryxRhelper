#' Run all tests in the Supporting_Macros/tests folder
#' 
#' 
#' 
#' @param pluginDir plugin directory
#' @export
runTests <- function(pluginDir = ".", build_doc = TRUE){
  with_dir_(file.path(pluginDir, 'Supporting_Macros', 'tests'), {
    tests <- list.files(".",  pattern = '.yxmd')
    results <- lapply(seq_along(tests), function(i){
      message("Testing ", tools::file_path_sans_ext(basename(tests[i])))
      runWorkflow(tests[i])
    })
    names(results) <- basename(tests)
    
    x <- jsonlite::toJSON(
      lapply(results, function(x){attr(x, 'status')}),
      auto_unbox = TRUE
    )
    cat(x, file = '_tests.json')
    if (build_doc) {
      rmarkdown::render('README.Rmd')
      browseURL('README.html')
    }
  })
}

with_dir_ <- function (new, code) {
  old <- setwd(dir = new)
  on.exit(setwd(old))
  force(code)
}