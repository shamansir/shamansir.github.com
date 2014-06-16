/*++ Copyright (c) 2007 Fotonation  Inc.  All rights reserved.*/
/* requires: neos-core.js */

/*  OOP Support

	from: http://www.ajaxpath.com/javascript-inheritance,
	see also: http://ajaxpatterns.org/Javascript_Inheritance */

function Class() {

}

Class.prototype.construct = function() {

};

Class.extend = function(def) {
    var classDef = function() {
        if (arguments[0] !== Class) {
            this.construct.apply(this, arguments);
        }
    };

    var proto = new this(Class);
    var superClass = this.prototype;

    for (var n in def) {
        var item = def[n];
        if (item instanceof Function) item.$ = superClass; else classDef[n] = item;
        proto[n] = item;
    }

    classDef.prototype = proto;

    classDef.extend = this.extend;
    return classDef;
};

/**
 * Creates a reference to the instance method, so the returned value may be used
 * as a function, but in fact will be called as method of the concrete instance
 * @param {Object} object instance object
 * @param {String} methodName name of the method
 * @return {Function} a reference to the method 
 */
function createMethodReference(object, methodName) {
    return function () {
        return object[methodName].apply(object, arguments);
    };
}
;

/**
 * creates a hash (use new Hash()), using the arguments list (like
 * ['key1', 'value1'], ['key2', 'value2'], ['key3', 'value3'])
 * @return {Object} object with the items property (items['key'] = 'value') and
 *         length property, specifiying the number of items
 */
function Hash()
{
    this.length = 0;
    this.items = new Array();
    for (var i = 0; i < arguments.length; i++) {
        this.items[arguments[i][0]] = arguments[i][1];
    }
}

/* Logging */

function LOG(informerName, text) {
    var logElement = document.getElementById('LOG_DIV');
    if (logElement) {
        logElement.appendChild(document.createTextNode(informerName + ': ' + text));
        logElement.appendChild(document.createElement('br'));
        logElement.scrollTop += 50;
    }
}

var Console = Class.extend({ 
	// the stub class to allow using console when browser have it,
	// if not - just pass all calls
	construct: function() {},
	log: function() { },
	info: function() { },
	warn: function() { },	
	error: function() { }
	
});

if (!window.console) {
	console = new Console();
}

/*
window.onerror = function (err, file, line) {
	console.error("Error " + err + ". Message:" + err.message + "; Description: " + err.description + "; [ File: " + file + "; Line: " + line + "]");
	return true;
} */

/* A little additions for internal objects */

Number.prototype.NaN0=function(){return isNaN(this)?0:this;}

Number.prototype.getFStr=function(fillNum){var fillNum=fillNum?fillNum:2;var temp=""+this;while(temp.length<fillNum)temp="0"+temp;return temp;}

Number.prototype.inBounds=function(start,stop){return ((this>=start)&&(this<stop))?true:false;};

function boolFromObj(obj){return(((obj=="true")||(obj == true))?true:false);}

String.prototype.trim=function(){var temp = this.replace( /^\s+/g, "" );return temp.replace( /\s+$/g, "" );}

String.prototype.asBoolVal=function(){return ((this=="true")?true:false);}

Boolean.prototype.asBoolVal=function(){return ((this==true)?true:false);} 

String.prototype.isEmpty=function(){return this.trim()=="";}


function intComparator(a, b) {
	return a - b; 
}

function getObjSortedProps(obj, sortFunc) {
	var propsArr = [];
	for (propName in obj) {
		propsArr.push(propName);
	}
	return propsArr.sort(sortFunc);
	//return sortFunc ? propsArr.sort() : propsArr.sort(sortFunc);
}

function indexOf(arr, elem) {
	for (itemIdx in arr) {
		if (arr[itemIdx] == elem) return itemIdx;
	}
	return null;
}

function removeFromArray(arr, element) { // removes only one item!
	for (itemIndex in arr) {
		if (arr[itemIndex] == element) {
			arr.splice(itemIndex, 1);
			return arr;
		}
	}
	return null;
}

var IS_IE			= NEOS['Browser'].MSIE;
var IS_FF			= NEOS['Browser'].Gecko;
var IS_SAFARI		= NEOS['Browser'].Safari;
var IS_SAFARI3		= NEOS['Browser'].Safari3;

/* Coordinates */
/* look: http://blog.firetree.net/2005/07/04/javascript-find-position/ */

