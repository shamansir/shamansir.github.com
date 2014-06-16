var occurencesByTypeMapping = {
    "openid": 
        { address: "http://%id%.myopenid.com", 
          icon: "openid.gif", 
          site: "http://openid.net" },
	/* messengers */
	"icq": 
		{ address: "http://icq.com/%id%", 
    	  icon: "icq.png", 
    	  site: "http://icq.com" 
	    },
	"skype": 
		{ address: "skype:%id%?userinfo", 
    	  icon: "skype.ico", 
    	  site: "http://skype.com" },
	"jabber": 
		{ address: "xmpp:%id%?vcard", 
		  icon: "jabber.png", 
		  site: "http://jabber.org" },
	"gtalk": 
		{ address: "gtalk:chat?jid=%id%@gmail.com", 
		  icon: "gtalk.png", 
		  site: "http://www.google.com/talk" }, // information link?
    /* email */
	"gmail": 
		{ address: "mailto:%id%@gmail.com", 
		  icon: "gmail.ico", 
		  site: "http://gmail.com" },
	"yahoo-profile": 
		{ address: "http://profiles.yahoo.com/%id%", 
		  icon: "yahoo-profile.png", 
		  site: "http://yahoo.com" },
	"yahoo": 
		{ address: "mailto:%id%@yahoo.com", 
		  icon: "yahoo.png", 
		  site: "http://mail.yahoo.com" },
	"zenbe": 
		{ address: "mailto:%id%@zenbe.com", 
		  icon: "zenbe.ico", 
		  site: "http://zenbe.com" },
    /* blogging */
    "wikidot": 
    	{ address: "http://%id%.wikidot.com", 
    	  icon: "wikidot.gif", 
    	  site: "http://wikidot.com" },
    "wordpress": 
    	{ address: "http://%id%.wordpress.com", 
    	  icon: "wordpress-white.png", 
    	  site: "http://wordpress.com" },
    "livejournal": 
    	{ address: "http://%id%.livejournal.com", 
    	  icon: "livejournal.ico", 
    	  site: "http://wordpress.com" },
    /* microblogging */
    "twitter": 
    	{ address: "http://twitter.com/%id%", 
    	  icon: "twitter.ico", 
    	  site: "http://twitter.com" },
    "plurk": 
    	{ address: "http://www.plurk.com/user/%id%", 
    	  icon: "plurk.png", 
    	  site: "http://www.plurk.com" },
    /* coblogging */
    "dirty": 
    	{ address: "http://dirty.ru/users/%id%", 
    	  icon: "dirty.ico", 
    	  site: "http://dirty.ru" },
    "leprosorium": 
    	{ address: "http://leprosorium.ru/users/%id%", 
    	  icon: "leprosorium.ico", 
    	  site: "http://leprosorium.ru" },
    "habrahabr": 
    	{ address: "http://%id%.habrahabr.ru", 
    	  icon: "habrahabr.ico", 
    	  site: "http://habrahabr.ru" },
    "autokadabra": 
    	{ address: "http://%id%.autokadabra.ru", 
    	  icon: "autokadabra.ico", 
    	  site: "http://autokadabra.ru" },
    "scarypeople": 
    	{ address: "http://www.scarypeople.ru/userinfo.php?uid=%id%", 
    	  icon: "scary.ico", 
    	  site: "http://scarypeople.ru" },
    /* social */
    "linked-in": 
    	{ address: "http://www.linkedin.com/in/%id%", 
    	  icon: "linkedin.ico", 
    	  site: "http://linkedin.com" },    
    "facebook": 
    	{ address: "http://www.facebook.com/profile.php?id=%id%", 
    	  icon: "facebook.gif", 
    	  site: "http://facebook.com" },
    "vkontakte": 
    	{ address: "http://vkontakte.ru/id%id%", 
    	  icon: "vkontakte.ico", 
    	  site: "http://vkontakte.ru" },
    /* wiki */
    "wikidot-profile":
        { address: "http://ru.wikibooks.org/wiki/Участник:%id%",
          icon: "wikidot.gif",
          site: "http://wikidot.com" },    	  
    "wikibooks":
        { address: "http://ru.wikibooks.org/wiki/Участник:%id%",
          icon: "wikibooks.ico",
          site: "http://ru.wikibooks.org" },
    /* special */ 
    "launchpad":
        { address: "http://launchpad.net/~%id%",
          icon: "launchpad.png",
          site: "http://launchpad.net" },
    "googlecode":
        { address: "http://code.google.com/u/%id%",
          icon: "googlecode.ico",
          site: "http://code.google.com" },
    "rpod":
        { address: "http://u%id%.rpod.ru",
          icon: "rpod.ico",
          site: "http://rpod.ru" },
    "deviantart":
        { address: "http://%id%.deviantart.com",
          icon: "deviantart.png",
          site: "http://deviantart.com/" },
    "lastfm": 
    	{ address: "http://www.last.fm/user/%id%", 
    	  icon: "lastfm.png", 
    	  site: "http://last.fm" },          
    "notabenoid":
        { address: "http://notabenoid.com/users/%id%",
          icon: "notabenoid.ico",
          site: "http://notabenoid.com" }, 
    "livemocha":
        { address: "http://www.livemocha.com/profiles/view/%id%",
          icon: "livemocha.ico",
          site: "http://www.livemocha.com" }, 
    "ag": 
    	{ address: "http://forums.ag.ru/?action=viewprofile&username=%id%", 
    	  icon: "ag.ico", 
    	  site: "http://ag.ru" },  
    "vimeo":
        { address: "http://www.vimeo.com/user%id%",
          icon: "vimeo.ico",	
          site: "http://www.vimeo.com" },
    "stack-overflow":
        { address: "http://stackoverflow.com/users/%id%",
          icon: "stack-overflow.ico",
          site: "http://stackoverflow.com" },
    "torrents":
        { address: "http://torrents.ru/forum/profile.php?mode=viewprofile&u=%id%",
          icon: "torrents.ico",
          site: "http://torrents.ru" },
    "todoist":
        { address: "http://todoist.com/",
          icon: "todoist.ico",
          site: "http://todoist.com/" },          
    "foxmarks": 
        { address: "http://foxmarks.com", 
          icon: "foxmarks.png", 
          site: "http://foxmarks.com" },
    "sdf": 
        { address: "http://%id%.freeshell.org", 
          icon: "sdf.ico", 
          site: "http://sdf.lonestar.org/" },
    /* online-games */
    "second-life":
        { address: "http://secondlife.com/",
          icon: "secondlife.ico",
          site: "http://secondlife.com/" },
    "project-torque":
        { address: "http://profile.aeriagames.com/user/%id%",
          icon: "project-torque.ico",
          site: "http://project-torque.aeriagames.com" },
    "teeworlds":
        { address: "http://teeworlds.com",
          icon: "teeworlds.ico",
          site: "http://teeworlds.com" }
    /* if mail -> replace ape and dot as [at] [dot] */
}

