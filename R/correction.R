#' Read the multiple choice part of the scanned NOPS
#' The scans should be PNG images
#' They must be placed in the "Scan/nops" folder
read_nops_scans <- function() {
  dir_qcm = file.path(DIR_SCAN,"nops")
  if(!dir.exists(dir_qcm)) dir.create(dir_qcm, recursive = TRUE)
  unlink(Sys.glob(file.path(dir_qcm,"*.zip")))

  nops_scan(dir = dir_qcm,
            verbose = TRUE,
            rotate = UPSIDE_DOWN,
            cores = PARALLEL_CORES,  # s'il y a des problèmes, mettre le num de cors à 1
            density = 300,
            string=FALSE
  )
}

#' Read the written part of the scanned NOPS
#' The scans should be PNG images
#' image files must be placed in the "Scan/string" folder
read_string_scan <- function() {
  dir_string = file.path(DIR_SCAN,"string")
  if(!dir.exists(dir_string)) dir.create(dir_string)
  # delete old zip files
  unlink(Sys.glob(file.path(dir_string,"*.zip")))

  nops_scan(dir = dir_string,
            verbose = TRUE,
            rotate = TRUE,
            cores = PARALLEL_CORES,  # s'il y a des problèmes, mettre le num de cores à 1
            density = 300,
            string=TRUE
  )
}

#' Check some necessary conditions for the automatic
#' evaluation of the scanned exams
check_evaluation <- function() {
  cat("Checking for evaluation...\n")

  ### STUDENT list ###
  if (!file.exists(file.path(DIR_EMARGEMENT,STUDENTS_LIST))) {
    cat(paste("Student list file not found.\n"))
    cat(file.path(DIR_EMARGEMENT,STUDENTS_LIST))
    cat('\n')
    stop("Evaluation aborted.")
  }

  # stop if the student list header is wrong
  stud = read.csv(file.path(DIR_EMARGEMENT,STUDENTS_LIST), sep=';')
  if (!all(colnames(stud) == c("registration","name","id"))) {
    print("The columns of the Student list file are wrong.")
    print("Please use: registration;name;id")
    stop("Evaluation aborted.")
  }
  # stop if id numbers are not unique
  n_occur = data.frame(table(stud$id))
  duplicata = n_occur[,n_occur$Freq>1]
  if (length(duplicata) != 0) {
    cat("Error in the students list\n")
    cat("Some ID are not unique.\n")
    print(duplicata)
    stop("Evaluation aborted.")
  }
  # stop if registration numbers are not unique
  n_occur = data.frame(table(stud$registration))
  duplicata = n_occur[,n_occur$Freq>1]
  if (length(duplicata) != 0) {
    cat("Error in the students list\n")
    cat("Some REGISTRATION numbers are not unique.\n")
    print(duplicata)
    stop("Aborted.")
  }

  cat("Student list OK\n")

  ### NOPS and string scan ###
  dir_nops = file.path(DIR_SCAN,"nops")
  dir_string = file.path(DIR_SCAN,"string")

  # check the nops folder
  if(!dir.exists(dir_nops)) {
    dir.create(dir_qcm, recursive = TRUE)
    cat(paste(">>> The scan folder did not exist.", dir_nops, "created\n"))
    stop(">>> Please, put your scanned NOPS (exam forms) there.")
  }

  nops_fnames = list.files(dir_nops, pattern="(?i).*[.]png")
  str_fnames = c()
  if (dir.exists(dir_string)) {
    str_fnames = list.files(dir_string, pattern="(?i).*[.]png")
  }

  # stop if no NOPS are found
  if(length(nops_fnames) == 0) {
    stop("No scanned nops found. Make sure you're using PNG images.")
  }

  # stop if number of strings and NOPS is different
  if (length(str_fnames)!=0) {
    if (length(str_fnames)!=length(nops_fnames)) {
      cat("The number of string and NOPS scans must be equal\n")
      cat(paste("String:", length(str_fnames),'\n'))
      cat(paste("NOPS:", length(nops_fnames),'\n'))
      stop("Evaluation aborted.")
    }
  }

  # stop if scan filenames contain whitespaces
  for (fname in nops_fnames) {
    if(grepl("\\s+", fname)) {
      cat(paste("Error in",dir_nops,'\n'))
      cat(paste(fname, "because it contains white spaces.\n"))
      stop("Evaluation aborted.")
    }
  }
  for (fname in str_fnames) {
    if(grepl("\\s+", fname)) {
      cat(paste("Error in",dir_string,'\n'))
      cat(paste(fname, "because it contains white spaces.\n"))
      stop("Evaluation aborted.")
    }
  }
  cat("Scan files OK\n")
  cat("Ready for evaluation\n")

  list(nNOPS=length(nops_fnames), nString=length(str_fnames))
}

