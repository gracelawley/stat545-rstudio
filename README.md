  [![Travis build status](https://travis-ci.org/rstudio-education/stat545-reboot.svg?branch=master)](https://travis-ci.org/rstudio-education/stat545-reboot) [![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![Netlify Status](https://api.netlify.com/api/v1/badges/82ff5a18-8a13-4f25-b688-230b04bc5664/deploy-status)](https://app.netlify.com/sites/gracious-allen-b2d17f/deploys)

This bookdown book is a *work in progress*. We'll update this `README` and the repo status when ready! :rocket:


# Requirements to preview the bookdown locally 

## OMDb API Key

1. Request an API key [here](https://www.omdbapi.com/apikey.aspx)
1. Check your email and follow the instructions to activate your key
1. Add the API key to your `.Renviron` file. First, open your .`Renviron` file:
  
    ```{r eval = FALSE}
    library(usethis)
    edit_r_environ()
    ```
    
    Next, add `OMDB_API_KEY=<your-key>` on a new line, replacing `<your-key>` with your OMDb key. (Make sure to have your `.Renviron` file end on a new line!)
    
## Required packages

### Use `pak` to install any missing packages

Here's one way to install the needed packages (only the ones that you don't already have) using the [`pak` package](https://pak.r-lib.org/index.html).

```r
# all the packages needed
pkg_list <- c("bookdown", "devtools", "dichromat", "DT", "fs", "gapminder",
              "gender", "geonames", "git2r", "glue", "gridExtra",  "htmltools",
              "httr", "knitr", "RColorBrewer", "rebird", "rmarkdown", "rplos", 
              "rvest", "testthat", "tidyverse", "usethis", "viridis", "xfun", 
              "xml2", "ropensci/genderdata", "rstudio/gt")
```

```r
# install.packages("pak")
pak::pkg_install(pkg_list)
```

### Use `renv` to recreate our project library

Another option is to use the [`renv` package](https://rstudio.github.io/renv/index.html) to replicate our exact project library. `renv` will create a private, project-specific library that is separate from your personal package library. This would be a good option if, for example, you have a specific version of a package installed that you don't want to mess with.

The `renv` package is still in the development stage so these instructions may change. See the [Introduction to renv](https://rstudio.github.io/renv/articles/renv.html) page for more information on what `renv` is doing behind the scenes. 

Once you have a local copy of this project (either via fork/clone or downloading a zip file), follow these steps:

1. Install the development version of the `renv` package (the same version we used to take a "snapshot" of our project library):
   
    ```r
    if (!requireNamespace("remotes"))
      install.packages("remotes")
  
    remotes::install_github("rstudio/renv@46f1123")
    ```

1. Run `renv::activate()`. 
    + This will create a private, project-specific library. If you at the Packages tab of RStudio the list of packages will be pretty sparse. 
  
1. Run `renv::restore()`. 
    + This will print out something along the lines of "The following packages will be installed", followed by a long list of packages. Select yes. `renv` will copy over any packages that you already have installed elsewhere and will install any packages that you do not already have.
    
1. Restart R (*Session > Restart R*).
    + You will see something that looks like `Project '~/stat545-rstudio-add-renv' loaded. [renv 0.6.0-70]` print out in the Console. If you look at the Packages tab now, the list should be much longer.
    
1. Preview the bookdown via *Addins > Preview Book* or `bookdown::serve_book()`.