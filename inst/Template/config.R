# =================================================
# LaMMExam - CONFIGURATION FILE
# =================================================

# -------------------------------------------------
# Information à modifiér poru chaque examen

# titre de l'examen
TITLE = "Tutorial Exam"
# Date de l'examen
DATE = "25/05/2020"
# Autheur (affiché seulement dans la generation d'écrits)
AUTHOR = "M. Pascucci, M.L. Taupin"
# Initialization des nombre pseudo-aleatoires pour la
# génération des reponses
SEED = 1
# Dossier des exercices (dans DIR_EXOS), où se trouvent les dossiers
# 'nops' et 'ecrits' pour les deux types d'examens
EXOS_BASE = "tutorial"
# Nom du fichier de la liste d'emargement (dans DIR_EMARGEMENT)
STUDENTS_LIST = "students.csv"
# generer des NOPS# (feuille d'examen pour lecture automatique par scan)
# Les seuls exercices acceptés sont des single/multiple choice
# en plus on peut ajouter jusqu'à 3 exercices de type STRING (répose ouverte)
# nombre de copies à générer
NOPS_N = 2

# -------------------------------------------------
# Nom de l'insittution
INSTITUTION = "UEVE"
# language des copies
NOPS_LANGUAGE = "en"
# rendre possible l'écrasement des exercices générés precedamment
# pour le même examen?
OVERWRITE = TRUE

# The logo that should be put on the exam forms
# The image file must be placed in the "Config/res/logo" folder
LOGO = ""

# -------------------------------------------------
# EXAMENS ECRITS ( exams2pdf() )
# il s'agit d'énoncés d'examen traditionnaux, tout type d'exercice est accepté (même)
ECRITS_SUBTITLE = "Partie écrite de l'examen"
ECRITS_N = 2 # nombre de copies



