<?xml version="1.0"?> 
<xsl:stylesheet version="1.0"  
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:o="http://ulric-wilfred.name"
	exclude-result-prefixes="o">
<!-- xmlns="http://www.w3.org/1999/xhtml" -->	 

  <xsl:output method="xml"
              encoding="utf-8"
              standalone="yes"
              indent="yes"
              omit-xml-declaration="yes"
              media-type="text/xhtml"/>
        <!-- 
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"        
         --> 
         
    <xsl:template name="occurence">
        <li>
            <a href="javascript:alert('{@type}')" title="{@type}" id="occurence-{@type}-sitelink">
                <img alt="{@type}" src="{@type}.ico" id="occurence-{@type}-icon" class="occurence-icon" />
            </a>
            <xsl:if test="o:name">
                <a href="javascript:alert('{@type}:{o:id}');" id="occurence-{@type}-link" title="{o:id}" alt="{o:name}" class="occurence-link">
                    <xsl:value-of select="o:name"/>
                </a>
            </xsl:if>
            <xsl:if test="not(o:name)">
                <a href="javascript:alert('{@type}:{o:id}');" id="occurence-{@type}-link" title="{o:id}" alt="{o:id}" class="occurence-link">
                    <xsl:value-of select="o:id"/>
                </a>
            </xsl:if>
            <span class="occurence-type">(<xsl:value-of select="@type"/>)</span>        
        </li>    
    </xsl:template>
                            
	<xsl:template match="/o:occurences">
		<ul id="occurences">
		<xsl:for-each select="./o:occurence">
			<xsl:call-template name="occurence" />
    	</xsl:for-each>
        <xsl:for-each select="./o:group">
            <li>
                <xsl:if test="o:name">
                    <span class="occurence-group-name" id="occurence-{@shortname}-group"><xsl:value-of select="o:name"/></span>
                </xsl:if>
                <ul id="{@shortname}">
                    <xsl:for-each select="./o:occurence">
                        <xsl:call-template name="occurence" />
                    </xsl:for-each>
                </ul>
            </li>
        </xsl:for-each>     	
    	</ul>
	</xsl:template>

</xsl:stylesheet>
