# SwiftElasticSearch

## About Project

This project aims to create fast responsive Swift Library, supported for IPhone and Mac apps which provides the functionality of Elastic Search to be integrated in the app.

The library provides very high performance results i.e. it provides response to user queries in milliseconds of time including the elastic search processing time.

## Installation

### Swift Package Manager

The Swift Package Manager is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but ElasticSwift does support its use on supported platforms.

To add SwiftElasticSearch library as dependency, add the following line in the dependencies value of Package.swift : 

```
dependencies: [
.Package(url: "https://github.com/appbaseio-apps/SwiftElasticSearch.git", "1.1.0")
]
```
### Manual Installation

* Download the project using command :

```
git clone "https://github.com/appbaseio-apps/SwiftElasticSearch.git"
```
* Build the project in the Xcode software in its release mode (Product -> Scheme -> Edit Scheme -> Release Mode) and copy the .framework file that is generated and paste it on the Desktop

* Open the project in which the library needs to be used

* Open Build Phases tab in the Build Settings of the project and add the copied framework in `Link Binary with Libraries` section

* Now the library is ready to use in your project

#### If the library doesn't work (or isn't imported):

* Open File -> New File -> Header File

* Name the header file as <appName>-Bridging-Header

* Go to Project -> Build Settings and browse to Bridging option

* Double click on the Objective-C Bridging Header and enter <appName>-Bridging-Header in the pop-up dialog box

* Import the library in the new bridging header file and now the library is ready to use
