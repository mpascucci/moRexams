check_folder <- function(folderName) {
  # check if the specified folder exists, otherwise throw an error
  if (!dir.exists(folderName)) {
    stop(paste("The folder", folderName, "does not exist."))
  }
}

get_config_dir = function() {
  # Get the path of the config folder
  # this is a private function
  # If a folder named "Config" exist in the current
  # working path, then this is returned.
  if (dir.exists(DIR_CONFIG)) {
    DIR_CONFIG }
  else {
    system.file("Config", package = "morexams")
  }
}

morexams_init = function() {
  templates = list.files(system.file("Template", package = "morexams"),full.names = TRUE)
  file.copy(templates, getwd(), recursive = TRUE)
}

create_config_dir = function() {
  # Create a configuration dir in the current folder
  # The configuration dir contains the PDF templates
  if (!dir.exists("Config")) {
    file.copy(system.file("Config", package = "morexams"), getwd(), recursive = TRUE)
  } else {
    cat("Config folder exists already in the current working folder")
  }
}

count_decimals <- function(x) {
  # return the length of the (significant) decimal part of x
  x <- toString(x)
  split = unlist(strsplit(x, "\\."))
  if (length(split) != 2) {
    0
  } else {
    decimal_part = split[2]
    2**floor(log10(strtoi(decimal_part)))
  }
}
count_decimals(2.14)

# verifice que la fonction qui génère la solution est bien écrite.
#
# gen_sol : focntion qui genère la solution de l'exercice
# params : liste nomée d'arguments pour appeler gen_sol
# solution : la solution correspondante à l'appel de gen_sol avec params
check_solution <- function(gen_sol, params, solution) {
  precision = count_decimals(solution)
  if (
    !assertthat::are_equal(
      round(do.call(gen_sol, args=params), digits = precision),
      round(solution, digits=precision) )
  ) {
    stop("la fonction gen_sol ne passe pas le test.")
  }
}

clean_console <- function() {
  cat("\014") # clean the console screen
}

# renders a list as an HTML table
array_to_HTMLTable <- function(c, columns) {
  s <- "<style>td.lex { padding-right: 0.5em; } </style>"
  s <- paste(s,"<table style='margin:auto;'>",sep="\n")
  col_n = min(columns, length(c))

  for (i in 1: length(c)) {
    if (i %% col_n == 1) {
      s <- paste(s,"<tr>", sep="")
    }

    td <- paste("<td class='lex'>",c[i],"</td>", sep="")
    s <- paste(s,td,sep=' ')

    if (i %% col_n == 0) {
      s <- paste(s,"</tr>",sep='')
      s <- paste(s,"\n",sep='')
    }
  }
  s <- paste(s,"</table>", sep="\n")
  s
}


# renders a list as a MarkDown table
array_to_MDTable <- function(c, columns) {
  col_n = min(columns, length(c))
  s <- paste(rep('', times = col_n+2), collapse="|")
  s <- paste(s,'\n',sep='')

  s <- paste(s,'|',sep='')
  l <- paste(rep('-', times = col_n), collapse="|")
  s <- paste(s,l,sep='')
  s <- paste(s,'|\n',sep='')

  for (i in 1: length(c)) {
    if (i %% col_n == 1) {
      s <- paste(s,"|", sep="")
    }
    s <- paste(s,c[i],sep='')
    s <- paste(s,'|',sep='')

    if (i %% col_n == 0) {
      s <- paste(s,"\n", sep="")
    }
  }
  s
}

safe_mkdir <- function (folder) {
  # Remove the specified folder.
  #
  # Check if the folder exists already.
  # If it exists, it will continue according to the
  # value of the OVERWRITE config variable

  if (!dir.exists(folder)){
    dir.create(folder, recursive=TRUE)
  } else {
    if (OVERWRITE) {
      answ <- readline(prompt="The output folder exists already, overwrite? [Y/n]")
      if (answ!="" & toupper(answ)!="Y"){
        stop("Operation aborted.")
      }
      # delete the output folder
      unlink(folder, recursive=TRUE)
      # create the output folder
      dir.create(folder)
    } else {
      # Stop program execution
      stop(paste("The folder", output_path, "exists already.", "Delete it or change the OVERWRITE config value to TRUE in config.R"))
    }
  }
}
