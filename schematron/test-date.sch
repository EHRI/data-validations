<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron">
  <sch:ns prefix="ead" uri="urn:isbn:1-931666-22-9"/>
  <sch:title>Test date validation</sch:title>
  <sch:pattern>
    <sch:title>Date validation</sch:title>
    <sch:rule context="ead:unitdate">
      <!-- check date format -->
      <sch:assert test="matches(@normal, '^(\d{4}-?\d{2}-?\d{2}/?){1,2}$')">invalid date format</sch:assert>
      <!-- check existence of start date -->
      <sch:let name="start-date" value="replace(@normal, '/.*', '')"/>
      <sch:let name="start-date" value="replace($start-date, '-', '')"/>
      <sch:let name="start-date" value="string-join((substring($start-date, 1, 4), substring($start-date, 5, 2), substring($start-date, 7, 2)), '-')"/>
      <sch:assert test="$start-date castable as xs:date">non-existent start date</sch:assert>
      <!-- check existence of end date -->
      <sch:let name="end-date" value="replace(@normal, '.*/', '')"/>
      <sch:let name="end-date" value="replace($end-date, '-', '')"/>
      <sch:let name="end-date" value="string-join((substring($end-date, 1, 4), substring($end-date, 5, 2), substring($end-date, 7, 2)), '-')"/>
      <sch:assert test="$end-date castable as xs:date">non-existent end date</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
