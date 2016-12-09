/**
 * @providesModule RCTFH
 * @flow
 */
'use strict';

var NativeRCTFH = require('NativeModules').FH;

/**
 * High-level docs for the RCTFH iOS API can be written here.
 */

var RCTFH = {
  init: async function() {
    return NativeRCTFH.init();
  },
  auth: async function(authPolicy, username, password) { 
    return NativeRCTFH.auth(authPolicy, username, password);
  },
  cloud: async function(options) { 
    return NativeRCTFH.cloud(options);
  }
};

module.exports = RCTFH;
