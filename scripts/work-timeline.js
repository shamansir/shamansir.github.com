var textModeOptions =
    [ 'off', 'one', 'three' ];

var textModeLabels =
    [ 'x', 'a', 'thr' ];

var textMode = 0; // 'off'

/* var shapeModes = {
    off: function(shape, text, label) {

    },
    one: function(shape, text, label) {

    },
    three: function(shape, text, label) {

    }
}; */

function workControls(target, workTarget) {
    var workTarget = d3.select(workTarget);

    var radius = 5;

    d3.select(target)
      .append('svg')
      .append('g')//.text(textModeLabels[textMode])
      //.style('opacity', textMode ? 1 : 0.5)
      .call(function(g) {
        g.append('circle')
         .attr('cx', radius).attr('cy', radius)
         .attr('r', radius).attr('fill', 'black')
         .style('cursor', 'pointer');
        g.append('text').attr('fill', 'white').style('pointer-events', 'none')
                        .attr('font-size', '10px')
                        .attr('x',radius).attr('y', radius)
                        .text(textModeLabels[textMode])
                        .attr('text-anchor', 'middle')
                        .attr('alignment-baseline', 'central');
      })
      .on('click', function() {
          textMode = textMode < (textModeOptions.length - 1) ? textMode + 1 : 0;
          console.log(textMode, textModeLabels[textMode]);
          d3.select(this).select('text').text(textModeLabels[textMode])
                                        .attr('fill', textMode === 2 ? 'black' : 'white');
          d3.select(this).select('circle').style('fill-opacity', textMode === 2 ? 0.1 : 1);
          //d3.select(this).style('opacity', textMode ? 1 : 0.5)
          workTarget.selectAll('circle.month')
                    .style('fill-opacity', textMode === 2 ? 0.1 : 1);
          workTarget.selectAll('text.month')
                    .style('visibility', textMode === 1 ? 'visible' : 'hidden');
          workTarget.selectAll('text.month3')
                    .style('visibility', textMode === 2 ? 'visible' : 'hidden');
      });
}

function work(target) {
    var today = new Date();

    var monthsNames = [ 'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec' ];

    var monthsShortNames = [ 'j', 'f', 'm', 'a', 'm', 'j', 'j', 'a', 's', 'o', 'n', 'd' ];

    var firstDate;
    var lastDate = today;

    var width = 150, height = 500;

    var monthsInRow = 6;

    var dates = {};

    var colors = {};

    // init colots and dates
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

    var yearAxis = d3.axisLeft().scale(yearScale)
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

    // ## monthPos ##
    // (get the X, Y position of a requested month)

    function monthPos(month, year, addX, addY) {
        return {
            x: monthScale(month % monthsInRow) + (addX || 0),
            y: yearScale((month < monthsInRow) ? (year - firstYear)
                                               : (year - firstYear) + 0.5
                        ) + (addY || 0)
        }
    }

    // ## drawMonth ##
    // (draw a circle with the text, representing a month)

    function drawMonth(target, w, month, year) {
        console.log(w.id, monthsNames[month], (1900 + year));
        var group = d3.select(target);

        var pos = monthPos(month, year);
        var color = colors[w.id];

        group.append('circle').style('pointer-events', 'none')
             .classed('month', true)
             .attr('data-w', w.id)
             .attr('data-month', month).attr('data-year', 1900 + year)
             .attr('cx', pos.x).attr('cy', pos.y)
             .attr('fill', color)
             .attr('r', radius);

        group.append('text').style('pointer-events', 'none')
             .classed('month3', true)
             .style('visibility', 'hidden')
             .style('font-size', '10px')
             .attr('data-w', w.id)
             .attr('data-month', month).attr('data-year', 1900 + year)
             .attr('text-anchor', 'middle')
             .attr('alignment-baseline', 'central')
             .attr('x', monthScale(month % monthsInRow))
             .attr('y', yearScale((month < monthsInRow) ? (year - firstYear)
                                                        : (year - firstYear) + 0.5))
             .attr('fill', color)
             .text(monthsNames[month]);

        group.append('text').style('pointer-events', 'none')
             .classed('month', true)
             .style('visibility', 'hidden')
             .style('font-size', '10px')
             .attr('data-w', w.id)
             .attr('data-month', month).attr('data-year', 1900 + year)
             .attr('text-anchor', 'middle')
             .attr('alignment-baseline', 'central')
             .attr('x', monthScale(month % monthsInRow))
             .attr('y', yearScale((month < monthsInRow) ? (year - firstYear)
                                                        : (year - firstYear) + 0.5))
             //.attr('fill', color)
             .attr('fill', 'white')
             .text(monthsShortNames[month]);

    }

    // ## drawArea ##
    // (draw a path which covers the area of all the months during specified period of time)

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

        var gutterWidth = 5;

        var gutter = d3.select(target).append('rect')
           .attr('fill', 'transparent')
           //.attr('fill-opacity', 0.1)
           .attr('x', -gutterWidth - radius)
           .attr('y', topY)
           .attr('width', gutterWidth)
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

    // ## Main code ##

    // add SVG root
    var svg = d3.select(target).append('svg')
                .attr('width', width).attr('height', height);

    // add workplaces groups
    svg.append('g').attr('id', 'workplaces')
       .attr('transform', 'translate(' + (yearAxisWidth + radius) +  ',' + radius + ')')
       .selectAll('g').data(workData).enter()
       .append('g').attr('id', function(w) { return w.id; })
       .classed('workplace', true)
       .each(function(w, index) {

            var wDates = dates[w.id];
            var wColor = colors[w.id];

            var correspondingItem = d3.selectAll('#work-' + w.id);

            //correspondingItem.selectAll('.marker').remove();

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

    // add year axis
    svg.append('g').call(yearAxis)
       .attr('transform', 'translate(' + yearAxisWidth + ',0)')
       .selectAll('text').style('alignment-baseline', 'baseline');

    console.log(firstDate, lastDate, dates);

    /* workData.forEach(function(workItem) {
        console.log(workItem);
        var startDate = new Date(workItem.from + ' GMT');
        var endDate = workItem.to ? new Date(workItem.to + ' GMT') : new Date();
        console.log(workItem.title, startDate.toUTCString(),
                                    endDate.toUTCString());
    }); */
}
