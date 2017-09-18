var monthToIdx = { Jan:  0, Feb:  1, Mar:  2, Apr:  3,
                   May:  4, Jun:  5, Jul:  6, Aug:  7,
                   Sep:  8, Oct:  9, Nov: 10, Dec: 11 };

function from(month, year) {
    return new Date(year, monthToIdx[month], 1);
}

function to(month, year) {
    return new Date(year, monthToIdx[month] + 1, 0);
}

var workData = [
    {
        id: 'jetbrains',
        title: 'JetBrains',
        label: 'JB',
        from: from('May', 2016),
        places: [ 'Munich, Germany '],
        subjects: {
            'javascript': 0.6,
            'html': 0.2,
            'javascript/react': 0.2
        }

    },
    {
        id: 'animatron',
        title: 'Animatron',
        label: 'AT',
        from: from('Jun', 2011),
        to: to('Apr', 2016),
        places: [ 'Odessa, Ukraine',
                  'Munich, Germany' ],
        subjects: {
            'java/gwt': 0.2,
            'html/canvas': 0.4,
            'javascript': 0.4
        }
    },
    {
        id: 'ipark-ventures',
        title: 'iPark Ventures',
        label: 'iV',
        places: [ 'Odessa, Ukraine' ],
        from: from('Apr', 2010),
        to: to('May', 2011),
        subjects: {
            'java/gwt': 0.8,
            'javascript': 0.2
        }
    },
    {
        id: 'exectum',
        title: 'Exectum LLC',
        label: 'EX',
        places: [ 'St. Petersburg, Russia' ],
        from: from('Sep', 2009),
        to: to('Feb', 2010),
        subjects: {
            'javascript/extjs': 0.7,
            'java/rmi': 0.15,
            'java/spring': 0.15
        }
    },
    {
        id: 'sea-project',
        title: 'Sea Project',
        label: 'SP',
        places: [ 'St. Petersburg, Russia' ],
        from: from('Aug', 2009),
        to: to('Aug', 2009),
        subjects: {
            'xml/xslt': 0.6,
            'javascript': 0.4
        }
    },
    {
        id: 'piclinq',
        title: 'Piclinq Rus / Fotonation Inc.',
        label: 'FN',
        places: [ 'St. Petersburg, Russia' ],
        from: from('Jul', 2007),
        to: to('May', 2009),
        subjects: {
            'java/wicket': 0.6,
            'javascript': 0.4
        }
    },
    {
        id: 'fabrika-koda',
        title: 'Fabrika Koda Ltd.',
        label: 'FK',
        places: [ 'St. Petersburg, Russia' ],
        from: from('Nov', 2006),
        to: to('Jun', 2007),
        subjects: {
            'php': 0.6,
            'javascript': 0.4
        }
    },
    {
        id: 'emdev-llc',
        title: 'EmDev LLC',
        label: 'ED',
        places: [ 'St. Petersburg, Russia' ],
        from: from('May', 2005),
        to: to('Oct', 2006),
        subjects: {
            'java/spring': 0.24,
            'java/hibernate': 0.14,
            'java/jsp': 0.07,
            'javascript': 0.31,
            'delphi/vcl': 0.17,
            'python': 0.07
        }
    },
    {
        id: 'vniiokeangeologiya',
        title: 'VNIIOkeangeologiya',
        label: 'VO',
        places: [ 'St. Petersburg, Russia', 'Crimea, Ukraine', 'Xiao Nang Hai, China' ],
        from: from('Apr', 2004),
        to: to('Mar', 2005),
        subjects: {
            'delphi': 1.0
        }
    }
];
