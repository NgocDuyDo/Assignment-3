//
//  MealViewModel.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import Foundation

class MealLogViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedDate = Date()
    @Published var mealToEdit: Meal?  // Holds the meal being edited

    init() {
        loadMeals()  // Load meals from UserDefaults or other storage upon initialization
    }

    func addMeal(meal: Meal) {
        if let index = meals.firstIndex(where: { $0.id == meal.id }) {
            meals[index] = meal  // Update existing meal
        } else {
            meals.append(meal)  // Add new meal
        }
        saveMeals()
    }

    func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: "mealsData")
        }
    }

    func loadMeals() {
        if let mealsData = UserDefaults.standard.data(forKey: "mealsData"),
           let decodedMeals = try? JSONDecoder().decode([Meal].self, from: mealsData) {
            meals = decodedMeals
        }
    }

    func meals(for date: Date) -> [Meal] {
        return meals.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    /*func hasMeals(for date: Date) -> Bool {
        !meals(for: date).isEmpty
    }*/
}

