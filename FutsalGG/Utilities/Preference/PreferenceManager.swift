//
//  PreferenceManager.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation
import ComposableArchitecture

protocol PreferenceManaging {
    var isAutoLogin: Bool { get set }
}

final class Preference: PreferenceManaging {
    static let shared = Preference()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Keys {
        static let isAutoLogin = "IS_AUTO_LOGIN"
    }
    
    var isAutoLogin: Bool {
        get { defaults.bool(forKey: Keys.isAutoLogin) }
        set { defaults.set(newValue, forKey: Keys.isAutoLogin) }
    }
}

// MARK: - TCA Dependency
extension Preference: DependencyKey {
    static var liveValue: PreferenceManaging {
        return Preference.shared
    }
    
    static var testValue: PreferenceManaging {
        return PreferenceMock()
    }
}

extension DependencyValues {
    var preference: PreferenceManaging {
        get { self[Preference.self] }
        set { self[Preference.self] = newValue }
    }
}

// MARK: - Mock for Testing
final class PreferenceMock: PreferenceManaging {
    var isAutoLogin: Bool = false
}
