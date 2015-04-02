var urlByTypeMapping = {
	"icq": { address: "http://icq.com/%id%", icon: "./icons/icq.png", site: "http://icq.com" },
	"skype": { address: "skype:%id%?userinfo", icon: "./icons/skype.ico", site: "http://skype.com" }, 
	"jabber": { address: "xmpp:%id%?vcard", icon: "./icons/jabber.png", site: "http://jabber.org" },
	"gtalk": { address: "gtalk:chat?jid=%id%@gmail.com", icon: "./icons/gtalk.png", site: "http://www.google.com/talk/" }, // information link?	
	"gmail": { address: "mailto:%id%@gmail.com", icon: "./icons/gmail.ico", site: "http://gmail.com" },	
	"yahoo-profile": { address: "http://profiles.yahoo.com/%id%", icon: "./icons/yahoo-profile.png", site: "http://yahoo.com" },
	"yahoo": { address: "mailto:%id%@yahoo.com", icon: "./icons/yahoo.png", site: "http://mail.yahoo.com" },
	"zenbe": { address: "mailto:%id%@zenbe.com", icon: "./icons/zenbe.ico", site: "http://zenbe.com" },	
	"openid": { address: "http://%id%.myopenid.com", icon: "./icons/openid.png", site: "http://openid.net" },	
	"lastfm": { address: "http://www.last.fm/user/%id%", icon: "./icons/lastfm.png", site: "http://last.fm" },
	"facebook": { address: "http://www.facebook.com/profile.php?id=%id%", icon: "./icons/facebook.gif", site: "http://facebook.com" },
	"linked-in": { address: "http://www.linkedin.com/in/%id%", icon: "./icons/linkedin.ico", site: "http://linkedin.com" },
	"wikidot": { address: "http://%id%.wikidot.com", icon: "./icons/wikidot.gif", site: "http://wikidot.com" },	
	"wordpress": { address: "http://%id%.wordpress.com", icon: "./icons/wordpress-white.png", site: "http://wordpress.com" },
	"livejournal": { address: "http://%id%.livejournal.com", icon: "./icons/livejournal.ico", site: "http://wordpress.com" },	
	"foxmarks": { address: "http://foxmarks.com", icon: "./icons/foxmarks.png", site: "http://foxmarks.com" },
	"dirty": { address: "http://dirty.ru/users/%id%", icon: "./icons/dirty.ico", site: "http://dirty.ru" },
	"leprosorium": { address: "http://leprosorium.ru/users/%id%", icon: "./icons/leprosorium.ico", site: "http://leprosorium.ru" },
	"habrahabr": { address: "http://%id%.habrahabr.ru", icon: "./icons/habrahabr.ico", site: "http://habrahabr.ru" },
	"autokadabra": { address: "http://%id%.autokadabra.ru", icon: "./icons/autokadabra.ico", site: "http://autokadabra.ru" },
	"scarypeople": { address: "http://www.scarypeople.ru/userinfo.php?uid=%id%", icon: "./icons/scary.ico", site: "http://scarypeople.ru" },
	"vkontakte": { address: "http://vkontakte.ru/id%id%", icon: "./icons/vkontakte.ico", site: "http://vkontakte.ru" },
	"ag": { address: "http://forums.ag.ru/?action=viewprofile&username=%id%", icon: "./icons/ag.ico", site: "http://ag.ru" },
	"twitter": { address: "http://twitter.com/%id%", icon: "./icons/twitter.ico", site: "http://twitter.com" }	
/* lastfm block */
/* if mail -> replace ape and dot as [at] [dot] */
}
