/**
 * Stub of RCTFH for Android.
 *
 * @providesModule RCTFH
 * @flow
 */
'use strict';

var warning = require('fbjs/lib/warning');
var RCTFH = require('./index.js');

/**
 * High-level docs for the RCTFH Android API can be written here.
 */

// define the RCTFH4Android "Constructor"
function RCTFH4Android() {}

// Define the Android Native module implementation functions
RCTFH4Android.prototype.getCloudHost = async function () {
  return await this.fh.getCloudHost();
};
RCTFH4Android.prototype.getFHParams = async function () {
  return await this.fh.getFHParams();
};
RCTFH4Android.prototype.echo = function () {
  return 'echo ...';
};

// do the RCTFH mixin
RCTFH.constructor.mixin(RCTFH4Android);
var rctFH4Android = new RCTFH4Android();
console.debug('after RCTFH mixin', rctFH4Android, rctFH4Android.prototype);

module.exports = rctFH4Android;
