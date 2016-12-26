var monthToIdx = { Jan:  0, Feb:  1, Mar:  2, Apr:  3,
                   May:  4, Jun:  5, Jul:  6, Aug:  7,
                   Sep:  8, Oct:  9, Nov: 10, Dec: 11 };

console.log({ Jan:  0, Feb:  1, Mar:  2, Apr:  3,
                   May:  4, Jun:  5, Jul:  6, Aug:  7,
                   Sep:  8, Oct:  9, Nov: 10, Dec: 11 });

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
            'javascript': 0.8,
            'javascript/react': 0.1
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
        from: from('Apr', 2004),
        to: to('Mar', 2005),
        subjects: {
            'delphi': 1.0
        }
    }
];

function work(target) {
    var today = new Date();

    var monthsNames = [ 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec' ];    

    var firstDate;
    var lastDate = today;

    var width = 150, height = 500;

    var monthsInRow = 6;

    var dates = {};

    var colors = {};

    workData.forEach(function(w) {
        var fromDate = w.from;
        var toDate = w.to || today;
        if (!firstDate || fromDate < firstDate) firstDate = fromDate;
        dates[w.id] = [ fromDate, toDate ];
        colors[w.id] = 'rgb(' + Math.floor(Math.random() * 255) + ',' +
                                Math.floor(Math.random() * 255) + ',' +
                                Math.floor(Math.random() * 255) + ')';
    });

    var firstYear = firstDate.getYear();
    var lastYear = lastDate.getYear();
    var yearCount = lastYear - firstYear;

    console.log(firstYear, lastYear, yearCount);

    var yearAxisWidth = 32;

    var padding = 0;

    var monthScale = d3.scaleLinear().range([ 0, width - yearAxisWidth ])
                                     .domain([ 0, monthsInRow ]);
    var yearScale = d3.scaleLinear().range([ 0 + (height * padding), 
                                             height - (height * padding) ])
                                    .domain([ 0, yearCount + 1 ]);

    var xSide = 12;
    var ySide = 12;

    var xMargin = monthScale(1) - monthScale(0) - xSide;
    var yMargin = yearScale(0.5) - yearScale(0) - ySide;

    var yearAxis = d3.axisRight().scale(yearScale)
                     //.tickSize(yearAxisWidth / 2)
                     .tickFormat(function(idx) {
                         return 1900 + firstYear + idx;
                     });

    /* var monthAxis = d3.axisRight().scale(yearScale)
                      .ticks((lastYear - firstYear) * 12)
                      .tickSize(yearAxisWidth / 16)
                      .tickFormat(function(idx) {
                           return '';
                       }); */

    var radius = ySide / 2;
    var diameter = radius * 2;

    function monthPos(month, year, addX, addY) {
        return {
            x: monthScale(month % monthsInRow) + (addX || 0),
            y: yearScale((month < monthsInRow) ? (year - firstYear)
                                               : (year - firstYear) + 0.5
                        ) + (addY || 0)
        }
    }

    function drawMonth(target, w, month, year) {
        console.log(w.id, monthsNames[month], (1900 + year));
        var group = d3.select(target);

        var pos = monthPos(month, year);

        group.append('circle').style('pointer-events', 'none')
             .attr('data-w', w.id)
             .attr('data-month', month).attr('data-year', 1900 + year)
             .attr('cx', pos.x).attr('cy', pos.y)
             .attr('fill', colors[w.id])
             .attr('r', radius);

        /* group.append('text')
             .attr('x', monthScale(month % monthsInRow))
             .attr('y', yearScale((month < monthsInRow) ? (year - firstYear)
                                                        : (year - firstYear) + 0.5))
             .attr('fill', 'rgba(0,0,0,0.3)')
             .text(monthsNames[month] + '/' + (1900 + year)); */
    }

    /* function monthDiff(startMonth, startYear, endMonth, endYear) {
        return endMonth - startMonth + (12 * (endYear - startYear));
    } */

    function drawArea(target, w, startMonth, startYear, endMonth, endYear) {
        var correspondingItem = d3.selectAll('#work-' + w.id);

        //var monthsBetween = monthDiff(startMonth, startYear, endMonth, endYear);
        var takesOneRow = (startYear == endYear) && 
                          (((startMonth < monthsInRow) && (endMonth < monthsInRow)) ||
                           ((startMonth >= monthsInRow) && (endMonth >= monthsInRow)));
        var points = [];
        var halfXMargin = xMargin / 2;        
        var halfYMargin = yMargin / 2;
        if (takesOneRow) {
            /* 0 */ points.push(monthPos(startMonth, startYear, -halfXMargin, -halfYMargin));         
            /* 1 */ points.push(monthPos(endMonth, endYear, diameter + halfXMargin, -halfYMargin));
            /* 2 */ points.push(monthPos(endMonth, endYear, diameter + halfXMargin, diameter + halfYMargin));
            /* 3 */ points.push(monthPos(startMonth, startYear, -halfXMargin, diameter + halfYMargin));
            /* 4 */ points.push(monthPos(startMonth, startYear, -halfXMargin, -halfYMargin)); // 4
        } else/* if (monthsBetween >= 12)*/ { 
            /* 0 */ points.push(monthPos(startMonth, startYear, -halfXMargin, -halfYMargin));
            /* 1 */ points.push(monthPos((startMonth >= monthsInRow)
                                         ? (monthsInRow * 2) - 1
                                         : monthsInRow - 1, startYear, diameter + halfXMargin, -halfYMargin));
            if (endMonth >= monthsInRow) {
                /* 2 */ points.push(monthPos(monthsInRow - 1, endYear, diameter + halfXMargin, diameter + halfYMargin));
            } else {
                /* 2 */ points.push(monthPos((monthsInRow * 2) - 1, endYear - 1, diameter + halfXMargin, diameter + halfYMargin));
            }
            /* 3 */ points.push(monthPos(endMonth, endYear, diameter + halfXMargin, -halfYMargin));
            /* 4 */ points.push(monthPos(endMonth, endYear, diameter + halfXMargin, diameter + halfYMargin));
            /* 5 */ points.push(monthPos((endMonth >= monthsInRow) ? monthsInRow : 0, endYear, -halfXMargin, diameter + halfYMargin));
            if (startMonth >= monthsInRow) {
                /* 6 */ points.push(monthPos(0, startYear + 1, -halfXMargin, -halfYMargin));
            } else {
                /* 6 */ points.push(monthPos(monthsInRow, startYear,  -halfXMargin, -halfYMargin));
            }
            /* 7 */ points.push(monthPos(startMonth, startYear, -halfXMargin, diameter + halfYMargin));
        }        

        /* 
        var strokeColor = d3.color(colors[w.id]);
        var fillColor = strokeColor;//.brighter(1.5) */

        var strokeColor = 'transparent';
        var fillColor = colors[w.id];

        var path = d3.select(target).append('path')
          .attr('fill', 'transparent')
          .attr('fill-opacity', 0.1)
          .attr('stroke', strokeColor)
          .attr('stroke-width', 1)
          .attr('d', 'M ' + points[0].x + ' '
                          + points[0].y + ' '
                   + points.slice(1).map(function(point) {
                       return 'L ' + point.x + ' ' + point.y; 
                     })
                   + 'Z'   
               );

        /* 
        var topY = yearScale(startMonth < monthsInRow ? startYear - firstYear
                                                      : startYear - firstYear + 0.5) - halfYMargin;
        var bottomY = yearScale(endMonth < monthsInRow ? endYear - firstYear + 0.5
                                                       : endYear - firstYear + 1) - halfYMargin;            */

        var topY = yearScale(startYear - firstYear + (startMonth / 12));
        var bottomY = yearScale(endYear - firstYear + ((endMonth + 1) / 12));

        var gutter = d3.select(target).append('rect')
           .attr('fill', 'transparent')
           //.attr('fill-opacity', 0.1)
           .attr('x', width - yearAxisWidth)
           .attr('y', topY)
           .attr('width', 5)
           .attr('height', bottomY - topY);     

        function highlight() {
            correspondingItem.classed('active', true);
            path.attr('fill', fillColor);
            gutter.attr('fill', fillColor);
        }      

        function removeHightlight() {
            correspondingItem.classed('active', false);
            path.attr('fill', 'transparent');
            gutter.attr('fill', 'transparent');
        }

        path.style('pointer-events', 'all')
            .style('cursor', 'pointer')
            .on('mouseover', highlight)
            .on('mouseout', removeHightlight);

        correspondingItem
            .style('cursor', 'pointer')
            .on('mouseover', highlight)
            .on('mouseout', removeHightlight);            

        /* points.forEach(function(point, idx) {
            d3.select(target).append('text').text(idx)
              //.attr('alignment-baseline', 'hanging')
              .style('font-size', 8)  
              .attr('transform', 'translate(' + point.x + ',' + point.y + ')')
        }); */         
    }

    var svg = d3.select(target).append('svg')
                .attr('width', width).attr('height', height);

    svg.append('g').attr('id', 'workplaces')
       .attr('transform', 'translate(0,' + radius + ')')
       .selectAll('g').data(workData).enter()
       .append('g').attr('id', function(w) { return w.id; })
       .classed('workplace', true)
       .each(function(w, index) {

            var wDates = dates[w.id];
            var wColor = colors[w.id];

            var correspondingItem = d3.selectAll('#work-' + w.id);

            correspondingItem.append('span').text('●')
                             .classed('marker', true)
                             .style('color', wColor);

            var startMonth = wDates[0].getMonth(), startYear = wDates[0].getYear();
            var endMonth =   wDates[1].getMonth(), endYear   = wDates[1].getYear();

            console.log(w.id, monthsNames[startMonth], 1900 + startYear, '->',
                              monthsNames[endMonth],   1900 + endYear);

            var area = d3.select(this)
                         .append('g').classed('area', true)
                         .attr('transform', 'translate(0, ' + -1 * radius + ')')
                         .node();
              
            drawArea(area, w, startMonth, startYear,
                              endMonth, endYear);

            var circles = d3.select(this).append('g').classed('circles', true)
                                         .attr('transform', 'translate(' + radius + ',0)')
                                         .node();

            var month;
            if (startYear == endYear) {
                for (month = startMonth; month <= endMonth; month++) {
                    drawMonth(circles, w, month, startYear);
                }
            } else {
                for (month = startMonth; month < 12; month++) {
                    drawMonth(circles, w, month, startYear);
                }
                var year;
                for (year = startYear + 1; year < endYear; year++) {
                    for (month = 0; month < 12; month++) {
                        drawMonth(circles, w, month, year);
                    }
                }
                for (month = 0; month <= endMonth; month++) {
                    drawMonth(circles, w, month, endYear);
                }
            }

       });

    svg.append('g').call(yearAxis)
       .attr('transform', 'translate(' + (width - yearAxisWidth) + ',0)')
       .selectAll('text').style('alignment-baseline', 'baseline');

    /* svg.append('g').call(monthAxis)
       .attr('transform', 'translate(' + (width - yearAxisWidth) + ',0)')
       .selectAll('text').style('alignment-baseline', 'baseline'); */       

    console.log(firstDate, lastDate, dates);

    /* workData.forEach(function(workItem) {
        console.log(workItem);
        var startDate = new Date(workItem.from + ' GMT');
        var endDate = workItem.to ? new Date(workItem.to + ' GMT') : new Date();
        console.log(workItem.title, startDate.toUTCString(),
                                    endDate.toUTCString());
    }); */
}
