//
//  OptionButton.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/10/23.
//

import SwiftUI

struct OptionButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Lora-Bold", size: 16))
                .underline(!isSelected)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(Color("darktextColor"))
        .background(isSelected ? Color("buttonColor") : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .pushInEffect()
    }
}


