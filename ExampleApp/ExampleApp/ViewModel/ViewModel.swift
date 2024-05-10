//
//  ViewModel.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import AdyenCardReveal
import SwiftUI

final class ViewModel: ObservableObject {
    private let apiClient: AsyncApiClientProtocol
    private let paymentInstrumentId: String

    @Published var revealAlert: RevealAlert?
    @Published var enteredPin: String = ""
    @Published var isShowingEnterPin = false

    init(paymentInstrumentId: String,
         apiClient: AsyncApiClientProtocol)
    {
        self.paymentInstrumentId = paymentInstrumentId
        self.apiClient = apiClient
    }

    // MARK: - Reveal card details

    @MainActor
    func revealPan() async throws {
        do {
            let details = try await fetchCardDetails()
            revealAlert = .pan(details)
        } catch {
            revealAlert = .error(error.asAppError())
        }
    }

    private func fetchCardDetails() async throws -> CardDetails {
        // Fetch public key
        let request = PublicKeyRequest(purpose: .panReveal, format: .jwk)
        let publicKey = try await apiClient.perform(request).publicKey

        let cardRevealService = CardRevealService()

        // Encrypt key
        let encryptedKey = try cardRevealService.generateEncryptedKey(jwk: publicKey)

        struct PanRevealResponse: Response {
            let encryptedData: String
        }

        // Create request
        let revealRequest = CardRevealRequest<PanRevealResponse>(
            paymentInstrumentId: paymentInstrumentId,
            encryptedKey: encryptedKey,
            purpose: .panReveal
        )

        // Call reveal end-point
        let encryptedData = try await apiClient.perform(revealRequest).encryptedData
        let details = try cardRevealService.cardDetails(encryptedData: encryptedData)

        return CardDetails(
            pan: details.pan,
            cvc: details.cvc,
            expiration: "\(details.expiration.month)/\(details.expiration.year)"
        )
    }

    // MARK: - Reveal PIN

    @MainActor
    func revealPin() async throws {
        do {
            let pin = try await fetchPin()
            revealAlert = .pin(pin)
        } catch {
            revealAlert = .error(error.asAppError())
        }
    }

    private func fetchPin() async throws -> String {
        // Fetch public key
        let pubKeyRequest = PublicKeyRequest(purpose: .pinReveal, format: .jwk)
        let publicKeyResponse = try await apiClient.perform(pubKeyRequest)

        let pinRevealService = PinRevealService()

        // Encrypt key
        let encryptedPinBlock = try pinRevealService.generateEncryptedKey(jwk: publicKeyResponse.publicKey)

        struct PinRevealResponse: Response {
            let encryptedPinBlock: String
            let token: String
        }

        // Create request
        let revealRequest = CardRevealRequest<PinRevealResponse>(
            paymentInstrumentId: paymentInstrumentId,
            encryptedKey: encryptedPinBlock,
            purpose: .pinReveal
        )

        // Call reveal endpoint
        let revealResponse = try await apiClient.perform(revealRequest)

        // Decrypt PIN
        return try pinRevealService.pin(
            encryptedPinBlock: revealResponse.encryptedPinBlock,
            token: revealResponse.token
        )
    }

    // MARK: - Change PIN

    func showEnterPin() {
        isShowingEnterPin = true
    }

    @MainActor
    func changePin() async throws {
        do {
            try await changePin(enteredPin)
        } catch {
            revealAlert = .error(error.asAppError())
        }

        enteredPin = ""
    }

    private func changePin(_ pin: String) async throws {
        // Fetch public key
        let pubKeyRequest = PublicKeyRequest(purpose: .pinChange, format: .jwk)
        let publicKey = try await apiClient.perform(pubKeyRequest).publicKey

        let pinChangeService = PinChangeService()
        // Encrypt PIN
        let encryptedPin = try pinChangeService.encryptedPinBlock(jwk: publicKey, pin: enteredPin)

        struct PinChangeResponse: Response {
            let status: String
        }

        // Create request
        let request = CardRevealRequest<PinChangeResponse>(
            paymentInstrumentId: paymentInstrumentId,
            encryptedKey: encryptedPin.encryptedKey,
            encryptedPinBlock: encryptedPin.encryptedPinBlock,
            token: encryptedPin.token,
            purpose: .pinChange
        )

        // Send encrypted PIN
        _ = try await apiClient.perform(request)
    }
}

extension ViewModel {
    struct CardDetails {
        let pan: String // primary account number
        let cvc: String
        let expiration: String

        var value: String {
            "Primary account number: \(pan)\nCVC: \(cvc)\nExpires: \(expiration)"
        }
    }

    enum RevealAlert: Identifiable {
        case pin(String)
        case pan(CardDetails)
        case error(AppError)

        var id: String {
            switch self {
            case let .pin(pin):
                pin
            case let .pan(pan):
                pan.value
            case .error:
                "error"
            }
        }

        var value: String {
            switch self {
            case let .pin(pin):
                pin
            case let .pan(pan):
                pan.value
            case let .error(error):
                error.localizedDescription
            }
        }
    }
}
