library(tidyverse)
library(tuneR)
library(signal)
library(oce)
library(caret)
library(fs)
library(progress)

source("xx_audio-functions.R")

# generate all the spectrograms and save to plot directories
walk2(final_birds$location, final_birds$dir_name, chunk_and_save)
