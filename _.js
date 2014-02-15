var layout = (function() {

function random(from, to) {
  return from + (Math.random() * (to - from));
}

var initialized = false;

var segments,
    matrices,
    handles;

var seg_count;

var cur_segment;

var idx_to_id,
    id_to_idx;

var x_offset,
    y_offset,
    x_offset_ratio = 0.1,
    y_offset_ratio = 0.2,
    y_range = 200,
    x_range = 250;

var seg_height_ratio = 0.55;

var z_rot_start = -(Math.PI / 15),
    z_rot_end = Math.PI / 15,
    y_rot_start = 0,
    y_rot_end = Math.PI / 15;

var identity_mat,
    identity_str;

var root;

function layout(current) {

    // layout() calculates a matrix for every segment (a.k.a. section) using random angle
    // of rotation by axis of Y and Z, stacks them in one (broken) line and then applies
    // a required inverted transformation matrix to the root element, so the current segment
    // will be positioned in center, while others will be positioned relatively to current one
    // properly.

    // Matrix calculation is done just once at the very start, then for all the next calls this
    // code just transforms the root element using the knowledge about current segment.

    // get current segment ID
    var current = current || (location.hash ? location.hash.slice(1) : '') || '';

    // initialize all segments and their 3d transforms (current one is a bit different
    // in transforms from others, so it's good to know which one is current) or skip all that,
    // if they are already initialized
    initializeOrSkip(current);

    // save an index of the current segment
    var current_idx = current ? id_to_idx[current] : 0;
    // style up the current segment, using `current` CSS class
    if (cur_segment) cur_segment.classList.remove('current');
    cur_segment = segments[current_idx];
    cur_segment.classList.add('current');

    // if current segment is the first one, no root transformations needed at all
    // (though they should be reset to identity, if they were applied before)
    if (current_idx === 0) {
        root.style.webkitTransform = identity_str;
    // if not, get the matrix of current segment transformations,
    // invert it, translate to the top left corner of the segments,
    // and then apply the result as `tranformation-matrix` via CSS
    } else if (current_idx) {
        var inv = mat4.clone(matrices[current_idx]);
        //mat4.translate(inv, inv, [-x_offset, -y_offset, 0]);
        mat4.invert(inv, inv);
        mat4.translate(inv, inv, [x_offset, y_offset, 0]);
        root.style.webkitTransform = mat4_cssStr(inv);
    }

}

function initializeOrSkip(current) {
    if (initialized) return;

    // TODO: call on resize

    identity_mat = mat4.create();
    identity_str = mat4_cssStr(identity_mat);

    root = document.getElementById('segments-root');

    segments = document.getElementsByClassName('segment');
    seg_count = segments.length;
    handles = [];

    idx_to_id = [];
    id_to_idx = [];

    var html = document.body.parentNode,
        width = html.clientWidth,
        height = html.clientHeight;

    x_offset = width * x_offset_ratio,
    y_offset = height * y_offset_ratio;

    var opacity_range = seg_count, // 5, seg_count
        blur_range = 5; // TODO, seg_count

    // initialize segment width
    var segment, segment_id, segment_content;
    for (var i = 0; i < seg_count; i++) {
        segment = segments[i];

        //segment.style.width = Math.floor(random(x_range, x_range * 1.5)) + 'px';
        segment.style.width = x_range + 'px';

        segment_content = segment.getElementsByClassName('segment-inner')[0];
        if (segment_content) {
            var prev_height = segment_content.clientHeight;
            var height_limit = Math.floor(height * seg_height_ratio);
            segment_content.style.maxHeight = height_limit + 'px';
            segment.style.minHeight = height_limit + 'px';
            if (prev_height > height_limit) {
                segment_content.classList.add('overflown');
            } else {
                segment_content.classList.remove('overflown');
            }
        }

        segment_id = segment.id;

        id_to_idx[segment_id] = i;
        idx_to_id[i] = segment_id;

        segment.id = segment_id + '-' + i; // to prevent auto-scroll

        handles[i] = document.getElementById(segment_id + '-handle');
        if (handles[i]) {
            handles[i].addEventListener('click', (function(segment_id) {
               return function() {
                   //console.log('click-handle', segment_id);
                   location.hash = '#' + segment_id;
                   layout(segment_id);
               };
            })(segment_id), false);
        }
    }

    var nav_list = document.getElementsByTagName('nav')
    var nav_links = nav_list[0].getElementsByClassName('seg-href');
    for (var i = 0, il = nav_links.length, par_id, seg_id; i < il; i++) {
        //par_id = nav_links[i].parentNode.id;
        par_id = nav_links[i].id;
        seg_id = par_id.slice(0, par_id.length - '-href'.length);
        nav_links[i].addEventListener('click', (function(segment_id) {
           return function() {
               //console.log('nav-click-handle', segment_id);
               location.hash = '#' + segment_id;
               layout(segment_id);
           };
        })(seg_id), false);
    }

    matrices = [];

    var angleZ, angleY;
    var mat = mat4.create(),
        mat_trans = mat4.create();
    mat4.translate(mat, mat, [x_offset, y_offset, 0]);
    for (var i = 0; i < seg_count; i++) {
        if (i) {
            angleZ = random(z_rot_start, z_rot_end);
            angleY = random(y_rot_start, y_rot_end);
            mat4.rotateZ(mat, mat, angleZ);
            mat4.rotateY(mat, mat, angleY * -1);
            matrices[i] = mat4.clone(mat);
        }
        segments[i].style.webkitTransform = mat4_cssStr(mat);
        mat_trans[12] = segments[i].offsetWidth; // substitute translate-x value
        mat4.multiply(mat, mat, mat_trans);
        //segments[i].style.webkitPerspective = i * 50;
    }

    initialized = true;
}

function mat4_cssStr(src) {
    return 'matrix3d(' +
        src[ 0].toFixed(10) + ',' + src[ 1].toFixed(10) + ',' + src[ 2].toFixed(10) + ',' + src[ 3].toFixed(10) + ',' +
        src[ 4].toFixed(10) + ',' + src[ 5].toFixed(10) + ',' + src[ 6].toFixed(10) + ',' + src[ 7].toFixed(10) + ',' +
        src[ 8].toFixed(10) + ',' + src[ 9].toFixed(10) + ',' + src[10].toFixed(10) + ',' + src[11].toFixed(10) + ',' +
        src[12].toFixed(10) + ',' + src[13].toFixed(10) + ',' + src[14].toFixed(10) + ',' + src[15].toFixed(10) +
    ')';

}

/* Copyright (c) 2013, Brandon Jones, Colin MacKenzie IV. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

/* DISCLAIMER

NB: MODIFIED FROM ORGINAL BY CUTTING OF 60% OF CODE, DON'T USE IT FROM HERE

Modified to use usual JavaScript arrays instead of GL-ones, and
used for the purpose of holy Math only. If you plan to friend it
back to WebGL, use the original source from:

https://github.com/toji/gl-matrix/blob/master/src/gl-matrix/mat4.js

*/

/**
 * @class 4x4 Matrix
 * @name mat4
 */
var mat4 = {};

/**
 * Creates a new identity mat4
 *
 * @returns {mat4} a new 4x4 matrix
 */
mat4.create = function() {
    var out = new Array(16);/*new GLMAT_ARRAY_TYPE(16)*/
    out[0] = 1;
    out[1] = 0;
    out[2] = 0;
    out[3] = 0;
    out[4] = 0;
    out[5] = 1;
    out[6] = 0;
    out[7] = 0;
    out[8] = 0;
    out[9] = 0;
    out[10] = 1;
    out[11] = 0;
    out[12] = 0;
    out[13] = 0;
    out[14] = 0;
    out[15] = 1;
    return out;
};

/**
 * Creates a new mat4 initialized with values from an existing matrix
 *
 * @param {mat4} a matrix to clone
 * @returns {mat4} a new 4x4 matrix
 */
mat4.clone = function(a) {
    var out = new Array(16); /*new GLMAT_ARRAY_TYPE(16);*/
    out[0] = a[0];
    out[1] = a[1];
    out[2] = a[2];
    out[3] = a[3];
    out[4] = a[4];
    out[5] = a[5];
    out[6] = a[6];
    out[7] = a[7];
    out[8] = a[8];
    out[9] = a[9];
    out[10] = a[10];
    out[11] = a[11];
    out[12] = a[12];
    out[13] = a[13];
    out[14] = a[14];
    out[15] = a[15];
    return out;
};

/**
 * Inverts a mat4
 *
 * @param {mat4} out the receiving matrix
 * @param {mat4} a the source matrix
 * @returns {mat4} out
 */
mat4.invert = function(out, a) {
    var a00 = a[0], a01 = a[1], a02 = a[2], a03 = a[3],
        a10 = a[4], a11 = a[5], a12 = a[6], a13 = a[7],
        a20 = a[8], a21 = a[9], a22 = a[10], a23 = a[11],
        a30 = a[12], a31 = a[13], a32 = a[14], a33 = a[15],

        b00 = a00 * a11 - a01 * a10,
        b01 = a00 * a12 - a02 * a10,
        b02 = a00 * a13 - a03 * a10,
        b03 = a01 * a12 - a02 * a11,
        b04 = a01 * a13 - a03 * a11,
        b05 = a02 * a13 - a03 * a12,
        b06 = a20 * a31 - a21 * a30,
        b07 = a20 * a32 - a22 * a30,
        b08 = a20 * a33 - a23 * a30,
        b09 = a21 * a32 - a22 * a31,
        b10 = a21 * a33 - a23 * a31,
        b11 = a22 * a33 - a23 * a32,

        // Calculate the determinant
        det = b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06;

    if (!det) {
        return null;
    }
    det = 1.0 / det;

    out[0] = (a11 * b11 - a12 * b10 + a13 * b09) * det;
    out[1] = (a02 * b10 - a01 * b11 - a03 * b09) * det;
    out[2] = (a31 * b05 - a32 * b04 + a33 * b03) * det;
    out[3] = (a22 * b04 - a21 * b05 - a23 * b03) * det;
    out[4] = (a12 * b08 - a10 * b11 - a13 * b07) * det;
    out[5] = (a00 * b11 - a02 * b08 + a03 * b07) * det;
    out[6] = (a32 * b02 - a30 * b05 - a33 * b01) * det;
    out[7] = (a20 * b05 - a22 * b02 + a23 * b01) * det;
    out[8] = (a10 * b10 - a11 * b08 + a13 * b06) * det;
    out[9] = (a01 * b08 - a00 * b10 - a03 * b06) * det;
    out[10] = (a30 * b04 - a31 * b02 + a33 * b00) * det;
    out[11] = (a21 * b02 - a20 * b04 - a23 * b00) * det;
    out[12] = (a11 * b07 - a10 * b09 - a12 * b06) * det;
    out[13] = (a00 * b09 - a01 * b07 + a02 * b06) * det;
    out[14] = (a31 * b01 - a30 * b03 - a32 * b00) * det;
    out[15] = (a20 * b03 - a21 * b01 + a22 * b00) * det;

    return out;
};

/**
 * Multiplies two mat4's
 *
 * @param {mat4} out the receiving matrix
 * @param {mat4} a the first operand
 * @param {mat4} b the second operand
 * @returns {mat4} out
 */
mat4.multiply = function (out, a, b) {
    var a00 = a[0], a01 = a[1], a02 = a[2], a03 = a[3],
        a10 = a[4], a11 = a[5], a12 = a[6], a13 = a[7],
        a20 = a[8], a21 = a[9], a22 = a[10], a23 = a[11],
        a30 = a[12], a31 = a[13], a32 = a[14], a33 = a[15];

    // Cache only the current line of the second matrix
    var b0  = b[0], b1 = b[1], b2 = b[2], b3 = b[3];
    out[0] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
    out[1] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
    out[2] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
    out[3] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

    b0 = b[4]; b1 = b[5]; b2 = b[6]; b3 = b[7];
    out[4] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
    out[5] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
    out[6] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
    out[7] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

    b0 = b[8]; b1 = b[9]; b2 = b[10]; b3 = b[11];
    out[8] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
    out[9] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
    out[10] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
    out[11] = b0*a03 + b1*a13 + b2*a23 + b3*a33;

    b0 = b[12]; b1 = b[13]; b2 = b[14]; b3 = b[15];
    out[12] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
    out[13] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
    out[14] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
    out[15] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
    return out;
};

/**
 * Translate a mat4 by the given vector
 *
 * @param {mat4} out the receiving matrix
 * @param {mat4} a the matrix to translate
 * @param {vec3} v vector to translate by
 * @returns {mat4} out
 */
mat4.translate = function (out, a, v) {
    var x = v[0], y = v[1], z = v[2],
        a00, a01, a02, a03,
        a10, a11, a12, a13,
        a20, a21, a22, a23,
        a30, a31, a32, a33;

        a00 = a[0]; a01 = a[1]; a02 = a[2]; a03 = a[3];
        a10 = a[4]; a11 = a[5]; a12 = a[6]; a13 = a[7];
        a20 = a[8]; a21 = a[9]; a22 = a[10]; a23 = a[11];
        a30 = a[12]; a31 = a[13]; a32 = a[14]; a33 = a[15];

    out[0] = a00 + a03*x;
    out[1] = a01 + a03*y;
    out[2] = a02 + a03*z;
    out[3] = a03;

    out[4] = a10 + a13*x;
    out[5] = a11 + a13*y;
    out[6] = a12 + a13*z;
    out[7] = a13;

    out[8] = a20 + a23*x;
    out[9] = a21 + a23*y;
    out[10] = a22 + a23*z;
    out[11] = a23;
    out[12] = a30 + a33*x;
    out[13] = a31 + a33*y;
    out[14] = a32 + a33*z;
    out[15] = a33;

    return out;
};

/**
 * Rotates a matrix by the given angle around the Y axis
 *
 * @param {mat4} out the receiving matrix
 * @param {mat4} a the matrix to rotate
 * @param {Number} rad the angle to rotate the matrix by
 * @returns {mat4} out
 */
mat4.rotateY = function (out, a, rad) {
    var s = Math.sin(rad),
        c = Math.cos(rad),
        a00 = a[0],
        a01 = a[1],
        a02 = a[2],
        a03 = a[3],
        a20 = a[8],
        a21 = a[9],
        a22 = a[10],
        a23 = a[11];

    if (a !== out) { // If the source and destination differ, copy the unchanged rows
        out[4]  = a[4];
        out[5]  = a[5];
        out[6]  = a[6];
        out[7]  = a[7];
        out[12] = a[12];
        out[13] = a[13];
        out[14] = a[14];
        out[15] = a[15];
    }

    // Perform axis-specific matrix multiplication
    out[0] = a00 * c - a20 * s;
    out[1] = a01 * c - a21 * s;
    out[2] = a02 * c - a22 * s;
    out[3] = a03 * c - a23 * s;
    out[8] = a00 * s + a20 * c;
    out[9] = a01 * s + a21 * c;
    out[10] = a02 * s + a22 * c;
    out[11] = a03 * s + a23 * c;
    return out;
};

/**
 * Rotates a matrix by the given angle around the Z axis
 *
 * @param {mat4} out the receiving matrix
 * @param {mat4} a the matrix to rotate
 * @param {Number} rad the angle to rotate the matrix by
 * @returns {mat4} out
 */
mat4.rotateZ = function (out, a, rad) {
    var s = Math.sin(rad),
        c = Math.cos(rad),
        a00 = a[0],
        a01 = a[1],
        a02 = a[2],
        a03 = a[3],
        a10 = a[4],
        a11 = a[5],
        a12 = a[6],
        a13 = a[7];

    if (a !== out) { // If the source and destination differ, copy the unchanged last row
        out[8]  = a[8];
        out[9]  = a[9];
        out[10] = a[10];
        out[11] = a[11];
        out[12] = a[12];
        out[13] = a[13];
        out[14] = a[14];
        out[15] = a[15];
    }

    // Perform axis-specific matrix multiplication
    out[0] = a00 * c + a10 * s;
    out[1] = a01 * c + a11 * s;
    out[2] = a02 * c + a12 * s;
    out[3] = a03 * c + a13 * s;
    out[4] = a10 * c - a00 * s;
    out[5] = a11 * c - a01 * s;
    out[6] = a12 * c - a02 * s;
    out[7] = a13 * c - a03 * s;
    return out;
};

return layout;

})();
