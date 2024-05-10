//
//  AppApiContext.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import Foundation

struct AppApiContext {
    let baseURL = URL(string: Constants.baseUrl)!
    let headers: [String: String] = [
        "Content-Type": "application/json",
        "X-API-KEY": Constants.apiKey,
    ]

    let queryParameters: [URLQueryItem] = []
}
