<?xml version="1.0" encoding="utf-8"?>
<!--
  /*
    This stylesheet is written and constructed by shaman.sir (cc) and may be used anywhere for any good purpose 
    (by saying "good" I mean "money-independent and people-safe only"), please just don't forget to write my
    name somewhere around (let it be "shaman.sir", ok). If we will not steal, but we will give, the peace will
    come in our land... may be
    
    shaman.sir@gmail.com
  */
-->

<!--
<?xml-stylesheet type="text/xsl" href="./page-mode-filter.xsl"?>
-->
<!-- <!DOCTYPE xsl:stylesheet [
	<!ENTITY quot   "&#x0022;">	  
	<!ENTITY amp    "&#x0026;">
	<!ENTITY apos   "&#x0027;">  
	<!ENTITY lt     "&#x003C;">
	<!ENTITY gt     "&#x003E;">  
	<!ENTITY nbsp   "&#x00A0;">  
]> -->

<!--
  resulting content structure:
  
html>body 
	.sheet
		#page
			#header
				#style-selector
			#page-area
				ul#nav-bar
				#page-info
				#description-block
				ul#tab-bar
				ul#sub-nav-menu
				#content
				#adware-zone				
			#footer
				#logo-block
				#copyrights-logo
				span#main-copyright
  
-->

  <!-- templates order:
PAGE-ATTRIBUTES
NAV-MENU
TAB-BAR
SUB-NAV-MENU
CONTENT-BLOCKS
ARTICLE
FILE
NEWS-ENTRY
PAGE-CODE
TEXT-BLOCK
EXPANDED-DATE
LOCALIZE
PAGE
-->

<!-- templates calling positions:
[PAGE] ->
[PAGE-ATTRIBUTES]
[LOCALIZE]
html>body
	.sheet
		#page
			#page-header
				#style-selector
			#page-control
				#pages-area
					ul#nav-bar [NAV-MENU]
					#page-info
						#description-block
				#basis
					ul#tab-bar [TAB-BAR]
					#content [CONTENT-BLOCKS] -> 
                 [ARTICLE], [FILE], [NEWS-ENTRY], [PAGE-CODE], [TEXT-BLOCK] -> [EXPANDED-DATE]
				#page-sections-area
					#sub-nav-holder
					ul#sub-nav-menu [SUB-NAV-MENU]
					#adware-zone
			#footer
				#logo-block
				#copyrights-logo
				span#main-copyright
-->

<!-- TODO:
create an index page (in simple xhtml) (and selection box) to allow to select from versions:
  no-xml (html)
  default (xml-based)
  opera xml-based version [different xslt/xml or function-available()]
  big fonts [css change]
  no-styles [css change]
  for ppc [css change]
  printable [css change]
  results may be created using another xslt
create content  
create different versions  
  opera not supports document(), make an alternative version for
upgrade styles
  make hovering buttons to store backrounds as one image
(head, body and) some other elements are generated now with unused namespaces, fix it
all translations must to be stored in one simple xml file - finish language-changing support
  (there are a lot of variables now exist, and they all use localize template - it's no good - I need somethiing with XPath)
page content must to support rss inclusion
-->

<xsl:stylesheet version="1.0" 
                xmlns="http://www.w3.org/1999/xhtml" 
	              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:p="http://www.shaman-sir.by.ru/XSD/Pages"
                xmlns:m="http://www.shaman-sir.by.ru/XSD/Menus"
                xmlns:g="http://www.shaman-sir.by.ru/XSD/Generic"
                xmlns:l="http://www.shaman-sir.by.ru/XSD/Localization"
                exclude-result-prefixes="xsl p m g l"
                extension-element-prefixes="p m g l">
  <xsl:output method="xml"
              encoding="utf-8"
              standalone="yes"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              indent="yes"/>

  <!-- 
  <xsl:include href="./page-mode-filter.xsl"/>
  -->

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ PAGE-ATTRIBUTES ]))))))) -->

  <!-- page attributes template: page-attributes -->

  <!-- analyses 
       <p:page mode="{xml-based|no-xml|big-fonts|opera-version|printable}">
       and expands it into the inclusion of the according css styles. 
       
       the result is the proper number of 
       <link rel="stylesheet" type="text/css" href="../css/{css-file-name}.css" /> 
       <link rel="stylesheet" type="text/css" href=". . ." /> 
       . . .
       tags.
  -->
  
  <xsl:template match="/p:page[@*]" name="page-attributes">
    <xsl:comment>
      <xsl:text> styles inclusion for the page mode: </xsl:text><xsl:if test="(/p:page[not(@mode)])">default</xsl:if><xsl:if test="(/p:page[@mode])"><xsl:value-of select="/p:page/@mode"/></xsl:if><xsl:text> </xsl:text>
    </xsl:comment>

    <!-- /page/@mode -->    
    <xsl:if test="(/p:page[not(@mode)]) | 
                  (/p:page[@mode=xml-based]) | 
                  (/p:page[@mode=no-xml]) |
                  (/p:page[@mode=big-fonts]) |
                  (/p:page[@mode=opera-version])">
      <link rel="stylesheet" type="text/css" href="../css/structure.css" />
      <link rel="stylesheet" type="text/css" href="../css/non-css-support.css" />
      <link rel="stylesheet" type="text/css" href="../css/elements.css" />
      <link rel="stylesheet" type="text/css" href="../css/backgrounds.css" />
      <link rel="stylesheet" type="text/css" href="../css/page-content.css" />
      <link rel="stylesheet" type="text/css" href="../css/text-modification.css" />
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
    <!--
    <xsl:element name="f:styles-filtering" namespace="http://www.shaman-sir.by.ru/XSD/Filtering">
      <xsl:if test="not(/p:page[not(@mode)])">
        <xsl:attribute name="append">
          <xsl:value-of select="/p:page/@mode"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:element>
    -->

    <xsl:comment>
      <xsl:text> / styles inclusion </xsl:text>
    </xsl:comment>    
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ NAV-MENU ]))))))) -->

  <!-- navigation menu template: nav-menu -->

  <!-- expands 
    <m:nav-menu>
      <m:page-location [active="{true|false}"] [location-id="{id}"]>
        <g:name>{menu-item-name}</g:name>
        <g:href>{url-to-point-to}</g:href>
      </m:page-location>
      <m:page-location>
        . . .
      </m:page-location>
      . . .
    </m:nav-menu>
    
       or
   <m:nav-menu-source src="{path-to-xml-with-the-structure-above}" activate="{location-id-to-activate}" />
   
       into
   <ul id="nav-bar">
     <li><a href="{url-to-point-to}" title="{menu-item-name}" [id="active"]>{menu-item-name}</a></li>
     <li><a href=". . ." title=". . .">. . .</a></li>
     . . .
   </ul>
   
   ( {id} must to match "[A-Za-z][\w-]*" )   
   
   "src" {path-to-xml-with-the-structure-above} 
        param receives the address of the xml file to take values from or just the current node if file is not specified   
  -->
  
  <xsl:template match="/p:page/m:nav-menu" name="nav-menu">
    <xsl:param name="src"/>
    <xsl:param name="activate"/>
    
    <xsl:comment>
      <xsl:text> the main navigation bar </xsl:text>
    </xsl:comment>

    <ul id="nav-bar">
      <!-- menu tag is not recommneded by W3C -->

      <xsl:for-each select="$src/m:nav-menu/m:page-location">
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
                <xsl:text>nav-active</xsl:text>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="g:name"/>
            <!-- </a> -->
          </xsl:element>
        </li>
      </xsl:for-each>

    </ul>
    <!-- #nav-bar -->

    <xsl:comment>
      <xsl:text> / main navigation bar (ul#nav-bar) </xsl:text>
    </xsl:comment>    
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ TAB-BAR ]))))))) -->

  <!-- tabs bar template: tab-bar -->

  <!-- expands
    <m:tab-menu>
      <m:page-location [active="{true|false}"] [location-id="{id}"]>
        <g:name>{tab-location-name}</g:name>
        <g:href>{url-to-point-to}</g:href>
      </m:page-location>
      <m:page-location . . .>
        . . .
      </m:page-location>
      . . .
    </m:tab-menu> 
  
      or
    <m:tab-menu-source src="{path-to-xml-with-the-structure-above}" activate="{location-id-to-activate}" />
  
      into
    <ul id="tab-bar">
      <li><a href="{url-to-point-to}" title="{tab-location-name}" [id="active"]>{tab-location-name}<a></li>
      <li><a href=". . ." title=". . ." . . .>. . .<a></li>
      . . .
    </ul>
    
   "src" {path-to-xml-with-the-structure-above} 
        param receives the address of the xml file to take values from or just the current node if file is not specified
   "activate" {location-id-to-activate}
        specifies the id of the item to activate
  -->
  
  <xsl:template match="/p:page/m:tab-menu" name="tab-bar">
    <xsl:param name="src"/>
    <xsl:param name="activate"/>

    <xsl:comment>
      <xsl:text> the tabs bar here </xsl:text> 
    </xsl:comment>
    
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
                <xsl:text>tab-active</xsl:text>
              </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="g:name"/>
            <!-- </a> -->
          </xsl:element>
        </li>
      </xsl:for-each>
    </ul>
    <!-- #tab-bar -->

    <xsl:comment>
      <xsl:text> / tabs bar (ul#tab-bar) </xsl:text>
    </xsl:comment>    
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ SUB-NAV-MENU ]))))))) -->

