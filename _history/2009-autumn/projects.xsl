<?xml version="1.0"?> 
<xsl:stylesheet version="1.0"  
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:p="http://ulric-wilfred.name"
    exclude-result-prefixes="p">
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
    
    <xsl:template name="company">
        <xsl:param name="company"/>
        <xsl:choose>
            <xsl:when test="$company/p:website-url">
                <a href="{$company/p:website-url}" title="{$company/p:name}" class="company-link">
                    <span class="project-company">
                        <xsl:value-of select="$company/p:name" />
                    </span>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <span class="project-company">
                    <xsl:value-of select="$company/p:name" />
                </span>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template name="file">
        <a class="project-file-link" href="{@url}" title="{@title}">
            <xsl:value-of select="@title" />
        </a>
        <xsl:if test="@mime-type">
            <span class="project-file-mime">
                (<xsl:value-of select="@mime-type" />)
            </span>
        </xsl:if>
    </xsl:template>
         
    <xsl:template name="project">
        <li>
            <xsl:if test="p:logo">
                <img src="{p:logo}" alt="{p:name}" title="{p:name}" class="project-logo" />
            </xsl:if>
            <xsl:choose>
	            <xsl:when test="p:url">
	                <h5 class="project-{@status}"><a href="{p:url}" title="{p:name}" >
	                    <xsl:value-of select="p:name"/>
	                </a></h5>                
	            </xsl:when>
	            <xsl:otherwise>
	                <h5 class="project-{@status}">
	                   <xsl:value-of select="p:name"/>
	                </h5>
	            </xsl:otherwise>
            </xsl:choose>                                       
            <span class="project-comment">
                (<span class="project-type"><xsl:value-of select="@type"/></span>
                    <xsl:if test="@license">;
                    <span class="project-license">
                        <xsl:value-of select="@license"/>
                     </span>
                </xsl:if><xsl:if test="@cooperative='true'">;
                     <span class="project-cooperative">Cooperative</span>
                </xsl:if>)
            </span>
            <p class="project-brief">
                <xsl:value-of select="p:brief" />
            </p>
            <dl class="project-description">
                <xsl:if test="p:alternative-name">
                    <dt>Alternative Name:</dt>
                    <dd><xsl:value-of select="p:alternative-name" /></dd>                
                </xsl:if>
                <dt>Status:</dt>
                <dd><xsl:value-of select="@status" /></dd>
                <xsl:if test="@year-finished">
                    <dt>Finished at:</dt>
                    <dd><xsl:value-of select="@year-finished" /></dd>                
                </xsl:if>                
                <xsl:if test="@lang">
                    <dt>Language:</dt>
                    <dd><xsl:value-of select="@lang" /></dd>                
                </xsl:if>
                <xsl:if test="p:company-ordered">
                    <dt>Ordered by:</dt>
                    <dd>
                        <xsl:call-template name="company">
                            <xsl:with-param name="company" select="p:company-ordered" />
                        </xsl:call-template>
                    </dd>
                </xsl:if>
                <xsl:if test="p:company-developed">
                    <dt>Developed by:</dt>
                    <dd><xsl:for-each select="./p:company-developed">
	                    <xsl:call-template name="company">
	                        <xsl:with-param name="company" select="." />
	                    </xsl:call-template>
                    </xsl:for-each></dd>
                </xsl:if>                
                <xsl:if test="p:source-url">
                    <dt>Source:</dt>
                    <dd><a href="{p:source-url}" title="Source" class="project-source-url">
                        Open</a></dd>                
                </xsl:if> 
                <xsl:if test="p:used-technologies">
                    <dt>Used Technologies:</dt>
                    <dd><xsl:value-of select="p:used-technologies" /></dd>                
                </xsl:if>
                <xsl:if test="@duration">
                    <dt>Duration:</dt>
                    <dd><xsl:value-of select="@duration" /></dd>                
                </xsl:if>
                <xsl:if test="p:related-files">
                    <dt>Related Files:</dt>
                    <xsl:for-each select="./p:related-files/p:file">
                        <dd><xsl:call-template name="file" /></dd>
                    </xsl:for-each>
                </xsl:if>                                            
            </dl>
        </li>
  </xsl:template>
  
    <xsl:template match="/p:projects">
        <ul id="projects">
        <xsl:for-each select="./p:project">
            <xsl:call-template name="project" />
        </xsl:for-each>
        <xsl:for-each select="./p:group">
            <li>
                <xsl:if test="p:name">
                    <span class="project-group-name" id="project-{@shortname}-group"><xsl:value-of select="p:name"/></span>
                </xsl:if>
                <ul id="{@shortname}">
                    <xsl:for-each select="./p:project">
                        <xsl:call-template name="project" />
                    </xsl:for-each>
                </ul>
            </li>
        </xsl:for-each>         
        </ul>
    </xsl:template>  

</xsl:stylesheet>