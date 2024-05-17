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
                personalInformationSection
                bodyMetricsSection
                medicationsSection
                saveProfileButton
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private var personalInformationSection: some View {
        Group {
            Section(header: Text("Personal Information").foregroundColor(.mint)) {
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
            Section(header: Text("Gender").foregroundColor(.mint)) {
                Picker("Gender", selection: $userViewModel.user.gender) {
                    ForEach(User.Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue.capitalized).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
    
    private var bodyMetricsSection: some View {
        Section(header: Text("Body Metrics").foregroundColor(.mint)) {
            HStack {
                Text("Weight (kg):")
                Spacer()
                TextField("", value: $userViewModel.user.weight, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
            }

            HStack {
                Text("Height (cm):")
                Spacer()
                TextField("", value: $userViewModel.user.height, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)
            }
        }
    }
    
    private var medicationsSection: some View {
        Group{
            Section(header: Text("Medication").foregroundColor(.mint)) {
                // List of medications
                ForEach($userViewModel.medications) { $medication in
                    VStack(alignment: .leading) {
                        Text("\(medication.medicationName)")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Text("\(medication.medicationDosage), at \(medication.medicationTime, formatter: DateFormatter.shortTime), \(medication.medicationReminderTiming.rawValue)")
                    }
                }
                .onDelete(perform: userViewModel.removeMedications)
            }
            Section(header: Text("Add Medication").foregroundColor(.mint)) {
                TextField("Medication Name", text: $userViewModel.newMedicationName)
                TextField("Dosage", text: $userViewModel.newMedicationDosage)
                DatePicker("Time:", selection: $userViewModel.newMedicationTime, displayedComponents: .hourAndMinute)
                Picker("Reminder Timing", selection: $userViewModel.newMedicationReminderTiming) {
                    ForEach(Medication.ReminderTiming.allCases, id: \.self) { timing in
                        Text(timing.rawValue).tag(timing)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Add Medication") {
                    let newMedication = Medication(
                        medicationName: userViewModel.newMedicationName,
                        medicationDosage: userViewModel.newMedicationDosage,
                        medicationTime: userViewModel.newMedicationTime,
                        medicationReminderTiming: userViewModel.newMedicationReminderTiming
                    )
                    userViewModel.addMedication(medication: newMedication)
                    userViewModel.resetNewMedicationFields() // Clears the fields after adding
                }
                .foregroundColor(.mint)
            }
        }
    }

    private var saveProfileButton: some View {
        Button("Save Profile") {
            userViewModel.saveUser()
            isProfileSaved = true
        }
        .tint(.mint)
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
