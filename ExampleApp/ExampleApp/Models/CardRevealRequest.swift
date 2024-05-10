//
//  CardRevealRequest.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import Foundation

struct CardRevealRequest<T: Response>: Request {
    typealias ResponseType = T

    let paymentInstrumentId: String
    let encryptedKey: String
    let encryptedPinBlock: String?
    let token: String?
    let path: String

    init(
        paymentInstrumentId: String,
        encryptedKey: String,
        encryptedPinBlock: String? = nil,
        token: String? = nil,
        purpose: Purpose
    ) {
        self.paymentInstrumentId = paymentInstrumentId
        self.encryptedKey = encryptedKey
        self.encryptedPinBlock = encryptedPinBlock
        self.token = token

        switch purpose {
        case .panReveal:
            path = "paymentInstruments/reveal"
        case .pinReveal:
            path = "pins/reveal"
        case .pinChange:
            path = "pins/change"
        }
    }

    let queryParameters: [URLQueryItem] = []
    let method: String = "POST"

    enum CodingKeys: CodingKey {
        case paymentInstrumentId
        case encryptedKey
        case encryptedPinBlock
        case token
    }
}

extension CardRevealRequest {
    enum Purpose: String {
        case panReveal
        case pinReveal
        case pinChange
    }
}
