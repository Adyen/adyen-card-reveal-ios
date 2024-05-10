//
//  PublicKeyRequest.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import Foundation

struct PublicKeyRequest: Request {
    typealias ResponseType = PublicKeyResponse

    let path = "publicKey"

    init(purpose: Purpose, format: Format) {
        queryParameters = [
            URLQueryItem(name: "purpose", value: purpose.rawValue),
            URLQueryItem(name: "format", value: format.rawValue),
        ]
    }

    let queryParameters: [URLQueryItem]
    let method: String = "GET"

    func encode(to _: Encoder) throws {}
}

extension PublicKeyRequest {
    enum Purpose: String {
        case panReveal
        case pinReveal
        case pinChange
    }

    enum Format: String {
        case jwk
        case pem
    }
}
