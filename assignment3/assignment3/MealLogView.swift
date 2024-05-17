//
//  MealLogView.swift
//  assignment3
//
//  Created by Chohwi Park on 29/4/2024.
//

import SwiftUI
 
 struct MealLogView: View {
     @StateObject var viewModel = MealLogViewModel(userViewModel: UserViewModel())
     @StateObject var userViewModel = UserViewModel()
     @State private var showingDetails = false
     @State private var currentMeal: Meal?
     
     init() {
         let userViewModel = UserViewModel()
         _viewModel = StateObject(wrappedValue: MealLogViewModel(userViewModel: userViewModel))
         _userViewModel = StateObject(wrappedValue: userViewModel)
     }
     
     var body: some View {
         VStack {
             Text("Meal Log")
                 .foregroundColor(.mint)
                 .font(.system(size: 30))
                 .fontWeight(.bold)
                 .padding()

             DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                 .datePickerStyle(GraphicalDatePickerStyle())
                 .tint(.mint)
                 .labelsHidden()
                 .frame(width: 350, height: 280, alignment: .center)
                 .padding(20)

             Text("Recorded Meals").font(.system(size: 20).weight(.medium))
                 .foregroundColor(Color.white)
                 .background(
                     Group {
                         if !viewModel.meals(for: viewModel.selectedDate).isEmpty {
                             RoundedRectangle(cornerRadius: 10.0)
                                 .frame(width: 1000, height: 45, alignment: .center)
                                 .foregroundColor(Color.mint).brightness(0.1)
                         } else {
                             RoundedRectangle(cornerRadius: 10.0)
                                 .frame(width: 1000, height: 45, alignment: .center)
                                 .foregroundColor(Color.gray).brightness(0.1)
                         }
                     }
                 )
                 .padding(.top)

             mealListSection
             /*ForEach(viewModel.medications) { medication in
                 Text("\(medication.medicationName) : \(medication.medicationDosage), at \(medication.medicationTime, formatter: DateFormatter.shortTime), \(medication.medicationReminderTiming.rawValue)")
             }
             .padding(.bottom, 60)*/

             Button("Add Meal Log") {
                 currentMeal = Meal(mealType: .breakfast, menuName: "", calories: 0, date: viewModel.selectedDate)
                 showingDetails = true
             }
             .font(.system(size: 18).weight(.medium))
             .foregroundColor(Color.white)
             .background(
                 RoundedRectangle(cornerRadius: 10.0)
                     .frame(width: 210, height: 40, alignment: .center)
                     .foregroundColor(Color.mint)
             )
             .padding()

             Spacer()
         }
         .sheet(item: $currentMeal, onDismiss: {
             // Perform any clean-up or reset actions if necessary
         }) { meal in
             MealEntryView(viewModel: viewModel, userViewModel: userViewModel, meal: meal)
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
                 .font(.system(size: 18))
                 .fontWeight(.bold)
             Text("Meal Type: \(meal.mealType.rawValue.capitalized)")
                 .font(.system(size: 14))
             Text("Calories: \(meal.calories)")
                 .font(.system(size: 14))
             
             if !meal.selectedMedications.isEmpty {
                 VStack(alignment: .leading) {
                     Text("Medications:").bold()
                         .font(.system(size: 18))
                     ForEach(meal.selectedMedications, id: \.self) { id in
                         if let medication = viewModel.findMedication(by: id) {
                             Text(medication.medicationName)
                                 .font(.system(size: 14))
                             // Display medication name
                         } else {
                             Text("Unknown Medication") // Handle unknown medications
                         }
                     }
                 }
              }
         }.padding(-10)
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

