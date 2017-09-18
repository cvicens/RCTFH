/**
 * Stub of RCTFH for iOS.
 *
 * @providesModule RCTFH
 * @flow
 */
'use strict';

var warning = require('fbjs/lib/warning');
var RCTFH = require('./index.js');

/**
 * High-level docs for the RCTFH iOS API can be written here.
 */

// define the RCTFH4iOS "Constructor"
function RCTFH4iOS() {}

// Define the Android Native module implementation functions
RCTFH4iOS.prototype.getCloudHost = async function () {
  warning('Not yet implemented for iOS.');
};
RCTFH4iOS.prototype.getFHParams = async function () {
  warning('Not yet implemented for iOS.');
};
RCTFH4iOS.prototype.echo = function () {
  return 'echo ...';
};

// do the RCTFH mixin
RCTFH.constructor.mixin(RCTFH4iOS);
var rctFH4iOS = new RCTFH4iOS();
console.debug('after RCTFH mixin', rctFH4iOS, rctFH4iOS.prototype);

module.exports = rctFH4iOS;
