//
//  RecipeDetailViewModel.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/13/23.
//

import SwiftUI
import Combine

class RecipeDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetail?
    @Published var showWebView = false
    @Published var showTitleInNavigationBar = false
    @Published var showFullInstructions = false
    @Published var youtubeVideoPlayer: YouTubeVideoPlayer?
    @Published var isChecked: [String: Bool] = [:]
    @Published var showRecipeIngredients = true
    @Published var showVideoInstructions = false
    
    private let titleVisibilityThreshold: CGFloat = 260
    private let mealId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(mealId: String) {
        self.mealId = mealId
        fetchMealDetails()
    }
    
    func updateTitleVisibility(with offset: CGFloat) {
        showTitleInNavigationBar = offset <= -titleVisibilityThreshold
    }
    
    private func fetchMealDetails() {
        NetworkManager().fetchMealDetails(idMeal: mealId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.mealDetail = detail
                    
                    //pre-load YouTube video
                    if let youtubeURL = detail.strYoutube, let url = URL(string: youtubeURL) {
                        self?.youtubeVideoPlayer = YouTubeVideoPlayer(youtubeURL: url.absoluteString)
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func toggleIngredientSelection(for ingredient: String, measure: String) {
        let uniqueID = "\(ingredient)-\(measure)"
        isChecked[uniqueID] = !(isChecked[uniqueID] ?? false)
    }
}


struct CheckBoxView: View {
    @Binding var checked: Bool
    
    var body: some View {
        Button(action: {
            self.checked.toggle()
        }) {
            Image(systemName: checked ? "checkmark.square" : "square")
                .resizable()
                .foregroundColor(checked ? Color("darktextColor") : .gray)
                .frame(width: 20, height: 20)
        }
    }
}

//key to communicate the scroll offset
struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
