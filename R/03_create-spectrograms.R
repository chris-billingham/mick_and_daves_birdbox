library(tidyverse)
library(tuneR)
library(signal)
library(oce)
library(caret)
library(fs)
library(progress)

source("R/xx_audio-functions.R")

final_birds <- readRDS("data/final_birds.rds")
# generate all the spectrograms and save to plot directories
walk2(final_birds$location, final_birds$dir_name, chunk_and_save)
