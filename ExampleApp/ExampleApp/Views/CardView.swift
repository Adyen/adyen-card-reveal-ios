//
//  CardView.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import PassKit
import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image("card_image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .border(.gray)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.gray), lineWidth: 1)
                )

            Button("Reveal PAN") {
                Task {
                    try await viewModel.revealPan()
                }
            }
            .horizontallyCentered

            Button("Reveal PIN") {
                Task {
                    try await viewModel.revealPin()
                }
            }
            .horizontallyCentered

            Button("Change PIN") {
                viewModel.showEnterPin()
            }
            .horizontallyCentered

            Spacer()
        }
        .padding(10)
        .alert(item: $viewModel.revealAlert) { pin in
            Alert(
                title: Text(pin.value),
                dismissButton: .default(Text("Close"))
            )
        }
        .alert("Change PIN", isPresented: $viewModel.isShowingEnterPin) {
            TextField("Enter new PIN", text: $viewModel.enteredPin)
                .keyboardType(.decimalPad)

            Button("Cancel") {
                viewModel.isShowingEnterPin = false
            }

            Button("Ok") {
                Task {
                    try await viewModel.changePin()
                }
            }
        } message: {
            Text("Enter your new 4 digit pin")
        }
    }
}

#Preview {
    CardView(
        viewModel: ViewModel(
            paymentInstrumentId: "",
            apiClient: AppApiClient()
        )
    )
}
