/**
 * @providesModule RCTFH for Android
 * @flow
 */
'use strict';

import { NativeModules } from 'react-native';
export const { FH } = NativeModules;

var RCTFH = {
  init: async function() {
    return await FH.init();
  },
  getCloudUrl: async function() {
    console.warn('Function getCloudUrl not yet implemented for Android');
  },
  auth: async function(authPolicy, username, password) { 
    return await FH.auth(authPolicy, username, password);
  },
  cloud: async function(options) { 
    return await FH.cloud(options);
  }
};

module.exports = RCTFH;

