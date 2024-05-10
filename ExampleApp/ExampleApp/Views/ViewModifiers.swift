//
//  ViewModifiers.swift
//  Adyen Card Reveal
//
//  Copyright (c) 2024 Adyen N.V.
//

import SwiftUI

private struct HorizontallyCenteredView: ViewModifier {
    fileprivate func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

private struct VerilcallyCenteredView: ViewModifier {
    fileprivate func body(content: Content) -> some View {
        VStack {
            Spacer()
            content
            Spacer()
        }
    }
}

extension View {
    public var horizontallyCentered: some View {
        modifier(HorizontallyCenteredView())
    }

    public var verticallyCentered: some View {
        modifier(VerilcallyCenteredView())
    }
}
