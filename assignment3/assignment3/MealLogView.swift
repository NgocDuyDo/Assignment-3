//
//  MealLogView.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import SwiftUI
 
 struct MealLogView: View {
     @StateObject var viewModel = MealLogViewModel()
     @State private var showingMealDetails = false
     @State private var addingNewMeal = false
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                
                List(viewModel.meals(for: viewModel.selectedDate)) { meal in
                    VStack(alignment: .leading) {
                        Text(meal.menuName)
                            .font(.headline)
                        Text("Meal Type: \(meal.mealType.rawValue.capitalized)")
                        Text("Calories: \(meal.calories)")
                        if meal.hasMedication {
                            Text("Medication Details:").foregroundStyle(.brown)
                            Text("Medication Name: \(meal.medication!.name)")
                            Text("Dosage: \(meal.medication!.dosage)")
                            if meal.hasMedication, let medicationTime = meal.medication?.time{
                                Text("Medication Time: \(medicationTime, formatter:DateFormatter.shortTime)")
                            }
                            Text("ReminderTiming: \(meal.medication!.reminderTiming.rawValue)")
                        }
                    }
                    .padding()
                    .onTapGesture {
                        // Set this meal for editing
                        viewModel.mealToEdit = meal
                        showingMealDetails = true
                    }
                }
                
                Button("Add Meal Log") {
                    addingNewMeal = true
                }
                Spacer()
            }
            .navigationTitle("Meal Log")
            .sheet(isPresented: $addingNewMeal) {
                // Present a view to add a new meal
                MealEntryView(viewModel: viewModel, meal: Meal(mealType: .breakfast, menuName: "", calories: 0, date: viewModel.selectedDate))
            }
        }
    }
}

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
                Picker("Meal Type", selection: $meal.mealType) {
                    ForEach(Meal.MealType.allCases, id: \.self) { type in
                        Text(type.rawValue.capitalized).tag(type)
                    }
                }
                TextField("Menu Name", text: $meal.menuName)
                TextField("Calories", value: $meal.calories, formatter: NumberFormatter())
                Section(header: Text("Medication Details")) {
                    TextField("Medication Name", text: $medicationName)
                    TextField("Dosage", text: $medicationDosage)
                    DatePicker("Medication Time", selection: $selectedMedicationTime, displayedComponents: .hourAndMinute)
                    Picker("Reminder Timing", selection: $selectedReminderTimingIndex){
                        ForEach(0..<reminderTimings.count) {index in
                            Text(reminderTimings[index])
                        }
                    }
                }
    
                Button("Save") {
                    let reminderTiming = reminderTimings[selectedReminderTimingIndex]
                    let medication = Medication(name: medicationName, dosage: medicationDosage, time: selectedMedicationTime, reminderTiming: .afterMeal)
                    meal.medication = medication
                    if let index = viewModel.meals.firstIndex(where: { $0.id == meal.id }) {
                        viewModel.meals[index] = meal // Update existing meal
                    } else {
                        viewModel.addMeal(meal: meal) // Add new meal
                    }
                    presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
                }
            }
            .navigationTitle("Add/Edit Meal")
        }
    }
}



extension MealLogViewModel {
    func hasMeals(for date: Date) -> Bool {
        !meals(for: date).isEmpty
    }
}
extension DateFormatter {
    static let shortTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    } ()
}

struct MealLogView_Previews: PreviewProvider {
    static var previews: some View {
        MealLogView()
    }
}

