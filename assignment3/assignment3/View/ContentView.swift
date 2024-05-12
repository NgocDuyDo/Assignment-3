//
//  ContentView.swift
//  assignment3
//
//  Created by Chohwi Park on 22/4/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MealLogView()
                .tabItem {
                    Label("Log", systemImage: "book")
                }
            UserView()
                .tabItem {
                    Label("User Info", systemImage: "person")
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            Label("Diet App", systemImage: "leaf")
                .foregroundColor(.mint)
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
            Text("🍽️")
                .font(.system(size: 100))
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}

