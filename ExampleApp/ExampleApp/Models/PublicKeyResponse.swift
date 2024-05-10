//
//  PublicKeyResponse.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import Foundation

struct PublicKeyResponse: Response {
    let publicKey: Data
    let publicKeyExpiryDate: String
}
