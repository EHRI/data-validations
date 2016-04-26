<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:mscw="moscow"
    
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
        
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--More specific template for Node766 that provides custom behavior -->
    <xsl:template match="//sch:assert[@mscw:advice='SHOULD-WP17' or @mscw:advice='SHOULD-WP19' or @mscw:advice='COULD']">  
    </xsl:template>
    <xsl:template match="//sch:report[@mscw:advice='SHOULD-WP17' or @mscw:advice='SHOULD-WP19' or @mscw:advice='COULD']">  
    </xsl:template>
    
</xsl:stylesheet>

