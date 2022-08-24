#!/bin/bash

dnf install -y openssl-devel
RDscriptsan -e "install.packages('devtools', dependencies = TRUE, repos = 'https://cloud.r-project.org/')"
RDscriptsan -e "install.packages(c( 'Rcpp', 'graphics', 'grDevices', 'grid', 'shiny', 'jpeg', 'png', 'tiff', 'R6', 'RcppArmadillo', 'testthat', 'knitr', 'rmarkdown', 'covr', 'remotes' ), repos = 'https://cloud.r-project.org/')"
RDscriptsan -e "setwd('/$1')" -e "system('RDsan CMD build OpenImageR')" -e "system('RDsan CMD check --as-cran OpenImageR_1.2.5.tar.gz')"
