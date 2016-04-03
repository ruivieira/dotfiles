options(prompt="R> ")

# set the default CRAN mirror
local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.opencpu.org"
  options(repos = r)
})

# stop asking to save the workspace on exit
exit <- function() { q("no") }
