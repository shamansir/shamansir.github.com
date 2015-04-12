// source: http://tributary.io/inlet/1fd86904dcc5b12776e7

var w = 137, // full width
    h = 35; // full height

var gw = w, // graph width
    gh = h * 0.6; // graph height

var tw = 75, // tooltip width
    th = 30; // tooltip height

var x_title_height = h * 0.15;

var x_axis_h = h - gh, // x axis height
    x_axis_font = Math.min(x_axis_h * 0.4, gw * 0.05); // x axis font size

d3.selectAll('body svg.tooltip').remove();

var svg = d3.selectAll("svg")
//          .attr('class', 'foo')
			.attr('width', w)
			.attr('height', h)
            .style('border', 'none');

var dateFormat = d3.time.format.iso;

function weight(start, end) {
    var startMonth = start.getMonth(),
        endMonth = end.getMonth();
    var startYear = start.getFullYear(),
        endYear = end.getFullYear();
    var result = (endYear !== startYear) ?
                 ((12 - startMonth) +
                  ((endYear - startYear - 1) * 12) +
                  endMonth + 1) :
                (endMonth - startMonth + 1);
    //console.log(d3.time.format('%Y-%m')(start),
    //            d3.time.format('%Y-%m')(end),
    //            result);
    return result;
}

dataset.forEach(function(wp, i) {
  wp.idx = i;
  wp.start = dateFormat.parse(wp.start);
  wp.end = wp.end ? dateFormat.parse(wp.end) : new Date();
  wp.weight = weight(wp.start, wp.end);
  //weights.push({ weight: wp.weight, idx: i });
});

d3.nest()
  .key(function(wp) { return wp.weight; })
  .sortKeys(function(a, b) {
      if (a === b) return 0;
      return (parseInt(a, 0) > parseInt(b, 0)) ? 1 : -1;
  })
  .entries(dataset)
  .forEach(function(entry, i) {
      var wp = entry.values[0];
      wp.weight_idx = i;
  });

var minYear = d3.min(dataset, function(d) { return d.start.getFullYear(); });
var maxYear = d3.max(dataset, function(d) { return d.end.getFullYear(); });
var yearsCount = maxYear - minYear;

var yearScale = d3.scale.linear()
                     .domain([minYear, maxYear + 1])
                     .range([0, gw]);
var monthXScale = d3.scale.linear()
                     .domain([0, (maxYear - minYear + 1) * 2])
                     .range([0, gw]);
var monthYScale = d3.scale.linear()
                     .domain([0, 6])
                     .range([0, gh]);
//var colorScale = d3.scale.category10()
//                     .domain([0, dataset.length - 1]);

/* function brewer(set, size) {
  if (size < 3) return colorbrewer[set][3];
  if (!colorbrewer[set][size]) return colorbrewer[set][3];
} */

var colorScale = d3.scale.linear()
                         .domain(d3.range(0, dataset.length))
                         .range(colorbrewer.YlGn[dataset.length]);

var workplacesGroup = svg.append('g')
   .attr('class', 'workplaces');

var workplaces = workplacesGroup.selectAll('g.workplaces g.workplace')
   .data(dataset)
   .enter()
   .append("g")
   .attr('id', function(d, i) { return 'workplace-'+i; })
   .attr('class', 'workplace')
   .attr('transform', function(d) {
       return 'translate(' + yearScale(d.start.getFullYear()) + ',0)';
    });

