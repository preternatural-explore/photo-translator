//
// Copyright (c) Vatsal Manot
//

import Swallow

public protocol _RawUserInfoProtocol: Codable, Hashable, Initiable, Sendable {
    
}

public enum _RawUserInfoKey: Codable, Hashable, @unchecked Sendable {
    case type(_SerializedTypeIdentity)
    case key(_SerializedTypeIdentity)
}

public struct _RawUserInfo: _RawUserInfoProtocol, Initiable, @unchecked Sendable {
    private var storage: [_RawUserInfoKey: Any] = [:]
    
    public var isEmpty: Bool {
        storage.isEmpty
    }
    
    public init() {
        
    }
    
    public init(from decoder: any Decoder) throws {
        self.storage = try Dictionary<_RawUserInfoKey, _UnsafelySerialized<Any>>(from: decoder).mapValues({ $0.wrappedValue })
    }
    
    public func encode(to encoder: any Encoder) throws {
        try storage.mapValues({ _UnsafelySerialized<Any>(wrappedValue: $0) }).encode(to: encoder)
    }
    
    public mutating func assign<Value: Hashable>(
        _ value: Value
    ) {
        let key = _key(fromType: Swift.type(of: value))
        
        storage[key] = _UnsafelySerialized(wrappedValue: value)
    }
    
    private func _key<Key: UserInfoKey>(
        fromType type: Key.Type
    ) -> _RawUserInfoKey{
        _RawUserInfoKey.key(_SerializedTypeIdentity(from: type))
    }
    
    private func _key<Value: Hashable>(
        fromType type: Value.Type
    ) -> _RawUserInfoKey {
        _RawUserInfoKey.type(_SerializedTypeIdentity(from: type))
    }
    
    public subscript<Key: UserInfoKey>(
        _ type: Key.Type
    ) -> Key.Value {
        get {
            let key = _key(fromType: type)
            
            return try! storage[key].map({ try cast($0, to: Key.Value.self) }) ?? Key.defaultValue
        } set {
            let key = _key(fromType: type)
            
            storage[key] = _UnsafelySerialized(wrappedValue: newValue)
        }
    }
    
    public subscript<Value: Hashable>(
        _ type: Value.Type
    ) -> Value? {
        get {
            let key = _key(fromType: type)
            
            return try! storage[key].map({ try cast($0, to: Value.self) })
        } set {
            let key = _key(fromType: type)
            
            if let newValue {
                storage[key] = _UnsafelySerialized(wrappedValue: newValue)
            } else {
                storage[key] = nil
            }
        }
    }
}

// MARK: - Conformances

extension _RawUserInfo: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.isEmpty && rhs.isEmpty {
            return true
        }
        
        guard lhs.storage.keys == rhs.storage.keys else {
            return false
        }
        
        for key in lhs.storage.keys {
            let lhsValue = lhs.storage[key]!
            
            guard let rhsValue = rhs.storage[key] else {
                return false
            }
            
            let isEqual: Bool? = #try(.optimistic) {
                guard try AnyEquatable(from: lhsValue) == AnyEquatable(from: rhsValue) else {
                    return false
                }
                
                return true
            }
            
            guard let _isEqual: Bool = isEqual, _isEqual else {
                return false
            }
        }
        
        return true
    }
}

extension _RawUserInfo: Hashable {
    public func hash(into hasher: inout Hasher) {
        for (key, value) in storage {
            hasher.combine(key)
            hasher.combine(_HashableExistential<Any>(wrappedValue: value))
        }
    }
}

extension _RawUserInfo: ThrowingMergeOperatable {
    public mutating func mergeInPlace(with other: _RawUserInfo) throws {
        var mergedKeys: Set<_RawUserInfoKey> = []
        
        for (key, value) in storage {
            if let otherValue = other.storage[key], var value = value as? (any ThrowingMergeOperatable) {
                try value._opaque_mergeInPlace(with: otherValue)
                
                self.storage[key] = value
            }
        }
        
        for newKey in Set(other.storage.keys).subtracting(mergedKeys) {
            mergedKeys.insert(newKey)
        }
    }
}

extension ThrowingMergeOperatable {
    mutating func _opaque_mergeInPlace<T>(with other: T) throws {
        let other: Self = try cast(other, to: Self.self)
        
        try mergeInPlace(with: other)
    }
}

// MARK: - Conformances

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension _RawUserInfo: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        
    }
}