<!-- sub-navigation menu template: sub-nav-menu -->

<!-- expands
  <m:position-list>
    <m:position>
      <m:name>{position-name}</m:name>
      <m:anchor>{position-anchor-in-the-document}</m:anchor>
    </m:position>
    <m:position>
      . . .
    </m:position>
    . . .
  </m:position-list>
  
    into
  <ul id="sub-nav-menu">
    <li><a href="{position-anchor-in-the-document}" title="{position-name}">{position-name}</a></li>
    <li><a href=". . ." title=". . .">. . .</a></li>
    . . .
  </ul>
  
  ( {position-anchor} must to match "#[A-Za-z][\w-]*" )
  -->

<xsl:template match="/p:page/m:position-list" name="sub-nav-menu">
  <xsl:comment>
    <xsl:text> sub-navigation menu </xsl:text>
  </xsl:comment>

  <ul id="sub-nav-menu">
    <!-- menu tag is not recommneded by W3C -->
    <xsl:for-each select="./m:position-list/m:position">
      <li>
        <a href="{m:anchor}" title="{m:name}">
          <xsl:value-of select="m:name"/>
        </a>
      </li>
    </xsl:for-each>
  </ul>
  <!-- #sub-nav-menu -->

  <xsl:comment>
    <xsl:text> / sub-navigation menu (ul#sub-nav-menu) </xsl:text>
  </xsl:comment>
</xsl:template>

<!-- *************************************************************************************************************** -->

<!-- ((((((([ CONTENT-BLOCKS ]))))))) -->

  <!-- content blocks template: content-blocks -->

  <!-- expands
  <p:content>
    <p:block [title="{title}"]>
      <p:items type="{article|file|news-entry|page-code|text-block}">
        . . . // here is the according template call: ARTICLE, FILE, NEWS-ENTRY, PAGE-CODE or TEXT-BLOCK
      </p:items>
      . . .
    </p:block>  
    . . .
  </p:content>
  
    into:
  <h3>{title}</h3>
  . . . // content, depending of the item type, see according templates also
  
  and then passes it to the according template, passing the lang
  
  "lang"
       parameter contains language value for future multi-language support
  -->
  <xsl:template match="/p:page/p:content" name="content-blocks">
    <xsl:param name="lang" />

    <xsl:for-each select="./p:content/p:block">
      <xsl:variable name="content_block_num"><xsl:number /></xsl:variable>
      
      <xsl:comment>
        <xsl:text> started content block #</xsl:text>
        <xsl:value-of select="$content_block_num"/>
        <xsl:text>, "</xsl:text>
        <xsl:value-of select="@title"/>
        <xsl:text>" </xsl:text>
      </xsl:comment>
      <h3>
        <xsl:value-of select="@title"/>
      </h3>
      <xsl:for-each select="./p:items">
        <xsl:choose>
          <xsl:when test="@type='article'">
            <xsl:call-template name="article"> <!-- ::: ARTICLE ::: -->
              <xsl:with-param name="lang" select="$lang" />
              <xsl:with-param name="content_block_num" select="$content_block_num" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@type='file'">
            <xsl:call-template name="file"> <!-- ::: FILE ::: -->
              <xsl:with-param name="lang" select="$lang" />
              <xsl:with-param name="content_block_num" select="$content_block_num" />              
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@type='news-entry'">
            <xsl:call-template name="news-entry"> <!-- ::: NEWS-ENTRY ::: -->
              <xsl:with-param name="lang" select="$lang" />
              <xsl:with-param name="content_block_num" select="$content_block_num" />              
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@type='page-code'">
            <xsl:call-template name="page-code"> <!-- ::: PAGE-CODE ::: -->
              <xsl:with-param name="content_block_num" select="$content_block_num" />
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="@type='text-block'">
            <xsl:call-template name="text-block"> <!-- ::: TEXT_BLOCK ::: -->
              <xsl:with-param name="lang" select="$lang" />
              <xsl:with-param name="content_block_num" select="$content_block_num" />              
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <span class="error-msg">Parsing error occured, items type is unrecognizable</span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:comment>
        <xsl:text> / finished content block #</xsl:text><xsl:value-of select="$content_block_num"/><xsl:text> </xsl:text>
      </xsl:comment>
    </xsl:for-each>

  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ ARTICLE ]))))))) -->

  <!-- article content template: article -->

  <!-- expands
    <p:items type="article">
      <p:articles xmlns="http://www.w3.org/1999/xhtml">
        <p:article [id="{article-id}"]>
          <p:title>{article-title}</p:title>
          <p:author>
            [<g:name>{author-name}</g:name>]
            [<g:last-name>{author-last-name}</g:last-name>]
            <g:nickname>{author-nickname}</g:nickname>
          </p:author>
          [<p:date>{post-date}</p:date>]
          <p:content>
            <p>{article-content}</p>
          </p:content>
        </p:article>
        <p:article . . .>
         . . .
        </p:article>
        . . .
       </p:articles>
     </p:items>
     
    into
      <div id="{article-id}" class="article">
        <h4>{article-title}</h4>
        <span class="alternative">`by: |автор: `</span> // depends of the "lang" value - "en" or "ru"
        <dfn>
          <span class="author-name">[{author-name}]</span>
          <span class="author-nickname">{author-nickname}</span>
          <span class="author-last-name">[{author-last-name}]</span>
          [ <span class="alternative">@ </span><span class="date">{post-date}</span> ]
        </dfn>
        <p>
          {article-content}
        </p>
      </div>
      <div . . .>
        . . .
      </div>
      . . .
      
  {article-id} will be generated if not specified, but if specified, must match to "[A-Za-z][\w-]*"
  {post-date} must match to "((0\d)|1(1|2))/(([0-2]\d)|(3(0|1)))(/\d{4})?\s(((0|1)\d)|(2[0-4])):[0-5]\d(\.[0-5]\d)?" 
             (mm/dd[/yyyy] hh:mm[.ss]), if specified

  "lang"
       parameter contains language value for future multi-language support
  "content_block_num"
       is parameter just for generating useful comments with numbering
  -->  
  
  <xsl:template name="article" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="lang" />
    <xsl:param name="content_block_num" />

    <xsl:for-each select="./p:articles/p:article">
      <xsl:variable name="article_block_num"><xsl:value-of select="$content_block_num"/>.<xsl:number /></xsl:variable>
      <xsl:variable name="article_block_id"><xsl:value-of select="generate-id()"/></xsl:variable>

      <xsl:comment>
        <xsl:text> started article #</xsl:text>
        <xsl:value-of select="$article_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$article_block_id" />
        <xsl:text>), "</xsl:text>
        <xsl:value-of select="./p:title" />
        <xsl:text>" </xsl:text>
      </xsl:comment>
      
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="$article_block_id"/>
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

      <xsl:comment>
        <xsl:text> / finished article #</xsl:text>
        <xsl:value-of select="$article_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$article_block_id" />
        <xsl:text>) </xsl:text>
      </xsl:comment>     
      
    </xsl:for-each>
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ FILE ]))))))) -->

  <!-- file content template: file -->

  <!-- expands
      <p:items type="file">
        <p:files xmlns="http://www.w3.org/1999/xhtml">
          <p:file [type="{image|application}"] [id="{file-id}"]>
            <p:href>{description-link}</p:href>
            <p:fileURI>{file-url}</p:fileURI>
            <p:screenshotURI>{screenshot-url}</p:screenshotURI>
            <p:name>{file-title}</p:name>
            <p:description>
              <p>{file-description}</p>
            </p:description>
          </p:file>
          <p:file . . .>
            . . .
          </p:file>
          . . .
        </p:files>
      </p:items>
    
    into
      {$link-text:}
        `Link to|Ссылка для` // depends of the "lang" value - "en" or "ru"
          {$type=image}`Examine|изучения` // depends of the "lang" value - "en" or "ru"
          {$type=application}`Download|скачивания` // depends of the "lang" value - "en" or "ru"
          {$type=*}`Take|изъятия` // depends of the "lang" value - "en" or "ru"
      {/$link-text}
      
      <div id="{file-id}" class="file">
        <h4>
          <a href="{description-link}" title="{file-title}" class="file-title-link">{file-title}</a>
        </h4>
        <a href="{file-url}" title="{file-title}">
          <span class="alternative">`image: |изображение: `</span> // depends of the "lang" value - "en" or "ru"
          <img alt="{file-title}" title="{file-title} screenshot" class="file-screenshot" src="{screenshot-url}"/>
        </a>
        <dl>
          <dt>{file-title} `description|(описание)`</dt> // depends of the "lang" value - "en" or "ru"
          <dd>
            <a href="{file-url}" title="{$link-text}" class="file-link">{$link-text}</a>
            <p>{file-description}</p>
          </dd>
        </dl>
      </div>
      <div . . .>
        . . .
      </div>
      . . .
      
  {file-id} will be generated if not specified, but if specified, must match to "[A-Za-z][\w-]*"

  "lang"
       parameter contains language value for future multi-language support
  "content_block_num"
       is parameter just for generating useful comments with numbering
  -->

  <xsl:template name="file" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="lang" />
    <xsl:param name="content_block_num" />
    
    <xsl:for-each select="./p:files/p:file">
      <xsl:variable name="file_block_num"><xsl:value-of select="$content_block_num"/>.<xsl:number /></xsl:variable>
      <xsl:variable name="file_block_id"><xsl:value-of select="generate-id()"/></xsl:variable>

      <xsl:variable name="file_link_text">
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
      </xsl:variable>

      <xsl:comment>
        <xsl:text> started file #</xsl:text>
        <xsl:value-of select="$file_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@type" />
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$file_block_id" />
        <xsl:text>), "</xsl:text>
        <xsl:value-of select="./p:name" />
        <xsl:text>" description </xsl:text>
      </xsl:comment>      
      
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="$file_block_id" />
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
              <xsl:attribute name="title">
                <xsl:value-of select="$file_link_text"/>
              </xsl:attribute>
              <xsl:value-of select="$file_link_text"/>
            </xsl:element>
            <xsl:copy-of select="./p:description/node()"/>
          </dd>
        </dl>
      </xsl:element>

      <xsl:comment>
        <xsl:text> / finished file #</xsl:text>
        <xsl:value-of select="$file_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$file_block_id" />
        <xsl:text>) description </xsl:text>
      </xsl:comment>

    </xsl:for-each>
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ NEWS-ENTRY ]))))))) -->

  <!-- news entry content template: news-entry -->

  <!-- expands
    <p:items type="news-entry">
      <p:news xmlns="http://www.w3.org/1999/xhtml">
        <p:entry [id="{entry-id}"]>
          <p:title>{entry-title}</p:title>
          [ <p:author>
              [<g:name>{author-name}</g:name>]
              [<g:last-name>{author-last-name}</g:last-name>]
              <g:nickname>{author-nickname}</g:nickname>
            </p:author> ]
          <p:post-date>{post-date}</p:post-date>
          <p:content>
            <p>{entry-content}</p>
          </p:content>
        </p:entry>
        <p:entry>
          . . .
        </p:entry>
        . . .
      </p:news>
    </p:items>
    
    into
      <div id="{entry-id}" class="news-entry">
        <h4>{entry-title}</h4>
        <p>
          {entry-content}
        </p>        
        [ <span class="alternative">`by: |автор: `</span> ] // depends of the "lang" value - "en" or "ru"
        <dfn>
          [ 
          <span class="author-name">[{author-name}]</span>
          <span class="author-nickname">{author-nickname}</span>
          <span class="author-last-name">[{author-last-name}]</span>
          <span class="alternative">,</span>
          ]
          <span class="alternative">`posted @ |опубликовано `</span> // depends of the "lang" value - "en" or "ru"
          <span class="date">{post-date}</span> 
        </dfn>
      </div>
      <div . . .>
        . . .
      </div>
      . . .
      
  {entry-id} will be generated if not specified, but if specified, must match to "[A-Za-z][\w-]*"
  {post-date} must match to "((0\d)|1(1|2))/(([0-2]\d)|(3(0|1)))(/\d{4})?\s(((0|1)\d)|(2[0-4])):[0-5]\d(\.[0-5]\d)?" 
             (mm/dd[/yyyy] hh:mm[.ss]), if specified  

  "lang"
       parameter contains language value for future multi-language support
  "content_block_num"
       is parameter just for generating useful comments with numbering
  -->

  <xsl:template name="news-entry" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="lang" />
    <xsl:param name="content_block_num" />    
    
    <xsl:for-each select="./p:news/p:entry">
      <xsl:variable name="entry_block_num"><xsl:value-of select="$content_block_num"/>.<xsl:number /></xsl:variable>
      <xsl:variable name="entry_block_id"><xsl:value-of select="generate-id()"/></xsl:variable>

      <xsl:comment>
        <xsl:text> started news entry #</xsl:text>
        <xsl:value-of select="$entry_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$entry_block_id" />
        <xsl:text>), "</xsl:text>
        <xsl:value-of select="./p:title" />
        <xsl:text>" </xsl:text>
      </xsl:comment>

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

      <xsl:comment>
        <xsl:text> / finished news entry #</xsl:text>
        <xsl:value-of select="$entry_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$entry_block_id" />
        <xsl:text>) </xsl:text>
      </xsl:comment>

    </xsl:for-each>
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ PAGE-CODE ]))))))) -->

  <!-- page code content template: page-code -->

  <!-- expands
    <p:items type="page-code">
      <p:page-code xmlns="http://www.w3.org/1999/xhtml">
        <p:code-block [id="block-id"]>
          [<p:title>{code-block-title}</p:title>]
          <p:content>
            <p>{page-code-content}</p>
          </p:content>
        </p:code-block>
        <p:code-block>
          . . .
        </p:code-block>
        . . .
      </p:page-code>
    </p:items>  
    
    into:
    <div id="{block-id}" class="page-code">
      [<h4>{code-block-title}</h4>]
      <p>{page-code-content}</p>
    </div>
    [<hr />] // if there are some more code blocks will follow further
    <div . . .>
      . . .
    </div>
    [. . .]
    . . .
    
    {block-id} will be generated if not specified, but if specified, must match to "[A-Za-z][\w-]*"
    
    "content_block_num"
         is parameter just for generating useful comments with numbering    
  -->
  
  <xsl:template name="page-code" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="content_block_num" />

    <xsl:for-each select="./p:page-code/p:code-block">
      <xsl:variable name="code_block_num"><xsl:value-of select="$content_block_num"/>.<xsl:number /></xsl:variable>
      <xsl:variable name="code_block_id"><xsl:value-of select="generate-id()"/></xsl:variable>

      <xsl:comment>
        <xsl:text> started code block #</xsl:text>
        <xsl:value-of select="$code_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$code_block_id" />
        <xsl:text>) </xsl:text>
      </xsl:comment>      
      
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="$code_block_id"/>
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

      <xsl:comment>
        <xsl:text> / finished code block #</xsl:text>
        <xsl:value-of select="$code_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$code_block_id" />
        <xsl:text>) </xsl:text>
      </xsl:comment>

    </xsl:for-each>
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ TEXT-BLOCK ]))))))) -->

  <!-- text block content template: text-block -->

  <!-- expands
      <p:items type="text-block">
        <p:text-blocks xmlns="http://www.w3.org/1999/xhtml">
          <p:text-block [type="(prose)|poetry"] [id="{text-block-id}"]>
            <p:title>{text-block-title}</p:title>
            [ <p:start-date>{start-date}</p:start-date> |
              <p:start-expanded-date>. . .</p:start-expanded-date> // here is EXPANDED-DATE template call ]
            [ <p:finish-date>{finish-date}</p:finish-date> |
              <p:finish-expanded-date>. . .</p:finish-expanded-date> // here is EXPANDED-DATE template call ]
            [ <p:author>
                [ <g:name>{author-name}</g:name> ]
                [ <g:last-name>{author-last-name}</g:last-name> ]
                <g:nickname>{author-nickname}</g:nickname>
              </p:author> ]
            [ <p:place>{place-name}</p:place>]
            <p:content>
              <p>{text-block-content}</p>
            </p:content>
          </p:text-block>
          <p:text-block>
            . . .
          </p:text-block>
          . . .
        </p:text-blocks>
      </p:items> 
    
    into:
    <div id="{text-block-id}" class="text-block">
      [<h4>{text-block-title}</h4>]
      <div class="{prose|poem}">    // depending of ./p:text-block/@type
        [ <span class="alternative">`written |за авторством `</span> ]   // depends of the "lang" value - "en" or "ru"
        <span class="alternative">`by |от `</span>  // depends of the "lang" value - "en" or "ru"
        [ <span class="author-name">`(unknown author)|(неизвестный автор)`</span> ] // depends of the "lang" value - "en" or "ru",
                                                         // occurs if author is not specified
        <dfn>
          [ 
          <span class="author-name">[{author-name}]</span>
          <span class="author-nickname">{author-nickname}</span>
          <span class="author-last-name">[{author-last-name}]</span>
          <span class="alternative">,</span> (cc)
          ]    // occurs if author is specified
          [
            <span class="alternative">`in |датировано `</span> // depends of the "lang" value - "en" or "ru"
            <span class="date">
              [ {start-date} - ] |   // occurs if simple start date is specified 
              [
                <span class="alternative">` period from | периодом с `</span> // depends of the "lang" value - "en" or "ru"
                . . .   // EXPANDED-DATE template is called here
                <span class="alternative">` to | по `</span> // depends of the "lang" value - "en" or "ru"              
              ]     // occurs if expanded start date is specified           
              [ {finish-date} ] |   // occurs if simple finish date is specified 
              [ . . .   // EXPANDED-DATE template is called here ] |    // occurs if expanded finish date is specified
              [ `...` ]   // occurs if no finish date is specified
            </span>
          ]   // occurs if date is specified
          [
            [ `,` ]  //  occurs if finish date is specified
            <span class="alternative">`at |в месте `</span>
            <span class="place">{place-name}</place>
          ]   // occurs if place is specified
        </dfn>
        <p>{text-block-content}</p>        
      </div>  // div.prose | div.poem
    </div>  // div.text-block
    [<hr />] // if there are some more text blocks will follow further
    <div . . .>
      . . .
    </div>
    [. . .]
    . . .
    
    {text-block-id} will be generated if not specified, but if specified, must match to "[A-Za-z][\w-]*"
    {start-date}
    {finish-date}
         must match "((((((0\d)|1(1|2))|\?{2})/)?((([0-2]\d)|(3(0|1)))|\?{2})/)?((\d{4})|\?{4}))|((((0\d)|1(1|2))|\?{2})/((([0-2]\d)|(3(0|1)))|\?{2})(/((\d{4})|\?{4}))?)",
         format is "([mm/[dd/]]yyyy|mm/dd[/yyyy])"
    
    "lang"
         parameter contains language value for future multi-language support    
    "content_block_num"
         is parameter just for generating useful comments with numbering    
  -->  
  <xsl:template name="text-block" match="/p:page/p:content/p:block/p:items">
    <xsl:param name="lang" />
    <xsl:param name="content_block_num" />
    
    <xsl:for-each select="./p:text-blocks/p:text-block">
      <xsl:variable name="text_block_num"><xsl:value-of select="$content_block_num"/>.<xsl:number /></xsl:variable>
      <xsl:variable name="text_block_id"><xsl:value-of select="generate-id()"/></xsl:variable>

      <xsl:comment>
        <xsl:text> started text block #</xsl:text>
        <xsl:value-of select="$text_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$text_block_id" />
        <xsl:text>), "</xsl:text>
        <xsl:value-of select="./p:title" />
        <xsl:text>" </xsl:text>
      </xsl:comment>      
      
      <xsl:element name="div">
        <xsl:attribute name="id">
          <xsl:if test="@id">
            <xsl:value-of select="@id"/>
          </xsl:if>
          <xsl:if test="not(@id)">
            <xsl:value-of select="$text_block_id"/>
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
                  <xsl:apply-templates select="p:start-expanded-date"/> <!-- ::: EXPANDED-DATE ::: -->
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
                  <xsl:apply-templates select="p:finish-expanded-date"/> <!-- ::: EXPANDED-DATE ::: -->
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

      <xsl:comment>
        <xsl:text> / finished text block #</xsl:text>
        <xsl:value-of select="$text_block_num" />
        <xsl:text> (</xsl:text>
        <xsl:value-of select="$text_block_id" />
        <xsl:text>) </xsl:text>
      </xsl:comment>

    </xsl:for-each>
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ EXPANDED-DATE ]))))))) -->

  <!-- expanded date matching template -->

  <!-- expands
    <p:start-expanded-date> | <p:finish-expanded-date>
        [ <g:day-of-month>{day-of-month}</g:day-of-month>
          [ <g:day-of-week>{day-of-week:Mon|Tue|Wed|...|Monday|Tuesday|Wednesday|...}</g:day-of-week> ]
          <g:month>{month}</g:month> | 
                  <g:month-name>{month-name:Jan|Feb|Mar|...|January|February|March|...|unidentified}</g:month-name>
        ] | [
          <g:season>{season:Winter|Spring|Summer|Autumn|unidentified}</g:season>
        ]
        <g:year>{year}</g:year>
    </p:start-expanded-date> | </p:finish-expanded-date>
  
    into
    `[ {season}, ][{day-of-month}]([.{month}.]|[ {month-name} ])[{year}][, {day-of-week}] `
  
    {day-of-month} must to be between 1 and 31
    {month} must to be between 1 and 12
    {year} must to have four digits
  -->

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

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ LOCALIZE ]))))))) -->

  <!-- localization/localization-source tag matching template -->

  <!--
  allows to specify either resource strings, resource strings sources or use the default languages variables 
  (only english as default is supported now). in fact, returns correct value for each variable and call for
  every one of them
  
  <l:localization-default as="en"/> // to use default english language variables
  | <l:localization-source src="{path-to-xml-file-containing-structure-described-below}" select="{language-id}"/>
  | 
    <l:localization [select="{language-id}"]>
      <l:language id="{language-id}">
        <l:string id="{resource-string-name}">{resource-string-value}</l:string>
        <l:string . . .>. . .</l:string>
        . . .
      </l:language>
      <l:language . . .>
        . . .
      </l:language>      
      . . .
    </l:localization>
  
  {language} languages supported now are en|ru
  {resource-string-name} is used to call the template with concrete resource name when creating variable 
                             (useful to use different prefixes for resource and variable (`l:` & `p:`, for example))
                             
  "lang"
      language defined in {language-id}
  "resource-name"
      concrete string name to take the value from (for selected language)
  "default"
      default value for the variable
  -->

  <xsl:template name="localize" match="/p:page/l:localization | /p:page/l:localization-source">
    <xsl:param name="resource-name" />
    <xsl:param name="lang" />
    <xsl:param name="default" />
    <xsl:choose>
      <xsl:when test="l:localization/@select">
        <xsl:variable name="lang-node" select="l:localization/l:language[@id=$lang]"/>
        <xsl:value-of select="$lang-node/l:string[@id=$resource-name]"/>
      </xsl:when>
      <xsl:when test="l:localization-source/@select">
        <xsl:variable name="src" select="document(l:localization-source/@src)" />
        <xsl:variable name="lang-node" select="document(l:localization-source/@src)/l:localization/l:language[@id=$lang]"/>
        <xsl:value-of select="$lang-node/l:string[@id=$resource-name]"/>
      </xsl:when>
      <xsl:when test="l:localization-default/@as">
        <xsl:value-of select="$default" />
      </xsl:when>
    </xsl:choose>
  </xsl:template>