workplaces.selectAll('.workplace rect')
.data(function(d,i) {
    var startMonth = d.start.getMonth(),
        endMonth = d.end.getMonth();
    var startYear = d.start.getFullYear(),
        endYear = d.end.getFullYear();
    //console.log(d.company, d.weight, d.weight_idx);
    var monthRects = [];
    for (var year = startYear; year <= endYear; year++) {
        var dx = (year - startYear) * 2;
        var from = (year === startYear) ? startMonth : 0,
            to = (year === endYear) ? endMonth : 11;
        for (var month = from; month <= to; month++) {
           monthRects.push({
             x: dx + ((month < 6) ? 0 : 1),
             y: month % 6,
             fill: d3.hsl(colorScale(d.weight_idx)),
             year: year,
             workplace: d,
             hint: month + '\'' + year
          });
       }
    }
    if (i === (dataset.length - 1)) {
       monthRects[monthRects.length - 1].fill = d3.hsl('pink');
    }
    return monthRects;
})
   .enter()
   .append('rect')
   .attr('class', function(d) { return 'month-in-workplace-' + d.workplace.idx + ' month-of-' + d.year; })
   .attr('x', function(d) { return monthXScale(d.x) })
   .attr('y', function(d) { return monthYScale(d.y) })
   .attr("width", monthXScale(1) - 0.5)
   .attr("height", monthYScale(1) - 0.5)
   .attr('fill', function(d) { return d.fill; })
   .attr('hint', function(d) { return d.hint })
   .style('cursor', 'pointer')
   .on('mousemove', function(d) {
        svg.selectAll('.month-in-workplace-' + d.workplace.idx)
          //.transition()
          //.duration(100)
          //.ease('cubic-in')
          .attr('fill', function(d) { return d.fill.darker(); });
        fillTooltip(d.workplace);
   })
   .on('mouseout', function(d) {
        svg.selectAll('.month-in-workplace-' + d.workplace.idx)
          //.transition()
          //.duration(100)
          //.ease('cubic-out')
          .attr('fill', function(d) { return d.fill; });
        hideTooltip();
   });

var yearFormat = d3.time.format('\'%y');

var xAxis = svg.append('g')
   .call(d3.svg.axis()
                  .scale(yearScale)
                  .orient('bottom')
                  .tickSize(5, 10, 2)
                  .tickFormat(function(d, i) {
                      return yearFormat(new Date('' + d));
                  }))
   .attr('class', 'x-axis')
   .attr('transform', 'translate(0,' + gh + ')');
                  //.outerTickSize(0)

xAxis.selectAll("line")
     .attr('class', 'year-line')
     .attr('stroke', 'rgba(200, 200, 200, .2)');

xAxis.selectAll("text")
     .attr('x', monthXScale(1))
     .attr('y', 5)
     .attr('fill', 'rgba(30, 30, 90, .4)')
     .style('font-size', Math.floor(x_axis_font)+'px')
     //.style("text-anchor", "start")
     //.attr('transform', 'rotate(-90 0 0)');
   .style('cursor', 'pointer')
   .on('mouseover', function(d) {
        d3.select(this).attr('fill', 'black');
        svg.selectAll('.month-of-' + d)
          .transition()
          .duration(100)
          .attr('fill', function(d) { return d.fill.brighter(0.5); });
   })
   .on('mouseout', function(d) {
        d3.select(this).attr('fill', 'rgba(30, 30, 90, .4)');
        svg.selectAll('.month-of-' + d)
          .transition()
          .duration(100)
          .attr('fill', function(d) { return d.fill; });
   });

xAxis.selectAll("path")
//     .attr('transform', 'translate(' + monthXScale(2) + ',0)')
     .attr('fill', 'rgba(240,240,240,1)');

var tooltip = d3.select('body').append('svg');

//var tooltip = tsvg.append('g')
tooltip.attr('class', 'tooltip')
   //.attr('transform', 'translate(' + gw + ', 0)')
   //.append('rect')
   .attr('width', tw)
   .attr('height', th)
   .style('font-size', Math.floor(th / 3) + 'px')
//   .style('padding', '5px')
   .style('display', 'none')
   .style('position', 'absolute');

tooltip.append('rect').attr('width', tw).attr('height', th)
                      .attr('fill', 'white')
                      .attr('stroke', 'black')
                      //.attr('rx', 5).attr('ry', 5)
tooltip.append('text').attr('class','company').attr('x', 3).attr('y', (th - 3) / 3);
tooltip.append('text').attr('class','duration').attr('x', 3).attr('y', 2 * (th - 3) / 3);
tooltip.append('text').attr('class','skills').attr('x', 3).attr('y', th - 3);

function hideTooltip() {
   tooltip/*.transition().duration(100)*/.style('display', 'none');
}

function fillTooltip(wp) {
   tooltip.style('left', d3.event.pageX).style('top', d3.event.pageY);
   tooltip.selectAll('.company').text(wp.company);
   tooltip.selectAll('.duration').text(wp.weight);
   tooltip.selectAll('.skills').text('Woo');
   tooltip.style('display', 'block');
}
