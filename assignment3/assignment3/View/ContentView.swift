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
            ProfileView()
                .navigationBarTitle("Profile")
        }
    }
}
struct ProfileView: View {
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var gender: Gender = .male
    @State private var weight: Int = 0
    @State private var height: Int = 0
    
