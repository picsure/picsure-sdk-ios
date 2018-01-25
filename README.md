<img src="assets/logo.png" alt="Picsure">

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage)
![Swift 4.0](https://img.shields.io/badge/Swift-4.0.x-orange.svg)
![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg)

Picsure generates insurance proposals based on image informations within seconds. This is the worldwide first AI in the insurance business based on image recognitions. We are providing our White-Label-API for insurance companies. Which allows them to create a new and full digital sales channel for their customers.

### Requirements ###

* Swift 4.0+
* iOS 8.0+

## Installation ⚙️ ##

#### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'Picsure', '~> 1.1.0'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

#### [Carthage](https://github.com/Carthage/Carthage)

Add this to `Cartfile`:

```
github "picsure/picsure-sdk-ios" ~> 1.1.0
```
And then, in the `Cartfile ` directory, type:

```bash
$ carthage update --platform iOS
```

## Usage 🚀 ##

Picsure SDK is as simple as possible. There are two main methods.

First, you have to initalize Picsure SDK with your API key.

```swift
Picsure.configure(withApiKey: "YOUR_API_KEY")
```
then just recognize the needed photo:

```swift
Picsure.upload(photo) { result in
    // check result or error ...
    // result - enum with two cases: success(json), failure(error).
}
```

You can configure response language as well. Just call:

```swift
Picsure.configure(language: "en")
```

with one of available language identifiers. Here is a list of supported languages:

- `at` - Austria
- `au` - Australia
- `ch` - Switzerland
- `da` - Denmark
- `de` - Germany
- `el` - Greece
- `en` - England
- `es` - Spain
- `fi` - Finland
- `fr` - France
- `gb` - United Kingdom
- `it` - Italy
- `ja` - Japan
- `nl` - Netherlands
- `no` - Norway
- `ru` - Russian Federation
- `us` - United States
- `zh` - China

Default identifier is `en`.

**NOTE:** Picsure needs to access the user’s Photos library to read EXIF data. Don't forget to request it before using:

```swift
import Photos

PHPhotoLibrary.requestAuthorization { status in
	print(status)
}
```

And add `NSPhotoLibraryUsageDescription` to `Info.plist`.

## License ##

Picsure SDK is available under the MIT license. See the LICENSE file for more info.
