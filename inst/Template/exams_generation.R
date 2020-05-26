library(morexams)
morexams_init()

# load the exam configuration
rm(list = ls())
load_exam_config("Config.R")

## OUTPUT FOLDER:
## exams are generated in a subfloder of the current
## working path, called "Generated"

# generate the NOPS (exams sheets
# that can be scanned and automatically corrected)
make_nops()

## Generate traditional exam sheets
make_traditional_exams()

## Write the solution in the output folder
write_one_solution()

## Generate the solutions for each exam sheet
make_all_solutions()

## Backup the current config and files
backup_config()
