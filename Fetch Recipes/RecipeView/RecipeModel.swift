//
//  RecipeModel.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/13/23.
//

import Foundation

struct Meal: Decodable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

struct MealResponse: Decodable {
    let meals: [Meal]
}