var SECTION_ID = 'occurences';

sectorsMap[SECTION_ID].additionalHtml = '<style type="text/css">table.lfmWidgetchart_e75075d15bd5d46a3998630193a6e2aa td {margin:0 !important;padding:0 !important;border:0 !important;}table.lfmWidgetchart_e75075d15bd5d46a3998630193a6e2aa tr.lfmHead a:hover {background:url(http://cdn.last.fm/widgets/images/en/header/chart/recenttracks_regular_blue.png) no-repeat 0 0 !important;}table.lfmWidgetchart_e75075d15bd5d46a3998630193a6e2aa tr.lfmEmbed object {float:left;}table.lfmWidgetchart_e75075d15bd5d46a3998630193a6e2aa tr.lfmFoot td.lfmConfig a:hover {background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat 0px 0 !important;;}table.lfmWidgetchart_e75075d15bd5d46a3998630193a6e2aa tr.lfmFoot td.lfmView a:hover {background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat -85px 0 !important;}table.lfmWidgetchart_e75075d15bd5d46a3998630193a6e2aa tr.lfmFoot td.lfmPopup a:hover {background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat -159px 0 !important;}</style><table class="lfmWidgetchart_e75075d15bd5d46a3998630193a6e2aa" cellpadding="0" cellspacing="0" border="0" style="width:184px;"><tr class="lfmHead"><td><a title="shamansir: Recently Listened Tracks" href="http://www.last.fm/user/shamansir" target="_blank" style="display:block;overflow:hidden;height:20px;width:184px;background:url(http://cdn.last.fm/widgets/images/en/header/chart/recenttracks_regular_blue.png) no-repeat 0 -20px;text-decoration:none;border:0;"></a></td></tr><tr class="lfmEmbed"><td><object type="application/x-shockwave-flash" data="http://cdn.last.fm/widgets/chart/19.swf" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" id="lfmEmbed_691036083" width="184" height="179"> <param name="movie" value="http://cdn.last.fm/widgets/chart/19.swf" /> <param name="flashvars" value="type=recenttracks&amp;user=shamansir&amp;theme=blue&amp;lang=en&amp;widget_id=chart_e75075d15bd5d46a3998630193a6e2aa" /> <param name="allowScriptAccess" value="always" /> <param name="allowNetworking" value="all" /> <param name="allowFullScreen" value="true" /> <param name="quality" value="high" /> <param name="bgcolor" value="6598cd" /> <param name="wmode" value="transparent" /> <param name="menu" value="true" /> </object></td></tr><tr class="lfmFoot"><td style="background:url(http://cdn.last.fm/widgets/images/footer_bg/blue.png) repeat-x 0 0;text-align:right;"><table cellspacing="0" cellpadding="0" border="0" style="width:184px;"><tr><td class="lfmConfig"><a href="http://www.last.fm/widgets/?colour=blue&amp;chartType=recenttracks&amp;user=shamansir&amp;chartFriends=0&amp;from=code&amp;widget=chart" title="Get your own widget" target="_blank" style="display:block;overflow:hidden;width:85px;height:20px;float:right;background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat 0px -20px;text-decoration:none;border:0;"></a></td><td class="lfmView" style="width:74px;"><a href="http://www.last.fm/user/shamansir" title="View shamansir`s profile" target="_blank" style="display:block;overflow:hidden;width:74px;height:20px;background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat -85px -20px;text-decoration:none;border:0;"></a></td><td class="lfmPopup"style="width:25px;"><a href="http://www.last.fm/widgets/popup/?colour=blue&amp;chartType=recenttracks&amp;user=shamansir&amp;chartFriends=0&amp;from=code&amp;widget=chart&amp;resize=1" title="Load this chart in a pop up" target="_blank" style="display:block;overflow:hidden;width:25px;height:20px;background:url(http://cdn.last.fm/widgets/images/en/footer/blue.png) no-repeat -159px -20px;text-decoration:none;border:0;" onclick="window.open(this.href + \'&amp;resize=0\',\'lfm_popup\',\'height=279,width=234,resizable=yes,scrollbars=yes\'); return false;"></a></td></tr></table></td></tr></table>';

dataSource = occurencesByTypeMapping;