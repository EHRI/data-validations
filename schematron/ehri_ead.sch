<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" schemaVersion="0.4" queryBinding="xslt2">
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
  <sch:p>0.3 (2016-04-27): date validation</sch:p>
  <sch:p>0.4 (2016-05-03): separated date validation in a function</sch:p>

  <!-- add dashes to a //unitdate/@normal date where missing -->
  <!-- format must be YYYY-MM-DD with any of the dashes being optional -->
  <xsl:function name="ead:dashify-unitdate-normal" as="xs:string">
    <xsl:param name="unitdate-normal" as="xs:string"/>
    <!-- first remove any dashes -->
    <xsl:variable name="unitdate-normal" select="replace($unitdate-normal, '-', '')"/>
    <!-- then join the date parts with dashes -->
    <xsl:variable name="unitdate-normal" select="string-join((
                                                   substring($unitdate-normal, 1, 4),
                                                   substring($unitdate-normal, 5, 2),
                                                   substring($unitdate-normal, 7, 2)
                                                   ), '-')"/>
    <!-- finally return the result -->
    <xsl:sequence select="$unitdate-normal"/>
  </xsl:function>

  <!-- check if //unitdate/@normal date(s) actually exist -->
  <!-- e.g. 2000-02-29 exists but 2001-02-29 does not -->
  <xsl:function name="ead:unitdate-normal-exists" as="xs:boolean">
    <xsl:param name="unitdate-normal" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="contains($unitdate-normal, '/')">
        <xsl:variable name="start-date" select="ead:dashify-unitdate-normal(replace($unitdate-normal, '/.*', ''))"/>
        <xsl:variable name="end-date" select="ead:dashify-unitdate-normal(replace($unitdate-normal, '.*/', ''))"/>
        <xsl:sequence select="$start-date castable as xs:date and $end-date castable as xs:date"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="date" select="ead:dashify-unitdate-normal($unitdate-normal)"/>
        <xsl:sequence select="$date castable as xs:date"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

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
      <sch:assert role="MUST-WP19" test="normalize-space(.)">eadid MUST contain text</sch:assert>
      <sch:assert role="SHOULD-WP17" test="@mainagencycode">eadid SHOULD contain a mainagencycode attribute</sch:assert>
    </sch:rule>
    <sch:rule context="ead:eadheader">
      <sch:assert role="MUST-WP19" test="ead:profiledesc">eadheader MUST contain a profiledesc</sch:assert>
    </sch:rule>
    <sch:rule context="ead:profiledesc">
      <sch:assert role="MUST-WP19" test="ead:langusage/ead:language">eadheader MUST specify a langusage/language</sch:assert>
      <sch:assert role="SHOULD-WP17" test="ead:creation">eadheader SHOULD specify a creation</sch:assert>
      <sch:assert role="COULD" test="ead:creation/ead:date and normalize-space(ead:creation/ead:date)">eadheader COULD have a non-empty creation-date</sch:assert>
    </sch:rule>
    <sch:rule context="ead:filedesc">
      <sch:assert role="SHOULD-WP17" test="ead:publicationstmt/ead:publisher">eadheader SHOULD specify a publisher</sch:assert>
    </sch:rule>
    <sch:rule context="ead:revisiondesc/ead:change">
      <sch:assert role="SHOULD-WP17" test="normalize-space(ead:date)">a revisiondesc SHOULD have a non-empty date</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>did's</sch:title>
    <sch:rule context="ead:did">
      <sch:assert role="MUST-WP19" test="ead:unitid">a did MUST have a unitid, according 17.3 and WP19</sch:assert>
      <sch:report role="SHOULD-WP17" test="ead:unitid=''">a unitid SHOULD not be empty</sch:report>
      <!-- except for ehri-created unitid's, which might overlap when they have a different label -->
      <!--                <sch:assert role="MUST-WP19" test="count(//ead:unitid[not(starts-with(@label, 'ehri'))])=count(distinct-values(//ead:unitid[not(starts-with(@label, 'ehri'))]))">unitid's MUST be unique within one eadfile, according 17.3</sch:assert>
