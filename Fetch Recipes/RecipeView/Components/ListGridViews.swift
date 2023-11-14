//
//  ListGridViews.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/13/23.
//

import SwiftUI

struct RecipeScrollView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        ScrollView {
            if viewModel.isGridViewActive {
                GridView(viewModel: viewModel)
            } else {
                ListView(viewModel: viewModel)
            }
        }
        .padding()
    }
}

struct GridView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        if viewModel.filteredMeals.isEmpty {
            Text("No results")
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
        } else {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(viewModel.filteredMeals.filter { !$0.idMeal.isEmpty }, id: \.idMeal) { meal in
                    NavigationLink(destination: RecipeDetailView(mealId: meal.idMeal)) {
                        RecipeGridCell(meal: meal)
                    }.pushInEffect()
                }
            }
        }
    }
}


struct ListView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        if viewModel.filteredMeals.isEmpty {
            Text("No results")
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
        } else {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.filteredMeals.filter { !$0.idMeal.isEmpty }, id: \.idMeal) { meal in
                    NavigationLink(destination: RecipeDetailView(mealId: meal.idMeal)) {
                        RecipeListCell(meal: meal, viewModel: viewModel)
                    }.pushInEffect()
                }
            }
        }
    }
}



struct RecipeGridCell: View {
    let meal: Meal
    
    var body: some View {
        VStack {
            AsyncImageView(
                url: URL(string: meal.strMealThumb),
                placeholder: Color.gray
            )
            .frame(height: 150)
            .cornerRadius(8)
            HStack {
                Text(meal.strMeal)
                    .font(.custom("Lora-Bold", size: 19))
                    .foregroundColor(Color("darktextColor"))
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .frame(height: 45)
                    .multilineTextAlignment(.leading)
                    .padding([.leading, .bottom], 8)
                Spacer()
            }
        }
        .frame(minHeight: 200)
        .background(Color("tagColor"))
        .cornerRadius(10)
    }
}

struct RecipeListCell: View {
    let meal: Meal
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        HStack {
            AsyncImageView(
                url: URL(string: meal.strMealThumb),
                placeholder: Color.gray
            )
            .frame(width: 75, height: 75)
            .cornerRadius(8)
            
            RecipeTitleText(text: viewModel.truncateText(meal.strMeal, limit: 50))
            
            Spacer()
        }
        .frame(height: 68)
        .background(Color("tagColor"))
        .cornerRadius(10)
    }
}
