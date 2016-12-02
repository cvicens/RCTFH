/**
 * @providesModule RCTFH
 * @flow
 */
'use strict';

var NativeRCTFH = require('NativeModules').RCTFH;

/**
 * High-level docs for the RCTFH iOS API can be written here.
 */

var RCTFH = {
  test: function() {
    NativeRCTFH.test();
  }
};

module.exports = RCTFH;
