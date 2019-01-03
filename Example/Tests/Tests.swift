import XCTest
import JSONPath

private struct Person: Codable {
    let name: String
    let age: Int
    let isMarried: Bool
}

class Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPlainStructurePlainValue() {
        let simpleJson = [
            "key": "value"
        ]

        do {
            let simpleJsonData = try JSONSerialization.data(withJSONObject: simpleJson, options: [])
            let simpleTree = try JSONTree(data: simpleJsonData)
            let simpleValue: String? = simpleTree.key?.value()

            XCTAssertEqual(simpleValue, simpleJson["key"])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testPlainStructureCustomValue() {
        let customJson: [String : Any] = [
            "name": "Михаил",
            "age": 30,
            "isMarried": false,
            ]

        do {
            let customJsonData = try JSONSerialization.data(withJSONObject: customJson, options: [])
            let customTree = try JSONTree(data: customJsonData)
            let person: Person? = customTree.value()

            XCTAssertEqual(person?.name, customJson["name"] as? String)
            XCTAssertEqual(person?.age, customJson["age"] as? Int)
            XCTAssertEqual(person?.isMarried, customJson["isMarried"] as? Bool)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testNestedPlainValue() {
        let nestedJson = [
            "container": [
                "key2": "value2"
            ]
        ]

        do {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson, options: [])
            let nestedTree = try JSONTree(data: nestedJsonData)
            let plainValue: String? = nestedTree.container?.key2?.value()

            XCTAssertEqual(plainValue, nestedJson["container"]?["key2"])
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testNestedCustomValue() {
        let nestedStructJson = [
            "container": [
                "object": [
                    "name": "Михаил",
                    "age": 30,
                    "isMarried": false,
                ]
            ]
        ]

        do {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedStructJson, options: [])
            let nestedTree = try JSONTree(data: nestedJsonData)
            let person: Person? = nestedTree.container?.object?.value()

            let customJson = nestedStructJson["container"]?["object"]
            XCTAssertEqual(person?.name, customJson?["name"] as? String)
            XCTAssertEqual(person?.age, customJson?["age"] as? Int)
            XCTAssertEqual(person?.isMarried, customJson?["isMarried"] as? Bool)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testHomogeneousArrayIsParsingWhole() {
        let arrayJson = [
            [
                "name": "Михаил",
                "age": 30,
                "isMarried": false,
                ],
            [
                "name": "Адам",
                "age": 45,
                "isMarried": true,
                ],
            ]

        do {
            let arrayJsonData = try JSONSerialization.data(withJSONObject: arrayJson, options: [])
            let arrayTree = try JSONTree(data: arrayJsonData)
            let persons: [Person]? = arrayTree.value()

            XCTAssertEqual(persons?.count, arrayJson.count)

            let person = persons?.first
            let personJson = arrayJson.first

            XCTAssertEqual(person?.name, personJson?["name"] as? String)
            XCTAssertEqual(person?.age, personJson?["age"] as? Int)
            XCTAssertEqual(person?.isMarried, personJson?["isMarried"] as? Bool)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testHomogeneousArrayIsParsingByIndex() {
        let arrayJson = [
            [
                "name": "Михаил",
                "age": 30,
                "isMarried": false,
                ],
            [
                "name": "Адам",
                "age": 45,
                "isMarried": true,
                ],
            ]

        do {
            let arrayJsonData = try JSONSerialization.data(withJSONObject: arrayJson, options: [])
            let arrayTree = try JSONTree(data: arrayJsonData)
            let person: Person? = arrayTree[0]?.value()

            let personJson = arrayJson.first

            XCTAssertEqual(person?.name, personJson?["name"] as? String)
            XCTAssertEqual(person?.age, personJson?["age"] as? Int)
            XCTAssertEqual(person?.isMarried, personJson?["isMarried"] as? Bool)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testNestedHomogeneousArrayIsParsingWhole() {
        let arrayContainingJson = [
            "objects": [
                [
                    "name": "Михаил",
                    "age": 30,
                    "isMarried": false,
                    ],
                [
                    "name": "Адам",
                    "age": 45,
                    "isMarried": true,
                    ],
            ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrayContainingJson, options: [])
            let arrayTree = try JSONTree(data: jsonData)
            let persons: [Person]? = arrayTree.objects?.value()

            let jsonArray = arrayContainingJson["objects"]
            XCTAssertEqual(persons?.count, jsonArray?.count)

            let person = persons?.first
            let personJson = jsonArray?.first

            XCTAssertEqual(person?.name, personJson?["name"] as? String)
            XCTAssertEqual(person?.age, personJson?["age"] as? Int)
            XCTAssertEqual(person?.isMarried, personJson?["isMarried"] as? Bool)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testNestedHomogeneousArrayIsParsingByIndex() {
        let arrayContainingJson = [
            "objects": [
                [
                    "name": "Михаил",
                    "age": 30,
                    "isMarried": false,
                    ],
                [
                    "name": "Адам",
                    "age": 45,
                    "isMarried": true,
                    ],
            ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrayContainingJson, options: [])
            let arrayTree = try JSONTree(data: jsonData)
            let person: Person? = arrayTree.objects?[0]?.value()

            let personJson = arrayContainingJson["objects"]?.first

            XCTAssertEqual(person?.name, personJson?["name"] as? String)
            XCTAssertEqual(person?.age, personJson?["age"] as? Int)
            XCTAssertEqual(person?.isMarried, personJson?["isMarried"] as? Bool)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }


    func testPlainValueIsParsingInDictionaryInArrayInDictionary() {
        let arrayContainingJson = [
            "objects": [
                [
                    "name": "Михаил",
                    "age": 30,
                    "isMarried": false,
                    ],
                [
                    "name": "Адам",
                    "age": 45,
                    "isMarried": true,
                    ],
            ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrayContainingJson, options: [])
            let arrayTree = try JSONTree(data: jsonData)
            let name: String? = arrayTree.objects?[0]?.name?.value()

            let personName = arrayContainingJson["objects"]?.first?["name"] as? String

            XCTAssertEqual(name, personName)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testHeterogeneousArrayIsParsingByIndex() {
        let arrayContainingJson = [
            "objects": [
                [
                    "name": "Михаил",
                    "age": 30,
                    "isMarried": false,
                    ],
                [
                    "not_name": 123,
                    "not_age": "45",
                    ],
            ]
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrayContainingJson, options: [])
            let arrayTree = try JSONTree(data: jsonData)
            let person: Person? = arrayTree.objects?[0]?.value()

            let personJson = arrayContainingJson["objects"]?.first

            XCTAssertEqual(person?.name, personJson?["name"] as? String)
            XCTAssertEqual(person?.age, personJson?["age"] as? Int)
            XCTAssertEqual(person?.isMarried, personJson?["isMarried"] as? Bool)

            let plainValue: Int? = arrayTree.objects?[1]?.not_name?.value()
            let plainJsonValue = arrayContainingJson["objects"]?[1]["not_name"] as? Int

            XCTAssertEqual(plainValue, plainJsonValue)
        } catch {
            XCTFail(error.localizedDescription)
        }

    }
}
