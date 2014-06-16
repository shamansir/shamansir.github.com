<?xml version="1.0"?> 
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:f="http://ulric-wilfred.name"
	exclude-result-prefixes="f"> 

  <xsl:output method="xml"
              encoding="utf-8"
              standalone="yes"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              indent="yes"/>
                            
	<xsl:template match="/f:favourites">
		<div id="data-pane" class="wide">
		<xsl:if test="./f:music">
			<span class="favourites-label">Music:</span>
			<ul id="music" class="favourites">
				<xsl:for-each select="f:music/f:music-artist">
					<li>
						<xsl:choose>
							<xsl:when test="@lastfm-id"><a href="http://www.last.fm/music/{@lastfm-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:when test="@wikipedia-id"><a href="http://en.wikipedia.org/wiki/{@wikipedia-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:otherwise><a href="http://www.last.fm/music/{.}" title="{.}"><xsl:value-of select="." /></a></xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
		<xsl:if test="./f:movies">
			<span class="favourites-label">Movies:</span>
			<ul id="movies" class="favourites">
				<xsl:for-each select="f:movies/f:movie">
					<li>
						<xsl:choose>
							<xsl:when test="@imdb-id"><a href="http://www.imdb.com/title/tt{@imdb-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:when test="@wikipedia-id"><a href="http://en.wikipedia.org/wiki/{@wikipedia-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:otherwise><a href="http://en.wikipedia.org/wiki/{.}" title="{.}"><xsl:value-of select="." /></a></xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
		<xsl:if test="./f:games">
			<span class="favourites-label">Games:</span>
			<ul id="games" class="favourites">
				<xsl:for-each select="f:games/f:game">
					<li>
						<xsl:choose>
							<xsl:when test="@mobygames-id"><a href="http://www.mobygames.com/game/{@mobygames-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:when test="@gamespot-id"><a href="http://www.gamespot.com/{@gamespot-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>							
							<xsl:when test="@ag-id"><a href="http://www.ag.ru/games/{@ag-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:when test="@wikipedia-id"><a href="http://en.wikipedia.org/wiki/{@wikipedia-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:otherwise><a href="http://en.wikipedia.org/wiki/{.}" title="{.}"><xsl:value-of select="." /></a></xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
		<xsl:if test="./f:series-list">
			<span class="favourites-label">Series:</span>
			<ul id="series" class="favourites">
				<xsl:for-each select="f:series-list/f:series">
					<li>
						<xsl:choose>
							<xsl:when test="@imdb-id"><a href="http://www.imdb.com/title/tt{@imdb-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:when test="@wikipedia-id"><a href="http://en.wikipedia.org/wiki/{@wikipedia-id}" title="{.}"><xsl:value-of select="." /></a></xsl:when>
							<xsl:otherwise><a href="http://en.wikipedia.org/wiki/{.}" title="{.}"><xsl:value-of select="." /></a></xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
		<xsl:if test="./f:books">
			<span class="favourites-label">Books:</span>
			<ul id="books" class="favourites">
				<xsl:for-each select="f:books/f:book">
					<li>
						<xsl:choose>
							<xsl:when test="@wikipedia-id"><a href="http://en.wikipedia.org/wiki/{@wikipedia-id}" title="{./f:name}"><xsl:value-of select="./f:name" /></a></xsl:when>
							<xsl:otherwise>
								<xsl:if test="not(@no-link)">
									<a href="http://en.wikipedia.org/wiki/{./f:name}" title="{./f:name}"><xsl:value-of select="./f:name" /></a>
								</xsl:if>
								<xsl:if test="@no-link">
									<xsl:value-of select="./f:name" />
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>						
						<xsl:if test="./f:author">
							<span class="book-author-comment">
								(by<xsl:for-each select="./f:author"><span class="book-author"><xsl:element name="a">
									<xsl:attribute name="href">
										<xsl:choose>
											<xsl:when test="./@wikipedia-id">http://en.wikipedia.org/wiki/<xsl:value-of select="./@wikipedia-id" /></xsl:when>
											<xsl:otherwise>http://en.wikipedia.org/wiki/<xsl:value-of select="." /></xsl:otherwise>
										</xsl:choose>														 
									</xsl:attribute>
									<xsl:value-of select="." />
								</xsl:element></span></xsl:for-each>)
							</span>
						</xsl:if>							
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>				
    	</div>
    	<div id="info-pane"></div>
	</xsl:template>

</xsl:stylesheet>