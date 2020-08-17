# Getting and Cleaning Data - Course Project

The goal of this project was to take this [dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
and perform a series of abstractions and transformations in order to clean up the dataset for later analysis.

> ## Requirements
>
> This script requires the [`tidyverse`](https://www.tidyverse.org/) pacakge.
>
> ```r
> install.packages("tidyverse")
> ```

- [`run_analysis.R`](run_analysis.R):

  This script:

  - downloads the dataset and extracts it (if necessary),
  - loads and merges the dataset,
  - performs transformations on the dataset, and
  - cleans the dataset.

- [`CodeBook.md`](CodeBook.md)

  It de the variables, the data, and any transformations or work that was performed to clean up the data.
