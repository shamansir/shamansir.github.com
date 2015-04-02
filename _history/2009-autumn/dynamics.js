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

/**
 * Loads any XML document using ActiveX (for IE) or createDocumentFunction (for 
 * other browsers)
 * @param {String} fileName name of the file to be loaded
 * @return {XMLDocument|Object}
 */
function loadXML(fileName) { // http://www.w3schools.com/xsl/xsl_client.asp    
    var xmlFile = null;
    
    if (window.ActiveXObject) { // IE
        xmlFile = new ActiveXObject("Microsoft.XMLDOM");
    } else if (document.implementation 
            && document.implementation.createDocument) { // Mozilla, Firefox, Opera, etc.
        xmlFile = document.implementation.createDocument("","",null);
        if (!xmlFile.load) { // Safari lacks on this method,
        	   // so we make a synchronous XMLHttpRequest
        	var request = makeRequest(fileName, null, null, true);
        	return request.responseXML;
        }
    } else {
        alert('Your browser cannot create XML DOM Documents');
    }
    xmlFile.async = false;
    try {
        xmlFile.load(fileName);
    } catch(e) {
        alert('an error occured while loading XML file ' + fileName);
    }
    return(xmlFile);
}

/**
 * Applies specified XSL stylesheet to the specified XML file and returns
 * the result as a string. ActiveX is used in IE, otherwise, XSLTProcessor
 * is used.
 * @param {String} xmlFileName path to the xml file to be transformed
 * @param {String} xslFileName path to the xsl file to be applied to the xml
 * @return {String} xsl transformation result as a text
 */
function getStylingResult(xmlFileName, xslFileName) { 
	var xmlContent = loadXML(xmlFileName);
	var xslContent = loadXML(xslFileName);
    if (window.ActiveXObject) { // IE
        return xmlContent.transformNode(xslContent);        
    } else if (window.XSLTProcessor) { // Mozilla, Firefox, Opera, etc.
        var xsltProcessor=new XSLTProcessor();
        xsltProcessor.importStylesheet(xslContent);
        // return xsltProcessor.transformToFragment(xmlContent, document); 
                // somehow, transformToFragment works incorrectly, recognizing the
                // result of transformation as xml, not html, because 
                // xsl:output="xhtml" is still not supported, and for xhtml
                // xsl:output="xml" is used 
                // (xsl:output="html" strips namespaces)
                // see: http://osdir.com/ml/mozilla.devel.layout.xslt/2003-10/msg00008.html
                // also, see: https://developer.mozilla.org/en/Using_the_Mozilla_JavaScript_interface_to_XSL_Transformations
        var resultDocument = xsltProcessor.transformToDocument(xmlContent);
        var xmls = new XMLSerializer();   
        return xmls.serializeToString(resultDocument);
    }
}