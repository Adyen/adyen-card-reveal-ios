//
//  AppApiClient.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import Foundation

protocol AsyncApiClientProtocol {
    func perform<R: Request>(_ request: R) async throws -> R.ResponseType
}

class AppApiClient: AsyncApiClientProtocol {
    let apiContext: AppApiContext
    let urlSession: URLSession

    init(apiContext: AppApiContext = AppApiContext(), configuration: URLSessionConfiguration? = nil) {
        self.apiContext = apiContext
        self.urlSession = configuration.flatMap { URLSession(configuration: $0) } ?? .shared
    }

    func perform<R: Request>(_ request: R) async throws -> R.ResponseType {
        var url = apiContext.baseURL.appendingPathComponent(request.path)
        url.append(queryItems: request.queryParameters)

        var modifiedRequest = URLRequest(url: url)
        modifiedRequest.allHTTPHeaderFields = apiContext.headers
        modifiedRequest.httpMethod = request.method

        if modifiedRequest.httpMethod == "POST" {
            modifiedRequest.httpBody = try JSONEncoder().encode(request)
        }

        let (data, _) = try await urlSession.data(for: modifiedRequest)
        let decoder = JSONDecoder()
        return try decoder.decode(R.ResponseType.self, from: data)
    }
}
