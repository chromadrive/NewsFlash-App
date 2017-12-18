# NewsFlash

_CS198-001 Project by [@chromadrive](github.com/chromadrive) [@zeyanaAM](github.com/zeyanaam) and [@aaronhoby](github.com/aaronhoby)_

## Getting Started
0) Navigate to the backend API ([http://newsapp-backend2.herokuapp.com/](http://newsapp-backend2.herokuapp.com/)) using a web browser and make sure it hasn't crashed.

1) Install the CocoaPods: `pod install`

2) Open XCode and launch the app, everything should already be working.

## Some Notes About the Server

The backend code included is incomplete and may not run properly, please see our backend's [development repo](https://github.com/chromadrive/NewsFlash-backend).

We've included references to our deployment server in our source should you build it, but the live version of the backend is quite unstable and is very crash-happy, and as a result `NewsFlash-CLIENT` may not work. If that happens, please either email me (`wxiong @ berkeley`) so I can get the server back up and running, or try running `NewsFlash-CLIENT-CACHED`. It's the same app, but runs on a cached version of our server.

If you do end up having to resort to using the cached app, you can test our search/browse functionality with these queries:

- Search: `Trump`, `iPhone`, `Star Wars`, `Black Friday`
- Browse Location: `United States`, `United Kingdom`, `Saudi Arabia`, `China`
- Browse Category: `Society`, `Science`, `Arts`