library(morexams)

# load the exam configuration
rm(list = ls())
load_exam_config("config.R")

## OUTPUT FOLDER:
## exams are generated in a subfloder of the current
## working path, called "Generated"

# generate the NOPS (exams sheets
# that can be scanned and automatically corrected)
make_nops()

## Write the solution in the output folder
## (optional)
write_one_solution()

## Generate traditional exam sheets (optional)
make_traditional_exams()

## Generate the solutions for each exam sheet
## (optional, useful for open questions with random data)
make_all_solutions()

## Backup the current config and files (optional)
backup_config()
