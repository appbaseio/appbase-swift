# SwiftElasticSearch

## About Project

This project aims to create fast responsive Swift Library, supported for IPhone and Mac apps which provides the functionality of Elastic Search to be integrated in the app.

The library provides very high performance results i.e. it provides response to user queries in milliseconds of time including the elastic search processing time.

## Installation

### Cloning project (Easiest way)

* Download the project using command :

```
git clone "https://github.com/appbaseio-apps/SwiftElasticSearch.git"
```
* Navigate to file `SwiftElasticSearch.xcodeproj` and copy and paste it in your project directory (Under blue file icon in Xcode)

* Navigate to General Settings (click on blue file icon) -> Linked Framweworks and binaries

* Click on `+` icon and add the `SwiftElasticSearch.framework` file that is available under `Workspace` folder

* Build the project and that's it. The library is ready to import

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
