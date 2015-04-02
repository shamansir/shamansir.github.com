<?xml version="1.0" encoding="utf-8"?>  
<xsl:stylesheet version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:c="http://ulric-wilfred.name" exclude-result-prefixes="c">
<!--    xmlns="http://www.w3.org/1999/xhtml" -->	 

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
     
    <xsl:template name="contact">
        <li><a href="javascript:alert('{@type}')" title="{@type}" id="contact-{@type}-sitelink">
                <img alt="{@type}" src="{@type}.ico" id="contact-{@type}-icon" class="contact-icon" />
            </a>
            <xsl:if test="c:name">
                <a href="javascript:alert('{@type}:{c:id}');" id="contact-{@type}-link" title="{c:id}" alt="{c:name}" class="contact-link">
                    <xsl:value-of select="c:name"/>
                </a>
            </xsl:if>
            <xsl:if test="not(c:name)">
                <a href="javascript:alert('{@type}:{c:id}');" id="contact-{@type}-link" title="{c:id}" alt="{c:id}" class="contact-link">
                    <xsl:value-of select="c:id"/>
                </a>
            </xsl:if>
            <span class="contact-type">(<xsl:value-of select="@type"/>)</span>          
        </li>
    </xsl:template>
                            
	<xsl:template match="/c:contacts">
		<ul id="contacts">
		<xsl:for-each select="./c:contact">
			<xsl:call-template name="contact" />
    	</xsl:for-each>
		<xsl:for-each select="./c:group">
			<li>
			    <xsl:if test="c:name">
			         <span class="contact-group-name" id="contact-{@shortname}-group"><xsl:value-of select="c:name"/></span>
			    </xsl:if>
				<ul id="{@shortname}">
					<xsl:for-each select="./c:contact">
						<xsl:call-template name="contact" />
					</xsl:for-each>
				</ul>
			</li>
    	</xsl:for-each> 	
    	</ul>
	</xsl:template>

</xsl:stylesheet>
