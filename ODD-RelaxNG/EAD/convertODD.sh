#!/bin/bash

# This script generates HTML documentation and RelaxNG (with embedded schematron) from EHRi_EAD.odd
# You need to execute it in the EAD directory.
# A local installation of Java 1.6+, Saxon and Ant is required
# For more information, check http://www.tei-c.org/release/doc/tei-xsl/#commandline

#Relax NG
#XSL/Stylesheets/bin/teitorelaxng --odd EHRI_EAD.odd EHRI_EAD.rng

#HTML
# We don't use the script provided by the TEI consortium in order to set our own parameters to the XLS stylesheets
saxon -s:EHRI_EAD.odd -xsl:XSL/Stylesheets/odds/odd2odd.xsl -o:output.tmp1.xml
saxon -s:output.tmp1.xml -xsl:XSL/Stylesheets/profiles/eadodd/oddhtml.xsl -o:EHRI_EAD_doc.html