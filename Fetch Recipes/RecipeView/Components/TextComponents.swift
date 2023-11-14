//
//  TextComponents.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/13/23.
//

import SwiftUI

struct RecipeTitleText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Lora-Bold", size: 19))
            .foregroundColor(Color("textColor"))
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }
}
