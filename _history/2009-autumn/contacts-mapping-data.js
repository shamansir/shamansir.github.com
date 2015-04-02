var contactsByTypeMapping = {
	"icq": {
    	   address: "http://www.icq.com/people/cmd.php?uin=%id%&action=add",
    	   icon: "http://status.icq.com/online.gif?icq=%id%&img=5",
    	   site: "http://icq.com"
	   },
	"skype": {
    	   address: "skype:%id%?chat",
    	   icon: "http://mystatus.skype.com/smallicon/%id%",
    	   site: "http://skype.com"
	   },
	"jabber": {
	       address: "xmpp:%id%?message;subject=From%20site",
	       icon: "http://netlab.cz/status/?jid=%id%&ib=psi",
	       site: "http://jabber.org"
	   },
	"gtalk": {
    	   address: "gtalk:chat?jid=%id%@gmail.com",
    	   icon: "http://www.IMStatusCheck.com/status/gtalk/%id%@gmail.com",
    	   site: "http://google.com/talk"
	   },
	"yahoo": {
    	   address: "ymsgr:sendIM?%id%&m=from+site",
    	   icon: "http://mail.opi.yahoo.com/online?u=%id%&m=g&t=0",
    	   site: "http://messenger.yahoo.com/"
	   },
	"gmail": {
	       address: "mailto:%id%@gmail.com",
	       icon: "gmail.ico",
	       site: "http://gmail.com"
	   },
	"yahoo-mail": {
	       address: "mailto:%id%@yahoo.com",
	       icon: "yahoo.png",
	       site: "http://mail.yahoo.com"
	   }
}

var SECTION_ID = 'contacts';

sectorsMap[SECTION_ID].additionalHtml = '<iframe src="http://www.google.com/talk/service/badge/Show?tk=z01q6amlqlp3b08lv5rcbbqvgplpv0gseqmi9jt5loal008g79h6mvrtgsp92i4h6sc7sqkn5h7rdtb7q0h7j8q6ufjjv5nj83ndgpts76m7n0tg8ukp27mgd588f8ra55k89bks22mrhagq6dlk7j3kidba1r339u4dh2fsl&amp;w=200&amp;h=60" allowtransparency="true" frameborder="0" height="60" width="200"></iframe>';

dataSource = contactsByTypeMapping;