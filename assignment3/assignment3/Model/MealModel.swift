//
//  MealModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation
struct Meal: Identifiable, Codable {
    var id: UUID = UUID()
    var mealType: MealType
    var menuName: String
    var calories: Int
    var date: Date
    var selectedMedications: [UUID] = []
    //var medication: Medication?
    //var hasMedication: Bool {
       // return medication != nil
    //}
    enum MealType: String, Codable, CaseIterable {
        case breakfast, lunch, dinner, snack
    }
}

