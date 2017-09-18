## Instructions for Android

### 1. Create your React Native Project
Do it as usual, for example: ``$ react-native init Test001 ``

Next an example output of the previous command.

```shell
$ react-native init HelloWorld

```

### 2. Add 'rct-fh' dependency
Using npm: ``npm install rct-fh``

Or using yarn ``yarn add rct-fh``

Underneath the output using npm.

```shell

```

### 3. Let's link the new module
To do so, let's use: ``react-native link`` as in the following test.

```shell
$ react-native link

```

### 4. Install RHMAP Android framework using Graddle
Let's create a Podfile at ``./ios/Podfile``, change Test001 by the name of the React Native project us used with ``react-native init``.

```shell

```
Now change dir to ``./android`` and run ``graddle install``

You should get an output similar to this one.

```

```

### 5. Create the RHMAP Android configuration file
Below you'll find an example of ``fhconfig.plist`` file.

```json
```

To create it open the Android Studio workspace generated before (if you cannot find the workspace maybe you should go to the previous chapter and run ``graddle install``).

```
$ cd HelloWorld
```

Once inside the Andoird Studio workspace create a new file under the project node in the file inspector.

1. Right click on the project icon in the file inspector and select 'New File'. Select 'Property list' as the file type.
2. Give the file the following name ``fhconfig.json``
3. It's time to copy the contents of the sample file above, to do so, right click the file and select 'Open As'→'Source Code'
4. Paste the contents and edit the file to match your Cloud App where is running the sample 'hello' end point.

### 6. Using the module
Below you'll find an example of ``index.android.js`` that uses our module ``rct-fh``. Please pay attention to the class name exported (Test001 in our example) and also to the name of the app registered in the last line (again Test001 in our example). For simplicity make the name of both the class and the component registered to be the name of the React Native application we used in **step #1** where we run ``react-native init <App Name>``.

#### 6.1 Importing the module
To import the module, just require 'rct-fh'.

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
The function to initialize the module is: ``RCTFH.init()``. This function is asynchronous and as such we could use the keyword ``await`` to asynchronously await for the init process to finish (in the same fashion as ``then`` in a Promise). As you can see below, once the init process has ``resolved`` properly we get the ``result`` object. On the other hand if there is a problem while initializing the module the init process will be ``rejected`` and hence the ``catch`` code will be fired. See method RCT\_REMAP\_METHOD(init, resolver, rejecter) [RCTFH.m](./RCTFH.m).

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


#### index.android.js complete example code

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
