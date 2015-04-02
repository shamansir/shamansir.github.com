function generateLinks(idsPrefix) {
	for (var linkType in urlByTypeMapping) {
		var infodata = urlByTypeMapping[linkType];
		var imgElement = document.getElementById(idsPrefix + "-" + linkType + "-icon");
		var sitelinkElement = document.getElementById(idsPrefix + "-" + linkType + "-sitelink");		
		var linkElement = document.getElementById(idsPrefix + "-" + linkType + "-link");
		var userId = (linkElement) ? linkElement.title : "";
		if (imgElement) {		
			/* spanElement.innerHTML = "";
			spanElement.innerText = ""; */
            /* imgElement.style.width = "16px";
            imgElement.style.height = "16px"; */
            imgElement.src = infodata.icon.replace("%id%", userId);
			/* imgElement.style.backgroundImage = "url('" + infodata.icon.replace("%id%", userId) + "') no-repeat"; */
			/* imgElement.onclick = function(siteLink) { return function() { window.open(siteLink, "_blank") } }(infodata.site);
			imgElement.style.cursor = "pointer"; */
		}
		if (sitelinkElement) {
		    sitelinkElement.href = infodata.site; 
        }
		if (linkElement) {
			linkElement.href = infodata.address.replace("%id%", userId);
		}
	}
}