function findOffsetHeight(e) {
	var res = 0;
	while ((res == 0) && e.parentNode) {
		e = e.parentNode;	
		res = e.offsetHeight; 
	}
	return res;
}

function findPos(e) {
	var baseEl = e;
	var curleft = 0;
	var curtop = 0;
	if (e.offsetParent) {
		do {		
			curleft += e.offsetLeft;
			curtop += e.offsetTop;
		} while (e = e.offsetParent);
	}
	var docBody = document.documentElement ? document.documentElement : document.body;
	if (docBody) {
		curleft += (baseEl.currentStyle?(parseInt(baseEl.currentStyle.borderLeftWidth)).NaN0():0) +
				   (IS_IE ? (parseInt(docBody.scrollLeft)).NaN0() : 0) - (parseInt(docBody.clientLeft)).NaN0();
		curtop  += (baseEl.currentStyle?(parseInt(baseEl.currentStyle.borderTopWidth)).NaN0():0) +
				   (IS_IE ? (parseInt(docBody.scrollTop)).NaN0() : 0) - (parseInt(docBody.clientTop)).NaN0();
	}	 
	return {x: curleft, y:curtop};
}

function mouseCoords(ev){
	if(ev.pageX || ev.pageY){
		return {x:ev.pageX, y:ev.pageY};
	} 
	/* look: http://xhtml.ru/2007/03/10/advanced-thumbnail-creator/ */
	/* look: http://www.habrahabr.ru/blog/webdev/13897.html */	
	/* look: http://quirksmode.org/js/events_properties.html */
	var docBody = document.documentElement ? document.documentElement : document.body;	

	return {
		x: ev.clientX + docBody.scrollLeft - docBody.clientLeft,
		y: ev.clientY + docBody.scrollTop  - docBody.clientTop
		// x: ev.clientX + document.body.scrollLeft + document.documentElement.scrollLeft,
		// y: e.clientY + document.body.scrollTop + document.documentElement.scrollTop		
	};
}

function getMouseOffset(target, ev){
	ev = ev || window.event;

	var docPos    = findPos(target);
	var mousePos  = mouseCoords(ev);
	
	//console.log("mousePos:", target.id ? target.id : target.nodeName, "x:" + (mousePos.x - docPos.x), "y: " + (mousePos.y - docPos.y));		
	
	return {
		x: mousePos.x - docPos.x, 
		y: mousePos.y - docPos.y
	};
}

/* Extensions */

function cloneObj(objToClone) {

	var clone = [];
	for (i in objToClone) {
		clone[i] = objToClone[i];
	}
	return clone;
}

function getFileName(filePath) {
	var slashPos = filePath.lastIndexOf('/');
	if (slashPos < 0) slashPos = filePath.lastIndexOf('\\');
	return filePath.substring(slashPos); 
}

function _xor(a,b) {
  return ( a || b ) && !( a && b );
}

/* DOM */

var NS_SYMB				= ':';

/* Recursive function, walking through the node tree,
   and applying another function to each node (and passing
   current node and optional data package there). Differs from 
   DOM TreeWalker, anyway not appliable to IE */

function walkTree(node, mapFunction, dataPackage) {
	if (node == null) return;
	mapFunction(node, dataPackage);
	for (var i = 0; i < node.childNodes.length; i++) {
		walkTree(node.childNodes[i], mapFunction, dataPackage);
	}
}

function searchTree(node, searchFunction, dataPackage) {
	if (node == null) return;
	var funcResult = searchFunction(node, dataPackage);
	if (funcResult) return funcResult;
	for (var i = 0; i < node.childNodes.length; i++) {
		var searchResult = searchTree(node.childNodes[i], searchFunction, dataPackage);
		if (searchResult) return searchResult;
	}
}

function removeChildrenRecursively(node)
{
	if (!node) return;
	while (node.hasChildNodes()) {
		removeChildrenRecursively(node.firstChild);
		node.removeChild(node.firstChild);
	}
}

function removeElementById(nodeId) {
	document.getElementById(nodeId).parentNode.removeChild(document.getElementById(nodeId));
}

function getElementContent(element) {
    if(element==null){
    	return "";
    }
	return IS_SAFARI ? element.innerHTML : (element.textContent ? element.textContent : element.innerText);
}

/* function getElementsByClass( searchClass, domNode, tagName) {
	if (domNode == null) domNode = document;
	if (tagName == null) tagName = '*';
	var el = new Array();
	var tags = domNode.getElementsByTagName(tagName);
	var tcl = " "+searchClass+" ";
	for(i=0,j=0; i<tags.length; i++) {
		var test = " " + tags[i].className + " ";
		if (test.indexOf(tcl) != -1)
			el[j++] = tags[i];
	}
	return el;
} */

