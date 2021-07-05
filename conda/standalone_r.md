# Installing standalone R next to conda environments

This note goes through how to make a standalone R installation and how to use it. Special emphasis is put on how the standalone R can be used in conjunction with NoobQuant conda environments with separate R and Python installations. A standalone R installation might be useful as an addition to the conda environment ones as R via Anaconda updates slowly and new/working package versions might not be available there.

A very good text on installaing and using R can be found in [Efficient R Programming](https://csgillespie.github.io/efficientR/).

## About suitable environment setting

R sessions are controlled using files *.Rprofile* and *.Renviron*. More info on these files can be found [here](https://support.rstudio.com/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf) and [here](https://csgillespie.github.io/efficientR/set-up.html#r-startup).

There are three places where R searches for *.Rprofile*/*.Renviron* files when fired up (in order of search): Current project (`getwd()`) > *HOME* (`Sys.getenv("HOME")`) > *R_HOME* (`Sys.getenv("R_HOME")`). We want to be able to run different versions of R on the machine, so a preferable option would be to have the files at *R_HOME* for each R separately. Unfortunately, it seems that putting files under *R_HOME* does not work, that is, R session does not find the files although there are no files in the other two preferred paths. *HOME* level is too broad, as then multiple R instances would be using the same files.

This leaves us with following choices
 - separate *.Rprofile* and *.Renviron* files for each project. This is the preferrece option and is not as big of a hindrance, as it esy to copy the prepared files under each project and fire uo R from this directory (see below for more).
 - if we need only contents of *.Rprofile* (which can be sourced in each script) in the session, then we can store it in a custom path and source it when needed. This will become handy  when installing a Jupyter R kernel for the standalone R installation (see below). Note that it makes no use to put *.Renviron* here as it cannot be sourced from custom location.

## `r_sa_2021`: NoobQuant R standalone v4.1.0 installation

### R installation

 - Install R. Tested with R 4.1.0. This was the newest binary so easy install, but can be installed from older tar.gz files if Rtools is installed first.
 - Check for *HOME* level files (*.Rprofile* and *.Renviron*) with `Sys.getenv("HOME")` and delete them (if not crucial for other R installations).
 - Check for *R_HOME* level files (*.Rprofile* and *.Renviron*) with `Sys.getenv("R_HOME")`. Delete them.
 - Add a folder *"R-x.x.x-packages"* in a custom path <my_custom_path> where x's correspond to the R version number being installed. The path may be *R_HOME*, but this might be unavailable is it is under admin privileges. Add two folders in the path: *rfiles* and *packages*.

### Rtools40 v2 installation

 - Install RTools using Windows bianaries. Tested *rtools40v2-x86_64.exe*. This installs folder *rtools40* with RTools in chosen path.
 - Add *RTOOLS40_HOME* to Windows PATH: Environment variables -> User variables -> Name: RTOOLS40_HOME, Path: "C\:path_to_rtools" (e.g. "C:\Program Files\rtools40").

### Preparing user files

Prepare (project-level) *.Rprofile* file
```
message("Custom .Rprofile has been loaded from <project name here>!")
.libPaths("my_custom_path/R-x.x.x-packages/packages")
```

Prepare *.Rprofile* file for R Jupyter kernel
```
message("Custom .Rprofile has been loaded from rfiles folder!")
.libPaths("my_custom_path/R-x.x.x-packages/rfiles")
```

Prepare (project-level) *.Renviron* file
```
# Adjust PATH variable so that Rtools can be found
PATH="${RTOOLS40_HOME}\usr\bin;${PATH}"
```

### Using standadlone R installation

 - Put project-level *.Rprofile* and *.Renviron* files in project folder.
 - Launch R or RStudio from command promt from the project folder (careful with Windows paths, e.g. spaces need to be dealt with: `C:\Program^ Files\R\R-4.1.0\bin\R.exe`):
```
cs project_folder
path/to/R/bin/R.exe
```
 - This launches R and uses the project-level *.Rprofile* and *.Renviron* files. Test evreything crucial works
   - On launch, we should see the custom message from project-level *.Rprofile*.
   - Test that Rtools can be found: `Sys.which("make")` should return the rtools path. Then, test source intallation via `install.packages("jsonlite", type = "source")`.

### Using standalone R through Jupyter in NoobQuant conda environments

Install R kernel so that conda environments know to use this R installation as well. See [here](https://irkernel.github.io/installation/) and [here](https://github.com/IRkernel/IRkernel/blob/master/R/installspec.r)

 - Put *.Rprofile* file for Jupyter kernel under *my_custom_path/R-x.x.x-packages/rfiles*
 - Install kernel with rest of the conda kernel created from NoobQuant conda environment installations. Make sure to point to the *.Rprofile* file!
    ```
    install.packages('IRkernel')
    IRkernel::installspec(name='r_sa_2021', displayname='r_sa_2021', prefix="path_to_kernels/jupyter/kernels", rprofile="my_custom_path/R-x.x.x-packages/rfiles/.Rprofile")
    ```
 - The command created extra folder layers. Remove them by locating the folder *r_sa_2021* and copy-paste it to the same level with rest of the kernels. Delete empty folder layers.
 - Note that when running the standalone R thorugh Jupyter it does not get to know the content of proper *.Renviron* (it might see the content of other such file from conda installation), so that e.g. RTools might point to incorrect source (try with `Sys.which("make")`). This means that e.g. all Rtools related must be done in "proper" R instance, not via Jupyter kernel.

## Sources :
 - https://csgillespie.github.io/efficientR/set-up.html#r-startup
 - https://support.rstudio.com/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf
 - https://stackoverflow.com/questions/63680272/install-two-versions-of-rtools
 - https://cran.r-project.org/bin/windows/Rtools/
 - https://stackoverflow.com/questions/46819684/how-to-access-and-edit-rprofile