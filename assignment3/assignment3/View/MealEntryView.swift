//
//  MealEntryView.swift
//  assignment3
//
//  Created by Chohwi Park on 12/5/2024.
//

import SwiftUI

// View for adding or editing a meal entry.
struct MealEntryView: View {
    @ObservedObject var viewModel: MealLogViewModel
    @ObservedObject var userViewModel: UserViewModel
    @State var meal: Meal
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            //header
            Text("Add/Edit Meal")
                .foregroundColor(.mint)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Form {
                DatePicker("Date:", selection: $meal.date, displayedComponents: .date)
                mealDetailsSection
                
                //display medicationListSection only if there are medications
                if !userViewModel.medications.isEmpty {
                    medicationListSection
                }
                
                Button("Save") { //save button
                    saveMeal()
                }
                .tint(.mint)
            }
        }
    }

    //Section for entering meal details (type, name, and calories)
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
    
    // Section for selecting medications
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

    // Toggle selection status of a medication
    private func toggleMedicationSelected(_ id: UUID) {
        if let index = meal.selectedMedications.firstIndex(of: id) {
            meal.selectedMedications.remove(at: index)
        } else {
            meal.selectedMedications.append(id)
        }
    }
    
    // Save or update the meal
    private func saveMeal() {
        if let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }) {
            viewModel.meals[index] = meal // Update existing meal
        } else {
            viewModel.addMeal(meal) // Add new meal
        }
        presentationMode.wrappedValue.dismiss()
    }
}

//preview
struct MealEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let mealLogViewModel = MealLogViewModel(userViewModel: UserViewModel())
        let userViewModel = UserViewModel()
        MealEntryView(
              viewModel: mealLogViewModel,
              userViewModel: userViewModel,
              meal: Meal(
                  mealType: .breakfast,
                  menuName: "Sample Breakfast",
                  calories: 350,
                  date: Date(),
                  selectedMedications: []
              )
        )
    }
}
