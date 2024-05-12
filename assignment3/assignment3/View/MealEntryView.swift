//
//  MealEntryView.swift
//  assignment3
//
//  Created by Chohwi Park on 12/5/2024.
//

import SwiftUI

struct MealEntryView: View {
    @ObservedObject var viewModel: MealLogViewModel
    @State var meal: Meal
    @Environment(\.presentationMode) var presentationMode
    @State private var medicationName = ""
    @State private var medicationDosage = ""
    @State private var selectedMedicationTime = Date()
    @State private var selectedReminderTimingIndex = 0
    let reminderTimings = ["Before Meal", "During Meal", "After Meal"]
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $meal.date, displayedComponents: .date)
                
                mealDetailsSection
                
                medicationDetailsSection
                
                Button("Save") {
                    saveMeal()
                }
            }
            .navigationTitle("Add/Edit Meal")
        }
    }

    private var mealDetailsSection: some View {
        Group {
            Picker("Meal Type", selection: $meal.mealType) {
                ForEach(Meal.MealType.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            HStack {
                Text("Menu Name")
                Spacer()
                TextField("Enter menu name", text: $meal.menuName)
            }
            HStack {
                Text("Calories")
                Spacer()
                TextField("Enter calories", value: $meal.calories, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
            }
        }
    }

    private var medicationDetailsSection: some View {
        Section(header: Text("Medication Details")) {
            TextField("Medication Name", text: $medicationName)
            TextField("Dosage", text: $medicationDosage)
            DatePicker("Medication Time", selection: $selectedMedicationTime, displayedComponents: .hourAndMinute)
            Picker("Reminder Timing", selection: $selectedReminderTimingIndex) {
                ForEach(0..<reminderTimings.count) { index in
                    Text(reminderTimings[index])
                }
            }
        }
    }

    private func saveMeal() {
        let reminderTiming = reminderTimings[selectedReminderTimingIndex]
        let medication = Medication(name: medicationName, dosage: medicationDosage, time: selectedMedicationTime, reminderTiming: .afterMeal)
        meal.medication = medication
        if let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }) {
            viewModel.meals[index] = meal // Update existing meal
        } else {
            viewModel.addMeal(meal) // Add new meal
        }
        presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
        /*let reminderTiming = ReminderTiming(rawValue: reminderTimings[selectedReminderTimingIndex]) ?? .afterMeal
        let medication = Medication(name: medicationName, dosage: medicationDosage, time: selectedMedicationTime, reminderTiming: reminderTiming)
        meal.medication = medication
        viewModel.addMeal(meal, with: medication)
        presentationMode.wrappedValue.dismiss()*/
    }
}

struct MealEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MealLogViewModel()
        let sampleDate = Date()
        MealEntryView(viewModel: viewModel, meal: Meal(mealType: .breakfast, menuName: "", calories: 0, date: sampleDate))
    }
}
