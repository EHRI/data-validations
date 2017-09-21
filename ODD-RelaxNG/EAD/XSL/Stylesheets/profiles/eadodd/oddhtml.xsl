<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html"
    version="2.0">
    <!-- import base conversion style -->

    <xsl:import href="../../odds/odd2html.xsl"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>

         <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

This software is provided by the copyright holders and contributors
"as is" and any express or implied warranties, including, but not
limited to, the implied warranties of merchantability and fitness for
a particular purpose are disclaimed. In no event shall the copyright
holder or contributors be liable for any direct, indirect, incidental,
special, exemplary, or consequential damages (including, but not
limited to, procurement of substitute goods or services; loss of use,
data, or profits; or business interruption) however caused and on any
theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use
of this software, even if advised of the possibility of such damage.
</p>
         <p>Author: See AUTHORS</p>
         
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>

   <xsl:output method="xhtml" omit-xml-declaration="yes"/>
   <xsl:param name="cssFile">http://www.tei-c.org/release/xml/tei/stylesheet/tei.css</xsl:param>
   <xsl:param name="institution">European Holocaust Research Infrastructure</xsl:param>
   <xsl:param name="displayMode">rng</xsl:param>
   <xsl:param name="idPrefix">EAD.</xsl:param>
   <xsl:param name="feedbackURL"/>
   <xsl:param name="searchURL"/>
   
   <xsl:template name="attDefHook">
      <xsl:param name="attName"/>
      <xsl:variable name="linkId" select="concat('ead_att.', translate($attName, ':', '-'))"/>
      <xsl:choose>
         <xsl:when test="string-length($attName) gt 0">
            <span class="bookmarklink">
               <a class="bookmarklink" id="{$linkId}" href="#{$linkId}">
                  <xsl:attribute name="title">
                     <xsl:text>link to this attribute </xsl:text>
                  </xsl:attribute>
                  <!--<span class="invisible">
                     <xsl:text> </xsl:text>
                     <xsl:value-of select="$attName"/>
                  </span>-->
                  <span class="pilcrow">
                     <xsl:text>¶</xsl:text>
                  </span>
               </a>
            </span>
         </xsl:when>
         <xsl:otherwise>
            <xsl:comment>No linking pilcrow inserted: attname not provided.</xsl:comment>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
</xsl:stylesheet>
