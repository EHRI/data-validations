# EHRI EAD

EHRI_EAD.odd is the place where the EHRI EAD schema in maintained.

## How to update EHRI_EAD .odd
TBD

## Generate a RelaxNG schema with embedded schematron and HTML documentation
EHRI_EAD.odd is used to generate:
* a RelaxNG file with embedded schematron rules (EHRI_EAD.rng)
* HTML documentation (EHRI_EAD_doc.html)

These files need to be regenerated each time a change is made in EHRI_EAD.odd. To do so, simply run the script `convertODD.sh`

__NB: You need (java1.6+)[https://www.java.com/en/download/], (saxon)[http://www.saxonica.com/saxon-c/index.xml#download] and (ant)[https://ant.apache.org/] installed on you machine.__

To extract the schematron rules from the RelaxNG schema, run the following command:

```
saxon -s:EHRI_EAD.rng -xsl:XSL/ExtractSchFromRNG-2.xsl -o:EHRI_EAD.sch

```

