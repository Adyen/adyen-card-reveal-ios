//
//  AppError.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import Foundation

enum AppError: Error, LocalizedError {
    case generic
    case localized(String)

    var errorDescription: String? {
        switch self {
        case .generic:
            "Something went wrong"
        case let .localized(description):
            description
        }
    }
}

extension Error {
    func asAppError() -> AppError {
        AppError.localized(localizedDescription)
    }
}
