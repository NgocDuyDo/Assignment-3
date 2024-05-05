//
//  ContentView.swift
//  assignment3
//
//  Created by Chohwi Park on 22/4/2024.
//

import SwiftUI

struct ContentView: View {
     
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var gender: Gender = .male
    @State private var weight: Int = 0
    @State private var height: Int = 0
     var body: some View {
          NavigationView {
               Form {
                    Section(header: Text("Personal Information").foregroundColor(.blue))
                    TextField("Name", text: $name)
                    Stepper("Age: \(age)", value: $age, in: 0...120)
                    Picker("Gender", selection: $gender) {
                         ForEach(Gender.allCases, id: \self) {gender in
                              Text(gender.rawValue.capitalized)
                         }
                    }
                    .pickerStyle(SegmentedPickerStyle())
               }
               Section(header: Text("Body Metrics").foregroundColor(.green)) {
                    Stepper("Weight (kg): \(weight)", value: $weight, in: 0...400)
                    Stepper("Height (cm): \(height)", value: $height, in: 0...300)
               }
               Button(action: saveProfile) {
                    Text("Save Profile")
               }
          }
          .navigationTitle("Profile")
     }
}
func saveProfile() {
     print("Name: \(name), Age: \(age), Gender: \(gender.rawValue), Weight: \(weight), Height: \(height)")
}
enum Gender: String, CaseIterable {
     case male
     case female
     case other
}
    
