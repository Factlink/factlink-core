#! /usr/local/bin/perl

# This script can be used to generate cards for printing on the board based on the scrumdo.com xml output

use XML::Simple;
use Data::Dumper;

$xml = new XML::Simple ();
$data = $xml->XMLin("-");

print "\\documentclass{article}
\\usepackage[english]{babel}
\\usepackage[utf8]{inputenc}
\\begin{document}
\\noindent\n";

foreach $story (@{$data->{story}}){
	print "\\begin{tabular}{||p{12cm}||} \n";
	print "\\hline\n\\hline\n";
	print ("\\begin{flushleft}\\begin{tabular}{p{7cm}r} \\textbf{\\Huge{ID:$story->{story_id}}} & \\textbf{\\Huge{SP: $story->{points}}} \\end{tabular} \\end{flushleft} \\\\ \n");
	print "\\hline\n";
	$summary = escapeText($story->{summary});
	print ("\\begin{flushleft}\\Large{$summary}\\end{flushleft} \\\\ \n");
	if ($story->{detail}){
		print "\\hline\n";
		$detail = escapeText($story->{detail});
		print ("\\begin{flushleft}$detail\\end{flushleft}  \\\\ \n");
	}
	print "\\hline\n\\hline\n";
	print "\\end{tabular} \n \\\\ \n \\\\ \n \\\\ \n \\\\ \n";
}

print "\\end{document}\n";

sub escapeText(){
	$returnValue = $_[0];
	$returnValue =~ s/#/\\#/g;
	$returnValue =~ s/%/\\%/g;
	$returnValue =~ s/$/ /g;
	$returnValue =~ s/&/\\&/g;
	$returnValue =~ s/_/\\_/g;
	$returnValue =~ s/{/\\{/g;
	$returnValue =~ s/}/\\}/g;
	return $returnValue;
}