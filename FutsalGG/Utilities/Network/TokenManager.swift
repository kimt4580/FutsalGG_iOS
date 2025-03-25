//
//  TokenManager.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation
import KeychainSwift
import ComposableArchitecture

protocol TokenManaging {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    func clearTokens()
}

final class TokenManager: TokenManaging {
    static let shared = TokenManager()
    private let keychain = KeychainSwift()
    
    private init() {}
    
    private enum Keys {
        static let accessToken = "ACCESS_TOKEN"
        static let refreshToken = "REFRESH_TOKEN"
    }
    
    var accessToken: String? {
        get { keychain.get(Keys.accessToken) }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: Keys.accessToken)
            } else {
                keychain.delete(Keys.accessToken)
            }
        }
    }
    
    var refreshToken: String? {
        get { keychain.get(Keys.refreshToken) }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: Keys.refreshToken)
            } else {
                keychain.delete(Keys.refreshToken)
            }
        }
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
    }
}

// MARK: - TCA Dependency
extension TokenManager: DependencyKey {
    static var liveValue: TokenManaging {
        return TokenManager.shared
    }
    
    static var testValue: TokenManaging {
        return TokenManagerMock()
    }
}

extension DependencyValues {
    var tokenManager: TokenManaging {
        get { self[TokenManager.self] }
        set { self[TokenManager.self] = newValue }
    }
}

// MARK: - Mock for Testing
final class TokenManagerMock: TokenManaging {
    var accessToken: String?
    var refreshToken: String?
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
    }
}
