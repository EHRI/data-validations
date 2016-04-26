<?xml version="1.0" encoding="UTF-8"?>
<sch:schema schemaVersion="0.1" queryBinding="xslt2" xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:mscw="moscow">
    <sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
    <sch:title>after preprocess: A Schematron Schema for any EAD to validate for EHRI</sch:title>
    <sch:p>schematron to validate EAD files after preprocess, so they will be imported without any impediments.</sch:p>
    <sch:p>Version History:</sch:p>
    <sch:p>0.1 (2014-10-07) : Initial rules</sch:p>
    <sch:pattern>
        <sch:title>EAD header</sch:title>
        <sch:p>the EAD header contains useful information, like language of description, eadid etc.</sch:p>
        <sch:rule context="ead:eadid">
            <sch:assert mscw:advice="MUST" test="normalize-space(.)">eadid MUST contain text</sch:assert>
        </sch:rule>
        <sch:rule context="ead:eadheader">
            <sch:assert mscw:advice="MUST" test="ead:profiledesc/ead:langusage">eadheader MUST specify a langusage</sch:assert>
        </sch:rule>
        <sch:rule context="ead:langusage">
            <sch:assert mscw:advice="MUST" test="ead:language/@langcode">language MUST contain a langcode attribute</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>did's</sch:title>
        <sch:rule context="ead:did">
            <sch:assert mscw:advice="MUST" test="ead:unitid[@label='ehri_main_identifier']">a did MUST have a unitid</sch:assert>
            <!--<sch:assert mscw:advice="MUST" test="ead:unitid[starts-with(@type, 'refcode')]">a did MUST have a unitid with type="refcode"</sch:assert>-->
            
            <sch:report mscw:advice="MUST" test="ead:unitid[@label='ehri_main_identifier']=''">a unitid MUST not be empty</sch:report>
            <sch:assert mscw:advice="MUST" test="ead:unittitle">a did MUST have a unittitle</sch:assert>
            <sch:report mscw:advice="MUST" test="ead:unittitle=''">a unittitle MUST not be empty</sch:report>
            <!-- except for ehri-created unitid's, which might overlap when they have a different label -->
            <sch:assert mscw:advice="MUST" test="count(//ead:unitid[@label='ehri_main_identifier'])=count(distinct-values(//ead:unitid[@label='ehri_main_identifier']))">unitid's MUST be unique within one eadfile</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>archdesc's and c-levels</sch:title>
        <sch:rule context="ead:archdesc">
            <sch:assert mscw:advice="MUST" test="@level">archdesc MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c01">
            <sch:assert mscw:advice="MUST" test="@level">c01 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c02">
            <sch:assert mscw:advice="MUST" test="@level">c02 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c03">
            <sch:assert mscw:advice="MUST" test="@level">c03 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c04">
            <sch:assert mscw:advice="MUST" test="@level">c04 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c05">
            <sch:assert mscw:advice="MUST" test="@level">c05 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c06">
            <sch:assert mscw:advice="MUST" test="@level">c06 MUST have a level-attribute</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>