<?xml version="1.0" encoding="utf-8"?>
<!-- <!DOCTYPE xsl:stylesheet [
	<!ENTITY quot   "&#x0022;">	  
	<!ENTITY amp    "&#x0026;">
	<!ENTITY apos   "&#x0027;">  
	<!ENTITY lt     "&#x003C;">
	<!ENTITY gt     "&#x003E;">  
	<!ENTITY nbsp   "&#x00A0;">  
]> -->

<!-- TODO:

head and body elements are generated now with unneeded namespaces, get rid of it
all translations must to be stored in one simple xml file - finish language-changing support
opera not supports document(), make an alternative version for
create an index page (in simple xhtml) (and selection box) to allow to select from versions:
  no-xml (html)
  default (xml-based)
  opera xml-based [different xslt/xml or function-available()]
  big fonts [css change]
  no-styles [css change]
  for ppc [css change]
  printable [css change]
  results may be created using another xslt
make hovering buttons to store backrounds as one image
page content must to support rss inclusion
create content
upgrade styles
-->

<xsl:stylesheet version="1.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                xmlns:g="http://www.shaman-sir.by.ru/XSD/Generic"
                xmlns:p="http://www.shaman-sir.by.ru/XSD/Pages"
                xmlns:m="http://www.shaman-sir.by.ru/XSD/Menus"
                xmlns:l="http://www.shaman-sir.by.ru/XSD/Localization">
<xsl:output method="xml"
            encoding="utf-8"
            standalone="yes"
	          doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
	          doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
            indent="yes"/>

  <!--
  <xsl:namespace-alias stylesheet-prefix="xsi" result-prefix="#default"/>
  -->

