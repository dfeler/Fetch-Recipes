//
//  CustomModifiers.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/10/23.
//

import SwiftUI

struct PushInEffect: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

extension View {
    func pushInEffect() -> some View {
        self.modifier(PushInEffect())
    }
}


