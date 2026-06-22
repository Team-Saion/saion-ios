//
//  Storage.swift
//  Saion
//
//  Created by 신정욱 on 6/22/26.
//

import Foundation

// MARK: - AnyOptional

/// 제네릭 타입의 Optional 여부를 런타임에 확인하기 위한 내부 프로토콜
private protocol AnyOptional {
    /// 해당 인스턴스가 nil인지 여부를 반환함
    var isNil: Bool { get }
}

/// Optional 타입에 AnyOptional 준수성을 부여하여 nil 체크를 지원함
extension Optional: AnyOptional {
    fileprivate var isNil: Bool { self == nil }
}

// MARK: - Storage

/// 데이터를 UserDefaults에 영속적으로 안전하게 저장하는 프로퍼티 래퍼
@propertyWrapper
struct Storage<T: Codable & Sendable>: Sendable {
    
    // MARK: Properties
    
    /// UserDefaults에 저장된 값이 없거나 로드에 실패했을 때 반환할 기본값
    private let defaultValue: T
    
    /// UserDefaults에서 데이터를 식별하기 위한 키
    private let key: String
    
    // MARK: Initializer
    
    /// 기본값과 식별 키를 받아 Storage를 초기화함
    init(
        wrappedValue defaultValue: T,
        _ key: String
    ) {
        self.defaultValue = defaultValue
        self.key = key
    }
    
    // MARK: Wrapped Value
    
    /// 연산 프로퍼티를 통해 UserDefaults 읽기 및 쓰기 동작을 수행함
    var wrappedValue: T {
        get { load() ?? defaultValue }
        set {
            (newValue as? AnyOptional)?.isNil == true
            ? delete()
            : save(newValue)
        }
    }
    
    // MARK: Private Helpers
    
    /// 데이터를 JSON으로 직렬화한 후 UserDefaults에 저장함
    private func save(_ newValue: T) {
        guard let data = try? JSONEncoder().encode(newValue) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    /// UserDefaults에서 데이터를 조회한 후 지정된 타입으로 역직렬화함
    private func load() -> T? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let value = try? JSONDecoder().decode(T.self, from: data)
        else { return nil }
        
        return value
    }
    
    /// UserDefaults에서 식별 키에 해당하는 데이터를 삭제함
    private func delete() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// MARK: - ExpressibleByNilLiteral

/// 기본값이 nil로 선언될 수 있는 Optional 타입 전용 확장 구현부
extension Storage where T: ExpressibleByNilLiteral {
    /// 기본값 없이 식별 키만 받아 nil 초기값으로 Storage를 생성함
    init(_ key: String) {
        self.defaultValue = nil
        self.key = key
    }
}