<!-- page attributes template -->
  <xsl:template match="/p:page[@*]" name="page-attributes">
    <!-- /page/@mode -->
    <xsl:if test="(/p:page[not(@mode)]) | 
                  (/p:page[@mode=xml-based]) | 
                  (/p:page[@mode=no-xml]) |
                  (/p:page[@mode=big-fonts])">
      <link rel="stylesheet" type="text/css" href="../css/structure.css" />
      <link rel="stylesheet" type="text/css" href="../css/basics.css" />
      <link rel="stylesheet" type="text/css" href="../css/elements.css" />
      <link rel="stylesheet" type="text/css" href="../css/backgrounds.css" />
      <link rel="stylesheet" type="text/css" href="../css/content.css" />
      <link rel="stylesheet" type="text/css" href="../css/xsl.css" />
    </xsl:if>
    <xsl:choose>
      <xsl:when test="/p:page[@mode=big-fonts]">
        <link rel="stylesheet" type="text/css" href="../css/big-fonts.css" />
      </xsl:when>
      <xsl:when test="/p:page[@mode=printable]">
        <link rel="stylesheet" type="text/css" href="../css/printable.css" />
      </xsl:when>
    </xsl:choose>
    <!-- /page/@mode -->
  </xsl:template>

  <!-- navigation menu template -->
  <xsl:template match="/p:page/m:nav-menu" name="nav-menu">
    <xsl:param name="src"/>

    <ul id="nav-bar">
      <!-- menu tag is not recommneded by W3C -->

      <xsl:for-each select="$src/m:nav-menu/m:page-location">
        <li>
          <a href="{g:href}" title="{g:name}">
            <xsl:value-of select="g:name"/>
          </a>
        </li>
      </xsl:for-each>      

    </ul> <!-- #nav-bar -->

  </xsl:template>

  <!-- tabs bar template -->
  <xsl:template match="/p:page/m:tab-menu" name="tab-bar">
    <xsl:param name="src"/>
    <xsl:param name="activate"/>
    <ul id="tab-bar">
      <!-- menu tag is not recommneded by W3C -->
      <xsl:for-each select="$src/m:tab-menu/m:page-location">
        <li>
          <xsl:element name="a">
            <!-- <a href="{g:href}" title="{g:name}"> -->
            <xsl:attribute name="href">
              <xsl:value-of select="g:href"/>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="g:name"/>
            </xsl:attribute>
            <xsl:if test="(@active='true') or ($activate=@location-id)">
              <xsl:attribute name="id">
                <xsl:text>active</xsl:text>
              </xsl:attribute>  
            </xsl:if>
            <xsl:value-of select="g:name"/>
            <!-- </a> -->
          </xsl:element>
        </li>
      </xsl:for-each>
    </ul> <!-- #tab-bar -->
  </xsl:template>

  <!-- sub-navigation menu template -->
  <xsl:template match="/p:page/m:position-list" name="sub-nav-menu">
    <ul id="sub-nav-menu">
      <!-- menu tag is not recommneded by W3C -->
      <xsl:for-each select="./m:position-list/m:position">
        <li>
          <a href="{m:anchor}" title="{m:name}">
            <xsl:value-of select="m:name"/>
          </a>
        </li>
      </xsl:for-each>
    </ul> <!-- #sub-nav-menu -->
  </xsl:template>

  <!-- content blocks template -->
  <xsl:template match="/p:page/p:content" name="content-blocks">
    <xsl:param name="lang" />
    <xsl:for-each select="./p:content/p:block">
      <h3>
        <xsl:value-of select="@title"/>
      </h3>
      <xsl:for-each select="./p:items">
        <xsl:choose>
          <xsl:when test="@type='article'">
            <xsl:call-template name="article">
              <xsl:with-param name="lang" select="$lang" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@type='file'">
            <xsl:call-template name="file">
              <xsl:with-param name="lang" select="$lang" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@type='news-entry'">
            <xsl:call-template name="news-entry">
              <xsl:with-param name="lang" select="$lang" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@type='page-code'">
            <xsl:call-template name="page-code"/>
          </xsl:when>
          <xsl:when test="@type='text-block'">
            <xsl:call-template name="text-block">
              <xsl:with-param name="lang" select="$lang" />
            </xsl:call-template>
          </xsl:when>          
          <xsl:otherwise>
            <span class="error-msg">Parsing error occured, items type is unrecognizable</span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <!-- article content template -->
  <xsl:template name="article" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="lang" />
    <xsl:for-each select="./p:articles/p:article">
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="generate-id()"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:text>article</xsl:text>
        </xsl:attribute>
        <h4>
          <xsl:value-of select="./p:title"/>
        </h4>
        <span class="alternative">
          <xsl:choose>
            <xsl:when test="$lang='en'">
              <xsl:text>by: </xsl:text>
            </xsl:when>
            <xsl:when test="$lang='ru'">
              <xsl:text>автор: </xsl:text>
            </xsl:when>
          </xsl:choose>
        </span>          
        <dfn>
          <span class="author-name">
            <xsl:value-of select="./p:author/g:name"/>
          </span>
          <xsl:text> </xsl:text>          
          <span class="author-nickname">
            <xsl:value-of select="./p:author/g:nickname"/>
          </span>
          <xsl:text> </xsl:text>
          <span class="author-last-name">
            <xsl:value-of select="./p:author/g:last-name"/>
          </span>
          <xsl:text> </xsl:text>
          <xsl:if test="./p:date">
            <span class="alternative">@ </span>
            <span class="date">
              <xsl:value-of select="./p:date"/>
            </span>
          </xsl:if>
        </dfn>
        <xsl:copy-of select="./p:content/node()"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <!-- file content template -->
  <xsl:template name="file" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="lang" />
    <xsl:for-each select="./p:files/p:file">
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="generate-id()"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:text>file</xsl:text>
        </xsl:attribute>
        <h4>
          <a href="{./p:href}" title="{./p:name}" class="file-title-link">
            <xsl:value-of select="./p:name"/>
          </a>
        </h4>
        <a href="{./p:fileURI}" title="{./p:name}">
          <span class="alternative">
            <xsl:choose>
              <xsl:when test="$lang='en'">
                <xsl:text>image: </xsl:text>
              </xsl:when>
              <xsl:when test="$lang='ru'">
                <xsl:text>изображение: </xsl:text>
              </xsl:when>
            </xsl:choose>
          </span>
          <img alt="{./p:name}" title="{./p:name} screenshot" class="file-screenshot" src="{p:screenshotURI}"/>
        </a>
        <dl>
          <dt>
            <xsl:value-of select="./p:name"/>
            <xsl:choose>
              <xsl:when test="$lang='en'">
                <xsl:text> description</xsl:text>
              </xsl:when>
              <xsl:when test="$lang='ru'">
                <xsl:text> (описание)</xsl:text>
              </xsl:when>
            </xsl:choose>
          </dt>
          <dd>
            <xsl:element name="a">
              <xsl:attribute name="class">
                <xsl:text>file-link</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="href">
                <xsl:value-of select="./p:fileURI"/>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="$lang='en'">
                  <xsl:text>Link to </xsl:text>
                </xsl:when>
                <xsl:when test="$lang='ru'">
                  <xsl:text>Ссылка для </xsl:text>
                </xsl:when>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="@type='application'">
                  <xsl:choose>
                    <xsl:when test="$lang='en'">
                      <xsl:text> Download</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang='ru'">
                      <xsl:text> скачивания</xsl:text>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@type='image'">
                  <xsl:choose>
                    <xsl:when test="$lang='en'">
                      <xsl:text> Examine</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang='ru'">
                      <xsl:text> изучения</xsl:text>
                    </xsl:when>
                  </xsl:choose>                  
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$lang='en'">
                      <xsl:text> Take</xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang='ru'">
                      <xsl:text> изъятия</xsl:text>
                    </xsl:when>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>            
            <xsl:copy-of select="./p:description/node()"/>
          </dd>
        </dl>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <!-- news entry content template -->
  <xsl:template name="news-entry" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="lang" />
    <xsl:for-each select="./p:news/p:entry">
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="generate-id()"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:text>news-entry</xsl:text>
        </xsl:attribute>
        <h4>
          <xsl:value-of select="./p:title"/>
        </h4>
        <xsl:copy-of select="./p:content/node()"/>
        <xsl:if test="./p:author">
          <span class="alternative">
            <xsl:choose>
              <xsl:when test="$lang='en'">
                <xsl:text>by: </xsl:text>
              </xsl:when>
              <xsl:when test="$lang='ru'">
                <xsl:text>автор: </xsl:text>
              </xsl:when>
            </xsl:choose>
          </span>
        </xsl:if>
        <dfn>
          <xsl:if test="./p:author">
            <span class="author-name">
              <xsl:value-of select="./p:author/g:name"/>
            </span>
            <xsl:text> </xsl:text>
            <span class="author-nickname">
              <xsl:value-of select="./p:author/g:nickname"/>
            </span>
            <xsl:text> </xsl:text>
            <span class="author-last-name">
              <xsl:value-of select="./p:author/g:last-name"/>
            </span>
            <span class="alternative">,</span>
            <xsl:text> </xsl:text>
          </xsl:if>
          <span class="alternative">
            <xsl:choose>
              <xsl:when test="$lang='en'">
                <xsl:text>posted @ </xsl:text>
              </xsl:when>
              <xsl:when test="$lang='ru'">
                <xsl:text>опубликовано </xsl:text>
              </xsl:when>
            </xsl:choose>
          </span>
          <span class="date">
            <xsl:value-of select="./p:post-date"/>
          </span>
        </dfn>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>  

  <!-- page code content template -->  
  <xsl:template name="page-code" match="/p:page/p:content/p:block/p:items">
    <xsl:for-each select="./p:page-code/p:code-block">
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="generate-id()"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:text>page-code</xsl:text>
        </xsl:attribute>
        <xsl:if test="./p:title">
          <h4>
            <xsl:value-of select="./p:title"/>
          </h4>
        </xsl:if>
      <xsl:copy-of select="./p:content/node()"/>
      </xsl:element>
      <xsl:if test="following-sibling::*">
        <hr />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- text block content template -->
  <xsl:template name="text-block" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="lang" />    
    <xsl:for-each select="./p:text-blocks/p:text-block">
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="generate-id()"/>
          </xsl:if>
        </xsl:attribute>
        <xsl:attribute name="class">
          <xsl:text>text-block</xsl:text>
        </xsl:attribute>
        <xsl:if test="./p:title">
          <h4>
            <xsl:value-of select="./p:title"/>
          </h4>
        </xsl:if>
        <xsl:element name="div">
          <xsl:attribute name="class">
            <xsl:if test="@type='prose'">
              <xsl:text>prose</xsl:text>
            </xsl:if>
            <xsl:if test="@type='poetry'">
              <xsl:text>poem</xsl:text>
            </xsl:if>
          </xsl:attribute>
          <xsl:if test="(./p:author) | 
                        (./p:finish-date) | 
                        (./p:finish-expanded-date) |
                        (./p:place)">
            <span class="alternative">
              <xsl:choose>
                <xsl:when test="$lang='en'">
                  <xsl:text>written </xsl:text>
                </xsl:when>
                <xsl:when test="$lang='ru'">
                  <xsl:text>за авторством </xsl:text>
                </xsl:when>
              </xsl:choose>
            </span>
          </xsl:if>
          <span class="alternative">
            <xsl:choose>
              <xsl:when test="$lang='en'">
                <xsl:text>by </xsl:text>
              </xsl:when>
              <xsl:when test="$lang='ru'">
                <xsl:text>от </xsl:text>
              </xsl:when>
            </xsl:choose>
          </span>
          <xsl:if test="not(./p:author)">
            <span class="author-name">
              <xsl:choose>
                <xsl:when test="$lang='en'">
                  <xsl:text>(unknown author) </xsl:text>
                </xsl:when>
                <xsl:when test="$lang='ru'">
                  <xsl:text>(неизвестный автор) </xsl:text>
                </xsl:when>
              </xsl:choose>
            </span>
          </xsl:if>          
          <dfn>
            <xsl:if test="./p:author">
              <span class="author-name">
                <xsl:value-of select="./p:author/g:name"/>
              </span>
              <xsl:text> </xsl:text>
              <span class="author-nickname">
                <xsl:value-of select="./p:author/g:nickname"/>
              </span>
              <xsl:text> </xsl:text>
              <span class="author-last-name">
                <xsl:value-of select="./p:author/g:last-name"/>
              </span>
              <span class="alternative">,</span>
              <xsl:text> (cc) </xsl:text>
            </xsl:if>
            <xsl:if test="(./p:start-date) |
                          (./p:start-expanded-date) |
                          (./p:finish-date) |
                          (./p:finish-expanded-date)">
              <span class="alternative">
                <xsl:choose>
                  <xsl:when test="$lang='en'">
                    <xsl:text>in </xsl:text>
                  </xsl:when>
                  <xsl:when test="$lang='ru'">
                    <xsl:text>датировано </xsl:text>
                  </xsl:when>
                </xsl:choose>
              </span>
              <span class="date">
                <xsl:if test="./p:start-date">
                  <xsl:value-of select="./p:start-date"/>
                  <xsl:text> - </xsl:text>
                </xsl:if>
                <xsl:if test="./p:start-expanded-date">
                  <span class="alternative">
                    <xsl:choose>
                      <xsl:when test="$lang='en'">
                        <xsl:text> period from </xsl:text>
                      </xsl:when>
                      <xsl:when test="$lang='ru'">
                        <xsl:text> периодом с </xsl:text>
                      </xsl:when>
                    </xsl:choose>
                  </span>
                  <xsl:apply-templates select="p:start-expanded-date"/>
                  <xsl:choose>
                    <xsl:when test="$lang='en'">
                      <xsl:text> to </xsl:text>
                    </xsl:when>
                    <xsl:when test="$lang='ru'">
                      <xsl:text> по </xsl:text>
                    </xsl:when>
                  </xsl:choose>
                </xsl:if>
                <xsl:if test="./p:finish-date">
                  <xsl:value-of select="./p:finish-date"/>
                </xsl:if>
                <xsl:if test="./p:finish-expanded-date">
                  <xsl:apply-templates select="p:finish-expanded-date"/>
                </xsl:if>
                <xsl:if test="not(./p:finish-date) and not(./p:finish-expanded-date)">
                  <xsl:text>...</xsl:text>
                </xsl:if>
              </span>
            </xsl:if>
            <xsl:if test="./p:place">
              <xsl:if test="(./p:finish-date) | (./p:finish-expanded-date)">
                <xsl:text>, </xsl:text>
              </xsl:if>
              <span class="alternative">
                <xsl:choose>
                  <xsl:when test="$lang='en'">
                    <xsl:text>at </xsl:text>
                  </xsl:when>
                  <xsl:when test="$lang='ru'">
                    <xsl:text>в месте </xsl:text>
                  </xsl:when>
                </xsl:choose>
              </span>
              <span class="place">
                <xsl:value-of select="./p:place"/>
              </span>
            </xsl:if>
          </dfn>          
          <xsl:copy-of select="./p:content/node()"/>
        </xsl:element>
      </xsl:element>
      <xsl:if test="following-sibling::*">
        <hr />
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="p:finish-expanded-date | p:start-expanded-date">
    <xsl:if test="./g:season">
      <xsl:value-of select="./g:season"/>
      <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="./g:day-of-month">
      <xsl:value-of select="./g:day-of-month"/>
    </xsl:if>
    <xsl:if test="./g:month">
      <xsl:text>.</xsl:text>
      <xsl:value-of select="./g:month"/>
      <xsl:text>.</xsl:text>      
    </xsl:if>
    <xsl:if test="./g:month-name">
      <xsl:text> </xsl:text>
      <xsl:value-of select="./g:month-name"/>
      <xsl:text> </xsl:text>      
    </xsl:if>
    <xsl:if test="./g:year">
      <xsl:value-of select="./g:year"/>
    </xsl:if>
    <xsl:if test="./g:day-of-week">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="./g:day-of-week"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/p:page">
		<!-- HTML Source -->

    <!-- variables -->
    <xsl:variable name="p:language">
      <xsl:choose>
        <xsl:when test="l:localization/@select">
          <xsl:value-of select="l:localization/@select"/>
        </xsl:when>
        <xsl:when test="l:localization-source/@select">
          <xsl:value-of select="l:localization-source/@select"/>
        </xsl:when>        
        <xsl:when test="(not(@lang)) or (@lang='en')"><xsl:text>en</xsl:text></xsl:when>
        <xsl:when test="(@lang!='') and (@lang!='en')">
          <xsl:choose>
           <xsl:when test="@lang='ru'"><xsl:text>ru</xsl:text></xsl:when>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="p:lang-res-src">
      <xsl:choose>
        <xsl:when test="l:localization/@select">
          <xsl:copy-of select="l:localization/l:language[@id=$p:language]"/>
        </xsl:when>
        <xsl:when test="l:localization-source/@select">
          <xsl:variable name="src" select="document(l:localization-source/@src)" />
          <xsl:variable name="temp" select="document(l:localization-source/@src)/l:localization/l:language[@id=$p:language]"/>
          <xsl:value-of select="$temp"/>
          <!-- 
          <xsl:value-of select="$temp[l:string]"/>
          -->
        </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <!--
    <xsl:value-of select="$p:lang-res-src"/>
    -->

    <!--
    <xsl:variable name="p:definition-label" select="$p:lang-res-src/l:string[@id='l:site-introduction']"/>
    <xsl:variable name="p:site-introduction" select="$p:lang-res-src/l:string[@id='l:site-introduction']"/>
    -->

    <xsl:variable name="p:definition-label">
      <xsl:if test="(not(@lang)) or (@lang='en')">
        <xsl:text>Site definition, which is usually background image</xsl:text>
      </xsl:if>
      <xsl:if test="(@lang!='') and (@lang!='en')">
        <xsl:choose>
          <xsl:when test="@lang='ru'">
            <xsl:text>Описание сайта, по умолчанию представляющее собой фоновое изображение</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="p:site-introduction">
      <xsl:if test="(not(@lang)) or (@lang='en')">
        <xsl:text>welcome to shaman.sir homesite :: please feel yourself safe</xsl:text>
      </xsl:if>
      <xsl:if test="(@lang!='') and (@lang!='en')">
        <xsl:choose>
          <xsl:when test="@lang='ru'">
            <xsl:text>добро пожаловать на домашнюю страницу shaman.sir :: пожалуйста чувствуйте себя комфортно</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>    

    <!-- CONTENT -->
    <xsl:element namespace="http://www.w3.org/1999/xhtml" name="html">
      <xsl:attribute name="lang">
        <xsl:value-of select="$p:language"/>
      </xsl:attribute>

    <head>
			<title>
        <xsl:value-of select="/p:page/p:title"/>
      </title>
			
			<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

      <xsl:call-template name="page-attributes"/> <!-- page attributes template -->

      <link rel="shortcut icon" href="../images/star-black.gif" type="image/gif" />
			
			<meta name="copyright" content="Creative Commons (cc) shaman.sir, 2006" />
      <xsl:element name="meta">
        <xsl:attribute name="name">description</xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="/p:page/p:additional-data/p:description"/>
        </xsl:attribute>
      </xsl:element>
			<meta name="keywords" content="shaman.sir anthony kotenko japan web-design ppc pocket pc programming art" />			
