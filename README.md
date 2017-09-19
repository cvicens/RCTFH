# React Native RHMAP (former Feedhenry) Wrapper (unofficial)

**React Native Wrapper around Red Hat Mobile (former Feedhenry) SDK** is built to provide a RN App access to both **iOS** and **Android** to the Red Hat Mobile SDK.  You'll find all the information related to documentation of the both SDKs (iOS and Android) this module is based on:  
 * [Native iOS (Objectve-C) SDK](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/client_sdk/native-ios-objective-c)
 * [Native Android SDK](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/client_sdk/native-android)

## Why a native bridge? Why not just JavaScript?
As of today plain [JS SDK](http://feedhenry.org/fh-js-sdk/) is browser driven and hence not usable in React Native.

## What is included in this module?
The `rct-fh` module includes three files:
 * `index.js`: the main module file which includes common functionality available for both native platforms (iOS and Android);
 * `RCTFH.android.js`: "extends" the main module providing additional native functions currently available only for Android;
 * `RCTFH.ios.js`: "extends" the main module providing additional native functions currently available only for iOS;

> the reason we offer specific modules for each native platform is the ability to provide native functions on different time frames. This allow contributors can provide new RHMAP SDK's native implementations to this Wrapper! For example, at this time the `RCTFH.android.js` module offers [`fhCloudHost`](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/client_api/fh-getcloudurl) and [`fhParams`](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/client_api/fh-getfhparams) functions from the [Native Android Cliet SDK](https://access.redhat.com/documentation/en-us/red_hat_mobile_application_platform_hosted/3/html/client_sdk/native-android) which is not available on `RCTFH.ios.js` yet...

## Is there a React Native template?
Indeed, you can find it [here](https://github.com/cvicens/quickstart-react-native).

## Steps to use this module in your React Native Project
  1. Create your React Native Project
  2. Add 'rct-fh' module dependency
  3. link native modules
  4. Install RHMAP framework
  5. Create the RHMAP configuration file for server communication (Cloud Apps)
  6. Using the module

### [Instructions for iOS](steps4iOS.md)
### [Instructions for Android](steps4Android.md)
