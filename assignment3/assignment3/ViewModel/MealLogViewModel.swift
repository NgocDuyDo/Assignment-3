//
//  MealLogViewModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation

class MealLogViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedDate = Date()
    //@Published var mealToEdit: Meal?  // Holds the meal being edited

    init() {
        loadMeals()
    }

    func addMeal(_ meal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index] = meal
        } else {
            meals.append(meal)
        }
        saveMeals()
    }

    func deleteMeal(_ meal: Meal) {
        meals.removeAll { $0.id == meal.id }
        saveMeals()
    }

    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: "mealsData")
        }
    }

    private func loadMeals() {
        if let mealsData = UserDefaults.standard.data(forKey: "mealsData"),
           let decodedMeals = try? JSONDecoder().decode([Meal].self, from: mealsData) {
            meals = decodedMeals
        }
    }

    func meals(for date: Date) -> [Meal] {
        meals.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}

