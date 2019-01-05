# JSONPath

[![CI Status](https://img.shields.io/travis/Bogdan%20Manshilin/JSONPath.svg?style=flat)](https://travis-ci.org/Bogdan%20Manshilin/JSONPath)
[![Version](https://img.shields.io/cocoapods/v/JSONPath.svg?style=flat)](https://cocoapods.org/pods/JSONPath)
[![License](https://img.shields.io/cocoapods/l/JSONPath.svg?style=flat)](https://cocoapods.org/pods/JSONPath)
[![Platform](https://img.shields.io/cocoapods/p/JSONPath.svg?style=flat)](https://cocoapods.org/pods/JSONPath)
[![Swift](https://img.shields.io/badge/Swift-4.2-F16D39.svg?style=flat)](https://swift.org/blog/swift-4-2-released)

JSONPath is simple library for parsing complicate JSON structures

## Requirements

Swift 4.2

## Installition

JSONPath is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JSONPath'
```

## Benefits

Let’s we have the struct:
```swift
struct Person: Codable {
  let name: String
  let age: Int
}
```

and  the JSON:

```json
{
  "payload": {
    "persons": [
      {
        "name": "Ed",
        "age": "39"
      },
      {
        "name": "Keily",
        "age": "37"
      }
    ]
  }
}
```

There are few ways to got the struct from the JSON
1. Refuse `Codable` and parse it with any of 3rd party parsing library  manually
2. Use `Codable` but create 2 extra structs. Or 1 extra struct with custom init
3. **Using JSONPath simple call through JSON path and get array of Codable persons**

## Quick Start

The base struct of the library is `JSONTree`. Objects of this type are initialized with JSON Data.
```swift
let json = [
  "payload": [
    "persons": [
      [
        "name": "Ed",
        "age": "39"
      ],
      [
        "name": "Keily",
        "age": "37"
      ]
    ]
  ]
]
let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
let jsonTree = try JSONTree(data: jsonData)
```

It supports `dynamicMemberLookup` . To parse array of `Person` :
```swift
let persons: [Person]? = tree.payload?.persons?.value()
```

And you can subscribe by index:
```swift
let person: Person? = tree.payload?.persons?[0]?.value()
```

##  Contribute

If you want to help improve this library you can take on of the opened tasks:
1. Setup Travis CI
2. Exceptions instead of Optional result
3. Carthage support

## Author

Bogdan Manshilin, skimphiter@gmail.com

## License

JSONPath is available under the MIT license. See the LICENSE file for more info.
