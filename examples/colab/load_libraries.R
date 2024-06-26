# Load libraries

"
This function is intended to be sourced directly from a github raw URL as an efficient way
to install required packages without having to load any package or wrangle large
code snippets.

This is an efficient way to:
-install necessary packages (both those that you will use directly, and those that
are dependencies, excluding pre- installed libraries)
-load the ones you want to use in your session

This snippet works by installing as many packages and dependencies using binaries
from Posit's package manager as possible, which is much faster than compiling
from source.

If not loading rsims, this should take around 35 seconds. If loading rsims, it
should take around 45s.

User Instructions:
1. Source the function from it's github raw URL, for example:
source('https://raw.githubusercontent.com/RWLab/rwRtools/master/examples/colab/load_libraries.R')
2. Call the function with the following arguments:
  a. If you don't need rsims, set load_rsims = FALSE
  b. If you want to load additional libraries, specify them as a character vector
  and pass to extra_libraries:
  extra_libraries = c('patchwork', 'slider')
  c. If you know the dependencies of these libraries, you can pass them to extra_dependencies:
  extra_dependencies = c('grid', 'graphics')

How to figure out a package's dependencies? Use available.packages(). Example for
getting the packages that patchwork depends upon:
pkgs <- available.packages()
pkgs['patchwork','Imports']

If you don't know the dependencies of your extra packages, don't worry. They'll
be automatically installed, just a little slower than if you specified them.

Also don't worry about duplicating package installs. This is handled by the function.

If you get stuck, ask on Slack!

Note for devs:
GitHub caches raw content for 5 minutes, so any changes will take 5 minutes to
show up in GitHub.

TODO: make a debug message with status and return it
"

load_libraries <- function(load_rsims = TRUE, extra_libraries = c(), extra_dependencies = c()) {
  download.file("https://raw.githubusercontent.com/eddelbuettel/r2u/master/inst/scripts/add_cranapt_jammy.sh", "add_cranapt_jammy.sh")
  Sys.chmod("add_cranapt_jammy.sh", "0755")
  system("sudo ./add_cranapt_jammy.sh")

  readRenviron("/etc/R/Renviron")
  source("/etc/R/Rprofile.site")

  options(Ncpus = 2)  # 2 cores in standard colab... might as well use them

  # install pacman the old fashioned way - isn't listed as an ubuntu package, not available on Posit package manager
  install.packages('pacman')

  to_install <- c('googleCloudStorageR', 'googleAuthR','assertthat', 'R.oo', 'R.utils', 'foreach', 'doParallel', 'xts', 'Rcpp', 'TTR', 'arrow', 'feather',  'gtable')
  # 'iterators', 'zoo', 'R.methodsS3',  # removed because tested install without these libraries and no issues. May be able to remove others - test one at a time.
  if(length(to_install) > 0)
    lapply(to_install, pacman::p_install, character.only = TRUE, dependencies = FALSE, try.bioconductor = FALSE, force = FALSE)

  # install and load rwRtools from GH (sans dependencies)
  pacman::p_load_gh("RWLab/rwRtools", dependencies = FALSE, update = FALSE)

  if (length(extra_libraries) > 0)
    # do.call to avoid non-standard evaluation. weird bug
    do.call(pacman::p_load, list(extra_libraries, update = FALSE, install = TRUE, character.only = TRUE))

  if(load_rsims == TRUE) {
    to_install <- c('roll', 'here') # 'Rcpp' installed as part of rwRtools
    lapply(to_install, pacman::p_install, character.only = TRUE, dependencies = FALSE, try.bioconductor = FALSE, force = FALSE)
    pacman::p_load_gh("Robot-Wealth/rsims", dependencies = FALSE, update = FALSE)
  }
  require(tidyverse)
}


  # Uncomment for when Posit Package Manager is up and running again
  # # set options to favour binaries from Posit Package Manager
  # options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))
  # options(download.file.extra = sprintf("--header \"User-Agent: R (%s)\"", paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))
  # options(repos = c(REPO_NAME = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))
  # options(Ncpus = 2)  # 2 cores in standard colab... might as well use them
  # options(warn = -1)
  # cat("Using", getOption("Ncpus", 1L), " CPUs for package installation")
  #
  # # install pacman the old fashioned way - isn't listed as an ubuntu package
  # install.packages('pacman')
  #
  # # rwRtools dependencies (install but don't load)
  # # rwRtools_dependencies <- c(
  # #   "pillar", "tibble", "rlang", "httr", "iterators", "zoo", "R.methodsS3",
  # #   "callr", "foreach", "xts", "stringi", "Rcpp", "R.oo", "gargle", "assertthat",
  # #   "googleAuthR", "glue", "googleCloudStorageR", "R.utils", "feather", "arrow",
  # #   "lubridate", "readr", "stringr", "dplyr", "purrr", "magrittr", "TTR", "doParallel"
  # # )
  # rwRtools_dependencies <- c(
  #   "iterators", "zoo", "R.methodsS3",
  #   "foreach", "xts", "Rcpp", "R.oo", "assertthat",
  #   "googleAuthR", "googleCloudStorageR", "R.utils", "feather", "arrow",
  #   "TTR", "doParallel"
  # )
  #
  # # libraries to load (install and load)
  # libs_to_load <- c(
  #   c("tidyverse", "lubridate"),
  #   extra_libraries
  # )
  #
  # # dependencies (install but don't load)
  # other_dependencies <- c(
  #   "generics", "lifecycle", "R6", "rlang", "tidyselect", "vctrs", "pillar",
  #   "ellipsis", "digest", "gtable", "isoband", "MASS", "mgcv", "scales", "withr",
  #   "stringi", "iterators", "R.methodsS3", "openssl", "foreach", "xts",
  #   "R.oo", "RcppArmadillo", "slam", "timeDate", "cccp", "Rglpk", "timeSeries",
  #   "tibble", "tidyr", "here", "roll", "Rcpp", "RcppParallel"
  # )
  #
  # # libraries to install
  # to_install <- unique(c(
  #   libs_to_load,
  #   other_dependencies,
  #   rwRtools_dependencies,
  #   extra_dependencies
  # ))
  #
  # # pre-installed libraries
  # installed <- installed.packages()[, "Package"]
  #
  # # remove from apt list any packages that are already installed
  # to_install <- to_install[!to_install %in% installed]
  #
  # # remove arrow and install v13 instead (latest takes forever)
  # to_install <- to_install[to_install != "arrow"]
  #
  # # install
  # retry_download("arrow", "13.0.0.1")
  # lapply(to_install, retry_download)
  # # install.packages(to_install, dependencies = TRUE)
  # # devtools::install_version('arrow', '13.0.0.1')
  #
  # tryCatch({
  #   # set to TRUE will catch any missed dependencies
  #   pacman::p_load(char = libs_to_load, install = TRUE, update = FALSE)
  #
  #   # install and load rwRtools from GH (sans dependencies)
  #   pacman::p_load_current_gh("RWLab/rwRtools", dependencies = TRUE)
  #
  #   # install and load rsims from GH (sans dependencies)
  #   if(load_rsims == TRUE)
  #     pacman::p_load_current_gh("Robot-Wealth/rsims", dependencies = TRUE)
  # }, error = function(e) {
  #   print(e)
  # })
# }
