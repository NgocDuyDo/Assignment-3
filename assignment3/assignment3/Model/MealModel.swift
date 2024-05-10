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
    var medication: Medication?
    enum MealType: String, Codable, CaseIterable {
        case breakfast, lunch, dinner, snack
    }
}
struct Medication: Identifiable, Codable {
    var name: String
    var dosage: String
    var time: Date
    var reminderTiming: ReminderTiming
    enum ReminderTiming: String, Codable, CaseIterable {
        case beforeMeal, duringMeal, afterMeal 
    }
}
