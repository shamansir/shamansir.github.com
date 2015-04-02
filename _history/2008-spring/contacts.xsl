<?xml version="1.0"?> 
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:c="http://ulric-wilfred.name" exclude-result-prefixes="c"> 

  <xsl:output method="xml"
              encoding="utf-8"
              standalone="yes"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              indent="yes"/>
                            
	<xsl:template match="/c:contacts">
		<div id="data-pane">
		<script type="text/javascript" src="./contacts-mapping-data.js"></script>
		<script type="text/javascript" src="./url-mapping.js"></script>
		<ul id="contacts">
		<xsl:for-each select="./c:contact">	
			<li><a href="javascript:alert('{@type}')" title="{@type}" id="contact-{@type}-sitelink"><img alt="{@type}" src="./icons/{@type}.ico" id="contact-{@type}-icon" class="contact-icon" /></a>
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
    	</xsl:for-each>
    	</ul>
    	<script type="text/javascript">generateLinks("contact");</script>
    	</div>
    	<div id="info-pane">
    		<iframe src="http://www.google.com/talk/service/badge/Show?tk=z01q6amlqlp3b08lv5rcbbqvgplpv0gseqmi9jt5loal008g79h6mvrtgsp92i4h6sc7sqkn5h7rdtb7q0h7j8q6ufjjv5nj83ndgpts76m7n0tg8ukp27mgd588f8ra55k89bks22mrhagq6dlk7j3kidba1r339u4dh2fsl&amp;w=200&amp;h=60" allowtransparency="true" frameborder="0" height="60" width="200"></iframe>
    	</div>
	</xsl:template>

</xsl:stylesheet>
