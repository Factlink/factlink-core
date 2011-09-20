#! /usr/local/bin/perl

# This script can be used to generate cards for printing on the board based on the scrumdo.com xml output


use XML::Simple;
use Data::Dumper;

$xml = new XML::Simple ();
$data = $xml->XMLin("-");

print "\\documentclass{article}
\\usepackage[english]{babel}
\\begin{document}
\\noindent\n";

foreach $story (@{$data->{story}}){
	print "\\begin{tabular}{||p{12cm}||} \n";
	print "\\hline\n\\hline\n";
	print ("\\begin{flushleft}\\begin{tabular}{p{8cm}r} \\huge{ID:$story->{story_id}} & \\textbf{\\huge{SP: $story->{points}}} \\end{tabular} \\end{flushleft} \\\\ \n");
	print "\\hline\n";
	print ("\\begin{flushleft}\\Large{Story: $story->{summary}}\\end{flushleft} \\\\ \n");
	print "\\hline\n";
	print ("\\begin{flushleft}Details: $story->{detail}\\end{flushleft}  \\\\ \n");
	print "\\hline\n\\hline\n";
	print "\\end{tabular} \n \\\\ \n \\\\ \n \\\\ \n \\\\ \n";
}

print "\\end{document}\n";
