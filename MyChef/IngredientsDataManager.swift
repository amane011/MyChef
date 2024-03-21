//
//  IngredientsDataManager.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/12/24.
//

import Foundation

class IngredientsDataManager {
    static let shared = IngredientsDataManager()
    var ingredientsSet: Set<String> = []

    private init() {
//        ingredientsSet.insert("phone")
//        ingredientsSet.insert("passport")
        loadIngredientsData()
    }

    private func loadIngredientsData() {
        guard let filePath = Bundle.main.path(forResource: "ingredients", ofType: "txt"),
              let fileContent = try? String(contentsOfFile: filePath) else {
            print("Failed to load or read the ingredients file")
            return
        }

        let lines = fileContent.components(separatedBy: "\n")
        for line in lines {
            let ingredients = line.components(separatedBy: ",")
            for ingredient in ingredients {
                ingredientsSet.insert(ingredient.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
}
