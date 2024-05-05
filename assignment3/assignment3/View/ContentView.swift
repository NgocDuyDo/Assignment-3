//
//  ContentView.swift
//  assignment3
//
//  Created by Chohwi Park on 22/4/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Label("Diet App", systemImage: "")
                    .foregroundColor(.mint)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Text("🍽️")
                    .font(.system(size: 100))
                Spacer()
                
                //NavigationLinks
                NavigationLink(destination: UserView(), label: {Text("User Information")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                })
                NavigationLink(destination: MealLogView(), label: {Text("Meal Log")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                })
                .padding(50)
                NavigationLink(destination: MedicationLogView(), label: {Text("Medication Log")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                })
                Spacer()
            }
        }
    }
    
}
#Preview {
    ContentView()
}

