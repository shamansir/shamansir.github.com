<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:u="http://ulric-wilfred.name">
	<xsl:output method="xml" encoding="utf-8" standalone="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" indent="yes" omit-xml-declaration="yes" />

	<xsl:include href="./vcard-profile.xsl" />
	<xsl:include href="./contacts.xsl" />
	<xsl:include href="./occurences.xsl" />
	<xsl:include href="./favourites.xsl" />
	
	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="no-cache" content=""/>
				<meta http-equiv="Expires" content="-1"/>
				<meta http-equiv="cache-Control" content="no-cache"/>				
				<link rel="stylesheet" type="text/css" href="./style.css" />
				<link rel="shortcut icon" href="./icons/star-black.gif"/>
				<link rel="icon" type="image/gif" href="./icons/star-black.gif"/>				
				<title>Ulric Wilfred: homesite</title>
			</head>
			<body>
				<h1 id="site-title"><span id="owner-name">Ulric Wilfred</span> homesite</h1>
				<ul id="nav-menu">
					<xsl:element name="li"><xsl:if test="./vCard"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="./personal-data.xml" title="Personal Data">Personal Data</a></xsl:element>
					<xsl:element name="li"><xsl:if test="./u:contacts"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="./contacts.xml" title="Contact Info">Contact Info</a></xsl:element>
					<xsl:element name="li"><xsl:if test="./u:occurences"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="./internet-occurence.xml" title="Occurences">Occurences</a></xsl:element>
					<xsl:element name="li"><xsl:if test="./u:favourites"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="./favourites.xml" title="Favourites">Favourites</a></xsl:element>
				</ul>
				<div id="content">
					<xsl:apply-templates/>
					<div id="footer">
						<a href="http://www.w3.org/XML/" title="XML"><img alt="XML-based" title="XML-based" src="./src/xml.png" /></a>
						<a href="http://www.w3.org/TR/xslt/" title="XSLT"><img alt="XSLT-based" title="XSLT-based" src="./src/xslt.jpg" /></a>			
						<a href="http://www.w3.org/TR/xhtml1/" title="XHTML"><img alt="Valid XHTML 1.0 Strict" title="Valid XHTML 1.0 Strict" src="./src/xhtml.jpg" /></a>
						<a href="http://www.w3.org/TR/REC-CSS2/" title="CSS"><img alt="Valid CSS 2.1" title="Valid Valid CSS 2.1" src="./src/css.gif" /></a>
						<span id="copyright">design by shaman.sir © 2008</span>					
					</div>	
				</div>	
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
