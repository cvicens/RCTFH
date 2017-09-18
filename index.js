import { NativeModules } from 'react-native';
const { FH } = NativeModules;

// Define the RCTFH Constructor
function RCTFH() {}

// Define the default functions (native code implemented for both platforms: iOS and Android )
RCTFH.prototype.fh = FH;
RCTFH.prototype.init = async function () {
  return await this.fh.init();
};
RCTFH.prototype.auth = async function (authPolicy, username, password) {
  return await this.fh.auth(authPolicy, username, password);
};
RCTFH.prototype.cloud = async function (options) {
  return await this.fh.cloud(options);
};

// mixin - augment the target object with the RCTFH functions
// see http://book.mixu.net/node/ch6.html for a detailed explanation about the mixin approach
RCTFH.mixin = function(destObject){
  ['fh', 'init', 'auth', 'cloud'].forEach(function(property) {
    destObject.prototype[property] = RCTFH.prototype[property];
  });
};

module.exports = new RCTFH();
