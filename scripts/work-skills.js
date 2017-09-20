function workSkills(target) {

        var today = new Date();

        function monthDiff(startMonth, startYear, endMonth, endYear) {
            return endMonth - startMonth + (12 * (endYear - startYear)) + 1;
        }

        var skills = {};

        function addSkillData(mainSkill, subSkill, w_id, value) {
            if (!skills[mainSkill]) skills[mainSkill] = {};
            if (!subSkill) return;
            if (!skills[mainSkill][subSkill]) skills[mainSkill][subSkill] = { total: 0, values: [] };
            skills[mainSkill][subSkill].total = skills[mainSkill][subSkill].total + value;
            skills[mainSkill][subSkill].values.push({ w: w_id, value: value });
        };

        var totalMonths = 0;

        var monthsCounts = [];
        var coefficients = [];

        workData.forEach(function(w) {
            var from = w.from;
            var to = w.to || today;
            var monthsCount = monthDiff(from.getMonth(), from.getFullYear(),
                                        to.getMonth(), to.getFullYear());

            console.log(w.title, monthsCount);
            monthsCounts.push(monthsCount);
            totalMonths += monthsCount;
            // console.log(w.id, from, to, monthsCount);
        });

        workData.forEach(function(w, w_idx) {
            coefficients.push(monthsCounts[w_idx] / totalMonths);
        });

        workData.forEach(function(w, w_idx) {
            var subjects = Object.keys(w.subjects);
            var subjectsCount = subjects.length;
            // console.log('-----');
            // console.log(w.id, monthsCounts[w_idx]);
            subjects.forEach(function(subject) {
                var pair = subject.split('/');
                var mainSkill = pair[0];
                var subSkill = pair[1] || null;
                console.log('>>', w.title, subject, w.subjects);
                console.log(mainSkill, '_', w.subjects[subject], (w.subjects[subject] * coefficients[w_idx]));
                addSkillData(mainSkill, '_', w.id, (w.subjects[subject] * coefficients[w_idx]));
                if (subSkill) {
                    console.log(mainSkill, subSkill, w.subjects[subject], (w.subjects[subject] * monthsCounts[w_idx]));
                    addSkillData(mainSkill, subSkill, w.id, (w.subjects[subject] * coefficients[w_idx]));
                }
            });
        });

        console.log('++++++++');
        console.log(skills);
        var totalSkills = 0;
        var totalSubSkills = 0;
        Object.keys(skills).forEach(function(skill) {
            totalSubSkills = 0;
            console.log(skill, skills[skill]._.total);
            totalSkills += skills[skill]._.total;
            Object.keys(skills[skill]).forEach(function(key) {
                if (key === '_') return;
                console.log('  ', key, skills[skill][key].total);
                totalSubSkills += skills[skill][key].total;
            });
            console.log('  total', totalSubSkills);
        });
        console.log('+++++++',totalSkills);

        var skillScale = d3.scaleLinear().range([ 0, Math.PI / 2 ])
                                         .domain([ 0, totalMonths ]);

        var EXPECTED_WIDTH = 100;
        var EXPECTED_HEIGHT = 200;
        var FONT_SIZE = 20;

        var svg = d3.select(target).append('svg')
                    .attr('width', EXPECTED_WIDTH).attr('height', EXPECTED_HEIGHT);

        // var lastSkillValue = {};
        // var lastSubSkillValue = {};

        var skillsTotal = 0;// FIXME: use linearScale
        var subSkillsTotal = 0; // FIXME: use linearScale

        var yScale = d3.scaleLinear().range([ 0, EXPECTED_HEIGHT - FONT_SIZE ])
                                     .domain([ 0, 1 ]);
        var heightScale = d3.scaleLinear().range([ 0, 1 ])
                                          .domain([ 0, 1 ]);

        svg.append('g').attr('id', 'skills')
           .selectAll('g').data(Object.keys(skills)).enter()
           .append('g').attr('id', function(skill) { return skill; })
           .attr('data-total', function(skill) { return skills[skill]['_'].total; })
           .attr('transform', function(skill) {
              var value = skills[skill]['_'].total;
              var y = yScale(skillsTotal);
              skillsTotal += value;
              return 'translate(0,' + y + ')';
            })
        //    .append('path').attr('d', function(skill) {
        //        var skillTotal = skills[skill]['_'];
        //         return arc(10, skills['_'], to);
        //    })
           .each(function(skill) {
               var skillTotal = skills[skill]['_'];
               return;
               //d3.select(this).append('arc')
               d3.select(this).selectAll('g')
                 .data(Object.keys(skills[skill]).filter(function() { return skill !== '_'; })).enter()
                 .append('g').attr('id', function(subSkill) { return subSkill; })
                 .attr('data-total', function(subSkill) { return skills[skill][subSkill].total; })
                 .attr('data-value', function(subSkill) { return skills[skill][subSkill].value; })
                 .append('text').text(function(subSkill) { return subSkill })
                 .attr('transform', function(subSkill) {
                    //var totalHeight = skills[skill]['_'].total;
                    //return 'scale(0,' + totalHeight + ')';
                 })
                //  .append('path').attr('d', function(subSkill) {
                //     return arc(20, from, to);
                //  })
           })
           .append('text')
           .attr('x', 0).attr('y', 0).attr('fill', 'black').attr('font-size', FONT_SIZE)
           .attr('text-anchor', 'start').attr('alignment-baseline','hanging')
           .text(function(skill) { return skill; })
           .attr('transform', function(skill) {
                var value = skills[skill]['_'].total;
                var sy = heightScale(value);
                // return 'scale(1,' + sy + ')';
                return 'scale(1,1)';
           });
    }

    function arc(r, from, to) {
      return [
        'M', r * Math.cos(to), r * Math.sin(to),
        'A', r, r, 0,
             ((to - from) <= Math.PI) ? 0 : 1, 0,
             r * Math.cos(from), r * Math.sin(from)
      ].join(' ');
    }

    // var sectionsScale = d3.scaleLinear()
    //                         .range([ 0, Math.PI * 2 ])
    //                         .domain([ 0, 100 ]);

    //   var gap = (config.gap / 180 * Math.PI);

    //       sectionGroup.append('path')
    //                   .style('cursor', 'pointer')
    //                   .attr('stroke', byIndex(config.colors))
    //                   .attr('stroke-width', config.thickness)
    //                   .attr('fill', 'transparent')
    //                   .attr('transform', 'rotate(-90)')
    //                   .attr('d', function(value) {
    //                     var from = sectionsScale(lastValue * 100);
    //                     var to = sectionsScale((lastValue + value) * 100);

    //                     lastValue += value;

    //                     return arc(radius, from, to - gap);
    //                   })
    //                   .on('mouseover', function(value, sectionIdx) {
    //                     highlightSection(sectionIdx);
    //                   })
    //                   .on('mouseout', function(value, sectionIdx) {
    //                     removeSectionHighlight(sectionIdx);
    //                   });
