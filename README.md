
[![](https://img.shields.io/docker/automated/mlampros/fedora_clang_san.svg)](https://hub.docker.com/r/mlampros/fedora_clang_san)


## **fedora_clang_rdsan**

<br>

**updated: 2023-12-02**: I modified the [Dockerfile_fedora_clang](https://github.com/mlampros/fedora_clang_rdsan/blob/master/Dockerfile_fedora_clang) file so that the latest clang version is installed

<br>

* This repository includes slight modifications of the [Dockerfiles from the rhub project](https://github.com/r-hub/rhub-linux-builders) to reproduce CRAN ASAN-UBSAN errors on Fedora Clang (latest version) using a [Github Action](https://github.com/mlampros/fedora_clang_rdsan/blob/master/.github/workflows/gh_action.yml)
* In the Github Action an [.R file](https://github.com/mlampros/fedora_clang_rdsan/blob/master/fedora_latest_version.R) is used to retrieve the latest version of the existing [Fedora Docker images](https://hub.docker.com/v2/repositories/library/fedora/tags) using the Docker API. Then, the highest numeric version (and not a character string such as "latest") will be used to build the Docker Image and check for potential CRAN ASAN-UBSAN Errors.
* Finally a [docker image is pushed to my Docker Account](https://hub.docker.com/repository/docker/mlampros/fedora_clang_san) that can be used to fix potential CRAN ASAN-UBSAN errors.
* This Github Action updates (currently) the [mlampros/fedora_clang_san:latest](https://hub.docker.com/repository/docker/mlampros/fedora_clang_san) docker image once per week.

<br>

Currently, as of *August 2022*, there is an issue when building an ASAN-UBSAN docker image using the latest Fedora version, which seems to be related to [a change in 'glibc'](https://bugzilla.redhat.com/show_bug.cgi?id=1900021#c3)

A temporary solution is to include **one** of the following two commands in the **docker run** command (*runtime*):

* `--cap-add=SYS_PTRACE --security-opt seccomp=unconfined`
* `--security-opt seccomp=unconfined`

<br>

**References** (*related to the 'glibc' issue*)

* https://stat.ethz.ch/pipermail/r-devel/2021-April/080679.html
* https://stat.ethz.ch/pipermail/r-sig-fedora/2021-March/000732.html
* https://bugzilla.redhat.com/show_bug.cgi?id=1900021#c3
* https://bugzilla.redhat.com/show_bug.cgi?id=1900021#c21
* https://bugzilla.redhat.com/show_bug.cgi?id=1900021#c42
* https://bugzilla.redhat.com/show_bug.cgi?id=1900021#c44
* https://github.com/r-hub/rhub/issues/464

<br>

Reproducing the [CRAN script](https://www.stats.ox.ac.uk/pub/bdr/Rconfig/r-devel-linux-x86_64-fedora-clang) (so that [LLVM, Clang](https://github.com/llvm/llvm-project/releases) can be built from source) using a Github Action is not an option, because the workflow requires more disk space than available (even after using a Github Action step to reduce the disk space). Thus, by using the latest Fedora version an LLVM-Clang version close to the CRAN requirement is installed so that an R package can be checked for ASAN-UBSAN errors.

<br>

### **How to use the [ASAN-UBSAN Docker Image](https://hub.docker.com/repository/docker/mlampros/fedora_clang_san)**

<br>

There are a couple of ways that the Docker image can be used:

**1. From the command line** (*the user can bind a directory such as 'pkg_dir', that includes an R package, in my case 'OpenImageR'*)

<br>

* `docker pull mlampros/fedora_clang_san:latest`
* `docker image ls`
* `docker run -it mlampros/fedora_clang_san:latest clang --version`
* `docker run --rm -ti --security-opt seccomp=unconfined -v /home/pkg_dir:/pkg_dir mlampros/fedora_clang_san:latest`
* `dnf install -y openssl-devel`
* `RDsan`
* `install.packages('devtools', dependencies = TRUE, repos = 'https://cloud.r-project.org/')`
* `install.packages(c( 'Rcpp', 'graphics', 'grDevices', 'grid', 'shiny', 'jpeg', 'png', 'tiff', 'R6', 'RcppArmadillo', 'testthat', 'knitr', 'rmarkdown', 'covr', 'remotes' ), repos = 'https://cloud.r-project.org/')`
* `setwd('/pkg_dir')`
* `system("RDsan CMD build OpenImageR")`
* `system("RDsan CMD check --as-cran OpenImageR_1.2.5.tar.gz")`

<br>

**2. From an R session using a saved bash file (see the [example_R_Sys_requirements.sh file](https://github.com/mlampros/fedora_clang_rdsan/blob/master/example_R_Sys_requirements.sh) in this repo) in a specified by the user *pkg_dir* directory that includes the (R & system) requirements. Assuming 'docker' and 'R' are already installed in the Operating System a user can use the following by first openning a command line window (the 'pkg_dir' is a positional parameter when using '/bin/bash' in 'docker run')**

<br>

* `R` (begin an R session)
* `system("docker pull mlampros/fedora_clang_san:latest")`
* `system("docker image ls")`
* `system("docker run -it mlampros/fedora_clang_san:latest clang --version")`
* `system("docker run --security-opt seccomp=unconfined -v /home/pkg_dir:/pkg_dir mlampros/fedora_clang_san:latest /bin/bash /pkg_dir/example_R_Sys_requirements.sh 'pkg_dir'")`

<br>

In both cases (*1.* and *2.*) the output CRAN *.Rcheck* folder is saved in the (adjusted) by the user directory '/home/pkg_dir' so that the user can fix the errors and re-run the CRAN checks.

My preferred way is *1.* because once the R packages are installed in the R session, the user has only to re-adjust the code (in 'pkg_dir') and re-run the 'R CMD build & check'. Whereas, the second case (when using the 'system()' command from within an R session) requires the re-installation of the R packages after a potential adjustment of the code.

Both cases (*1.* and *2.*) were tested on *Ubuntu 18.04* and *Linux Mint 18.2*

<br>

### **Similar Projects:**

* https://github.com/r-hub/rhub-linux-builders (*all OS's*)
* https://github.com/rocker-org/r-devel-san-clang (*OS: Debian*)
* https://github.com/wch/r-debug (*all OS's*)

<br>
