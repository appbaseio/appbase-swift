# SwiftElasticSearch

## About Project

This project aims to create fast responsive Swift Library, supported for IPhone and Mac apps which provides the functionality of Elastic Search to be integrated in the app.

The library provides very high performance results i.e. it provides response to user queries in milliseconds of time including the elastic search processing time.

## Installation

### Dynamic Framework (Simplest way)

* Download the latest release of [SwiftElasticSearch](https://github.com/appbaseio-apps/SwiftElasticSearch/archive/v0.0.3.zip) from Github and extract the zip 

* Navigate to your Xcode's project `General` settings (Click on the the blue icon showing your project's workspace -> General)

* Drag the `SwiftElasticSearch.xcodeproj` file from the extracted folder in the `Embedded Binaries` section and select the `Copy items if needed` checkbox in the prompted dialog box (if it appears) and click Finish

* Go to `Linked Frameworks and Libraries` section and click on the `+` icon

* Click on the `SwiftElasticSearch.framework` to add it to dependencies

* Build the project

Here is the GIF showing all the above steps in action - 

![GIF showing the above steps](https://github.com/appbaseio-apps/SwiftElasticSearch/blob/master/SwiftElasticSearchDemo.gif)

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds dependencies and provides binary frameworks for direct use.

To install Carthage, use [Homebrew](https://brew.sh/) package manager and write the following commands :

```
$ brew update
$ brew install carthage
```
To integrate SwiftElasticSearch in your Xcode project :

* Switch to your project directory in terminal

* Now make a Cartfile using command :

```
touch Cartfile
```
* Now open the Cartfile using command :

```
open Cartfile
```
* Add the following dependency in your Cartfile :

```
github "appbaseio-apps/SwiftElasticSearch" ~> <Release Version>
```
The current latest Release Version is 0.0.3

* Run `carthage update` to build the framework

* Drag the `SwiftElasticSearch.framework` file that is generated inside Build folder of Carthage to your Xcode project

* Build the project

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but ElasticSwift does support its use on supported platforms.

To add SwiftElasticSearch library as dependency, add the following line in the dependencies value of Package.swift : 

```
dependencies: [
.Package(url: "https://github.com/appbaseio-apps/SwiftElasticSearch.git", "1.1.0")
]
```

## Docs

WIP docs are at https://swift-elasticsearch.netlify.com.
