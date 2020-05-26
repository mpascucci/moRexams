
# Generate the NOPS
make_nops = function(show_pdf_solution=FALSE) {
  # check the input folders
  exos_path = file.path(EXOS_BASE_REL)
  check_folder(exos_path)

  cat(">>> NOPS GENERATION...\n")

  output_path = file.path(DIR_GENERATION, TITLE, NOPS_DOSSIER_PDF)
  # Clear the output folder
  safe_mkdir(output_path)

  # Get the list of exercices in the input folder
  myexam = list.files(path=exos_path, pattern=".*.Rmd") %>%
    map(function(x) file.path(exos_path, x))

  # Call Rexams NOPS generation function
  exams2nops(myexam, n = NOPS_N, # nombre de copies générées
             institution = INSTITUTION,
             name = NOPS_BASENAME,
             logo = LOGO,
             title = TITLE,
             language = NOPS_LANGUAGE,
             blank = 0, # page blanche (brouillon)
             replacement = TRUE, # deuxième feuille avec les cases à cocher
             duplex = TRUE, #page 2 blanche pour impression recto-verso
             encoding = "UTF-8",
             dir = output_path,
             usepackage = c("amsmath","amsfonts","amssymb"),
             # points = c(1,1,1,1,1,1,) # attention: length = num ex.
             # showpoints = TRUE,
             samepage = TRUE,
             reglength = 8,
             date = DATE,
             verbose=TRUE
  )

  cat("\n")
  cat(">>> NOPS generated in the output folder:\n")
  cat(paste(output_path,'\n'))

  if (show_pdf_solution){
    # show the solution sheet in pdf viewer
    exams2pdf(myexam,
              header=list(Date=DATE,
                          Title=TITLE,
                          author=AUTHOR,
                          Subtitle=ECRITS_SUBTITLE,
                          ID=function(i) gsub(" ", "0", format(i, width = floor(ECRITS_N/10) + 1 ))),
              template=file.path(get_config_dir(),"exams2pdf","LateX_templates","solution")
    )
  }
}

write_one_solution <- function() {
  # Write the solution of the exam in a PDF document
  # The NOPS need to to have already been generated.

  solution_folder = file.path(DIR_GENERATION, TITLE)
  exos_path = file.path(EXOS_BASE_REL)

  myexam = list.files(path=exos_path, pattern=".*.Rmd") %>%
    map(function(x) file.path(exos_path, x))

  exams2pdf(myexam,
            dir=solution_folder,
            header=list(Date=DATE,
                        Title=TITLE,
                        author=AUTHOR,
                        Subtitle=ECRITS_SUBTITLE,
                        ID=function(i) gsub(" ", "0", format(i, width = floor(ECRITS_N/10) + 1 ))),
            template=file.path(get_config_dir(),"exams2pdf","LateX_templates","solution")
  )
  cat(">>> Example solution saved:\n")
  cat(paste(solution_folder," \n"))
}

make_all_solutions = function() {
  # Generate a solution PDF for each generated NOPS

  # name of the solutions subfolder
  SOLUTIONS_DOSSIER_PDF = "solutions"

  # check the input folders
  exos_path = file.path(EXOS_BASE_REL)
  check_folder(exos_path)

  output_path = file.path(DIR_GENERATION, TITLE, SOLUTIONS_DOSSIER_PDF)
  # Clear the output folder
  safe_mkdir(output_path)

  cat(">>> NOPS solutions are being generated...\n")

  # LISTE EXERCICES
  myexam = list.files(path=exos_path, pattern=".*.Rmd") %>%
    map(function(x) file.path(exos_path, x))

  exams2pdf(myexam,
            n=NOPS_N,
            dir=output_path,
            header=list(Date=DATE,
                        Title=TITLE,
                        author=AUTHOR,
                        Subtitle=ECRITS_SUBTITLE,
                        ID = function(i) as.character( as.numeric(i))
                        ),
            template=file.path(get_config_dir(),"exams2pdf","LateX_templates", c("solution"))
  )
  cat("Exam solution generated...  Do not cheat ;)")
  # exams2html() genère un document HTML
}

make_traditional_exams = function() {
  # Generate traditional exam sheets (no optical correction)
  ECRITS_DOSSIER_PDF = "hand_corrected" # dossier où les PDF seront généres

  # check the input folders
  exos_path = file.path(EXOS_BASE_REL)
  check_folder(exos_path)

  cat(">>> Generating the exam sheets...\n")

  output_path = file.path(DIR_GENERATION, TITLE, ECRITS_DOSSIER_PDF)
  # Clear the output folder
  safe_mkdir(output_path)

  # Exercice list
  myexam = list.files(path=exos_path, pattern=".*.Rmd") %>%
    map(function(x) file.path(EXOS_BASE_REL, x))

  exams2pdf(myexam,
            n=ECRITS_N,
            dir=output_path,
            header=list(Date=DATE,
                        Title=TITLE,
                        author=AUTHOR,
                        Subtitle=ECRITS_SUBTITLE,
                        ID=function(i) gsub(" ", "0", format(i, width = floor(ECRITS_N/10) + 1 ))),
            template=file.path(get_config_dir(),"exams2pdf","LateX_templates", c("exam"))
  )
  cat("\n")
  cat(">>> NOPS generated in the output folder:\n")
  cat(paste(output_path,'\n'))

  # NOTE generate an HTML document with
  # exams2html()
}

backup_config <- function() {
  # Make a backup copy of the current configuration file
  #
  # This is particularly useful after generating the exam sheets
  # because some output files need to be re-used in the
  # optical correction step.

  time_tag = format(Sys.time(), "%Y_%m_%d-%H_%M_%S")

  output_base_path = file.path(DIR_GENERATION, TITLE)
  check_folder(output_base_path)

  backup_name = paste("backup",time_tag,sep="_",TITLE)
  temp_dir = file.path(output_base_path, backup_name)
  dir.create(temp_dir)

  cat(paste("#Exam:", TITLE,"\n",
            "#Backup on:", date(),'\n'), file=file.path(temp_dir,"log.txt"))

  file.copy(CONFIG_FILE, temp_dir)

  rds_file = file.path(output_base_path, NOPS_DOSSIER_PDF,
                       paste(NOPS_BASENAME,".rds",sep=''))
  if (file.exists(rds_file)) {
    dir.create(file.path(temp_dir,"nops"))
    file.copy(rds_file, file.path(temp_dir,"nops"))
  }

    zipr(file.path(DIR_GENERATION,
                 paste(backup_name,".zip",sep='')),
       temp_dir)
  unlink(temp_dir, recursive = TRUE)

  cat(">>> Backup completed.")
  }

