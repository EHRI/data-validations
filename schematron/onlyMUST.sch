<?xml version="1.0" encoding="UTF-8"?><sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:mscw="moscow" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" schemaVersion="0.1" queryBinding="xslt2">
    <sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
    <sch:title>An initial Schematron Schema for any EAD to validate for EHRI-preprocess</sch:title>
    <sch:p>this is before any EHRI preprocess. after validating according to the ead.xsd, this establishes some rules, according to Deliverable 17.3, for ead's provided to EHRI.
        It may be used as a starting point for data providers.
    </sch:p>
    <sch:p>Version History:</sch:p>
    <sch:p>0.1 (2014-10-07) : Initial rules</sch:p>
    <sch:p>0.2 (2014-10-17)     DEFINITIONS 
        <sch:emph>MUST-WP19</sch:emph>: mandatory for import process according to WP19
        <sch:emph>MUST-EAD</sch:emph>: mandatory according to the EAD specification of LoC
        <sch:emph>SHOULD-WP17</sch:emph>: mandatory for description process according to WP17
        <sch:emph>SHOULD-WP19</sch:emph>: desirable for description process according to WP19
        <sch:emph>COULD</sch:emph>: desirable for description process according to WP17
    </sch:p>
    
    <!-- TODO: langencoding="iso639-2b" dateencoding="iso8601" -->
    <!-- Question: do anything with level attribute? 
        
    class
    otherlevel
    
    http://www.loc.gov/ead/tglib/att_gen.html
 -->
    <sch:pattern>
        <sch:title>EAD header</sch:title>
        <sch:p>the EAD header contains useful information, like language of description, eadid etc.</sch:p>
        <sch:rule context="ead:eadid">
            <sch:assert mscw:advice="MUST-WP19" test="normalize-space(.)">eadid MUST contain text</sch:assert>
            
        </sch:rule>
        <sch:rule context="ead:eadheader">
            <sch:assert mscw:advice="MUST-WP19" test="ead:profiledesc">eadheader MUST contain a profiledesc</sch:assert>
        </sch:rule>
        <sch:rule context="ead:profiledesc">
            <sch:assert mscw:advice="MUST-WP19" test="ead:langusage/ead:language">eadheader MUST specify a langusage/language</sch:assert>
            
            
        </sch:rule>
        <sch:rule context="ead:filedesc">
            
        </sch:rule>
        <sch:rule context="ead:revisiondesc/ead:change">
            
        </sch:rule>
        
    </sch:pattern>
    <sch:pattern>
        <sch:title>did's</sch:title>
        <sch:rule context="ead:did">
            <sch:assert mscw:advice="MUST-WP19" test="ead:unitid">a did MUST have a unitid, according 17.3 and WP19</sch:assert>
            
            <!-- except for ehri-created unitid's, which might overlap when they have a different label -->
            <sch:assert mscw:advice="MUST-WP19" test="count(//ead:unitid[not(starts-with(@label, 'ehri'))])=count(distinct-values(//ead:unitid[not(starts-with(@label, 'ehri'))]))">unitid's MUST be unique within one eadfile, according 17.3</sch:assert>
            <sch:assert mscw:advice="MUST-WP19" test="ead:unittitle">a did MUST have a unittitle, according 17.3</sch:assert>
            <sch:assert mscw:advice="MUST-WP19" test="count(ead:unittitle[text()]) > 0">a did MUST have at least one non-empty unittitle</sch:assert>
            <!-- TODO 
    <sch:assert test="">When multiple unittitles are given, they SHOULD have different labels, according to 17.3</sch:assert>
    -->
            
            
            
            
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>unitdate's</sch:title>
        <sch:p>the xsd imposes a regexp on the 'normal' attribute. the unitdate itself however is free-text.</sch:p>
        <sch:rule context="ead:unitdate">
            
            
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>level attribute</sch:title>
        <sch:rule context="//*[@level]">
            <sch:assert mscw:advice="MUST-EAD" test="not(@level='otherlevel') or (@otherlevel and not(@otherlevel=''))">archdesc/c-level with @level 'otherlevel' MUST have an @otherlevel attribute describing the level</sch:assert>
            <!-- if its a fonds, it COULD be the archdesc -->
            
            <!--     parent(recordgrp) child(recordgrp) -->
            
            <!-- parent(recordgrp, subgrp) child(subgrp) -->
            
            <!-- child(file) parent(subgrp, recordgrp, series, subseries, collection) --> 
            
            <!-- child(item) parent(collection recordgrp file)-->
            
            <!-- child(otherlevel=sub-collection) parent(collection    otherlevel=sub-collection)-->
            
            <!-- child(series) parent(collection otherlevel=sub-collection  subfonds)-->
            
            <!-- child(subseries) parent(series    subseries)-->
            
            
            <!-- child(subfonds) parent(fonds    subfonds)-->
            
            
        </sch:rule>
    </sch:pattern>
<!-- 
    <sch:pattern>
        <sch:title>type attribute</sch:title>
        <sch:p>TYPE – required? (according to the LoC DTD information, this is not required, however they state in their text that it is required.)</sch:p>
        <sch:rule context="ead:dsc">
            <sch:assert mscw:advice="MUST-EAD" test="@type">dsc MUST have a @type attribute</sch:assert>
        </sch:rule>
    </sch:pattern>
 -->
    <sch:pattern>
        <!-- belongs to sch:pattern 'type attribute' but describes the same context, so needs a pattern of its own. -->
        <sch:rule context="//*[@type]">
            <sch:assert mscw:advice="MUST-EAD" test="not(@type='othertype') or (@othertype and not(@othertype=''))">dsc with @type 'othertype' MUST have an @othertype attribute describing the type</sch:assert>            
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>archdesc's and c-levels</sch:title>
        <sch:rule context="ead:archdesc">
            <sch:assert mscw:advice="MUST-WP19" test="@level">archdesc MUST have a level-attribute</sch:assert>
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        </sch:rule>
        <sch:rule context="ead:archdesc/ead:processinfo/ead:p">
            
        </sch:rule>
        <sch:rule context="ead:archdesc/ead:processinfo/ead:p/ead:date">
            
        </sch:rule>
        <sch:rule context="ead:language">
            <sch:assert mscw:advice="MUST-WP19" test="@langcode">language MUST contain a langcode attribute</sch:assert>
            
        </sch:rule> 
        <sch:rule context="ead:c01">
            <sch:assert mscw:advice="MUST-WP19" test="@level">c01 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c02">
            <sch:assert mscw:advice="MUST-WP19" test="@level">c02 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c03">
            <sch:assert mscw:advice="MUST-WP19" test="@level">c03 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c04">
            <sch:assert mscw:advice="MUST-WP19" test="@level">c04 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c05">
            <sch:assert mscw:advice="MUST-WP19" test="@level">c05 MUST have a level-attribute</sch:assert>
        </sch:rule>
        <sch:rule context="ead:c06">
            <sch:assert mscw:advice="MUST-WP19" test="@level">c06 MUST have a level-attribute</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>