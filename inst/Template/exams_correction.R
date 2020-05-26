library(morexams)
# load the configuration
rm(list = ls())
load_exam_config("Config.R")


## CORRECTION CONFIGURATION
# Points per exercice
POINTS=c(4,6,6,4)
# Do partial answers get points?
PARTIAL_ANS = FALSE
# Do wrong answer get negative points?
NEGATIVE_POINTS = FALSE
# Are the scanned images upside down?
UPSIDE_DOWN = FALSE
# Number of cores used when reading the scanned files
# (set to 1 in case of error)
PARALLEL_CORES = 1

# run the evaluation
# if force_read_scan is TRUE the scans are reading each time
# the funcion is called (time consuming), otherwise it uses the last reading
run_evaluation(force_read_scan = FALSE)

