var sectorsMap = {
	'personal-data': {
	    name: 'Personal Data',
	    xslFile: 'vcard-profile',
	    description: 'The basic information about me, as a VCard',
	    additionalHtml: '',
	    icon: 'imprint_16'
	},
	'contacts': {
	    name: 'Contacts',
        description: 'The contact data, which may be used to communicate with me',
        additionalHtml: '',
        script: 'contacts-mapping-data',
        itemID: 'contact',
        icon: 'adressbook_16'/*,
        linksParser: */
	},
	'occurences': {
	    name: 'Occurences',
        description: 'The places, where you can find me',
        additionalHtml: '',
        script: 'occurences-mapping-data',
        itemID: 'occurence',
        icon: 'internet_16'
	},
	'favourites': {
		name: 'Favourites',
        description: 'The stuff I like',
        additionalHtml: '',
        icon: 'star_outline_16'
	}/*
	'projects': {
	
	}, 
	'resume': {
    
    },*/
}

/* personal-info block description */

/* IDs */
var CONTENT_ELM_ID = 'content';
var NAV_ELM_ID = 'nav-menu';
var NAV_INFO_ELM_ID = 'nav-info';
var PERSONAL_INFO_ELM_ID = 'personal-info';
var ADDITIONAL_BLOCK_ELM_ID = 'additional-block';

/* paths */
var XML_DATA_PATH = './';
var XSL_SHEETS_PATH = './';
var SCRIPTS_PATH = './';
var APPS_ICONS_PATH = './icons/apps/';
var SECTORS_ICONS_PATH = './icons/';
var SECTOR_ICONS_EXT = '.gif';

/* classes */
// var LINK_TITLE_CLASS = '';

/* ids prefixes/postfixes */
var ITEM_LINK_POSTFIX = '-link';
var SITE_LINK_POSTFIX = '-sitelink';
var ICON_ELM_POSTFIX = '-icon';

var lastScriptLoaded = null;
var lastClickedNavLink = null;
var activeLinkText = '';

var dataSource = null;

function showNavInfo(text) {
	var navInfoElm = document.getElementById(NAV_INFO_ELM_ID);
    navInfoElm.innerHTML = '';
    navInfoElm.appendChild(document.createTextNode(text));
}

function generateNavLinks() {
    var navElm = document.getElementById(NAV_ELM_ID);
    navElm.innerHTML = '';
    for (sectorID in sectorsMap) {
        var sectorData = sectorsMap[sectorID];
        
        var liElm = document.createElement('li');
        
        var linkElm = document.createElement('a');
        linkElm.sectorCode = sectorID;
        linkElm.sectorItemID = sectorData.itemID;
        linkElm.sectorInfo = sectorData.description;
        linkElm.xmlFile = XML_DATA_PATH + (sectorData.xmlFile ? 
                sectorData.xmlFile : sectorID) + '.xml';
        linkElm.xslFile = XSL_SHEETS_PATH + (sectorData.xslFile ? 
                sectorData.xslFile : sectorID) + '.xsl';
        linkElm.scriptSrc = sectorData.script; 
        linkElm.title = sectorData.name;
        linkElm.href = XML_DATA_PATH + sectorID + '.xml';
        linkElm.onclick = function() {
        	if (lastClickedNavLink) lastClickedNavLink.parentNode.id = null;
        	this.parentNode.id = 'nav-active';
        	lastClickedNavLink = this;
        	
        	showNavInfo(this.sectorInfo);
            activeLinkText = this.sectorInfo;
            sectorId = this.sectorCode;
            sectorItemId = this.sectorItemID;

            document.getElementById(CONTENT_ELM_ID).innerHTML = 
                getStylingResult(this.xmlFile, this.xslFile);
                
            if (this.scriptSrc) {
                if (lastScriptLoaded) document.body.removeChild(lastScriptLoaded);
                
                var newScript = document.createElement('script');
                newScript.src = SCRIPTS_PATH + this.scriptSrc + '.js';
                newScript.type = 'text/javascript';
                newScript.onreadystatechange= function () {
                   if (this.readyState == 'complete') {
                       if (dataSource && sectorItemId) {
                            wrapLinksWithData(sectorItemId, dataSource);
                            loadAdditionalHtml(sectorId);
                       }
                       dataSource = null;
                   }
                }
                newScript.onload=function () {
                   if (dataSource && sectorItemId) {
                        wrapLinksWithData(sectorItemId, dataSource);
                        loadAdditionalHtml(sectorId);
                   }
                   dataSource = null;
                };                
                document.body.appendChild(newScript);                
                lastScriptLoaded = newScript;
            }
            
            return false;
        };
        linkElm.onmouseover = function() {
        	showNavInfo(this.sectorInfo);
        }
        linkElm.onmouseout = function() {
            showNavInfo(activeLinkText);
        }
        
        var imgElm = document.createElement('img');
        imgElm.src = SECTORS_ICONS_PATH + 
             (sectorData.icon ? sectorData.icon : sectorID) + SECTOR_ICONS_EXT;
        imgElm.title = sectorData.name;
        imgElm.alt = sectorData.description;
        linkElm.appendChild(imgElm);
        
        var spanElm = document.createElement('span');               
        // spanElm.className = '';
        spanElm.appendChild(document.createTextNode(sectorData.name));
        linkElm.appendChild(spanElm);
        
        liElm.appendChild(linkElm);
        navElm.appendChild(liElm);
    }
	
}

function clickNavLink(linkIdx) {
	var navElm = document.getElementById(NAV_ELM_ID);	
    // navElm.childNodes[linkIdx].id = 'nav-active';
    navElm.childNodes[linkIdx].firstChild.onclick();    
} 

function wrapLinksWithData(sectorItemID, itemsDataSource) {
    for (itemID in itemsDataSource) {
        var itemData = itemsDataSource[itemID];
        var siteLinkElm = document.getElementById(sectorItemID + '-' + itemID + SITE_LINK_POSTFIX);
        var iconElm = document.getElementById(sectorItemID + '-' + itemID + ICON_ELM_POSTFIX);
        var itemLinkElm = document.getElementById(sectorItemID + '-' + itemID + ITEM_LINK_POSTFIX);
        if (siteLinkElm) siteLinkElm.href = itemData.site;
        if (iconElm) iconElm.src = (itemData.icon.match(/^http:\/\//) ? '' : APPS_ICONS_PATH) + itemData.icon.replace(/\%id\%/, itemLinkElm.title);
        if (itemLinkElm) itemLinkElm.href = itemData.address.replace(/\%id\%/, itemLinkElm.title);
    }
}

function loadAdditionalHtml(sectorID) {
    document.getElementById(ADDITIONAL_BLOCK_ELM_ID).innerHTML =
       sectorsMap[sectorID].additionalHtml;
}