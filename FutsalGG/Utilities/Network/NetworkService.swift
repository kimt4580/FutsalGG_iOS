//
//  NetworkService.swift
//  FutsalGG
//
//  Created by 김태훈 on 3/25/25.
//

import Foundation
import Moya
import ComposableArchitecture

protocol NetworkServicing {
    func request<T: Decodable, E: APIEndpoint>(_ endpoint: E) async throws -> T
}

final class NetworkService: NetworkServicing {
    private var tokenManager: TokenManaging
    private var providers: [String: Any] = [:]
    private let decoder: JSONDecoder
    
    init(
        tokenManager: TokenManaging = TokenManager.shared,
        decoder: JSONDecoder = .init()
    ) {
        self.tokenManager = tokenManager
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T: Decodable, E: APIEndpoint>(_ endpoint: E) async throws -> T {
        // 인증이 필요한 요청인데 토큰이 없는 경우
        if endpoint.requiresAuth && tokenManager.accessToken == nil {
            throw NetworkError.unauthorized
        }
        
        do {
            return try await performRequest(endpoint)
        } catch NetworkError.unauthorized {
            // 인증이 필요한 요청이고 401 에러가 발생한 경우에만 토큰 리프레시 시도
            guard endpoint.requiresAuth else { throw NetworkError.unauthorized }
            return try await handleTokenRefresh(endpoint)
        }
    }
    
    private func performRequest<T: Decodable, E: APIEndpoint>(_ endpoint: E) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            getProvider(for: E.self).request(endpoint) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    do {
                        let decoded = try self.decoder.decode(T.self, from: response.data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: NetworkError.decodingError(error))
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: self.handleMoyaError(error))
                }
            }
        }
    }
    
    private func handleTokenRefresh<T: Decodable, E: APIEndpoint>(_ endpoint: E) async throws -> T {
        guard let refreshToken = tokenManager.refreshToken else {
            throw NetworkError.unauthorized
        }
        
        do {
            // 토큰 리프레시 요청
            let response: LoginResponseDTO = try await request(AuthEndpoint.refresh)
            
            // 새로운 토큰 저장
            tokenManager.accessToken = response.accessToken
            tokenManager.refreshToken = response.refreshToken
            
            // 원래 요청 재시도
            return try await performRequest(endpoint)
        } catch {
            // 리프레시 실패시 로그아웃
            tokenManager.clearTokens()
            throw NetworkError.unauthorized
        }
    }
    
    private func getProvider<E: APIEndpoint>(for type: E.Type) -> MoyaProvider<E> {
        let key = String(describing: type)
        if let provider = providers[key] as? MoyaProvider<E> {
            return provider
        }
        
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        let provider = MoyaProvider<E>(plugins: plugins)
        providers[key] = provider
        return provider
    }
    
    private func handleMoyaError(_ error: MoyaError) -> NetworkError {
        switch error {
        case .statusCode(let response) where response.statusCode == 401:
            return .unauthorized
        case .statusCode(let response):
            return .serverError(response.statusCode)
        case .underlying(let error, _):
            return .underlying(error)
        default:
            return .unknown
        }
    }
}

// MARK: - TCA Dependency
extension NetworkService: DependencyKey {
    static var liveValue: NetworkServicing {
        NetworkService()
    }
    
    static var testValue: NetworkServicing {
        NetworkServiceMock()
    }
}

extension DependencyValues {
    var networkService: NetworkServicing {
        get { self[NetworkService.self] }
        set { self[NetworkService.self] = newValue }
    }
}

// MARK: - Mock for Testing
final class NetworkServiceMock: NetworkServicing {
    func request<T: Decodable, E: APIEndpoint>(_ endpoint: E) async throws -> T {
        throw NetworkError.unknown
    }
}