<!-- *************************************************************************************************************** -->

  <!-- ((((((([ PAGE ]))))))) -->  

  <xsl:template match="/p:page">

    <!-- %%%%%%%[ variables ]%%%%%%% -->

    <!-- takes the {language-id} from l:localization (look LOCALIZE template describtion above) 
         and stores it in $p:language variable to pass it correctly to LOCALIZE template,
         also puts it in <html lang="{language-id}"> then -->
    <xsl:variable name="p:language">
      <xsl:choose>
        <xsl:when test="l:localization/@select">
          <xsl:value-of select="l:localization/@select"/>
        </xsl:when>
        <xsl:when test="l:localization-source/@select">
          <xsl:value-of select="l:localization-source/@select"/>
        </xsl:when>
        <xsl:when test="l:localization-default/@as">
          <xsl:value-of select="l:localization-default/@as"/>
        </xsl:when>
        <xsl:when test="(not(@lang)) or (@lang='en')">
          <xsl:text>en</xsl:text>
        </xsl:when>
        <xsl:when test="(@lang!='') and (@lang!='en')">
          <xsl:choose>
            <xsl:when test="@lang='ru'">
              <xsl:text>ru</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>en</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- %%%%%%%[ localized strings ]%%%%%%% -->
    
    <!-- TODO: generate with parent xslt then -->

    <!-- taking localized strings -->
    <xsl:variable name="p:definition-label">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->       
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:definition-label'" />
        <xsl:with-param name="default">
          <xsl:text>Site definition, which is usually background image</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:site-introduction">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:site-introduction'" />
        <xsl:with-param name="default">
          <xsl:text>welcome to shaman.sir homesite :: please feel yourself safe</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:skip-nav-caption">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:skip-nav-caption'" />
        <xsl:with-param name="default">
          <xsl:text>Skip navigation blocks and proceed to content</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:skip-nav-link">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:skip-nav-link'" />
        <xsl:with-param name="default">
          <xsl:text>Skip to content</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:proceed-sub-nav-caption">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:proceed-sub-nav-caption'" />
        <xsl:with-param name="default">
          <xsl:text>Proceed to sub-navigation, if required</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:proceed-sub-nav-link">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:proceed-sub-nav-link'" />
        <xsl:with-param name="default">
          <xsl:text>Proceed to sub-navigation</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:current-page-caption">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:current-page-caption'" />
        <xsl:with-param name="default">
          <xsl:text>Current page</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:current-page-link-prefix">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:current-page-link-prefix'" />
        <xsl:with-param name="default">
          <xsl:text>You are @</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:proceed-to-top-caption">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:proceed-to-top-caption'" />
        <xsl:with-param name="default">
          <xsl:text>Proceed to the top</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="p:proceed-to-top-link">
      <xsl:call-template name="localize"> <!-- ::: LOCALIZE ::: -->
        <xsl:with-param name="lang" select="$p:language" />
        <xsl:with-param name="resource-name" select="'l:proceed-to-top-link'" />
        <xsl:with-param name="default">
          <xsl:text>Proceed to the top</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- %%%%%%%[ / localized strings ]%%%%%%% -->

    <!-- %%%%%%%[ / variables ]%%%%%%% -->

    <!-- %%%%%%%[ XHTML CONTENT ]%%%%%%% -->

    <!-- expands 
    <p:page [mode="{(xml-based)|no-xml|big-fonts|opera-version|printable}"] [lang="{language-id}"]>
      <p:title>{page-title}</p:title>
      <p:sub-title>{page-sub-title}</p:sub-title>
      [ <p:additional-information>
          [ <p:author>
                [ <g:name>{author-name}</g:name> ]
                [ <g:last-name>{author-last-name}</g:last-name> ]
                <g:nickname>{author-nickname}</g:nickname>
              </p:author> ]* // no more than 5
          [ <p:creation-date>{creation-date}</p:creation-date> ]
          [ <p:definition>{page-definition}</p:definition> ]
          [ <p:description>{page-description}</p:description> ]
          [ <p:keywords>{page-keywords}</p:keywords> ]
        </p:additional-information> ]
      <l:localization . . .>. . .</l:localization> | 
          <l:localization-source . . ./> | 
             <l:localization-default . . ./>    // LOCALIZE template is called here
      <m:nav-menu-source . . ./> | <m:nav-menu>. . .</m:nav-menu>  // NAV-MENU template is called here
      <m:tab-menu-source . . ./> | <m:tab-menu>. . .</m:tab-menu>  // TAB-BAR template is called here
      [ <m:position-list>. . .</m:position-list> ]  // SUB-NAV-MENU template is called here
      <p:content>
        <p:block [title="{block-title}"]>
          <p:items type="{article|file|news-entry|page-code|text-block}">
            . . .   // CONTENT-BLOCKS template is called here
          </p:items>
        </p:block>
        <p:block . . .>
          . . .
        </p:block>
        . . .
      </p:content>
    </p:page>
    
    into
    <html lang="{language-id}">
    
      <head>
        <title>{page-title}</title>
        . . . // PAGE-ATTRIBUTES template is called here
        <meta name="description" content="{page-description}" />
        <meta name="keywords" content=". . . {page-keywords}" />
      </head>
      
        <div class="sheet">

          <div id="page">
          
            <div id="header">
              . . . // banner for non-css goes here (img.alternative)
              <p class="alternative"><dfn title="{$p:definition-label}">{$p:site-introduction}</dfn></p>
              
              <h1>{page-title}</h1>
              
              // <select id="style-selector" tabindex="4">
              //   <option label=". . .">. . .</option>
              //   . . .
              // </select> // style selector, will be there in future
              
            </div> // div#header
            
            <div id="page-area">
            
                <div id="skip-nav-link"> // Link to allow users with non-css browsers to skip navigation
                  <span class="link-with-key">
                    <a href="#content" title="{$p:skip-nav-caption} accesskey="1" tabindex="1">{$p:skip-nav-link}</a> [1]
                  </span>
                </div> 
                
                . . . // NAV-MENU is called here
                
                <span class="alternative">  // Link to allow users of non-css and text browsers to proceed to sub-navigation
                  <a href="#sub-nav-menu" title="{$p:proceed-sub-nav-caption} accesskey="2" tabindex="2">
                    {$p:proceed-sub-nav-link}
                  </a> [2]
                </span>
                
                <div id="page-info" class="alternative">
                
                  // The image of the current page tab
                  // (A little trick from Todd Farner to hide an image from non-css browsers)
                  <a href="#" id="page-tab" title="{$p:current-page-caption}" accesskey="3">
                    <span class="alternative">({$p:current-page-link-prefix} {page-sub-title})</span>
                  </a>
                  
                  <div id="description-block">
                    <dl>
                      <dt>{page-title}</dt><dd>{page-definition}</dd>
                      <dt>W3C WCAG 1.0 &amp; Section 508</dt><dd>. . .</dd> // Some stuff about WCAG Here
                    </dl>
                  </div>
                  
                </div> // div#page-info
                
                . . . // TAB-BAR is called here
                
                . . . // SUB-NAV-MENU is called here
                
                <div id="content">
                
                  <h2>{page-sub-title}</h2>
                  <dfn>{page-description}</dfn>
                  
                  . . . // CONTENT-BLOCKS is called here
                
                </div> // div#content
                
                <span class="link-with-key" id="proceed-to-top"> // Link to allow users of non-css and text browsers (and may be later in graphic also) to proceed to the top
                  <a href="#content" title="{$p:proceed-to-top-caption}" accesskey="4" tabindex="3">
                    {$p:proceed-to-top-link}
                  </a> [4]
                </span>
                
              </div>  //div#basis
              
                <div id="adware-zone">
                  <span class="alternative">. . .</span>
                  <a href=". . ." title=". . ."><img src=". . ." alt=". . ." /></a>                
                
                  . . . // a lot more of adware here
                </div>
              
            </div> // div#page-area
            
            <div id="footer">

              <div id="logo-block">

                <div id="supported-browsers">
                  <span class="alternative">Supported browsers:</span>
                  <a id=". . ." href=". . ." title=". . ."><span class="alternative">. . .</span></a>
                  <a . . .><span class="alternative">. . .</span></a>
                  . . .
                </div> div#supported-browsers

                <div id="webstandards">
                  <span class="alternative">Used technologies from:</span>
                  <a id="ws-logo" href=". . ." title=". . ."><span class="alternative">. . .</span></a>
                </div> div#webstandards

                <div id="made-with">
                  <span class="alternative">Used software:</span>
                  <a id=". . ." href=". . ." title=". . ."><span class="alternative">. . .</span></a>
                  <a . . .><span class="alternative">. . .</span></a>                
                  . . .
                </div> // div#made-with

              </div> // div#logo-block

              <div id="copyrights-logo">
                <a href=". . ."><img src=". . ." alt=". . ." /></a>
              </div> // div#copyrights-logo

              <span id="main-copyright" class="cc">shaman.sir, 2006</span>
            </div> // div#footer
          
          </div> // div#page
          
        </div> // div.sheet
      
      </body>
    
    </html>
    
    {creation-date} must match to "((0\d)|1(1|2))/(([0-2]\d)|(3(0|1)))(/\d{4})?\s(((0|1)\d)|(2[0-4])):[0-5]\d(\.[0-5]\d)?" 
             (mm/dd[/yyyy] hh:mm[.ss]), if specified
    {page-keywords} is intented to be the list of the space separated words, describing the page, to work
    
    -->
    
    <xsl:element namespace="http://www.w3.org/1999/xhtml" name="html">
      <xsl:attribute name="lang">
        <xsl:value-of select="$p:language"/>
      </xsl:attribute>

      <head>

        <xsl:comment>
          This page is the contents of shaman.sir homesite (shaman.sir@gmail.com).

          It may be used anywhere for any good purpose (by saying "good" I mean 
          "money-independent and people-safe only"), please just don't forget to write my name 
          somewhere around (let it be "shaman.sir", ok). If we will not steal, but we will give, the peace will
          come in our land... may be
        </xsl:comment>
        
        <title>
          <xsl:value-of select="/p:page/p:title"/>
        </title>

        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

        <xsl:call-template name="page-attributes"/> <!-- ::: PAGE-ATTRIBUTES ::: -->

        <link rel="shortcut icon" href="../images/star-black.gif" type="image/gif" />

        <meta name="copyright" content="Creative Commons (cc) shaman.sir, 2006" />
        <xsl:element name="meta">
          <xsl:attribute name="name">description</xsl:attribute>
          <xsl:attribute name="content">
            <xsl:value-of select="/p:page/p:additional-data/p:description"/>
          </xsl:attribute>
        </xsl:element>
        <xsl:element name="meta">
          <xsl:attribute name="name">keywords</xsl:attribute>
          <xsl:attribute name="content">
            shaman.sir tungusso shamanStillSir t-s(S)s-o anthony kotenko web-design prose poems images ppc pocket pc programming art japan
            <xsl:value-of select="/p:page/p:additional-data/p:keywords"/>
          </xsl:attribute>
        </xsl:element>        
      </head>

      <body>

        <div class="sheet">

          <div id="page">

            <xsl:comment> header of the page </xsl:comment>
            <div id="header">
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

              <xsl:comment> here must to be the style selector later </xsl:comment>
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
            <xsl:comment> / header of the page (div#header) </xsl:comment>

            <xsl:comment> page area </xsl:comment>
            <div id="page-area">

                <xsl:comment> Link to allow users of non-css and text browsers (and may be later in graphic also) to skip navigation </xsl:comment>
                <div id="skip-nav-link">
                  <span class="link-with-key">
                    <xsl:element name="a">
                      <xsl:attribute name="href">
                        <xsl:text>#content</xsl:text>
                      </xsl:attribute>
                      <xsl:attribute name="title">
                        <xsl:value-of select="$p:skip-nav-caption"/>
                      </xsl:attribute>
                      <xsl:attribute name="accesskey">
                        <xsl:text>1</xsl:text>
                      </xsl:attribute>
                      <xsl:attribute name="tabindex">
                        <xsl:text>1</xsl:text>
                      </xsl:attribute>
                      <xsl:value-of select="$p:skip-nav-link"/>
                    </xsl:element>
                    <xsl:text> [1]</xsl:text>
                  </span>
                </div>

                <!-- Main navigation bar -->
                <xsl:if test="not(m:nav-menu) and (m:nav-menu-source)">
                  <xsl:call-template name="nav-menu"> <!-- ::: NAV-MENU ::: -->
                    <xsl:with-param name="src" select="document(m:nav-menu-source/@src)" />
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="m:nav-menu">
                  <xsl:call-template name="nav-menu"> <!-- ::: NAV-MENU ::: -->
                    <xsl:with-param name="src" select="." />
                  </xsl:call-template>
                </xsl:if>

                <xsl:comment> Link to allow users of non-css and text browsers to proceed to sub-navigation </xsl:comment>
                <span class="alternative">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:text>#sub-nav-menu</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$p:proceed-sub-nav-caption"/>
                    </xsl:attribute>
                    <xsl:attribute name="accesskey">
                      <xsl:text>2</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tabindex">
                      <xsl:text>2</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="$p:proceed-sub-nav-link"/>
                  </xsl:element>
                  <xsl:text> [2]</xsl:text>
                </span>

                <xsl:comment> page info </xsl:comment>

                <div id="page-info">

                  <!-- The image of the current page tab -->
                  <xsl:comment> (A little trick from Todd Farner to hide an image from non-css browsers) </xsl:comment>
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:text>#</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                      <xsl:text>page-tab</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$p:current-page-caption"/>
                    </xsl:attribute>
                    <xsl:attribute name="accesskey">
                      <xsl:text>3</xsl:text>
                    </xsl:attribute>
                    <span class="alternative">
                      <xsl:text>(</xsl:text>
                      <xsl:value-of select="$p:current-page-link-prefix" />
                      <xsl:text> </xsl:text>
                      <xsl:value-of select="/p:page/p:sub-title" />
                      <xsl:text>)</xsl:text>
                    </span>
                  </xsl:element>

                  <xsl:comment> description block </xsl:comment>

                  <!-- Page description block -->
                  <div id="description-block" class="alternative">
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

                  <xsl:comment> / description block (div#description-block) </xsl:comment>

                </div>
                <!-- #page-info -->

                <xsl:comment> / page info (div#page-info) </xsl:comment>

                <!-- Block with tabs for navigating between different sections -->
                <xsl:if test="not(m:tab-menu) and (m:tab-menu-source)">
                  <xsl:call-template name="tab-bar"> <!-- ::: TAB-BAR ::: -->
                    <xsl:with-param name="src" select="document(m:tab-menu-source/@src)" />
                    <xsl:with-param name="activate" select="m:tab-menu-source/@activate" />
                  </xsl:call-template>
                </xsl:if>
                <xsl:if test="m:tab-menu">
                  <xsl:call-template name="tab-bar"> <!-- ::: TAB-BAR ::: -->
                    <xsl:with-param name="src" select="." />
                  </xsl:call-template>
                </xsl:if>

                <!-- Sub navigation - navigation by sub-sections -->
                <xsl:call-template name="sub-nav-menu" /> <!-- ::: SUB-NAV-MENU ::: -->              

                <!-- The main content of the page -->

                <xsl:comment> main content </xsl:comment>
                
                <div id="content">

                  <h2>
                    <xsl:value-of select="/p:page/p:sub-title"/>
                  </h2>

                  <dfn>
                    <xsl:copy-of select="/p:page/p:additional-data/p:definition/node()"/>
                  </dfn>

                  <xsl:call-template name="content-blocks"> <!-- ::: CONTENT-BLOCKS ::: -->
                    <xsl:with-param name="lang" select="$p:language" />
                  </xsl:call-template>

                </div>
                <!-- div#content -->

                <xsl:comment> / main content </xsl:comment>

                <xsl:comment> Link to allow users of non-css and text browsers (and may be later in graphic also) to proceed to the top </xsl:comment>
                <span class="link-with-key" id="proceed-to-top">
                  <xsl:element name="a">
                    <xsl:attribute name="href">
                      <xsl:text>#content</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="$p:proceed-to-top-caption"/>
                    </xsl:attribute>
                    <xsl:attribute name="accesskey">
                      <xsl:text>4</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="tabindex">
                      <xsl:text>3</xsl:text>
                    </xsl:attribute>
                    <xsl:value-of select="$p:proceed-to-top-link"/>
                  </xsl:element>
                  <xsl:text> [4]</xsl:text>
                </span>

                <xsl:comment> adware zone </xsl:comment>

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

                  <!-- IE says something bad here, if I'm online, if OK, I need to uncomment it, but it takes long anyway -->
                  <!--                  
                  <span class="alternative">Using W3Counter</span>
                  <xsl:comment> Begin W3Counter Tracking Code </xsl:comment>
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
                  <xsl:comment> End W3Counter Tracking Code </xsl:comment>
                  -->                  

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

                <xsl:comment> / adware zone (div#adware-zone) </xsl:comment>

            </div>
            <!-- #page-area -->

            <xsl:comment> / page area (div#page-area) </xsl:comment>

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
                shaman.sir, 2006-2007
              </span>
            </div>
            <!-- #footer -->

          </div>
          <!-- #page -->

        </div>
        <!-- .sheet -->

      </body>

    </xsl:element>

    <!-- %%%%%%%[ / XHTML CONTENT ]%%%%%%% -->
  </xsl:template>

</xsl:stylesheet>