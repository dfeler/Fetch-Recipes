//
//  RecipeViewModel.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/13/23.
//

import Foundation

class RecipeViewModel: ObservableObject {
    
    @Published var searchText: String = "" {
        didSet {
            filterAndSortMeals()
        }
    }
    @Published var isAscending: Bool = true {
        didSet {
            filterAndSortMeals()
        }
    }
    @Published var meals: [Meal] = []
    @Published var filteredMeals: [Meal] = []
    @Published var isGridViewActive = false

    func fetchMeals() {
        //fetch meals in the background
        DispatchQueue.global(qos: .userInitiated).async {
            NetworkManager().fetchMeals(category: "Dessert") { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let fetchedMeals):
                        self.meals = fetchedMeals
                        self.filterAndSortMeals()
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func filterAndSortMeals() {
        let sortedMeals = meals.sorted { isAscending ? $0.strMeal < $1.strMeal : $0.strMeal > $1.strMeal }
        if searchText.isEmpty {
            filteredMeals = sortedMeals
        } else {
            filteredMeals = sortedMeals.filter { $0.strMeal.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func truncateText(_ text: String, limit: Int) -> String {
        return text.count > limit ? String(text.prefix(limit)) + "..." : text
    }
}
