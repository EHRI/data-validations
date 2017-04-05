#EHRI EAD

EHRI_EAD.odd is the place where the EHRI EAD schema in maintained.

It is used to generate:
* a RelaxNG file with embedded schematron rules (EHRI_EAD.rng)
* HTML documentation (EHRI_EAD_doc.html)


To generate these files, simply run the script `convertODD.sh`


To extract the schematron rules from the RelaxNG schema, run the following command:

```
saxon -s:EHRI_EAD.rng -xsl:XSL/ExtractSchFromRNG-2.xsl -o:EHRI_EAD.sch

```

