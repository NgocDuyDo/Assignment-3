//
//  MealLogView.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import SwiftUI
 
 struct MealLogView: View {
     @StateObject var viewModel = MealLogViewModel()
     @StateObject var userViewModel = UserViewModel()
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
             .sheet(item: $currentMeal, onDismiss: {
                 // Perform any clean-up or reset actions if necessary
             }) { meal in
                 MealEntryView(viewModel: viewModel, userViewModel: userViewModel, meal: meal)
             }
         }
     }

     private var mealListSection: some View {
         List(viewModel.meals(for: viewModel.selectedDate)) { meal in
             MealView(viewModel: viewModel, meal: meal)  // Pass viewModel here
                 .padding()
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
     @ObservedObject var viewModel: MealLogViewModel
     let meal: Meal
     
     var body: some View {
         VStack(alignment: .leading) {
             Text(meal.menuName)
                 .font(.headline)
                 .fontWeight(.bold)
             Text("Meal Type: \(meal.mealType.rawValue.capitalized)")
             Text("Calories: \(meal.calories)")
             
             if !meal.selectedMedications.isEmpty {
                 VStack(alignment: .leading) {
                     Text("Medications:").bold()
                     ForEach(meal.selectedMedications, id: \.self) { id in
                         if let medication = viewModel.findMedication(by: id) {
                             Text(medication.medicationName) // Display medication name
                         } else {
                             Text("Unknown Medication") // Handle unknown medications
                         }
                     }
                 }
              }
         }
     }
 }


extension MealLogViewModel {
    func hasMeals(for date: Date) -> Bool {
        !meals(for: date).isEmpty
    }

    func findMedication(by id: UUID) -> Medication? {
        return medications.first { $0.id == id }
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

