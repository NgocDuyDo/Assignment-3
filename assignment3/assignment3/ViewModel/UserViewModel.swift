//
//  UserViewModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation

//ViewModel for managing user profile and medications
class UserViewModel: ObservableObject {
    @Published var user: User
    @Published var medications: [Medication] = []
    
    @Published var newMedicationName = ""
    @Published var newMedicationDosage = ""
    @Published var newMedicationTime = Date()
    @Published var newMedicationReminderTiming = Medication.ReminderTiming.afterMeal

    //initialiser, loading user and medications data from UserDefaults
    init() {
        self.user = UserViewModel.loadUser()
        self.medications = UserViewModel.loadMedications()
    }

    //adds a new medication and save it in the list
    func addMedication(medication: Medication) {
        medications.append(medication)
        saveMedications()
    }

    //removes a medication and save it in the list
    func removeMedications(at offsets: IndexSet) {
        medications.remove(atOffsets: offsets)
        saveMedications()
    }
    
    //resets the entering medications fields
    func resetNewMedicationFields() {
        newMedicationName = ""
        newMedicationDosage = ""
        newMedicationTime = Date()
        newMedicationReminderTiming = .afterMeal
    }
    
    //saves user data to UserDefaults
    func saveUser() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "userData")
        }
        saveMedications()
    }
    
    //saves medications to UserDefaults
    func saveMedications() {
        if let encoded = try? JSONEncoder().encode(medications) {
            UserDefaults.standard.set(encoded, forKey: "medicationsData")
        }
    }

    //loads user data from UserDefaults
    static func loadUser() -> User {
        if let userData = UserDefaults.standard.data(forKey: "userData"),
           let decodedUser = try? JSONDecoder().decode(User.self, from: userData) {
            return decodedUser
        }
        return User(name: "", dateOfBirth: Date(), gender: .male, weight: 0, height: 0)
    }
    
    //loads medications data from UserDefaults
    static func loadMedications() -> [Medication] {
        if let medsData = UserDefaults.standard.data(forKey: "medicationsData"),
           let decodedMeds = try? JSONDecoder().decode([Medication].self, from: medsData) {
            return decodedMeds
        }
        return []
    }
}
