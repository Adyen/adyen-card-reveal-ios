//
//  ContentView.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CardView(
                viewModel: ViewModel(
                    paymentInstrumentId: Constants.paymentInstrumentId,
                    apiClient: AppApiClient()
                )
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
