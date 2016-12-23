REACT Native Feedhenry Wrapper (unofficial)
=============
**React Native Wrapper around Feedhenry SDK** is built to provide a RN App access to both **iOS** and in the future also for **Android** to the Feedhenry SDK.

## Why a native bridge? Why not use just JavaScript?
As of today plain JS library is browser driven.


## Content
  * [Installation](#installation-and-linking-libraries)

1) Create your React Native project
2) npm install
2) Add dependencies: npm install --save rct-fh
3) (This maybe optional... related to a bug?) react-native upgrade
    If not... you could get this error---> Bundle Identifier not found... (https://github.com/facebook/react-native/issues/7308)

4) Link libraries: react-native link
4) cd ./node_modules/rct-fh/
   pod install
[OPTIONAL] If you want to use XCode...
5) cp sample-Podfile to ./ios/ ... change Podfile to match your Project name
6) Add libRCTFH.o en Build Phases/Link.... 
