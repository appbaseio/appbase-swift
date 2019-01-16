# SwiftElasticSearch

## About Project

This project aims to create fast responsive Swift Library, supported for IPhone and Mac apps which provides the functionality of Elastic Search to be integrated in the app.

The library provides very high performance results i.e. it provides response to user queries in milliseconds of time including the elastic search processing time.

## Installation

### Dynamic Framework (Simplest way)

* Download the latest release of [SwiftElasticSearch](https://github.com/appbaseio-apps/SwiftElasticSearch/archive/v0.0.4.zip) from Github and extract the zip 

* Navigate to your Xcode's project `General` settings (Click on the the blue icon showing your project's workspace -> General)

* Drag the `SwiftElasticSearch.xcodeproj` file from the extracted folder in the `Embedded Binaries` section and select the `Copy items if needed` checkbox in the prompted dialog box (if it appears) and click Finish

* Go to `Linked Frameworks and Libraries` section and click on the `+` icon

* Click on the `SwiftElasticSearch.framework` to add it to dependencies

* Build the project

Here is the GIF showing all the above steps in action - 

![Demo GIF](https://github.com/harsh-2711/Resources/blob/master/SwiftElasticSearchDemo.gif)

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
The current latest Release Version is 0.0.4

* Run `carthage update` to build the framework

* Drag the `SwiftElasticSearch.framework` file that is generated inside Build folder of Carthage to your Xcode project

* Build the project

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but ElasticSwift does support its use on supported platforms.

To add SwiftElasticSearch library as dependency, add the following line in the dependencies value of Package.swift : 

```
dependencies: [
.Package(url: "https://github.com/appbaseio-apps/SwiftElasticSearch.git", "1.0.0")
]
```

## Quick Example

Working code example. Please note that each step is dependent on previous step.

#### Step 1: Import library and initiate the SwiftElasticSearch client

```swift
import SwiftElasticSearch

// app and authentication configurations
let HOST_URL = "https://scalr.api.appbase.io"
let APPNAME = "SwiftClientES"
let CREDENTIALS = "9MrI8sWhQ:7cf68f3b-51f7-45c0-973f-f3e85ad10f4b"

let client = Client.init(url: HOST_URL, app: APPNAME, credentials: CREDENTIALS)
```

#### Step 2: Add some data into the app

```swift
// Index some movie names

client.index(type: "SwiftClientES", id: "movie1", body: ["title" : "Iron Man"]) { (json, response, error) in
  // json - provides recieved JSON body
  // response - provides the received response from the server
  // error - provides the error encountered if any

  print(json!)
}
```

**Console Output**

```swift
{
    "_id" = movie1;
    "_index" = SwiftClientES;
    "_shards" =     {
        failed = 0;
        successful = 2;
        total = 2;
    };
    "_type" = SwiftClientES;
    "_version" = 2;
    created = 0;
    result = updated;
}
```

#### Step 3: Get the posted data

```swift

client.get(type: "SwiftClientES", id: "movie1") { (json, response, error) in
    print(json!)
}
```

**Console output**

```swift
{
    "_id" = movie1;
    "_index" = SwiftClientES;
    "_source" =     {
        title = "Iron Man";
    };
    "_type" = SwiftClientES;
    "_version" = 2;
    found = 1;
}
```

* For more examples, refer to the tests file [SwiftElasticSearchTests.swift](https://github.com/appbaseio-apps/SwiftElasticSearch/blob/master/SwiftElasticSearchTests/SwiftElasticSearchTests.swift)

* For a fully working example app, refer to the GitHub repository [SwiftElasticSearchDemo](https://github.com/harsh-2711/SwiftElasticSearchDemo)

## Docs

WIP docs are at https://swift-elasticsearch.netlify.com.
