//
//  MealLogView.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import SwiftUI
 
 struct MealLogView: View {
     @StateObject var viewModel = MealLogViewModel()
     @State private var showingDetails = false
     @State private var currentMeal: Meal?
    
     var body: some View {
         NavigationView {
             VStack {
                 DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                     .datePickerStyle(GraphicalDatePickerStyle())
                     .padding()
                 
                 mealListSection
                 
                 Button("Add Meal Log") {
                     currentMeal = Meal(mealType: .breakfast, menuName: "", calories: 0, date: viewModel.selectedDate)
                     showingDetails = true
                 }
                 Spacer()
             }
             .navigationTitle("Meal Log")
             .sheet(isPresented: $showingDetails) {
                 if let currentMeal = currentMeal {
                     MealEntryView(viewModel: viewModel, meal: currentMeal)
                 }
             }
         }
     }

     private var mealListSection: some View {
         List(viewModel.meals(for: viewModel.selectedDate)) { meal in
             MealView(meal: meal)
                 .padding()
                 .onTapGesture {
                     self.currentMeal = meal
                     showingDetails = true
                 }
                 .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                     deleteButton(meal)
                     editButton(meal)
                 }
         }
     }
     
     private func deleteButton(_ meal: Meal) -> some View {
         Button(role: .destructive) {
             withAnimation {
                 viewModel.deleteMeal(meal)
             }
         } label: {
             Label("Delete", systemImage: "trash")
         }
     }
     
     private func editButton(_ meal: Meal) -> some View {
         Button {
             currentMeal = meal
             showingDetails = true
         } label: {
             Label("Edit", systemImage: "pencil")
         }
         .tint(.blue)
     }
 }

 struct MealView: View {
     let meal: Meal
     
     var body: some View {
         VStack(alignment: .leading) {
             Text(meal.menuName).font(.headline)
             Text("Meal Type: \(meal.mealType.rawValue.capitalized)")
             Text("Calories: \(meal.calories)")
             if let medication = meal.medication {
                 medicationDetails(medication)
             }
         }
     }

     @ViewBuilder
     private func medicationDetails(_ medication: Medication) -> some View {
         VStack(alignment: .leading) {
             Text("Medication Details:").foregroundColor(.brown)
             Text("Medication Name: \(medication.name)")
             Text("Dosage: \(medication.dosage)")
             Text("Medication Time: \(medication.time, formatter: DateFormatter.shortTime)")
             Text("Reminder Timing: \(medication.reminderTiming.rawValue)")
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
                        viewModel.addMeal(meal) // Add new meal
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

