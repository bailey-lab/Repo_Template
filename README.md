# Repo_Template
A template for organizing and performing analysis (adapted from https://github.com/PhanstielLab/project-template).

## Directory Structure

![](images/Repo_Template.drawio.svg)

### Prerequisites

- Install [Docker Desktop](https://www.docker.com/products/docker-desktop) for Windows and Mac.

## How to use this repo as a template

1. Create a repository from this template according to these instructions: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template

2. Clone the repository to your home computer.

```sh
git clone https://github.com/bailey-lab/Repo_Template.git
```

3. Rename the directory to your project name

```sh
mv Repo_Template My_Project
cd My_Project
```

4. Build docker image (rename with the title of your project) in a terminal window of your project directory.

```sh
docker build -t my_project .
```

5. Run the docker container with the username and password below in a terminal window of your project directory.

```sh
docker run --rm -p 8787:8787 -e USER=rstudio -e PASSWORD=yourpassword --volume ${PWD}:/home/rstudio my_project
```

6. Open a web browser and navigate to `localhost:8787`. Log in with username `rstudio` and password `yourpassword`.
    - When you are logged in, you can run R code in the console or open R scripts in the `src` directory.
        - ![](images/Console.png)
    - You will run the following commands in the terminal in RStudio.
        - ![](images/Terminal.png)

7. As I already have the `data/raw`, `config` and `src` directories (with the `analysis`, `processing`,`utils` subdirectories) made, you can start adding your data and scripts to these directories.

7. Run make commands (in the terminal) to inialize the general dictionaries.

```sh
make dirs
```

8. Fill the config file with the necessary information for your project. The formatting of the config file is as follows:

```sh
# your relative file path
config_path: "config/YYYY_MM_DD_config.yaml"

# the date of the analysis
date: "YYYY_MM_DD"

# the name of the project
project_name: "my_project"

# the description of the project
description: "Cool analysis of something"

# the path to the raw data
sample_summary_csv: "data/raw/UMI_counts.csv"

# the path to the output report file
output_file: "YYYY_MM_DD_final.html"
```

9. Run the snakemake pipeline (in the terminal), that creates date specific subdirectories in the `data/processed`, `plots` and `reports` directories and then renders the quarto document with the information from your config file.

```sh
snakemake -s Snakefile -c 1 --configfile config/YYYY_MM_DD_config.yaml
```

10. To clear all output and rerun this pipeline, run the following commands:

```sh
snakemake -s Snakefile --delete-all-output -c 1 --configfile config/YYYY_MM_DD_config.yaml
make clean
```

## What is usually in these directories?

- `data`: 
   
    - `data/raw`: This is where you put your raw data files. These files are not modified in any way. They are the starting point of your analysis.
    - `data/processed`: This is where you put your processed data files. These files are created by your scripts and are used as input for your analysis.

- `plots`: This is where you put your plots. These plots are created by your scripts and are used in your report.
    - The subdirectories in `plots` are named after the date of the analysis.

- `reports`: This is where you put your reports. These reports are created by your scripts and are the final output of your analysis. They are named by date.

- `src`: This is where you put your source code.
    - Analysis scripts (performing PCA, etc) are stored in the `analysis` subdirectory.
    - Processing scripts (reformatting, etc) are stored in the `processing` subdirectory.
    - Source scripts (common functions you use and make) are stored in the `utils` subdirectory.

- `config`: This is where you put your configuration files. These files contain the information needed for your scripts to run.