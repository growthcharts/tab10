FROM ghcr.io/growthcharts/jesse:0.2.2

# Copy config file
COPY /shiny srv/shiny-server/app
# Overwrite default app.R with jesse version
RUN mv srv/shiny-server/app/app_jesse.R srv/shiny-server/app/app.R

# install R packages required

# Change the packages list to suit your needs
RUN R -e 'install.packages(c(\
             "bsicons", \
             "rhandsontable", \
             "AGD", \
             "plotly", \
             "shinyjs", \
             "htmltools", \
             "bslib" \
           ) , \
           repos="https://packagemanager.rstudio.com/cran/__linux__/focal/2021-04-23" \
         )'


# get github packages
COPY Renviron .Renviron
RUN R -e 'install.packages("jsonvalidate")' # require 1.3.2
RUN R -e 'remotes::install_github("https://github.com/growthcharts/bdsmodels")'
RUN R -e 'remotes::install_github("https://github.com/growthcharts/jamesdemodata")'
RUN R -e 'remotes::install_github("https://github.com/growthcharts/tab10/tree/shinyserver")'
RUN rm .Renviron

# Downgrade to v3.4.4. ggplot2 v3.5.0 breaks functionality of bslib.
RUN R -e 'install.packages("http://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_3.4.4.tar.gz", repos=NULL, type="source")'