/* Attributes */

var IS_SAFARI			= NEOS['Browser'].Safari;

function getElmAttr(elm, attrName, ns) {
	// IE6 fails getAttribute when used on table element
	var elmValue = null;
	try {
		elmValue = (elm.getAttribute ? elm.getAttribute((ns ? (ns + NS_SYMB) : '') + attrName) : null);
	} catch (e) { return null; }
	if (!elmValue && IS_SAFARI) {
		elmValue = (elm.getAttributeNS ? elm.getAttributeNS(ns, attrName) : null);
	}
	return elmValue;
}

function setElmAttr(elm, attrName, value, ns) {
	if (!IS_SAFARI || !ns) {
		return (elm.setAttribute ? elm.setAttribute((ns ? (ns + NS_SYMB) : '') + attrName, value) : null);
	} else {
		return (elm.setAttributeNS ? elm.setAttributeNS(ns, attrName, value) : null);
	}
}

function remElmAttr(elm, attrName, ns) {
	if (!IS_SAFARI || !ns) {
		return (elm.removeAttribute ? elm.removeAttribute((ns ? (ns + NS_SYMB) : '') + attrName) : null);
	} else {
		return (elm.removeAttributeNS ? elm.removeAttributeNS(ns, attrName) : null);
	}
}

/* Object converter */

/* to thest things like 
   if(name in oc(['bobby','sue','smith'])) { ... }
   (from http://snook.ca/archives/javascript/testing_for_a_v/) */

function oc(a)
{
  var o = {};
  for(var i=0;i<a.length;i++)
  {
    o[a[i]]='';
  }
  return o;
}

/* Time */

function getTime() {
	return new Date().getTime();
}

/**
 * Browser-independent AJAX call
 * 
 * @param {String} locationURL an URL to call, without parameters
 * @param {String} [parameters=null] a parameters list, in the form 
 *        'param1=value1&param2=value2&param3=value3'
 * @param {Function(XHMLHTTPRequest, Object)} [onComplete=null] a function that
 *        will be called when the response (responseText or responseXML of 
 *        XHMLHTTPRequest) will be received
 * @param {Boolean} [doSynchronous=false] make a synchronous request (onComplete
 *        will /not/ be called)        
 * @param {Boolean} [doPost=false] make a POST request instead of GET        
 * @param {Object} [dataPackage=null] any object to transfer to the onComplete 
 *        listener
 * @return {XHMLHTTPRequest} request object, if no exceptions occured
 */
function makeRequest(locationURL, parameters, onComplete, doSynchronous, doPost, dataPackage) {

    var http_request = false;
    try {
        http_request = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e1) {
        try {
            http_request= new ActiveXObject("Microsoft.XMLHTTP");
        } catch (e2) {
            http_request = new XMLHttpRequest();
        }
    }

    //if (http_request.overrideMimeType) { // optional
    //  http_request.overrideMimeType('text/xml');
    //}

    if (!http_request) {
      alert('Cannot create XMLHTTP instance');
      return false;
    }

    if (onComplete && !doSynchronous) {
        completeListener = function() { 
            if (http_request.readyState == 4) {
                if (http_request.status == 200) {
                    onComplete(http_request, dataPackage)
                }
            }
        };
        http_request.onreadystatechange = completeListener;
    }
        

    //var salt = hex_md5(new Date().toString());
    if (doPost) {
        http_request.open('POST', locationURL, !doSynchronous);
        http_request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http_request.setRequestHeader("Content-length", parameters.length);
        http_request.setRequestHeader("Connection", "close");
        http_request.send(parameters);
    } else {
        http_request.open('GET', locationURL + (parameters ? ("?" + parameters) : ""), !doSynchronous);
        //http_request.open('GET', './proxy.php?' + parameters +
                    // "&salt=" + salt, true);
        http_request.send(null);                        
    }
    
    return http_request;
   
}

/* Element Wrapper class to wrap any DOM element */

var ElementWrapper = Class.extend({

	construct: 
		function(elementId) {
			this.elementId = elementId;
			this.element = null;
			this._initializeElement();
		},
		
	_initializeElement: 
		function() {
		
			if (!document.getElementById(this.elementId)) {
				this.element = document.createElement('div');
				this.element.id = this.elementId;
			} else {
				this.element = document.getElementById(this.elementId);
			}
			
		}

});
