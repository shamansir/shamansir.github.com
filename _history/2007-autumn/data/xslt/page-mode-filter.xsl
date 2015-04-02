<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xslt="http://www.w3.org/1999/XSL/Transform"
    xmlns:f="http://www.shaman-sir.by.ru/XSD/Filtering">

  <xsl:output method="xml"
              encoding="utf-8"
              standalone="yes"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              indent="yes"/>  
  
<xsl:namespace-alias stylesheet-prefix="xslt" result-prefix="xsl"/>

<xsl:variable name="mode">
  <xsl:text>xml-based</xsl:text>
  <!-- <xsl:text>,</xsl:text>
       <xsl:text>no-css</xsl:text> -->
  <!-- <xsl:text>,</xsl:text>
       <xsl:text>for-ppc</xsl:text> -->
  <!-- <xsl:text>,</xsl:text>
       <xsl:text>printable</xsl:text> -->
  <!-- <xsl:text>,</xsl:text>
       <xsl:text>big-fonts</xsl:text> -->
  <!-- <xsl:text>,</xsl:text>
       <xsl:text>no-xml</xsl:text> -->
  <!-- <xsl:text>,</xsl:text>
       <xsl:text>opera-version</xsl:text> -->
</xsl:variable>

<xsl:template name="styles-filtering">
    
</xsl:template>

<xsl:template match="f:styles-filtering">
  <link rel="stylesheet" type="text/css" href="../css/test.css" />
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet> 
