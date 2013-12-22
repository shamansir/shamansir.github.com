/* var path = [
  'M 10 99 C 215.7111111111111 106.48888888888891 421.4222222222222 113.97777777777782 587 227',
  'M 587 227 C 752.5777777777778 340.0222222222222 878.0222222222224 558.5777777777777 991 605',
  'M 991 605 C 1103.9777777777776 651.4222222222223 1204.4888888888888 525.7111111111112 1305 400'
]; */

function random(from, to) {
  return from + (Math.random() * (to - from));
}

var points = [ ];

var segments = document.getElementsByClassName('segment'),
    seg_count = segments.length;

var y_offset = 80,
    x_offset = 0,
    y_range = 200,
    x_range = 200;

points[0] = x_offset;
points[1] = y_offset;
for (var i = 0; i < seg_count; i++) {
  points.push(points[i * 2] + segments[i].offsetWidth);
  points.push((i !== 0) ? random(y_offset, y_offset + y_range)
                        : y_offset);
}

var cvs = document.getElementById('test-canvas'),
    ctx = cvs.getContext('2d');

ctx.strokeStyle = '#f00';
ctx.lineWidth = 2;
ctx.moveTo(points[0], points[1]);
for (var i = 2, il = points.length; i < il; i += 2) {
  ctx.lineTo(points[i], points[i + 1]);
}
ctx.stroke();

var deltaX, deltaY, angle;
for (var i = 0; i < seg_count; i++) {
    deltaX = points[i + i + 2] - points[i + i];
    deltaY = points[i + i + 3] - points[i + i + 1];
//angleInDegrees = arctan(deltaY / deltaX) * 180 / PI
    angle = Math.atan2(deltaY, deltaX) * 180 / Math.PI;
    segments[i].style.top = points[i + i + 1] + 'px';
    segments[i].style.left = points[i + i] + 'px';
    segments[i].style.webkitTransform = 'rotateZ(' + angle + 'deg)';
}
