import Foundation
import os
import SwiftUI

final class PreferencesService {
    enum Key: String {
        case connection
    }
    
    private static let defaults = UserDefaults.standard
    
    static func set<T>(_ value: T, forKey key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    static func get<T>(forKey key: Key) -> T? {
        return defaults.object(forKey: key.rawValue) as? T
    }
    
    static func get<T>(forKey key: Key, default defaultValue: T) -> T {
        return (defaults.object(forKey: key.rawValue) as? T) ?? defaultValue
    }
    
    static func remove(forKey key: Key) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
