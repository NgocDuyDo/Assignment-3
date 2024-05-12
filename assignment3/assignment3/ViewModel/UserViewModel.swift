//
//  UserViewModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation
class UserViewModel: ObservableObject {
    @Published var user: User
    @Published var medications: [Medication] = []
    
    @Published var newMedicationName = ""
    @Published var newMedicationDosage = ""
    @Published var newMedicationTime = Date()
    @Published var newMedicationReminderTiming = Medication.ReminderTiming.afterMeal

    init() {
        self.user = UserViewModel.loadUser()
        self.medications = UserViewModel.loadMedications()
    }

    func addMedication(medication: Medication) {
        medications.append(medication)
        saveMedications()
    }

    func removeMedications(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        saveMedications()
    }
    
    func resetNewMedicationFields() {
        newMedicationName = ""
        newMedicationDosage = ""
        newMedicationTime = Date()
        newMedicationReminderTiming = .afterMeal
    }
    
    func saveUser() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userData")
        }
        saveMedications()
    }
    
    func saveMedications() {
        if let encoded = try? JSONEncoder().encode(medications) {
            UserDefaults.standard.set(encoded, forKey: "medicationsData")
        }
    }

    static func loadUser() -> User {
        if let userData = UserDefaults.standard.data(forKey: "userData"),
           let decodedUser = try? JSONDecoder().decode(User.self, from: userData) {
            return decodedUser
        }
        return User(name: "", dateOfBirth: Date(), gender: .male, weight: 0, height: 0)
    }
    
    static func loadMedications() -> [Medication] {
        if let medsData = UserDefaults.standard.data(forKey: "medicationsData"),
           let decodedMeds = try? JSONDecoder().decode([Medication].self, from: medsData) {
            return decodedMeds
        }
        return []
    }
}
