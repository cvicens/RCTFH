## Instructions for iOS

## Local Environment setup
You have to setup the following tools before you can perform the other steps.

 * React Native CLI
  * requires:
    * NodeJS (>= 6.x)
    * npm
 * Xcode

We suggest you follow the official [**React Native Getting Started Guide**](https://facebook.github.io/react-native/docs/getting-started.html) instructions to get it right!

### 1. Create your React Native Project
Do it as usual, for example: ``$ react-native init Test001 ``

Next an example output of the previous command.

```shell
$ react-native init Test001
This will walk you through creating a new React Native project in /Users/u001/Projects/react/rhmap-lib/Test002
Using yarn v0.17.8
Installing react-native...
yarn add v0.17.8
info No lockfile found.
[1/4] 🔍  Resolving packages...
warning react-native > xcode > node-uuid@1.4.7: Use uuid module instead
[2/4] 🚚  Fetching packages...
...
├─ wordwrap@1.0.0
├─ xml-name-validator@2.0.1
└─ yargs@6.6.0
✨  Done in 4.21s.
To run your app on iOS:
   cd /Users/u001/Projects/react/rhmap-lib/Test001
   react-native run-ios
   - or -
   Open ios/Test002.xcodeproj in Xcode
   Hit the Run button
To run your app on Android:
   cd /Users/u001/Projects/react/rhmap-lib/Test001
   Have an Android emulator running (quickest way to get started), or a device connected
   react-native run-android
```

### 2. Add 'rct-fh' dependency
Using npm: ``npm install rct-fh``

Or using yarn ``yarn add rct-fh``

Underneath the output using yarn.

```shell
$ yarn add rct-fh
yarn add v0.17.8
[1/4] 🔍  Resolving packages...
[2/4] 🚚  Fetching packages...
[3/4] 🔗  Linking dependencies...
warning Incorrect peer dependency "react@^15.5.0".
[4/4] 📃  Building fresh packages...
success Saved lockfile.
success Saved 1 new dependency.
└─ rct-fh@0.0.9
✨  Done in 3.50s.
```

### 3. Let's link the new module
To do so, let's use: ``react-native link`` as in the following test.

```shell
$ react-native link
Scanning 564 folders for symlinks in /Users/u001/Projects/react/rhmap-lib/Test001/node_modules (5ms)
rnpm-install info Linking rct-fh ios dependency
rnpm-install info iOS module rct-fh has been successfully linked
```

### 4. Install RHMAP iOS framwork using cocoapods
Let's create a Podfile at ``./ios/Podfile``, change Test001 by the name of the React Native project us used with ``react-native init``.

```shell
source 'https://github.com/CocoaPods/Specs.git'
project 'Test001.xcodeproj'
platform :ios, '7.0'
use_frameworks!
target 'Test001' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  # Pods for FH
  #pod 'FH', '~> 3.1.1'
  pod 'RCTFH', path: '../node_modules/rct-fh'
end
```
Now change dir to ``./ios`` and run ``pod install``

You should get an output similar to this one.

```
$ pod install

---------------------------------------------
Error loading the plugin `cocoapods-appledoc-0.1.0`.

Gem::LoadError - Unable to activate cocoapods-appledoc-0.1.0, because cocoapods-1.2.0.beta.1 conflicts with cocoapods (~> 0.34)
/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/lib/ruby/2.0.0/rubygems/specification.rb:2007:in `raise_if_conflicts'
/System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/lib/ruby/2.0.0/rubygems/specification.rb:1176:in `activate'
/Library/Ruby/Gems/2.0.0/gems/claide-1.0.1/lib/claide/command/plugin_manager.rb:93:in `safe_activate_and_require'
/Library/Ruby/Gems/2.0.0/gems/claide-1.0.1/lib/claide/command/plugin_manager.rb:31:in `block in load_plugins'
/Library/Ruby/Gems/2.0.0/gems/claide-1.0.1/lib/claide/command/plugin_manager.rb:30:in `map'
/Library/Ruby/Gems/2.0.0/gems/claide-1.0.1/lib/claide/command/plugin_manager.rb:30:in `load_plugins'
/Library/Ruby/Gems/2.0.0/gems/claide-1.0.1/lib/claide/command.rb:326:in `block in run'
/Library/Ruby/Gems/2.0.0/gems/claide-1.0.1/lib/claide/command.rb:325:in `each'
/Library/Ruby/Gems/2.0.0/gems/claide-1.0.1/lib/claide/command.rb:325:in `run'
/Library/Ruby/Gems/2.0.0/gems/cocoapods-1.2.0.beta.1/lib/cocoapods/command.rb:50:in `run'
/Library/Ruby/Gems/2.0.0/gems/cocoapods-1.2.0.beta.1/bin/pod:55:in `<top (required)>'
/usr/local/bin/pod:23:in `load'
/usr/local/bin/pod:23:in `<main>'
---------------------------------------------

Analyzing dependencies
Fetching podspec for `RCTFH` from `../node_modules/rct-fh`
Downloading dependencies
Installing AeroGear-Push (1.2.0)
Installing FH (3.1.1)
Installing RCTFH (0.1.0)
Installing Reachability (3.2)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `Test001.xcworkspace` for this project from now on.
Sending stats
Pod installation complete! There is 1 dependency from the Podfile and 4 total pods installed.
```

### 5. Create the RHMAP iOS configuration file

In order to communicate with RHMAP Cloud Apps you have to provide a configuration file specific for your target platform:
 * [Server Connection setup for iOS](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/client_sdk/native-ios-objective-c#native-ios-objective-c-setup)

Below you'll find an example of ``fhconfig.plist`` file.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist>
<dict>
  <key>host</key>
  <string>https://[your rhmap domain].redhatmobile.com</string>
  <key>appid</key>
  <string>your_appid</string>
  <key>projectid</key>
  <string>your_projectid</string>
  <key>appkey</key>
  <string>your_appkey</string>
  <key>connectiontag</key>
  <string>x.y.z</string>
</dict>
</plist>
```

To create it open the XCode workspace generated before (if you cannot find the workspace maybe you should go to the previous chapter and run ``pod install``).

```
$ cd Test001
$ open ios/Test001.xcworkspace/
```

Once inside the XCode workspace create a new file under the project node in the file inspector.

1. Right click on the project icon in the file inspector and select 'New File'. Select 'Property list' as the file type.
2. Give the file the following name ``fhconfig.plist``
3. It's time to copy the contents of the sample file above, to do so, right click the file and select 'Open As'→'Source Code'
4. Paste the contents and edit the file to match your Cloud App where is running the sample 'hello' end point.

### 6. Using the module
Below you'll find an example of ``index.ios.js`` that uses our module ``rct-fh``. Please pay attention to the class name exported (Test001 in our example) and also to the name of the app registered in the last line (again Test001 in our example). For simplicity make the name of both the class and the component registered to be the name of the React Native application we used in **step #1** where we run ``react-native init <App Name>``.

#### 6.1 Importing the module
To import the module, just require 'rct-fh' (or the `rct-fh/RCTFH.ios` as explained [here](./README.md)).

```js
var RCTFH = require('rct-fh');
```
The excerpt below shows how we're defining an object exposing native module methods asynchronously. See [index.js](./index.js) for more details.

```js
RCTFH.prototype.init = async function () {
  return await this.fh.init();
};
RCTFH.prototype.auth = async function (authPolicy, username, password) {
  return await this.fh.auth(authPolicy, username, password);
};
RCTFH.prototype.cloud = async function (options) {
  return await this.fh.cloud(options);
};
```

#### 6.2 Init the module
The function to initialize the module is: ``RCTFH.init()``. This function is asynchronous and as such we could use the [keyword `await`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/await) to asynchronously await for the init process to finish (in the same fashion as ``then`` in a Promise). As you can see below, once the init process has ``resolved`` properly we get the ``result`` object. On the other hand if there is a problem while initializing the module the init process will be ``rejected`` and hence the ``catch`` code will be fired. See method RCT\_REMAP\_METHOD(init, resolver, rejecter) [RCTFH.m](./RCTFH.m).

```js
try {
	this.setState({message: 'Initializing...'});
	const result = await RCTFH.init();
	console.log('init result', result);
	this.setState({message: 'Ready'});

	if (result === 'SUCCESS') {
	  console.log('SUCCESS');
	  this.setState({init: true});
	} else {
	  console.error('Error');
	}
} catch (e) {
	console.error('Exception', e);
}
```

#### 6.3 Authentication
Before we can use this function we need to have defined an authentication policy in RHMAP Studio. For more information about authentication policies please go to [RHMAP Auth Policies](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/product_features/product-features-administration-and-management#auth-policies).

The function to trigger an authentication policy is: ``RCTFH.auth()``. This function is also asynchronous and as such we could use the keyword ``await`` to asynchronously await for the authentication process to finish. If the policy is invoked properly we will get a ``result`` object, if the credentials provided are correct the object will include a ``sessionToken`` attribute. On the other hand if there is a problem the function will be ``rejected`` and hence the ``catch`` code will be fired. See method RCT\_REMAP\_METHOD(auth, authPolicy, username, password, resolver, rejecter) [RCTFH.m](./RCTFH.m).

```js
try {
	const result = await RCTFH.auth(authPolicy, username, password);
	if (typeof result.sessionToken !== 'undefined') {
	  console.log('AUTHENTICATED');
	} else {
	  console.log('UNAUTHENTICATED');
	}
} catch (e) {
	console.error('ERROR', e);
}
```

#### 6.4 REST call, 'cloud' API
The function to call a RESTful endpoint exposed in a FeedHendry Cloud App is: ``RCTFH.cloud(options)``. Again, this function is asynchronous and as such we could use the keyword ``await`` to asynchronously await for the cloud call process to finish. In the same fashion as the init call, once the cloud call has ``resolved`` properly we get the ``result`` object and if there is a problem the ``catch`` code will be fired. See method RCT\_REMAP\_METHOD(cloud, options, resolver, rejecter) [RCTFH.m](./RCTFH.m).

As you can see, we are using a set options to use this function:

* ``path`` cloud app endpoint
* ``method`` HTTP method; GET, POST, etc.
* ``contentType`` usually *application/json*
* ``data `` object we want to use along with the HTTP method, in the case of the GET method a flat object is turned into query parameters
* ``timeout `` HTTP timeout

```js
try {
  const result = await RCTFH.cloud({
    "path": "/hello", //only the path part of the url, the host will be added automatically
    "method": "GET", //all other HTTP methods are supported as well. For example, HEAD, DELETE, OPTIONS
    "contentType": "application/json",
    "data": { "hello": this.state.userInput}, //data to send to the server
    "timeout": 25000 // timeout value specified in milliseconds. Default: 60000 (60s)
  });

  if (result && result.msg)
    this.setState({message: result.msg});
  else
    this.setState({message: JSON.stringify(result)});
} catch (e) {
  this.setState({message: 'Error' + e});
}
```


#### index.ios.js complete example code

```js
import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  TextInput,
  View,
  Button,
  Image
} from 'react-native';

var RCTFH = require('rct-fh');

export default class Test001 extends Component {
   constructor(props) {
    console.log('constructor()');
    super(props);

    this.state = {
      message: 'Waiting...',
      userInput: '',
      init: false
    };
  }

  componentDidMount () {
    // Let's init RHMAP module after the component mounts
    this.init();
  }


  sayHello = async () => {
    console.log('sayHello');
    try {
      const result = await RCTFH.cloud({
        "path": "/hello", //only the path part of the url, the host will be added automatically
        "method": "GET", //all other HTTP methods are supported as well. For example, HEAD, DELETE, OPTIONS
        "contentType": "application/json",
        "data": { "hello": this.state.userInput}, //data to send to the server
        "timeout": 25000 // timeout value specified in milliseconds. Default: 60000 (60s)
      });

      console.log('sayHello result', result);
      if (result && result.msg)
        this.setState({message: result.msg});
      else
        this.setState({message: JSON.stringify(result)});
    } catch (e) {
      this.setState({message: 'Error' + e});
    }
  }

  init = async () => {
      try {
        this.setState({message: 'Initializing...'});
        const result = await RCTFH.init();
        console.log('init result', result);
        this.setState({message: 'Ready'});

        if (result === 'SUCCESS') {
          console.log('SUCCESS');
          this.setState({init: true});
        } else {
          console.error('Error');
        }
      } catch (e) {
        console.error('Exception', e);
      }  
  }

  updateUserInput = async (userInput) => {
    this.setState({userInput: userInput});
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.h1}>
          Feed Henry - React Native Template
        </Text>
        <TextInput key='2' style={styles.input} autoCapitalize = 'none'
          onSubmitEditing={(event) => this.updateUserInput(event.nativeEvent.text)}
          onEndEditing={(event) => this.updateUserInput(event.nativeEvent.text)}
          placeholder='Enter Your Name Here'
          placeholderTextColor='grey'
        />

        <Button style={styles.button}
        disabled={!this.state.init}
        onPress={this.sayHello}
        title="Say Hello From The Cloud"
        accessibilityLabel="Say Hello From The Cloud"
        />

        <View style={{flex: 1, flexDirection: 'row', alignItems: 'flex-start'}}>
        <Text style={styles.message}>
        {this.state.message}
        </Text>
        </View>

      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    paddingTop: 23,
    flex: 1,
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
  },
  row: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  input: {
      margin: 30,
      height: 36,
      padding: 4,
      fontSize: 18,
      borderWidth: 1,
      borderColor: 'black',
      borderRadius: 8,
      color: 'black'
   },
  h1: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  message: {
    flex: 1,
    height: 150,
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
    color: 'grey',
    borderWidth: 1,
    borderColor: 'grey',
  },
});

AppRegistry.registerComponent('Test001', () => Test001);
```
