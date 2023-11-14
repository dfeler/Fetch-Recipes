//
//  SearchAndSortingViews.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/13/23.
//

import SwiftUI

struct SearchAndToggleView: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        VStack {
            HStack {
                SortButton(viewModel: viewModel)
                SearchField(viewModel: viewModel)
                GridViewToggle(viewModel: viewModel)
            }
            .padding()
        }
    }
}

struct SortButton: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        Button(action: {
            withAnimation {
                viewModel.isAscending.toggle()
            }
        }) {
            Image(systemName: viewModel.isAscending ? "arrow.up.arrow.down.square" : "arrow.up.arrow.down.square.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
        }
    }
}

struct SearchField: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        TextField("Search", text: $viewModel.searchText)
            .searchFieldStyle(viewModel: viewModel)
    }
}

struct GridViewToggle: View {
    @ObservedObject var viewModel: RecipeViewModel
    
    var body: some View {
        Button(action: {
            withAnimation {
                viewModel.isGridViewActive.toggle()
            }
        }) {
            Image(systemName: viewModel.isGridViewActive ? "list.bullet" : "square.grid.2x2")
                .resizable()
                .frame(width: 20, height: viewModel.isGridViewActive ? 15 : 20)
                .foregroundColor(.gray)
        }
    }
}

extension TextField {
    func searchFieldStyle(viewModel: RecipeViewModel) -> some View {
        self.disableAutocorrection(true)
            .frame(height: 40)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: {
                            viewModel.searchText = ""
                        }) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal, 5)
    }
}
