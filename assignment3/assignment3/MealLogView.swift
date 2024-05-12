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

