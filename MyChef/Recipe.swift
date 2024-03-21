//
//  Recipe.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/17/24.
//

import Foundation

struct Recipe {
    var ingredients : [String]
    var selectedPreferences: Set<String>?
    var selectedCalorieRange: String?
}
