FROM arjanhjhuizing/jesse:0.1.0

# Copy config file
COPY /shiny srv/shiny-server/tab10

# install R packages required
# Change the packages list to suit your needs
RUN R -e 'install.packages(c(\
             "bsicons", \
             "rhandsontable", \
             "ggplot2", \
             "AGD", \
             "plotly", \
             "shinyjs", \
             "htmltools", \
             "bslib" \
           ), \
           repos="https://packagemanager.rstudio.com/cran/__linux__/focal/2021-04-23"\
         )'


# get github packages
COPY Renviron .Renviron
RUN R -e 'install.packages("jsonvalidate")' # require 1.3.2
RUN R -e 'remotes::install_github("https://github.com/growthcharts/bdsmodels")'
RUN R -e 'remotes::install_github("https://github.com/growthcharts/tab10")'
RUN rm .Renviron

# On boot, start shiny and crond
CMD su -c /usr/bin/shiny-server shiny && service cron start
