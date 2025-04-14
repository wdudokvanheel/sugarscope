import SwiftUI
import Combine

@propertyWrapper
struct Preference<Value>: DynamicProperty where Value: Codable & Equatable {
    @ObservedObject private var storage: PreferenceStorage<Value>

    init(key: PreferenceKey, defaultValue: Value) {
        self.storage = PreferenceStorage(key: key, defaultValue: defaultValue)
    }

    var wrappedValue: Value {
        get { storage.value }
        nonmutating set { storage.value = newValue }
    }

    var projectedValue: ObservedObject<PreferenceStorage<Value>>.Wrapper {
        $storage
    }
}
