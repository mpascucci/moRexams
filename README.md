# MOREXAMS

[Rexam](http://www.r-exams.org/) is a very powerful R package for exam sheets geenration and correction.
The package is reach and its functions are highly customizable.
For this very reason its use might be confusing at first. This package is the synthesis of one year wokring with r-exams. `morexams` is built to facilitate users access to the `rexam` functionality, possibly lowering the entry cost.

`morexams` wraps `rexam` and adds mainly three features:
* add checks to avoid simple problems (duplicate students, missing sheets ...) which are difficult to debug in `rexam`
* add an `init` function to initialize a working folder with a basic structure needed to use `rexams` out of the box. The `init` function generates a fully-working example to immediately start with `rexam`.
* move the configuration from the function parameters to a configuration file, useful to store configurations and simplyfy the script writing.

## Install
Install `devtools` and `morexams` with the following commands:
```{R}
install.packages("devtools")
library(devtools)
install_github("mpascucci/morexams")
```

## Initialization
Open R in an empty directiory which will contain your new exam and run:
```{R}
library(morexams)
morexams_init()
```
This will setup the folder by copying the mains R scripts, config and tutorial files.

## Folder structure
```
|-Generated        #generated exam sheets
|-Logo             #logo to put on the exam sheets
|-Questions        #exam questions
|-Scan             #scanned exam sheets
|-Students         #students list
|-Evaluation       #exam results
exam_generation.R  #example script for exams sheet generation
exam_correction.R  #example script for auto exams correction
config.R           #the exam configuration file
```

## Exam procedure
(To be translated in English)
0. editer la configuration dans le ficheir `config.R`
1. generer les examens écrits et NOPS (`exams_generation.R`)
2. Faire une copie du dossier `Generated` pour securité
3. imprimer les copies recto-verso, agraffées.
4. prevenir les etudiants de la methode d'examen (en particulier stilo à bille bleu/noir et expliquer bien comment marquer le nombre de matricule sur la copie)
5. prendre une copie, faire les exercices et vérifier que la bonne reponse est presente dans chaque question (c'est à dire qu'on ne s'est pas trompé dans le code des exercices au moment du calcul de la solution)

## Examen
0. prevoir des stilos à billes
1. bien expliquer comment remplir les cases pour la matricule et les reponses (sens de remplissage, croix precise, pas de bavures)
2. demander aux étudiants de degraffer (arracher) et rendre une seule feuille de solutions pour chaque partie de l'examen (QCM/reponse ouverte). Faire deux tas: un tas pour la feuille des solution QCM et un tas pour les copies manuscrites (traditionnelles) qui doivent être rendues même vides. Dans chaque copie manuscrite il faut mettre, si presente, la feuille des reponses ouverte (string)
3. S'assurer que les étudiants aient écrit leur nom/prenom/matricule sur la feuille des resultat et su la copie manuscrite
4. Dire aux étudiants de garder la feuille de l'énoncé, qui leur sera indispensable pour comprendre la correction.

## Scan
* **Mettre toutes les copies dans le même sense**, coté opposé à l'agraffe en premier (avec cette configuration les pages sont scannées à l'invers, c'est normal, ça doit être comme ça si non ça ne marche pas).
* forcer le format A4
* choisir le format PNG, resolution 300dpi

## Correction
1. compter les copies blanches (pas de matruicule) et les enlever du pacquet avant le scan
2. numériser les feuilles et les copier dans le dossier `Scan/qcm` pour les QCM et `Scan/string` pour les feuilles des reponses libres.
3. utiliser le script `exams_correction.R` pour l'évaluatuation intéractive
4. en cas d'erreur inncomprehensible verifier que les pages sont toutes dans le même sans.
Erreur type:
	Error in scan(file = file, what = what, sep = sep, quote = quote, dec = dec,  :
	line 8 did not have 6 elements
veut dire qu'il y a un erreur de lecture et qu'il faut corriger à main le fichier Daten.txt dans le zip généré.
ATTENTION: **Modifier seulement avec un editor de texte simple pour ne pas perdre les zeros en tête**

## Archiver
* Après l'évaluation copier les dossier suivants ailleur pour archivage:
- Evaluation
- Scan
- Generation

### Note pour utiliser des scan PDF (au lieu de PNG)
testé seulement sous Linux
* On linux install ImageMagik
* modify /etc/ImageMagick-6/policy.xml
from ` <policy domain="coder" rights="none" pattern="PDF" />`
to `<policy domain="coder" rights="read|write" pattern="PDF" />`
