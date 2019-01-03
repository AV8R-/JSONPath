import Foundation

@dynamicMemberLookup
public struct JSONTree {
    private let path: [Key]
    private let decoder: Decoder

    public init(data: Data) throws {
        self = try JSONDecoder().decode(JSONTree.self, from: data)
    }

    private init(decoder: Decoder, path: [Key]) {
        self.decoder = decoder
        self.path = path
    }
}

extension JSONTree: Decodable {
    enum Key: CodingKey {
        case key(String)
        case index(Int)

        var stringValue: String {
            if case .key(let key) = self {
                return key
            } else {
                return ""
            }
        }

        var intValue: Int? {
            if case .index(let index) = self {
                return index
            } else {
                return nil
            }
        }

        init?(stringValue: String) {
            self = .key(stringValue)
        }

        init?(intValue: Int) {
            self = .index(intValue)
        }

        init?(codingKey: CodingKey) {
            if let index = codingKey.intValue {
                self = .index(index)
            } else {
                self = .key(codingKey.stringValue)
            }
        }
    }

    enum Container {
        case dictionary(KeyedDecodingContainer<Key>)
        case array(UnkeyedDecodingContainer)

        func nestedKeyedContainer(for key: Key) -> Container? {
            switch (key, self) {
            case (.index(let index), .array(var unkeyedContainer)):
                unkeyedContainer.scroll(to: index)
                return (try? unkeyedContainer.nestedContainer(keyedBy: Key.self)).map(Container.dictionary)
            case let (.key, .dictionary(keyedContainer)):
                return (try? keyedContainer.nestedContainer(keyedBy: Key.self, forKey: key)).map(Container.dictionary)
            default:
                return nil
            }
        }

        func nestedUnkeyedContainer(for key: Key) -> Container? {
            switch (key, self) {
            case (.index(let index), .array(var unkeyedContainer)):
                unkeyedContainer.scroll(to: index)
                return (try? unkeyedContainer.nestedUnkeyedContainer()).map(Container.array)
            case (.key, .dictionary(let keyedContainer)):
                return (try? keyedContainer.nestedUnkeyedContainer(forKey: key)).map(Container.array)
            default:
                return nil
            }
        }

        func decode<T: Decodable>(for key: Key) -> T? {
            switch (key, self) {
            case (.index(let index), .array(var unkeyedContainer)):
                unkeyedContainer.scroll(to: index)
                return try? unkeyedContainer.decode(T.self)
            case let (.key, .dictionary(keyedContainer)):
                return try? keyedContainer.decode(T.self, forKey: key)
            default:
                return nil
            }
        }
    }

    public init(from decoder: Decoder) throws {
        self.path = decoder.codingPath.compactMap(Key.init)
        self.decoder = decoder
    }
}

extension JSONTree {
    public subscript(dynamicMember member: String) -> JSONTree? {
        guard let key = Key(stringValue: member) else { return nil }
        return JSONTree(decoder: decoder, path: path + [key])
    }

    public subscript(index: Int) -> JSONTree? {
        guard let key = Key(intValue: index) else { return nil }
        return JSONTree(decoder: decoder, path: path + [key])
    }
}

extension JSONTree {
    public func value<T: Decodable>() -> T? {
        return path.isEmpty ? sinngleValue() : containedValue()
    }

    private func sinngleValue<T: Decodable>() -> T? {
        guard let container = try? decoder.singleValueContainer() else { return nil }
        return try? container.decode(T.self)
    }

    private func containedValue<T: Decodable>() -> T? {
        guard let first = self.path.first else {
            return try? decoder.singleValueContainer().decode(T.self)
        }

        var container: Container?
        switch first {
        case .index: container = try? .array(decoder.unkeyedContainer())
        case .key: container = try? .dictionary(decoder.container(keyedBy: Key.self))
        }

        guard self.path.count > 1 else {
            return container?.decode(for: first)
        }

        for i in 0..<(self.path.count - 1) {
            let key = self.path[i]
            let nextKey = self.path[i+1]

            switch nextKey {
            case .index: container = container?.nestedUnkeyedContainer(for: key)
            case .key: container = container?.nestedKeyedContainer(for: key)
            }
        }

        let last = self.path.last!
        return container?.decode(for: last)
    }
}

private extension UnkeyedDecodingContainer {
    mutating func scroll(to index: Int) {
        while currentIndex < index {
            _ = try? nestedContainer(keyedBy: JSONTree.Key.self)
        }
    }
}
