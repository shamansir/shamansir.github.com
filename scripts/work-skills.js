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

        workData.forEach(function(w) {
            var from = w.from;
            var to = w.to || today;
            var monthsCount = monthDiff(from.getMonth(), from.getFullYear(),
                                        to.getMonth(), to.getFullYear());

            monthsCounts.push(monthsCount);
            totalMonths += monthsCount;
            // console.log(w.id, from, to, monthsCount);
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
                console.log(mainSkill, subSkill || '_', w.subjects[subject], (w.subjects[subject] * monthsCounts[w_idx]));
                addSkillData(mainSkill, '_', w.id, (w.subjects[subject] * monthsCounts[w_idx]));
                if (subSkill) addSkillData(mainSkill, subSkill, w.id, (w.subjects[subject] * monthsCounts[w_idx]));
            });
        });

        console.log('++++++++');
        console.log(skills);

        var skillScale = d3.scaleLinear().range([ 0, Math.PI / 2 ])
                                         .domain([ 0, totalMonths ]);

        var svg = d3.select(target).append('svg')
                    .attr('width', 100).attr('height', 100);

        // var lastSkillValue = {};
        // var lastSubSkillValue = {};

        svg.append('g').attr('id', 'skills')
           .selectAll('g').data(Object.keys(skills)).enter()
           .append('g').attr('id', function(skill) { return skill; })
        //    .append('path').attr('d', function(skill) {
        //        var skillTotal = skills[skill]['_'];
        //         return arc(10, skills['_'], to);
        //    })
           .each(function(skill) {
               var skillTotal = skills[skill]['_'];
               //d3.select(this).append('arc')
               d3.select(this).selectAll('g')
                 .data(Object.keys(skills[skill]).filter(function() { return skill !== '_'; })).enter()
                 .append('g').attr('id', function(subSkill) { return subSkill; })
                 .append('text').text(function(subSkill) { return subSkill });
                //  .append('path').attr('d', function(subSkill) {
                //     return arc(20, from, to);
                //  })
           })
           .append('text')
           .text(function(skill) { return skill });
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
