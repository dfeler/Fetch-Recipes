//
//  RecipeDetailView.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/10/23.
//

import SwiftUI
import AVKit
import WebKit

struct RecipeDetailView: View {
    let mealId: String
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: RecipeDetailViewModel
    
    init(mealId: String) {
        self.mealId = mealId
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(mealId: mealId))
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let minY = geometry.frame(in: .global).minY
                let height = CGFloat(300)
                let stretch = max(0, minY)
                let scale = minY > 0 ? (1 + stretch / height) : 1
                
                ZStack(alignment: .top) {
                    if let urlString = viewModel.mealDetail?.strMealThumb, let url = URL(string: urlString) {
                        AsyncImageView(
                            url: url,
                            placeholder: Color.gray
                        )
                        .scaleEffect(scale)
                        .frame(width: UIScreen.main.bounds.width, height: height)
                        .clipped()
                        .offset(y: minY > 0 ? max(-height, -minY) : 0)
                    } else {
                        ProgressView()
                            .scaleEffect(scale)
                            .frame(width: UIScreen.main.bounds.width, height: height)
                    }
                }.onAppear {
                    viewModel.updateTitleVisibility(with: minY)
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    viewModel.updateTitleVisibility(with: minY)
                }
                
                Color.clear.preference(key: ViewOffsetKey.self, value: minY)
            }
            .frame(height: 300)
            .zIndex(1)
            
            if let mealDetail = viewModel.mealDetail {
                VStack(alignment: .leading){
                    VStack(alignment: .leading, spacing: -20) {
                        Text(mealDetail.strMeal)
                            .font(.custom("Lora-Bold", size: 29))
                            .bold()
                            .foregroundColor(.black)
                            .padding()
                        
                        HStack(spacing: -25) {
                            Text(mealDetail.strCategory)
                                .font(.custom("Lora-Bold", size: 16))
                                .foregroundColor(.black)
                                .padding([.leading, .trailing], 10)
                                .padding([.top, .bottom], 5)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("tagColor")))
                                .padding()
                            
                            HStack(spacing: 5) {
                                Image(systemName: "globe")
                                    .font(.system(size: 16))
                                
                                Text(mealDetail.strArea)
                                    .font(.custom("Lora-Bold", size: 16))
                                    .foregroundColor(.black)
                            }
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color("tagColor")))
                            .padding()
                            
                        }
                        
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Instructions:")
                            .font(.custom("Lora-Bold", size: 20))
                            .foregroundColor(.black)
                            .padding()
                        
                        Group {
                            if viewModel.showFullInstructions {
                                Text(mealDetail.strInstructions)
                            } else {
                                Text(mealDetail.strInstructionsPrefix)
                                    .lineLimit(5)
                            }
                        }
                        .font(.custom("Lora-Regular", size: 18))
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                        .padding(.horizontal)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                viewModel.showFullInstructions.toggle()
                            }
                        }
                        
                        if mealDetail.strInstructions.count > 100 {
                            Button(action: {
                                withAnimation {
                                    viewModel.showFullInstructions.toggle()
                                }
                            }) {
                                HStack {
                                    Text(viewModel.showFullInstructions ? "Collapse" : "Expand")
                                    Image(systemName: viewModel.showFullInstructions ? "arrow.up" : "arrow.down")
                                }
                            }
                            .font(.custom("Lora-Bold", size: 16))
                            .foregroundColor(.black)
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color("tagColor")))
                            .padding([.bottom, .leading, .trailing])
                        }
                    }
                }
            } else {
                Text("Loading...")
                    .foregroundColor(.black)
                    .padding()
            }
            
            HStack {
                OptionButton(title: "Recipe Ingredients", isSelected: viewModel.showRecipeIngredients) {
                    viewModel.showRecipeIngredients = true
                    viewModel.showVideoInstructions = false
                }
                
                OptionButton(title: "Video Instructions", isSelected: viewModel.showVideoInstructions) {
                    viewModel.showVideoInstructions = true
                    viewModel.showRecipeIngredients = false
                }
            }
            .padding()
            
            if viewModel.showRecipeIngredients, let mealDetail = viewModel.mealDetail {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(mealDetail.ingredientsAndMeasures.count)")
                            .font(.custom("Lora-Regular", size: 18))
                            .foregroundColor(Color("textColor"))
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 5)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color("tagColor")))
                        Text("Ingredients:")
                            .font(.custom("Lora-Bold", size: 20))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding([.top, .horizontal])
                    .background(Color("backgroundColor"))
                    
                    ForEach(mealDetail.ingredientsAndMeasures, id: \.ingredient) { item in
                        let uniqueID = "\(item.ingredient)-\(item.measure)"
                        HStack {
                            CheckBoxView(checked: Binding(
                                get: { viewModel.isChecked[uniqueID, default: false] },
                                set: { viewModel.isChecked[uniqueID] = $0 }
                            ))
                            .pushInEffect()
                            
                            Text(item.ingredient.capitalized)
                                .font(.custom("Lora-Bold", size: 18))
                                .foregroundColor(Color("textColor"))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(item.measure)
                                .font(.custom("Lora-Regular", size: 18))
                                .foregroundColor(.black)
                                .frame(alignment: .trailing)
                                .padding(.trailing, 12)
                        }
                        .padding([.leading, .trailing, .bottom])
                    }
                    .padding(.horizontal, 5)
                    .opacity(viewModel.showRecipeIngredients ? 1 : 0)
                    .animation(.easeInOut, value: viewModel.showRecipeIngredients)
                }
            }
            
            if viewModel.showVideoInstructions {
                if let youtubeVideoPlayer = viewModel.youtubeVideoPlayer {
                    youtubeVideoPlayer
                        .opacity(viewModel.showVideoInstructions ? 1 : 0)
                        .animation(.easeInOut, value: viewModel.showVideoInstructions)
                }
            }
        }
        .onPreferenceChange(ViewOffsetKey.self) { minY in
            viewModel.updateTitleVisibility(with: minY)
        }
        .navigationBarTitle(viewModel.showTitleInNavigationBar ? (viewModel.mealDetail?.strMeal ?? "") : "", displayMode: .inline)
        .background(Color("backgroundColor"))
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.gray)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color("navigationButton")))
        })
    }
}

extension MealDetail {
    var strInstructionsPrefix: String {
        let lines = strInstructions.split(separator: "\n")
        return lines.prefix(5).joined(separator: "\n") + "..."
    }
}




