//
//  MedicationModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation
struct Medication: Codable, Identifiable {
    var id = UUID()
    var medicationName: String
    var medicationDosage: String
    var medicationTime: Date
    var medicationReminderTiming: ReminderTiming
    
    //the possible timings for medication reminders
    enum ReminderTiming: String, Codable, CaseIterable {
        case beforeMeal = "Before Meal", duringMeal = "During Meal", afterMeal = "After Meal"
    }
}
