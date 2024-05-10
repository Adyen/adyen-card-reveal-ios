//
//  Request.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import Foundation

public protocol Request: Encodable {
    associatedtype ResponseType: Response

    var path: String { get }
    var queryParameters: [URLQueryItem] { get }
    var method: String { get }
}

public protocol Response: Decodable {}
