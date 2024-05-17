//
//  MealLogViewModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation

//ViewModel for managing meal entries and their associated medications
class MealLogViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedDate = Date()
    var userViewModel: UserViewModel

    //initialiser with a reference to a userViewModel
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        loadMeals()
    }

    //find a medication by UUID from the user's list of medications
    func findMedication(by id: UUID) -> Medication? {
        return userViewModel.medications.first { $0.id == id }
    }
    
    //adds or updates the meal information, then saves the list
    func addMeal(_ meal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index] = meal
        } else {
            meals.append(meal)
        }
        saveMeals()
    }

    //deletes a meal and saves the list
    func deleteMeal(_ meal: Meal) {
        meals.removeAll { $0.id == meal.id }
        saveMeals()
    }

    //saves meals data to UserDefaults
    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: "mealsData")
        }
    }

    //loads meals data from UserDefaults
    private func loadMeals() {
        if let mealsData = UserDefaults.standard.data(forKey: "mealsData"),
           let decodedMeals = try? JSONDecoder().decode([Meal].self, from: mealsData) {
            meals = decodedMeals
        }
    }

    //returns meal data for the specific date
    func meals(for date: Date) -> [Meal] {
        meals.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}

