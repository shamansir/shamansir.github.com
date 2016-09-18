var workData = [
    {
        id: 'jetbrains',
        title: 'JetBrains',
        label: 'JB',
        from: 'May 2016',
        places: [ 'Munich, Germany '],
        subjects: {
            'javascript': 0.8,
            'javascript/react': 0.1
        }

    },
    {
        id: 'animatron',
        title: 'Animatron',
        label: 'AT',
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
        id: 'ipark-ventures',
        title: 'iPark Ventures',
        label: 'iV',
        places: [ 'Odessa, Ukraine' ],
        from: 'Apr 2010',
        to: 'May 2011',
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
        from: 'Sep 2009',
        to: 'Feb 2010',
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
        from: 'Aug 2009',
        to: 'Aug 2009',
        subjects: {
            'xml/xslt': 0.6,
            'javascript': 0.4
        }
    },
    {
        id: 'fotonation',
        title: 'Fotonation Inc.',
        label: 'FN',
        places: [ 'St. Petersburg, Russia' ],
        from: 'Jul 2007',
        to: 'May 2009',
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
        from: 'Nov 2006',
        to: 'Jun 2007',
        subjects: {
            'php': 0.6,
            'javascript': 0.4
        }
    },
    {
        id: 'emdev',
        title: 'EmDev LLC',
        label: 'ED',
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
        id: 'vniiokeangeologiya',
        title: 'VNIIOkeangeologiya',
        label: 'VO',
        places: [ 'St. Petersburg, Russia', 'Crimea, Ukraine', 'Xiao Nang Hai, China' ],
        from: 'Apr 2004',
        to: 'Mar 2005',
        subjects: {
            'delphi': 1.0
        }
    }
];

function work(target) {
    var firstDate;
    var lastDate = new Date();

    var width = 400, height = 400;

    var monthsInRow = 6;

    var dates = {};

    var colors = {};

    workData.forEach(function(w) {
        var fromDate = new Date(w.from);
        var toDate = new Date(w.to);
        if (!firstDate || fromDate < firstDate) firstDate = fromDate;
        dates[w.id] = [ fromDate, toDate ];
        colors[w.id] = 'rgb(' + Math.floor(Math.random() * 255) + ',' +
                                Math.floor(Math.random() * 255) + ',' +
                                Math.floor(Math.random() * 255) + ')';
    });

    var firstYear = firstDate.getYear();
    var lastYear = lastDate.getYear();
    var yearCount = lastYear - firstYear;

    var monthScale = d3.scaleLinear().range([ 0, width ])
                                     .domain([ 0, monthsInRow ]);
    var yearScale = d3.scaleLinear().range([ 0, height ])
                                    .domain([ firstYear, firstYear + (yearCount * 2) ]);

    var monthsNames = [ 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec' ]

    function drawMonth(target, w, month, year) {
        console.log(w.id, monthsNames[month], (1900 + year));
        var group = d3.select(target);

        group.append('circle')
             .attr('data-w', w.id)
             .attr('data-month', month).attr('data-year', 1900 + year)
             .attr('cx', monthScale(month % monthsInRow))
             .attr('cy', yearScale(year))
             .attr('fill', colors[w.id])
             .attr('r', 5);

        group.append('text')
             .attr('x', monthScale(month % monthsInRow))
             .attr('y', yearScale(year))
             .attr('fill', 'rgba(0,0,0,0.3)')
             .text(monthsNames[month] + '/' + (1900 + year))
    }

    d3.select(target).append('svg')
      .attr('width', width).attr('height', height)
      .selectAll('g').data(workData).enter()
      .append('g').attr('id', function(w) { return w.id; })
      .each(function(w, index) {
        var wDates = dates[w.id];
        console.log(w.id, wDates[0].getMonth(), wDates[0].getYear(),
                          wDates[1].getMonth(), wDates[1].getYear());

        var startMonth = wDates[0].getMonth(), startYear = wDates[0].getYear();
        var endMonth =   wDates[1].getMonth(), endYear   = wDates[1].getYear();

        var month;
        if (startYear == endYear) {
            for (month = startMonth; month < endMonth; month++) {
                drawMonth(this, w, month, startYear);
            }
        } else {
            for (month = startMonth; month < 12; month++) {
                drawMonth(this, w, month, startYear);
            }
            var year;
            for (year = startYear + 1; year < endYear - 1; year++) {
                for (month = 0; month < 12; month++) {
                    drawMonth(this, w, month, year);
                }
            }
            for (month = 0; month < endMonth; month++) {
                drawMonth(this, w, month, endYear);
            }
        }

      });


    console.log(firstDate, lastDate, dates);

    /* workData.forEach(function(workItem) {
        console.log(workItem);
        var startDate = new Date(workItem.from + ' GMT');
        var endDate = workItem.to ? new Date(workItem.to + ' GMT') : new Date();
        console.log(workItem.title, startDate.toUTCString(),
                                    endDate.toUTCString());
    }); */
}