#' call the evaluation function of rexams
#' and generate the results.
evaluation <- function() {
  if (!dir.exists(DIR_EVALUATION)){
    dir.create(DIR_EVALUATION, recursive=TRUE)
  }

  # Output the exam automatic evaluation
  dir_qcm = file.path(DIR_SCAN,"nops")
  dir_string = file.path(DIR_SCAN,"string")

  N_EXERCICES <<- length(POINTS)

  # Retrieve the scanned results
  qcm_scan_zip_file = Sys.glob(file.path(dir_qcm,"nops_*.zip"))
  string_scan_zip_file = NULL
  if (length(Sys.glob(file.path(dir_string,"nops_*.zip"))) > 0) {
    string_scan_zip_file = Sys.glob(file.path(dir_string,"nops_string_*.zip"))
  }

  # evaluation
  ev1 <- nops_eval(
    register = file.path(DIR_EMARGEMENT,STUDENTS_LIST),
    solutions = Sys.glob(file.path(DIR_GENERATION,TITLE,NOPS_DOSSIER_PDF,"*.rds")),
    scans = qcm_scan_zip_file,
    string_scans = string_scan_zip_file,
    html = "index.html",
    language=NOPS_LANGUAGE,
    points = POINTS,
    string_points = c(1,2,3,4,5)/5,
    mark = FALSE,
    eval = exams_eval(partial = PARTIAL_ANS, negative = NEGATIVE_POINTS), # partial=TRUE partial credits are assigned to each correct choice
    interactive = TRUE
  )

  # arrange and unzip generated files
  file.rename("nops_eval.zip", file.path(DIR_EVALUATION,"HTML_results_data.zip"))
  file.rename("nops_eval.csv", file.path(DIR_EVALUATION,"nops_eval.csv"))
  unzip(file.path(DIR_EVALUATION,"HTML_results_data.zip"),
        exdir=file.path(DIR_EVALUATION, "HTML_results_data"))
  unlink(file.path(DIR_EVALUATION,"HTML_results_data.zip"))

  # copy the HTML index template in the evaluation folder
  html_index = list.files(
    system.file("HTML_templates", package = "morexams"), full.names = TRUE)
  file.copy(html_index, file.path(DIR_EVALUATION))
}

#' Generates a minimal result table.
#' It contains only 3 columns StudentName, ID, Note
evaluation_summary <- function(){
  nops_eval_csv = file.path(DIR_EVALUATION,"nops_eval.csv")
  if (!file.exists(nops_eval_csv)) {
    stop(paste("file",nops_eval_csv,"not found!"))
  }
  eval_summary <- read.csv(nops_eval_csv, sep=';')
  eval_summary_short <- eval_summary[,c("name","registration","points")]
  colnames(eval_summary_short) <- c("Name","ID","Note")
  eval_summary_short <- eval_summary_short[order(eval_summary_short$Name),]

  out_csv_name = paste("Notes", TITLE, sep='_')
  write.csv2(eval_summary_short,
               file=file.path(DIR_EVALUATION,paste(out_csv_name,".csv",sep='')),
               row.names=FALSE)

  cat(paste("short evaluation summary generated in",DIR_EVALUATION,"\n"))
}
