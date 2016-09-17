var workData = [
    {
        title: 'JB',
        from: 'May 2016',
        places: [ 'Munich, Germany '],
        subjects: {
            'javascript': 0.8,
            'javascript/react': 0.1
        }

    },
    {
        title: 'Animatron',
        from: 'Jun 2011',
        to: 'Apr 2016',
        places: [ 'Odessa, Ukraine',
                  'Munich, Germany' ],
        subjects: {
            'java/gwt': 0.2,
            'html/canvas': 0.4,
            'javascript': 0.4
        }
    },
    {
        title: 'iPark Ventures',
        places: [ 'Odessa, Ukraine' ],
        from: 'Apr 2010',
        to: 'May 2011',
        subjects: {
            'java/gwt': 0.8,
            'javascript': 0.2
        }
    },
    {
        title: 'Exectum LLC',
        places: [ 'St. Petersburg, Russia' ],
        from: 'Sep 2009',
        to: 'Feb 2010',
        subjects: {
            'javascript/extjs': 0.7,
            'java/rmi': 0.15,
            'java/spring': 0.15
        }
    },
    {
        title: 'Sea Project',
        places: [ 'St. Petersburg, Russia' ],
        from: 'Aug 2009',
        to: 'Aug 2009',
        subjects: {
            'xml/xslt': 0.6,
            'javascript': 0.4
        }
    },
    {
        title: 'Fotonation Inc.',
        places: [ 'St. Petersburg, Russia' ],
        from: 'Jul 2007',
        to: 'May 2009',
        subjects: {
            'java/wicket': 0.6,
            'javascript': 0.4
        }
    },
    {
        title: 'FK Ltd.',
        places: [ 'St. Petersburg, Russia' ],
        from: 'Nov 2006',
        to: 'Jun 2007',
        subjects: {
            'php': 0.6,
            'javascript': 0.4
        }
    },
    {
        title: 'EmDev LLC',
        places: [ 'St. Petersburg, Russia' ],
        from: 'May 2005',
        to: 'Oct 2006',
        subjects: {
            'java/spring': 0.5,
            'java/hibernate': 0.2,
            'java/jsp': 0.2,
            'javascript': 0.2,
            'delphi': 0.2,
            'python': 0.1
        }
    },
    {
        title: 'VNIIOkeangeologiya',
        places: [ 'St. Petersburg, Russia', 'Crimea, Ukraine', 'Xiao Nang Hai, China' ],
        from: 'Apr 2004',
        to: 'Mar 2005',
        subjects: [
            'delphi': 1.0
        ]
    }
];

function work(target) {
    var firstMonth,
        firstYear;

    var lastMonth,
        lastYear;

    workData.forEach(function(workItem) {
        console.log(workItem);
        var startDate = new Date(workItem.from + ' GMT');
        var endDate = workItem.to ? new Date(workItem.to + ' GMT') : new Date();
        console.log(workItem.title, startDate.toUTCString(),
                                    endDate.toUTCString());
    });
}
