<?xml version="1.0"?> 
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:o="http://ulric-wilfred.name"
	exclude-result-prefixes="o"> 

  <xsl:output method="xml"
              encoding="utf-8"
              standalone="yes"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              indent="yes"/>
                            
	<xsl:template match="/o:occurences">
		<div id="data-pane">
		<script type="text/javascript" src="./occurences-mapping-data.js"></script>
		<script type="text/javascript" src="./url-mapping.js"></script>
		<ul id="occurences">
		<xsl:for-each select="./o:occurence">
			<li><a href="javascript:alert('{@type}')" title="{@type}" id="occurence-{@type}-sitelink"><img alt="{@type}" src="./icons/{@type}.ico" id="occurence-{@type}-icon" class="occurence-icon" /></a>
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
    	</xsl:for-each>
    	</ul>
    	<script type="text/javascript">generateLinks("occurence");</script>
    	</div>
    	<div id="info-pane">
    		<style type="text/css">table.lfmWidgetchart_955db8fbc5e519c92896e23a7f99f920 td {margin:0 !important;padding:0 !important;border:0 !important;}table.lfmWidgetchart_955db8fbc5e519c92896e23a7f99f920 tr.lfmHead a:hover {background:url(http://cdn.last.fm/widgets/images/en/header/chart/recenttracks_regular_blue.png) no-repeat 0 0 !important;}table.lfmWidgetchart_955db8fbc5e519c92896e23a7f99f920 tr.lfmEmbed object {float:left;}table.lfmWidgetchart_955db8fbc5e519c92896e23a7f99f920 tr.lfmFoot td.lfmConfig a:hover {background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat 0px 0 !important;;}table.lfmWidgetchart_955db8fbc5e519c92896e23a7f99f920 tr.lfmFoot td.lfmView a:hover {background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat -85px 0 !important;}table.lfmWidgetchart_955db8fbc5e519c92896e23a7f99f920 tr.lfmFoot td.lfmPopup a:hover {background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat -159px 0 !important;}</style>
			<table class="lfmWidgetchart_955db8fbc5e519c92896e23a7f99f920" cellpadding="0" cellspacing="0" border="0" style="width:184px;">
				<tr class="lfmHead">
					<td>
						<a title="shamansir: Recently Listened Tracks" href="http://www.last.fm/user/shamansir/" target="_blank" style="display:block;overflow:hidden;height:20px;width:184px;background:url(http://cdn.last.fm/widgets/images/en/header/chart/recenttracks_regular_blue.png) no-repeat 0 -20px;text-decoration:none;border:0;"></a>
					</td>
				</tr>
				<tr class="lfmEmbed">
					<td>
						<object type="application/x-shockwave-flash" data="http://cdn.last.fm/widgets/chart/friends_6.swf" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="184" height="199" > 
						<param name="movie" value="http://cdn.last.fm/widgets/chart/friends_6.swf" /> 
						<param name="flashvars" value="type=recenttracks&amp;user=shamansir&amp;theme=blue&amp;lang=en&amp;widget_id=chart_955db8fbc5e519c92896e23a7f99f920" /> 
						<param name="bgcolor" value="6598cd" /> 
						<param name="quality" value="high" /> 
						<param name="allowScriptAccess" value="always" /> 
						<param name="allowNetworking" value="all" /> 
						</object>
					</td>
				</tr>
				<tr class="lfmFoot">
					<td style="background:url(http://cdn.last.fm/widgets/images/footer_bg/blue.png) repeat-x 0 0;text-align:right;">
						<table cellspacing="0" cellpadding="0" border="0" style="width:184px;">
							<tr>
								<td class="lfmConfig">
									<a href="http://www.last.fm/widgets/?colour=blue&amp;chartType=recenttracks&amp;user=shamansir&amp;chartFriends=1&amp;from=code&amp;widget=chart" title="Get your own widget" target="_blank" style="display:block;overflow:hidden;width:85px;height:20px;float:right;background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat 0px -20px;text-decoration:none;border:0;">
									</a>
								</td>
								<td class="lfmView" style="width:74px;">
									<a href="http://www.last.fm/user/shamansir/" title="View shamansir's profile" target="_blank" style="display:block;overflow:hidden;width:74px;height:20px;background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat -85px -20px;text-decoration:none;border:0;">
									</a>
								</td>
								<td class="lfmPopup" style="width:25px;">
									<a href="http://www.last.fm/widgets/popup/?colour=blue&amp;chartType=recenttracks&amp;user=shamansir&amp;chartFriends=1&amp;from=code&amp;widget=chart&amp;resize=1" title="Load this chart in a pop up" target="_blank" style="display:block;overflow:hidden;width:25px;height:20px;background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat -159px -20px;text-decoration:none;border:0;" onclick="window.open(this.href + '&amp;resize=0','lfm_popup','height=299,width=234,resizable=yes,scrollbars=yes'); return false;">
									</a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
    	</div>
	</xsl:template>

</xsl:stylesheet>
