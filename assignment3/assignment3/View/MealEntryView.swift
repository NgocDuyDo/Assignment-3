//
//  MealEntryView.swift
//  assignment3
//
//  Created by Chohwi Park on 12/5/2024.
//

import SwiftUI

struct MealEntryView: View {
    @ObservedObject var viewModel: MealLogViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State var meal: Meal
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date:", selection: $meal.date, displayedComponents: .date)
                
                mealDetailsSection
                
                medicationListSection
                
                Button("Save") {
                    saveMeal()
                }
                .tint(.mint)
            }
            .navigationTitle("Add/Edit Meal")
        }
    }

    private var mealDetailsSection: some View {
        Group {
            Picker("Meal Type:", selection: $meal.mealType) {
                ForEach(Meal.MealType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            HStack {
                Text("Meal Name:")
                Spacer()
                TextField("Enter meal name", text: $meal.menuName)
            }
            HStack {
                Text("Calories:")
                Spacer()
                TextField("Enter calories", value: $meal.calories, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
        }
    }
    private var medicationListSection: some View {
        Section(header: Text("Select Medications")) {
            ForEach(userViewModel.medications.indices, id: \.self) { index in
                HStack {
                    Button(action: {
                        toggleMedicationSelected(userViewModel.medications[index].id)
                    }) {
                        HStack {
                            Image(systemName: meal.selectedMedications.contains(userViewModel.medications[index].id) ? "checkmark.square.fill" : "square")
                                .tint(.mint)
                            Text(userViewModel.medications[index].medicationName)
                                .tint(.mint)
                        }
                    }
                }
            }
        }
    }

    private func toggleMedicationSelected(_ id: UUID) {
        if let index = meal.selectedMedications.firstIndex(of: id) {
            meal.selectedMedications.remove(at: index)
        } else {
            meal.selectedMedications.append(id)
        }
    }
    private func saveMeal() {
        if let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }) {
            viewModel.meals[index] = meal // Update existing meal
        } else {
            viewModel.addMeal(meal) // Add new meal
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct MealEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let mealLogViewModel = MealLogViewModel(userViewModel: UserViewModel())
        let userViewModel = UserViewModel()
        MealEntryView(
              viewModel: mealLogViewModel,
              userViewModel: userViewModel,
              meal: Meal(
                  mealType: .breakfast, // Default type
                  menuName: "Sample Breakfast", // Example menu name
                  calories: 350, // Example calorie count
                  date: Date(), // Current date
                  selectedMedications: [] // Empty medication list
              )
        )
    }
}
