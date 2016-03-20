options(prompt="R> ")

# set the default CRAN mirror
local({
  r <- getOption("repos")
  r["CRAN"] <- "http://star-www.st-andrews.ac.uk/cran/"
  options(repos = r)
})

# stop asking to save the workspace on exit
exit <- function() { q("no") }
