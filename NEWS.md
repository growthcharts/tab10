# tab10 1.1.0

## Adds a jamesapp-integrated app variant

* Adds `shiny/app_james.R`, a new app variant that retrieves dossier data
  from a JAMES OpenCPU session (`?session=` query param) instead of JESSE's
  local encrypted-RDS lookup, via a new `httr2`-based fetch of the session's
  `/rda` path. Part of wiring tab10's Table of Ten into jamesapp; see
  `james`'s new `request_tab10()` and `jamesdocker`'s new `/tab10` routes.
* Adds `Dockerfile.james`, a new build alongside the existing `Dockerfile`,
  based on `rocker/shiny:4.3.2` instead of the JESSE base image (JESSE was
  only needed for `postReq/getData.R`, which `app_james.R` no longer uses).
  `Dockerfile` (JESSE/I-JGZ) is unchanged.
* Adds `httr2` to Suggests

# tab10 1.0.0

## Revises the dependencies for the package

* Adds `bdsreader`, `bdsmodels` to Suggests
* Moves `jamedemodata` from Depends to Suggests
* Updates `app.R` with safe-loading code for app-only packages
* Moves the minimal R version to 4.1.0

# tab10 0.9.0

* merges `app_jesse.R` from the `shinyserver` branch, which contains the JESSE integration and runs on a server (#4)
* restores the inadvertently deleted local Shiny app `app.R`

# tab10 0.8.1

* Adds CITATION file

# tab10 0.8.0

* Various changes to make all R CMD CHECK warnings and notes disappear
* Updates DESCRIPTION and NEWS.md

# tab10 0.7.2

* Add Dockerfile for JESSE 0.2.2 deploy (only in shinyserver branch)
* Strip example data from app (only in shinyserver branch)

# tab10 0.7.1

* Set start-up screen and model to GIZ/overweight-4y

# tab10 0.7.0

* Creates implementation of data viewer and ToT for `preterm-32` logistic model
* Create ToT script for `preterm-32w` outcome
* Extend `pc4` table with `gemeente2020` and `COROP` columns
* Update `predictions` and `betas` with logistic model `preterm-32w`

# tab10 0.6.1 

* Specify package locations for ShinyApps

# tab10 0.6.0

* Adds the `go()` function with a ShinyApps implementation of overweight and language predictions models

# tab10 0.5.3.

* Adds `lang-4y` model estimates to `betas`
* Extends `predictions` and `riskrank` with `lang-4y` model predictions
* Duplicates `scripts` for `overweight-4y` to `lang-4y`

# tab10 0.5.2

* Turn app into R package
* Import functions
* Precalculate empty BMI chart

# tab10 0.5.1

* Adds `pc4` dataset for matching postal codes

# tab10 0.5.0

* Adds `pick_palette()`, `plot_densities()`, `probability_bar()`

# tab10 0.4.0

* Corrects the incorrect labeling of "very preterm" to "preterm" (GA < 37 weeks)
* Renames outcome `preterm-32w` as `preterm-37w`

# tab10 0.3.0

* Adds the outcome `preterm-32w`

# tab10 0.2.0

* First working version of script `overweight-4y-3`
