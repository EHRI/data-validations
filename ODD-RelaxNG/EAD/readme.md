# EHRI EAD

EHRI_EAD.odd is the place where the EHRI EAD schema in maintained.

The RelaxNG schema, the EHRI specific schematron rules and the documentation are combined in the same document, encoded with TEI ODD (One document does it all).

The EHRI EAD ODD is derived from the master EAD ODD, maintained by the [Parthenos project](http://parthenos-project.eu).

This master ODD is available here : https://github.com/ParthenosWP4/standardsLibrary/blob/master/archivalDescription/EAD/odd/EADSpec.xml

ODD is a description language that can be processed to generate an actual schema (a DTD, a RelaxNG XML or compact schema, or an XML schema), schematron rules and documentation in various formats (XHTML, PDF, EPUB, docx, odt).


EHRI created another ODD to document the specific rules and constraints of the EHRI data model.
In this new ODD file, called EHRI_EAD.odd, the generic EAD specification is imported and serves as baseline of the specification. The additional constraints are added only to the elements that they refer to. Therefore, the EHRI_EAD.odd file only contains the `<elementSpec>` and `<classSpec>` that are different from the EAD master source.

The merge of the two ODD files – the EAD generic and the EHRI specific – is made when we apply a transformation.

## How to update EHRI_EAD.odd
If you want to add a schematron rule to an element of the EAD schema, you need to update the `<elementSpec>` of it.

See below a code sample:

```
<elementSpec ident="date" module="EAD" mode="change">
    <constraintSpec ident="dateNormal" scheme="isoschematron" type="EHRI" mode="add">    
        <desc>All the <gi>date</gi> elements MUST have a <att>normal</att> attribute whose
        pattern respects the ISO8601 standard and take the following form: YYYY-MM-DD</desc> 
        <constraint>
            <rule xmlns="http://purl.oclc.org/dsdl/schematron" context="ead:date">
                <assert xmlns="http://purl.oclc.org/dsdl/schematron" role="MUST"
                    test="matches(@normal, '^(([0-9]|[1-9][0-9]|[1-9][0-9]{2}|[1-9][0-9]{3}))-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$')"
                    >@normal attribute MUST respect ISO8601 pattern = YYYY-MM-DD</assert>
            </rule>
      </constraint>
    </constraintSpec>
</elementSpec>
```


## Generate a RelaxNG schema with embedded schematron and HTML documentation
EHRI_EAD.odd is used to generate:
* a RelaxNG file with embedded schematron rules (EHRI_EAD.rng)
* HTML documentation (EHRI_EAD_doc.html)

These files need to be regenerated each time a change is made in EHRI_EAD.odd. To do so, simply run the script `convertODD.sh`

__NB: You need [java1.6+](https://www.java.com/en/download/), [saxon](http://www.saxonica.com/saxon-c/index.xml#download) and [ant](https://ant.apache.org/) installed on you machine.__

To extract the schematron rules from the RelaxNG schema, run the following command:

```
saxon -s:EHRI_EAD.rng -xsl:XSL/ExtractSchFromRNG-2.xsl -o:EHRI_EAD.sch

```

