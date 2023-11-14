//
//  RecipeView.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/10/23.
//

import SwiftUI

struct RecipeView: View {
    @StateObject private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchAndToggleView(viewModel: viewModel)
                RecipeScrollView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchMeals()
            }
            .background(Color("backgroundColor"))
            .navigationTitle("Fetch Recipes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}






