<img src="assets/logo.png" alt="Snapsure">

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage)
![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg) 
![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg) 

Snapsure generates insurance proposals based on image informations within seconds. This is the worldwide first AI in the insurance business based on image recognitions. We are providing our White-Label-API for insurance companies. Which allows them to create a new and full digital sales channel for their customers.

## Usage 🚀 ##

Snapsure SDK as simple as possible. There are only two methods.

First, you have to configure Snapsure SDK with your API key. You can check it in your account settings.

```swift
Snapsure.configure(withApiKey: "YOUR_API_KEY")
```
then just recognize the needed photo: 

```swift
Snapsure.uploadPhoto(photo) { result in
    // check recognition information, or error ...
    // result - enum with two cases: success(json), failure(error).
}
```

## Installation ⚙️ ##

#### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'Snapsure', '~> 1.0'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

#### [Carthage](https://github.com/Carthage/Carthage)

Add this to `Cartfile`

```
github "snapsure-insurance-bot/snapsure-sdk-ios" ~> 1.0
```

```bash
$ carthage update
```

### Requirements ###

* Swift 3.0
* iOS 8.0+

### License ###

Snapsure SDK is available under the MIT license. See the LICENSE file for more info.
