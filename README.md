# Adyen Card Reveal iOS

The `Adyen Card Reveal` iOS SDK helps integrate PAN (Primary Account Number) reveal, PIN (Personal Identification Number) reveal and change functionalities for `Adyen` issued cards.

## Installation

The SDK is available via `Swift Package Manager` or via manual installation.

### Swift Package Manager

1. Follow Apple's [Adding Package Dependencies to Your App](
https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app
) guide on how to add a Swift Package dependency.
2. Use `https://github.com/Adyen/adyen-card-reveal-ios` as the repository URL.

### Dynamic xcFramework

Drag the dynamic `AdyenCardReveal/XCFramework/Dynamic/AdyenCardReveal.xcframework` to the `Frameworks, Libraries, and Embedded Content` section in your general target settings. Select "Copy items if needed" when asked.

## Usage

### PAN Reveal

1. Fetch the public key from:
`/bcl/v2/publicKey?purpose=panReveal&format=jwk`. 
As this endpoint requires authentication you should delegate this request to your backend instead of calling directly from the app.

2. Initialize the service

```swift
let cardRevealService = CardRevealService()
```

3. Generate an encrypted key with the public key which you received as part of the `JWK` (`publicKey` property):

```swift
let encryptedKey = try cardRevealService.generateEncryptedKey(jwk: publicKey)
```

4. Use the `encryptedKey` to fetch the encrypted PAN data from the `/bcl/v2/paymentInstruments/reveal` endpoint. As with the previous requests, make this one from your backend and not the app. The `POST` body should have the following structure:

```json
{
    "paymentInstrumentId": "{payment_instrument_id}",
    "encryptedKey": "{encrypted_key}"
}

```

The response will have the following JSON structure:

```json
{
    "encryptedData": "{data_string}"
}

```

5. Use the `CardRevealService` to get card data by passing in the encrypted data

```swift
let details = try cardRevealService.cardDetails(from: encryptedData)
```

### PIN Reveal

1. Fetch the public key from `/bcl/v2/publicKey?purpose=pinReveal&format=jwk`. Delegate this request to your backend.

2. Initialize the service

```swift
let pinRevealService = PinRevealService()
```

3. Generate an encrypted key with the public key which you received as part of the `JWK` (`publicKey` property):

```swift
let encryptedKey = try cardRevealService.generateEncryptedKey(jwk: publicKey)
```

If you fetched the `pem` public key in step 1, then generate an encrypted key with the `pem`:

```swift
let encryptedKey = try cardRevealService.generateEncryptedKey(pem: publicKey)
```

4. Use the `encryptedKey` to fetch the encrypted PIN from `/bcl/v2/pins/reveal` endpoint. As with the previous requests make this one from your backend and not the app. The `POST` body should have the following structure:

```json
{
    "paymentInstrumentId": "{payment_instrument_id}",
    "encryptedKey": "{encrypted_key}"
}

```

The response will have the following JSON structure:

```json
{
    "encryptedPinBlock": "{data_string}",
    "token": "{token}"
}

```

5. Use `PinRevealService` to get card data by passing in `encryptedPinBlock` and `token`:

```swift
let pin = try pinRevealService.pin(encryptedPinBlock: encryptedPinBlock, token: token)
```

### PIN Change

1. Fetch the public key from `/bcl/v2/publicKey?purpose=pinChange&format=pem`. Delegate this request to your backend.

2. Initialize the service

```swift
let pinRevealService = PinChangeService()
```

3. Generate an encrypted PIN block with public key and the new PIN:

```swift
let encryptedPin = try pinChangeService.encryptedPinBlock(pem: publicKey, pin: pin)
```

4. Use the `encryptedPin` object to pass the values to the `/bcl/v2/pins/change` `POST` endpoint. Delegate this request to your backend. The `POST` body should have the following structure:

```json
{
    "paymentInstrumentId": "{payment_instrument_id}",
    "encryptedKey": "{encrypted_key}",
    "encryptedPinBlock": "{encrypted_pin_block}",
    "token": "{token}"
}

```

A successful response will have the following JSON structure:

```json
{
  "status" : "completed"
}

```

## See also

 * [API Documentation](https://docs.adyen.com/issuing/manage-card-data/)
 * [SDK Reference Adyen Card Reveal](https://adyen.github.io/adyen-card-reveal-ios/1.0.0/AdyenCardReveal/documentation/adyencardreveal/)
 * [Data security at Adyen](https://docs.adyen.com/development-resources/adyen-data-security)

## License

This SDK is available under the MIT License. For more information, see the [LICENSE](https://github.com/Adyen/adyen-card-reveal-ios/blob/main/LICENSE) file.
