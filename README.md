# ZoomAPI

## Installation
To install ZoomAPI using the Swift Package Manager, add the following to your Package.swift file's dependencies array:

```
.package(url: "https://github.com/varunchitturi/ZoomAPI.git", from: "0.1.0")
```
Then, add ZoomAPI to your target's dependencies:

```
.target(name: "YourTarget", dependencies: ["ZoomAPI"]),
```
## Usage

To use the ZoomAPI, import the package in your source code:

```
import ZoomAPI
```
Then, create an instance of the ZoomClient class, which is used to make calls to the Zoom API:

```
let zoomClient = ZoomClient()
```

Please refer to the [Zoom API documentation](https://marketplace.zoom.us/docs/api-reference/zoom-api) for more information on the available methods and their parameters.

## Testing

To run the tests for ZoomAPI, you will first need to set your Zoom API credentials as environment variables in Xcode. To do this, go to the "Scheme Editor" for the ZoomAPI target, select the "Run" tab, and then choose "Arguments". From here, you can add the `ZM_CLIENT_ID` (your Zoom App client id) and `ZM_CLIENT_SECRET` (your Zoom App client secret) variables in the "Environment Variables" section.

In addition, you will need to run the `RefreshToken` executable to obtain a refresh token for the tests to use. This can be done by running the following command:

```
$ xcodebuild -project ZoomAPI.xcodeproj -scheme RefreshToken -configuration Debug run
```
Once you have set your credentials and obtained a refresh token, you can run the tests for ZoomAPI by selecting the "Product > Test" menu in Xcode.

## License

ZoomAPI is released under the MIT License. See LICENSE for details.
