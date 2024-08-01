FROM rocker/verse

# Maintainer
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt install -y python3 python3-pip
RUN apt-get -y update && apt-get install -y \
    libudunits2-dev \
    libgdal-dev \
    libgeos-dev \
    libproj-dev \
    libmysqlclient-dev
#RUN pip3 install numpy scikit-learn pandas snakemake
RUN pip3 install snakemake
RUN pip3 install pulp==2.7.0

# Exposing the port
EXPOSE 8787

# Installing R packages
RUN R -e "install.packages(c('yaml','here','tidyverse', 'ggplot2', 'dplyr', 'readr', 'stringr', 'purrr','plotly','flextable','officer'))"
RUN R -e "install.packages('BiocManager', repos='http://cran.rstudio.com/')"