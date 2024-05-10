//
//  UserView.swift
//  assignment3
//
//  Created by Chohwi Park on 5/5/2024.
//

import SwiftUI

import SwiftUI

struct UserView: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var showDatePicker = false  // State to control visibility of the DatePicker
    @State private var isProfileSaved = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information").foregroundColor(.blue)) {
                    TextField("Name", text: $userViewModel.user.name)
                    
                    Button(action: {
                        // Toggle the visibility of the DatePicker
                        self.showDatePicker.toggle()
                    }) {
                        Text("Date of Birth: \(userViewModel.user.dateOfBirth, formatter: DateFormatter.shortDate)")
                            .foregroundColor(.primary)
                    }
                    if showDatePicker {
                        DatePicker("Select Date", selection: $userViewModel.user.dateOfBirth, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                }

                Section(header: Text("Gender").foregroundColor(.green)) {
                    Picker("Gender", selection: $userViewModel.user.gender) {
                        ForEach(User.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue.capitalized).tag(gender)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Body Metrics")) {
                    HStack {
                        Text("Weight (kg):")
                        Spacer()
                        TextField("", value: $userViewModel.user.weight, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80) // Adjust width based on UI needs
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Height (cm):")
                        Spacer()
                        TextField("", value: $userViewModel.user.height, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80) // Adjust width based on UI needs
                    }
                    .padding(.horizontal)
                }
                NavigationLink(
                    destination: MealLogView(), label: {
                Button(action: {
                       userViewModel.saveUser() 
                    Print("Profile is save")
                    isProfileSaved = true
                }) {
                    Text("Save Profile")
                }
            })
            .navigationTitle("Profile")
        }
    }
}

// Helper extension to format the date
extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}


#Preview {
    UserView()
}
