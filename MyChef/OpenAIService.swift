//
//  OpenAIService.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/18/24.
//

import UIKit
class OpenAIService {
    static let shared = OpenAIService()
    
    private let apiKey = ""
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    func generateRecipe(from details: Recipe, completion: @escaping (String?) -> Void) {
        var prompt = "Create a recipe with the following details:\n\nIngredients: \(details.ingredients.joined(separator: ", "))\n"
        
        if let preferences = details.selectedPreferences, !preferences.isEmpty {
            prompt += "Dietary Preferences: \(preferences.joined(separator: ", "))\n"
        }
        
        if let calorieRange = details.selectedCalorieRange {
            prompt += "Calorie Range: \(calorieRange)\n"
        }
        
        prompt += "\nRecipe:"
        
        var request = URLRequest(url: baseURL)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",  // Replace with the appropriate model for your use case
            "messages": [["role": "user", "content": prompt]]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error making OpenAI API call: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received from OpenAI API call")
                completion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any],
                   let answers = dictionary["choices"] as? [[String: Any]],
                   let firstAnswer = answers.first,
                   let message = firstAnswer["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content.trimmingCharacters(in: .whitespacesAndNewlines))
                } else {
                    print("JSON structure unexpected or missing values")
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON from OpenAI API: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