</head>

  <body>

    <div id="left-holder">
      <!-- IE needs some text here inside -->
      &#x00A0;
      <!-- <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text> -->
    </div>

    <div class="sheet">

      <div id="page">

        <!-- Head of the page -->
        <div id="page-header">
          <img class="alternative" src="../images/alternative-logo.png" alt="Alternative banner of the site" />

          <p class="alternative">
            <xsl:element name="dfn">
              <xsl:attribute name="title">
                <xsl:value-of select="$p:definition-label"/>
              </xsl:attribute>
              <xsl:value-of select="$p:site-introduction"/>
            </xsl:element>
          </p>

          <h1>
            <xsl:value-of select="/p:page/p:title"/>
          </h1>

          <!--
					 <select id="style-selector" tabindex="4">
					 				 <option label="xml-based">default: xml-based</option>
					 				 <option label="no-css">css disabled</option>
									 <option label="for-ppc">ppc version</option>
                   <option label="printable">printable</option>
                   <option label="big-fonts">with larger fonts</option>
                   <option label="no-xml">just XTML pages</option>
					 </select>
					 -->
        </div>
        <!-- #page-header -->

        <div id="page-control">

          <div id="pages-area">

            <!-- Link to allow users of non-css and text browsers (and may be later in graphic also) to skip navigation -->
            <div id="skip-nav-link">
              <span class="link-with-key">
                <a href="#content" title="Skip navigation blocks and proceed to content" accesskey="1" tabindex="1">
                  Skip to content
                </a> [1]
              </span>
            </div>

            <!-- Main navigation bar -->
            <xsl:if test="not(m:nav-menu) and (m:nav-menu-source)">
              <xsl:call-template name="nav-menu">
                <xsl:with-param name="src" select="document(m:nav-menu-source/@src)" />
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="m:nav-menu">
              <xsl:call-template name="nav-menu">
                <xsl:with-param name="src" select="." />
              </xsl:call-template>
            </xsl:if>
            
            <!-- Link to allow users of non-css and text browsers to proceed to sub-navigation -->
            <span class="alternative">
              <a href="#sub-nav-menu" title="Proceed to sub-navigation, if required" accesskey="2" tabindex="2">
                Proceed to sub-navigation
              </a> [2]
            </span>

            <div id="page-info">

              <!-- The image of the current page tab -->
              <!-- (A little trick from Todd Farner to hide an image from non-css browsers) -->
              <a href="#" id="page-tab" title="Current page" accesskey="3">
                <span class="alternative">(You are @ Home)</span>
              </a>

              <!-- Page description block -->
              <div id="description-block">
                <dl>
                  <dt>
                    <xsl:value-of select="/p:page/p:title"/>
                  </dt>
                  <dd>
                    <xsl:copy-of select="/p:page/p:additional-data/p:definition/node()"/>
                  </dd>
                  <dt>W3C WCAG 1.0 &amp; Section 508</dt>
                  <dd>
                    If <em>you</em> are not satisfied - please just e-mail the webmaster: <a href="mailto:shaman.sir@gmail.com">shaman.sir@gmail.com</a>.
                  </dd>
                </dl>
              </div>
              <!-- #description-block -->

            </div>
            <!-- #page-info -->

          </div>
          <!-- #pages-area -->

          <div id="basis">

            <!-- Block with tabs for navigating between different sections -->
            <xsl:if test="not(m:tab-menu) and (m:tab-menu-source)">
              <xsl:call-template name="tab-bar">
                <xsl:with-param name="src" select="document(m:tab-menu-source/@src)" />
                <xsl:with-param name="activate" select="m:tab-menu-source/@activate" />
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="m:tab-menu">
              <xsl:call-template name="tab-bar">
                <xsl:with-param name="src" select="." />
              </xsl:call-template>
            </xsl:if>

            <!-- The main content of the page -->
            <div id="content">

              <hr />

              <h2>
                <xsl:value-of select="/p:page/p:sub-title"/>
              </h2>

              <dfn>
                <xsl:copy-of select="/p:page/p:additional-data/p:definition/node()"/>
              </dfn>

              <xsl:if test="not(@lang)">
                <xsl:call-template name="content-blocks">
                  <xsl:with-param name="lang" select="'en'" />
                </xsl:call-template>
              </xsl:if>
              <xsl:if test="@lang!=''">
                <xsl:call-template name="content-blocks">
                  <xsl:with-param name="lang" select="@lang" />
                </xsl:call-template>
              </xsl:if>

            </div>

            <!-- Link to allow users of non-css and text browsers (and may be later in graphic also) to proceed to the top -->
            <span class="link-with-key" id="proceed-to-top">
              <a href="#content" title="Proceed to the top" accesskey="4" tabindex="3">
                Proceed to the top
              </a> [4]
            </span>

          </div>
          <!-- #basis -->

          <div id="page-sections-area">

            <div id="sub-nav-holder">
              <!-- IE needs some text here inside -->
              &#x00A0;
              <!-- <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text> -->
            </div>

            <!-- Sub navigation - navigation by sub-sections -->            
            <xsl:call-template name="sub-nav-menu" />

            <!-- Advertisment zone, to place banners here -->
            <div id="adware-zone">
           
           <!-- <span class="alternative">Stub banner</span>
					 <a href="#" title="Stub banner"><img src="./images/logos/stub-logo.png" alt="Some banner" /></a>
					  <span class="alternative">Stub banner</span>
					 <a href="#" title="Stub banner"><img src="./images/logos/stub-logo.png" alt="Some banner" /></a> 
           -->

           <!--
					 <span class="alternative">RSS 2.0 Source</span>
					 <a href="#" title="RSS Feed"><img src="./images/logos/rss2.gif" alt="RSS 2.0 Source" /></a>
					 -->

           <!--
					 <span class="alternative">XML/XSLT Based Source</span>
					 <a href="#" title="XML/XSLT Based"><img src="./images/logos/xml.gif" alt="XML/XSLT Based" /></a>
					 -->

              <span class="alternative">XHTML 1.0 Strict W3C Validated</span>
              <a href="http://validator.w3.org/check?uri=referer" title="Valid XHTML 1.0 Strict!">
                <img src="../images/logos/w3c-xhtml10.png" alt="Valid XHTML 1.0 Strict!" />
              </a>

              <span class="alternative">CSS 2.1 W3C Validated</span>
              <a href="http://jigsaw.w3.org/css-validator/check/referer" title="Valid CSS!">
                <img src="../images/logos/w3c-css21.gif" 
                     alt="Valid CSS!" />
              </a>

              <span class="alternative">WCAG 1.0 Double-A - Priorities L1 &amp; L2 Satisfied.</span>
              <a href="http://www.w3.org/WAI/WCAG1AA-Conformance" title="WCAG 1.0 Double-A - Priorities L1 &amp; L2 Satisfied">
                <img src="../images/logos/w3c-wai-aa-wx.gif" 
                     alt="WCAG 1.0 Double-A - Priorities L1 &amp; L2 Satisfied: WebXact Approved!" />
              </a>

              <span class="alternative">WCAG 1.0 Triple-A - Priorities L1-3 Satisfied</span>
              <a href="http://webxact.watchfire.com" title="WCAG 1.0 Triple-A - Priorities L1-3 Satisfied">
                <img src="../images/logos/w3c-wai-aaa-wx.gif" 
                     alt="WCAG 1.0 Triple-A - Priorities L1-3 Satisfied: WebXact, Cynthia &amp; Hermish Approved!" />
                <!-- webxact.watchfire.com -->
                <!-- www.cynthiasays.com -->
                <!-- www.contentquality.com -->
                <!-- http://www.hermish.com -->
                <!-- Lynx -->
              </a>

              <span class="alternative">Section 508 Satisfied</span>
              <a href="http://webxact.watchfire.com" title="Section 508 Satisfied">
                <img src="../images/logos/button_508-wx.gif" 
                     alt="Section 508 Satisfied: WebXact, Cynthia &amp; Hermish Approved!" />
                <!-- webxact.watchfire.com -->
                <!-- www.cynthiasays.com -->
                <!-- www.contentquality.com -->
                <!-- http://www.hermish.com -->
                <!-- Lynx -->
              </a>

              <span class="alternative">Using W3Counter</span>
              <!-- IE says something bad here, I need to place here my own icon -->
              <!-- Begin W3Counter Tracking Code -->
              <script type="text/javascript" src="http://www.w3counter.com/tracker.js"></script>
              <script type="text/javascript">
                w3counter(2812);
              </script>
              <noscript>
                <div>
                  <a href="http://www.w3counter.com/stats/2812" title="Using W3Counter">
                    <img src="../images/logos/w3counter.png"	style="border: 0" alt="W3Counter Web Stats" />
                  </a>
                </div>
              </noscript>
              <!-- End W3Counter Tracking Code-->

              <span class="alternative">Get Firefox.</span>
              <a href="http://www.mozilla.org/products/firefox" title="Get Firefox!">
                <img src="../images/logos/get-firefox.png" 
                     alt="Get Firefox" />
                <!-- http://www.spreadfirefox.com/?q=affiliates&id=0&t=82 -->
              </a>

              <span class="alternative">...or, at least, Opera :).</span>
              <a href="http://www.opera.com" title="...or, at least, Opera :)">
                <img src="../images/logos/get-opera.gif" 
                     alt="...or, at least, Opera :)" />
              </a>

              <span class="alternative">Creative Commons protected</span>
              <a href="http://creativecommons.org/licenses/by-sa/2.5/" title="Creative Commons: Attribution and Share Alike 2.5">
                <img src="../images/logos/ccLogo.gif" alt="Creative Commons: Attribution and Share Alike 2.5" />
              </a>


            </div>
            <!-- #adware-zone -->

          </div>
          <!-- #page-sections-area -->

        </div>
        <!-- #page-control -->

        <!-- And, the footer at last -->
        <div id="footer">

          <div id="logo-block">

            <div id="supported-browsers">
              <span class="alternative">Supported browsers:</span>
              <a id="firefox-logo" href="http://www.mozilla.com/products/firefox/" title="Firefox 1.5+ Supported">
                <span class="alternative">Firefox 1.5+ Supported</span>
              </a>
              <a id="opera-logo" href="http://www.opera.com/" title="Opera 9+ Supported">
                <span class="alternative">Opera 9+ Supported</span>
              </a>
              <a id="ie-logo" href="http://www.microsoft.com" title="IE 6+ Supported">
                <span class="alternative">IE 6+ Supported</span>
              </a>
            </div>
            <!-- #supported-browsers -->

            <div id="webstandards">
              <span class="alternative">Used technologies from:</span>
              <a id="ws-logo" href="http://www.webstandards.org" title="Used Web Standards">
                <span class="alternative">WebStandards.org</span>
              </a>
            </div>

            <div id="made-with">
              <span class="alternative">Used software:</span>
              <a id="html-kit-logo" href="http://www.chami.com/html-kit/" title="Used HTML-Kit">
                <span class="alternative">HTML-Kit 5.1</span>
              </a>
              <a id="ff-web-dev-logo" href="http://www.chrispederick.com/work/webdeveloper/" title="Used Web developer FireFox plugin">
                <span class="alternative">Web developer FireFox plugin 1.0.2</span>
              </a>
              <a id="photoshop-logo" href="http://www.adobe.com" title="Used Adobe Photoshop">
                <span class="alternative">Adobe Photoshop CS</span>
              </a>
              <a id="xml-spy-logo" href="http://www.altova.com" title="Using XMLSpy Home for XSD Construction">
                <span class="alternative">Altova XMLSpy</span>
              </a>
              <a id="xchng-xml-logo" href="http://www.exchangerxml.com" title="Using Exchanger XML Editor Lite for XML/XSLT Editing">
                <span class="alternative">Cladonia Exchanger XML Editor</span>
              </a>
            </div>
            <!-- #made-with -->

          </div>
          <!-- #logo-block -->

          <div id="copyrights-logo">
            <a href="http://creativecommons.org/licenses/by-sa/2.5/">
              <img src="../images/logos/cc-sr-2.png" alt="Creative Commons: Attribution and Share Alike 2.5" />
            </a>
          </div>
          <!-- #copyrights-logo -->

          <span id="main-copyright" class="cc">
            shaman.sir, 2006
          </span>
        </div>
        <!-- #footer -->

      </div>
      <!-- #page -->

    </div>
    <!-- .sheet -->

    <div id="right-holder">
      <!-- IE needs some text here inside -->
      &#x00A0;
      <!-- <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text> -->
    </div>

  </body>

  </xsl:element>

   <!-- / HTML Source -->
	</xsl:template>

</xsl:stylesheet>