-->
      <sch:assert role="MUST-WP19" test="count(//ead:unitid[@label='ehri_main_identifier'])=count(distinct-values(//ead:unitid[@label='ehri_main_identifier']))">unitid's MUST be unique within one eadfile, according 17.3</sch:assert>
      <sch:assert role="MUST-WP19" test="ead:unittitle">a did MUST have a unittitle, according 17.3</sch:assert>
      <sch:assert role="MUST-WP19" test="count(ead:unittitle[text()]) &gt; 0">a did MUST have at least one non-empty unittitle</sch:assert>
      <!-- TODO 
    <sch:assert test="">When multiple unittitles are given, they SHOULD have different labels, according to 17.3</sch:assert>
    -->
      <sch:assert role="SHOULD-WP17" test="count(ead:unittitle[text()])=1 or (count(ead:unittitle[text()]) = count(distinct-values(ead:unittitle[text()]/@label)))">when multiple unittitles are given, they SHOULD have different labels, according to 17.3</sch:assert>
      <sch:assert role="SHOULD-WP17" test="ead:unitdate">a did SHOULD have a unitdate, according 17.3</sch:assert>
      <sch:assert role="COULD" test="not(ead:unitdate) or (ead:unitdate/@label and not(ead:unitdate/@label='')) or (ead:unitdate/@encodinganalog and not(ead:unitdate/@encodinganalog=''))">unitdates COULD have a label, describing the type of date, according 17.3</sch:assert>
      <sch:assert role="SHOULD-WP17" test="ead:physdesc/ead:extent and not(ead:physdesc/ead:extent='')">a did SHOULD have a non-empty physdesc-extent, according to 17.3</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>unitdate's</sch:title>
    <sch:p>the xsd imposes a regexp on the 'normal' attribute. the unitdate itself however is free-text.</sch:p>
    <sch:rule context="ead:unitdate">
      <sch:assert role="SHOULD-WP17" test="normalize-space(.) or normalize-space(@normal)">unitdate SHOULD be non-empty or have a non-empty @normal attribute</sch:assert>
      <sch:assert role="SHOULD-WP19" test="normalize-space(@normal)">unitdate SHOULD have a non-empty @normal attribute</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>Date validation</sch:title>
    <sch:rule context="ead:unitdate">
      <sch:assert role="MUST-EAD" test="ead:unitdate-normal-exists(@normal)">unitdate/@normal should include a valid date</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>level attribute</sch:title>
    <sch:rule context="//*[@level]">
      <sch:assert role="MUST-EAD" test="not(@level='otherlevel') or (@otherlevel and not(@otherlevel=''))">archdesc/c-level with @level 'otherlevel' MUST have an @otherlevel attribute describing the level</sch:assert>
      <!-- if its a fonds, it COULD be the archdesc -->
      <sch:assert role="SHOULD-WP19" test="not(@level='fonds') or name(.)='archdesc'">ONLY the archdesc can be fonds level</sch:assert>
      <!--     parent(recordgrp) child(recordgrp) -->
      <sch:assert role="SHOULD-WP19" test="not(@level='recordgrp')                      or ( parent::*[@level='recordgrp'] or (name(.)='archdesc') or (name(.)='c01') and ancestor::*[@level='recordgrp'])">recordgrp SHOULD be a child of another recordgrp</sch:assert>
      <!-- parent(recordgrp, subgrp) child(subgrp) -->
      <sch:assert role="SHOULD-WP19" test="not(@level='subgrp')                  or (( parent::*[@level='recordgrp' or @level='subgrp'] )  or (name(.)='c01') and ancestor::*[@level='recordgrp'])">subgrp SHOULD be a child of another subgrp or a recordgrp</sch:assert>
      <!-- child(file) parent(subgrp, recordgrp, series, subseries, collection) -->
      <!-- child(item) parent(collection recordgrp file)-->
      <!-- child(otherlevel=sub-collection) parent(collection otherlevel=sub-collection)-->
      <!-- child(series) parent(collection otherlevel=sub-collection  subfonds)-->
      <!-- child(subseries) parent(series    subseries)-->
      <sch:assert role="SHOULD-WP19" test="not(@level='subseries') or parent::*[@level='subseries' or @level='series'] ">subseries SHOULD be a child of another subseries or a series</sch:assert>
      <!-- child(subfonds) parent(fonds    subfonds)-->
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>type attribute</sch:title>
    <sch:p>TYPE – required? (according to the LoC DTD information, this is not required, however they state in their text that it is required.)</sch:p>
    <sch:rule context="ead:dsc">
      <sch:assert role="MUST-EAD" test="@type">dsc MUST have a @type attribute</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <!-- belongs to sch:pattern 'type attribute' but describes the same context, so needs a pattern of its own. -->
    <sch:rule context="//*[@type]">
      <sch:assert role="MUST-EAD" test="not(@type='othertype') or (@othertype and not(@othertype=''))">dsc with @type 'othertype' MUST have an @othertype attribute describing the type</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:title>archdesc's and c-levels</sch:title>
    <sch:rule context="ead:archdesc">
      <sch:assert role="MUST-WP19" test="@level">archdesc MUST have a level-attribute</sch:assert>
      <sch:assert role="COULD" test="ead:did/ead:origination and not(ead:did/ead:origination='')">archdesc COULD have a non-empty origination</sch:assert>
      <sch:assert role="SHOULD-WP17" test="ead:processinfo/ead:p/ead:date">archdesc-processinfo SHOULD have a date</sch:assert>
      <sch:assert role="SHOULD-WP17" test="@level='fonds' or @level='recordgrp' or @level='collection' or @level='otherlevel'">archdesc-level SHOULD be 'fonds', 'recordgrp', 'collection' or 'otherlevel'</sch:assert>
      <sch:assert role="COULD" test="ead:did/ead:langmaterial">archdesc COULD have a langmaterial</sch:assert>
      <sch:assert role="COULD" test="ead:custodhist">archdesc COULD have a custodhist</sch:assert>
      <sch:assert role="COULD" test="ead:otherfindaid">archdesc COULD have an otherfindaid</sch:assert>
      <sch:assert role="COULD" test="ead:originalsloc">archdesc COULD have an originalsloc</sch:assert>
      <sch:assert role="COULD" test="ead:altformavail">archdesc COULD have an altformavail</sch:assert>
      <sch:assert role="COULD" test="ead:bibliography">archdesc COULD have a bibliography</sch:assert>
      <sch:assert role="COULD" test="ead:odd">archdesc COULD have an odd</sch:assert>
      <sch:assert role="COULD" test="ead:note">archdesc COULD have a note</sch:assert>
      <sch:assert role="COULD" test="ead:scopecontent">archdesc COULD have a scopecontent</sch:assert>
      <sch:assert role="COULD" test="ead:controlaccess">archdesc COULD have a controlaccess</sch:assert>
      <sch:assert role="COULD" test="ead:controlaccess/ead:subject">controlaccess COULD have a subject</sch:assert>
      <sch:assert role="COULD" test="ead:controlaccess/ead:place">controlaccess COULD have a place</sch:assert>
      <sch:assert role="COULD" test="ead:controlaccess/ead:persname">controlaccess COULD have a persname</sch:assert>
      <sch:assert role="COULD" test="ead:controlaccess/ead:orgname">controlaccess COULD have an orgname</sch:assert>
    </sch:rule>
    <sch:rule context="ead:archdesc/ead:processinfo/ead:p">
      <sch:assert role="SHOULD-WP17" test="normalize-space(.)">archdesc SHOULD have a non-empty processinfo</sch:assert>
    </sch:rule>
    <sch:rule context="ead:archdesc/ead:processinfo/ead:p/ead:date">
      <sch:assert role="SHOULD-WP17" test="normalize-space(.)">archdesc SHOULD have a non-empty processinfo-date</sch:assert>
    </sch:rule>
    <sch:rule context="ead:language">
      <sch:assert role="MUST-WP19" test="@langcode">language MUST contain a langcode attribute</sch:assert>
      <sch:assert role="SHOULD-WP17" test="@scriptcode">language SHOULD contain a scriptcode attribute</sch:assert>
    </sch:rule>
    <sch:rule context="ead:c01">
      <sch:assert role="MUST-WP19" test="@level">c01 MUST have a level-attribute</sch:assert>
    </sch:rule>
    <sch:rule context="ead:c02">
      <sch:assert role="MUST-WP19" test="@level">c02 MUST have a level-attribute</sch:assert>
    </sch:rule>
    <sch:rule context="ead:c03">
      <sch:assert role="MUST-WP19" test="@level">c03 MUST have a level-attribute</sch:assert>
    </sch:rule>
    <sch:rule context="ead:c04">
      <sch:assert role="MUST-WP19" test="@level">c04 MUST have a level-attribute</sch:assert>
    </sch:rule>
    <sch:rule context="ead:c05">
      <sch:assert role="MUST-WP19" test="@level">c05 MUST have a level-attribute</sch:assert>
    </sch:rule>
    <sch:rule context="ead:c06">
      <sch:assert role="MUST-WP19" test="@level">c06 MUST have a level-attribute</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
