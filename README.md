<img src="assets/logo.png" alt="Snapsure">

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage)
![Swift 3.0.x](https://img.shields.io/badge/Swift-3.0.x-orange.svg)
![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg)

Snapsure generates insurance proposals based on image informations within seconds. This is the worldwide first AI in the insurance business based on image recognitions. We are providing our White-Label-API for insurance companies. Which allows them to create a new and full digital sales channel for their customers.

### Requirements ###

* Swift 3.0
* iOS 8.0+

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

## Usage 🚀 ##

Snapsure SDK is as simple as possible. There are only two methods.

First, you have to initalize Snapsure SDK with your API key.

```swift
Snapsure.configure(withApiKey: "YOUR_API_KEY")
```
then just recognize the needed photo:

```swift
Snapsure.uploadPhoto(photo) { result in
    // check result or error ...
    // result - enum with two cases: success(json), failure(error).
}
```




## Licence ##

```
MIT License

Copyright (c) 2017 Snapsure

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
