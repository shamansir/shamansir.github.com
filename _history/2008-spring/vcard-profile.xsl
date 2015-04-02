<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" encoding="utf-8" standalone="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" indent="yes"/>
	<xsl:template match="/vCard">
		<div id="data-pane" class="vcard">
			<xsl:if test="./FN">
				<xsl:if test="./URL">
					<h3>
						<a class="url fn" href="{URL}">
							<xsl:value-of select="./FN"/>
						</a>
					</h3>
				</xsl:if>
				<xsl:if test="not(URL)">
					<h3 class="fn">
						<xsl:value-of select="./FN"/>
					</h3>
				</xsl:if>
			</xsl:if>
			<dl>
			<xsl:if test="./N">				
				<xsl:if test="./N/FAMILY">
					<dt class="name-label">family name:</dt>
					<dd class="family-name">
						<xsl:value-of select="./N/FAMILY"/>
					</dd>
				</xsl:if>
				<xsl:if test="./N/GIVEN">
					<dt class="name-label">given name:</dt>
					<dd class="given-name">
						<xsl:value-of select="./N/GIVEN"/>
					</dd>
				</xsl:if>
				<xsl:if test="./N/MIDDLE">
					<dt class="name-label">middle name:</dt>
					<dd class="additional-name">
						<xsl:value-of select="./N/MIDDLE"/>
					</dd>
				</xsl:if>				
			</xsl:if>			
			<xsl:if test="./NICKNAME">
				<dt class="nickname-label">nickname:</dt>
				<dd class="nickname">
					<xsl:value-of select="NICKNAME"/>
				</dd>
			</xsl:if>
			<xsl:if test="./BDAY">
				<dt class="bday-label">birthday:</dt>
				<dd class="bday">
					<xsl:value-of select="./BDAY"/>
				</dd>
			</xsl:if>			
			</dl>
			<dl>
			<xsl:for-each select="./URL">
				<dt class="url-label">url:</dt>
				<dd><a href="{.}" class="url" title="{.}"><xsl:if test="./HOME">(<span class="type">home</span>) </xsl:if><xsl:if test="./WORK">(<span class="type">work</span>) </xsl:if><xsl:value-of select="."/></a></dd>
			</xsl:for-each>
			<xsl:for-each select="./EMAIL">
				<dt class="mail-label">e-mail:</dt>
				<dd><a href="mailto:{./USERID}" class="email" title="{./USERID}"><xsl:if test="./HOME">(<span class="type">home</span>) </xsl:if><xsl:if test="./WORK">(<span class="type">work</span>) </xsl:if><span class="value"><xsl:value-of select="./USERID"/></span></a></dd>
			</xsl:for-each>
			<xsl:for-each select="./TEL">
				<dt class="tel-label">phone:</dt>
				<dd class="tel"><xsl:if test="./HOME">(<span class="type">home</span>) </xsl:if><xsl:if test="WORK">(<span class="type">work</span>) </xsl:if><span class="value"><xsl:value-of select="./NUMBER"/></span></dd>
			</xsl:for-each>			
			<xsl:if test="./JABBERID">
				<dt class="jabber-label">jabber:</dt>
				<dd><a href="xmpp:{./JABBERID}" class="url" title="{./JABBERID}">
					<xsl:value-of select="./JABBERID"/>
				</a></dd>
			</xsl:if>						
			</dl>
			<dl>	
			<xsl:if test="./ORG">
				<dt class="org-label">organization:</dt>
				<dd class="org organization-name"><xsl:value-of select="./ORG/ORGNAME" /></dd>
				<xsl:if test="./ORG/ORGUNIT">
					<dt class="org-label">organization unit:</dt>
					<dd class="organization-unit"><xsl:value-of select="./ORG/ORGUNIT" /></dd>
				</xsl:if>
			</xsl:if>
			<xsl:if test="./TITLE">
				<dt class="org-label">title:</dt>
				<dd class="title">
					<xsl:value-of select="./TITLE"/>
				</dd>
			</xsl:if>
			<xsl:if test="./ROLE">
				<dt class="org-label">role:</dt>
				<dd class="role">
					<xsl:value-of select="./ROLE"/>
				</dd>
			</xsl:if>
			</dl>
			<dl>
			<xsl:for-each select="./ADR">
				<dt class="address-label">location:</dt>
				<dd class="adr">
					<xsl:if test="./HOME">(<span class="type">home</span>) </xsl:if>
					<xsl:if test="./WORK">(<span class="type">work</span>) </xsl:if>
					<xsl:if test="./STREET"><span class="street-address"><xsl:value-of select="./STREET" /></span>, </xsl:if>
					<xsl:if test="./LOCALITY"><span class="locality"><xsl:value-of select="./LOCALITY" /></span>, </xsl:if>
					<xsl:if test="./REGION"><span class="region"><xsl:value-of select="./REGION" /></span>, </xsl:if>
					<xsl:if test="./PCODE"><span class="postal-code"><xsl:value-of select="./PCODE" /></span>, </xsl:if>
					<xsl:if test="./CTRY"><span class="country-name"><xsl:value-of select="./CTRY" /></span></xsl:if>
				</dd>
			</xsl:for-each>
			</dl>						
		</div>
		<div id="info-pane">
			<img alt="avatar" title="tungusso avatar" src="./avatar.jpg" />
			<a href="http://microformats.org/wiki/hcard" title="hCard microformat"><img alt="hCard inside" title="vCard datamatrix" src="./src/hcard.png" /></a>			
			<a href="http://datamatrix.kaywa.com/" title="Datamatrix"><img alt="vCard datamatrix" title="vCard datamatrix" src="./vCard-datamatrix.png" /></a>
			<a href="./ulric-wilfred.vcf" title="vCard file"><img alt="get vCard" title="get vCard" src="./src/vcard.png" /></a>
			<a href="./personal-data.xml" title="xml-vCard file"><img alt="get XML-vCard" title="get XML-vCard" src="./src/vcard-xml.png" /></a>
			<a href="./personal-data-rdf.xml" title="rdf/xml-vCard file"><img alt="get RDF/XML-vCard" title="get RDF/XML-vCard" src="./src/vcard-rdf.png" /></a>
		</div>
	</xsl:template>

</xsl:stylesheet>
