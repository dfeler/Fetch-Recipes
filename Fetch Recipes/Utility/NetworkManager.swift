//
//  NetworkManager.swift
//  Fetch Recipes
//
//  Created by Daniel Feler on 11/10/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case noData
    case custom(Error)
}

class NetworkManager {
    static let baseURL = "https://www.themealdb.com/api/json/v1/1/"

    func makeRequest(endpoint: String, parameters: [String: String], method: HTTPMethod, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard var components = URLComponents(string: Self.baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        if method == .get {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if method == .post {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = jsonData
            } catch {
                completion(.failure(.custom(error)))
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.custom(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            completion(.success(data))
        }
        task.resume()
    }
}

extension NetworkManager {
    func fetchMeals(category: String, completion: @escaping (Result<[Meal], NetworkError>) -> Void) {
        makeRequest(endpoint: "filter.php", parameters: ["c": category], method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                    let validMeals = mealResponse.meals.filter { !$0.strMeal.isEmpty && !$0.idMeal.isEmpty }
                    completion(.success(validMeals))
                } catch {
                    completion(.failure(.decodingError))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchMealDetails(idMeal: String, completion: @escaping (Result<MealDetail, NetworkError>) -> Void) {
        makeRequest(endpoint: "lookup.php", parameters: ["i": idMeal], method: .get) { result in
            switch result {
            case .success(let data):
                do {
                    let mealDetailResponse = try JSONDecoder().decode(MealDetailResponse.self, from: data)
                    guard let mealDetail = mealDetailResponse.meals.first else {
                        completion(.failure(.noData))
                        return
                    }
                    completion(.success(mealDetail))
                } catch {
                    completion(.failure(.decodingError))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
