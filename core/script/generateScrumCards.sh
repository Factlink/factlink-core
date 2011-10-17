#!/bin/bash

if [ -z $1 ] 
then
	echo "Please provice a file name of the xml from scrumdo"
else
	echo "Generating tex..."
	perl generateScrumCards.pl < $1 > cards.tex
	echo "Done"

	echo "Generating pdf..."
	pdflatex cards.tex 
	echo "Done"
	
	echo "Your cards are available in the file cards.pdf"	
fi
