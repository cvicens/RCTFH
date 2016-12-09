import { NativeModules } from 'react-native';
export const { FH } = NativeModules;

var RCTFH = {
  init: async function() {
    return await FH.init();
  },
  auth: async function(authPolicy, username, password) { 
    return await FH.auth(authPolicy, username, password);
  },
  cloud: async function(options) { 
    return await FH.cloud(options);
  }
};

module.exports = RCTFH;