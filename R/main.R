# moRexams main
morexam_version = 0.1

make_exam <- function() {
  # generate NOPS (exams sheets)
  make_nops()
  # save one PDF solution
  write_solution()
  # generate a solution sheet for each of the NOPS
  make_all_solutions()
  # save a backup copy of 'config.R' in the generation folder
  backup_config()
}

load_exam_config = function(config_file) {
  clean_console()
  source(config_file)

  set.seed(SEED)

  # global config variables
  CONFIG_FILE <<- config_file
  DIR_GENERATION <<- file.path(getwd(), "Generated")
  dir.create(DIR_GENERATION, showWarnings=FALSE)
  DIR_EMARGEMENT <<- file.path(getwd(), "Students")
  dir.create(DIR_EMARGEMENT, showWarnings=FALSE)
  DIR_CONFIG <<- file.path(getwd(), "Config")
  DIR_EXOS <<- file.path(getwd(), "Questions")
  DIR_SCAN <<- file.path(getwd(), "Scan")
  DIR_EVALUATION <<- file.path(getwd(), "Evaluation")
  EXOS_BASE_REL <<- file.path(DIR_EXOS, EXOS_BASE)
  # The NOPS output subfolder
  NOPS_DOSSIER_PDF <<- "nops"
  # Basename for the PDF NOPS files.
  NOPS_BASENAME <<- "exam_form"

  cat("Condig file read.\n")
  cat(paste("Exam:", TITLE, "\n"))
  cat(paste("copies:", NOPS_N, "\n"))
}

run_evaluation = function(force_read_scan=FALSE) {
  # Run the evaluation of the scanned and read NOPS
  # if force_read_scan is TRUE the scans are reading each time
  # the funcion is called (time consuming), otherwise it uses the last reading

  check_result = check_evaluation()

  # Retrieve the scanned results
  dir_qcm = file.path(DIR_SCAN,"nops")
  dir_string = file.path(DIR_SCAN,"string")
  qcm_scan_zip_file = Sys.glob(file.path(dir_qcm,"nops_*.zip"))
  string_scan_zip_file = NULL
  if (length(Sys.glob(file.path(dir_string,"nops_*.zip"))) > 0) {
    string_scan_zip_file = Sys.glob(file.path(dir_string,"nops_string_*.zip"))
  }

  if((length(qcm_scan_zip_file) == 0) || (force_read_scan)){
    cat("\n")
    cat(paste(">>> Reading", check_result$nNOPS,'NOPS...\n'))
    # read the scanned NOPS
    read_nops_scans()
  }

  # read string scan if there is any
  if (check_result$nString > 0){
    if((length(string_scan_zip_file) == 0) || (force_read_scan)){
      cat("\n")
      cat(paste(">>> Reading", check_result$nString,'String...\n'))
      read_string_scan()
    }
  }

  # evaluate
  cat("\n")
  cat(">>> Running evaluation...\n")
  evaluation()
  cat(paste("Files saved in", DIR_EVALUATION, '\n'))

  # Generate a minimal note sheet
  evaluation_summary()
}

