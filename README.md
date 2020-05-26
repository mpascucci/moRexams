

# PROCEDURE EXAMENS

## Install
* Installer le package "lammexams" (dans RStudi,o menu `Tools>Install Packages>Install From>Package archive file` et selectionner le fichier `lammexams_*.tar.gz` dans le dossier principale.
* sans avoir de fichier ;tar.gz, charget la librairie devtools: library(devtools)
Et executer la commande: install(“lammexams”)


## Preparation
0. editer la configuration dans le ficheir `config.R`
1. generer les examens écrits et NOPS (`exams_generation.R`)
2. copier ailleur et garder le fichier `.rds` (qui est generé automatiquement avec les nops)
3. si des écrits sont génerés, copier ailleur le dossier `ecrits_pdf`
4. imprimer les copies recto-verso, agraffées.
5. prevenir les etudiants de la methode d'examen (en particulier stilo à bille)
6. prendre une copie, faire les exercices et vérifier que la bonne reponse est presente dans chaque question (c'est à dire qu'on ne s'est pas trompé dans le code des exercices au moment du calcul de la solution)

## Examen
0. prevoir des stilos à billes
1. bien expliquer comment remplir les cases pour la matricule et les reponses (sens de remplissage, croix precise, pas de bavures)
2. demander aux étudiants de degraffer et rendre une seule feuille de solutions pour chaque partie de l'examen. Faire deux tas: un tas pour la feuille des solution QCM et un tas pour les copies manuscrites (traditionnelles) qui doivent être rendues même vides. Dans chaque copie il faut mêtre, si presente, la feuille des reponses libres (pour les quesions libres/pas QCM).
3. S'assurer que les étudiants aient écrit leur nom/prenom/matricule sur la feuille des resultat et su la copie manuscrite
4. Dire aux étudiants de garder la feuille de l'énoncé, qui leur sera indispensable pour comprendre la correction.

## Scan
* **Mettre toutes les copies dans le même sense**, coté opposé à l'agraffe en premier (avec cette configuration les pages sont scannées à l'invers, c'est normal, ça doit être comme ça si non ça ne marche pas).
* forcer le format A4
* autres paramètres par defaut (PDF compact / couleur / 300pdi)

## Correction
1. compter les copies blanches (pas de matruicule) et les enlever du pacquet avant le scan
2. numériser les feuilles et les copier dans le dossier `Scan/qcm` pour les QCM et `Scan/string` pour les feuilles des reponses libres.
3. utiliser le script `exams_correction.R` pour l'évaluatuation intéractive
4. en cas d'erreur inncomprehensible verifier que les pages sont toutes dans le même sans.
Erreur type:
	Error in scan(file = file, what = what, sep = sep, quote = quote, dec = dec,  :
	line 8 did not have 6 elements
veut dire qu'il y a un erreur de lecture et qu'il faut corriger à main le fichier Daten.txt dans le zip généré.
ATTENTION: **Modifier seulement avec un editor de texte simple pour ne pas perdre les zeros**

## Archiver
* Après l'évaluation copier les dossier suivants ailleur pour archivage:
- Evaluation
- Scan
- Generation

### Note pour utiliser les PDF (et pas PNG)
* On linux install ImageMagik
* modify /etc/ImageMagick-6/policy.xml
from ` <policy domain="coder" rights="none" pattern="PDF" />`
to `<policy domain="coder" rights="read|write" pattern="PDF" />`
