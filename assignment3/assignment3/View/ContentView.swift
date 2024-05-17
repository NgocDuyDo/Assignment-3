//
//  ContentView.swift
//  assignment3
//
//  Created by Chohwi Park on 22/4/2024.
//

import SwiftUI
import Charts
// ContentView: Main tab bar view
struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            MealLogView() //Placeholder for future meal log view
                .tabItem {
                    Label("Log", systemImage: "book")
                }
            UserView() // Placeholder for future user info view
                .tabItem {
                    Label("User Info", systemImage: "person")
                }
        }
        .accentColor(.mint) //set the tab bar accent color
    }
}

// Displays a line chart representing meal calories over time.
struct LineChartView: View {
    var viewModel = MealLogViewModel(userViewModel: UserViewModel())

    var sortedMeals: [Meal] {
        return viewModel.meals.sorted(by: { $0.date < $1.date })
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height:60)
            if (!viewModel.meals.isEmpty) {
                Chart {
                    ForEach(sortedMeals) { meal in
                        AreaMark(
                            x: PlottableValue.value("Month", meal.date),
                            y: PlottableValue.value("calories", meal.calories))
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(.linearGradient(colors: [Color.mint.opacity(0.3),Color.mint.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                        
                        LineMark(
                            x: PlottableValue.value("Month", meal.date),
                            y: PlottableValue.value("calories", meal.calories)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.mint)
                        .symbol {
                            Circle()
                                .stroke(.mint, lineWidth: 5)
                                .fill(.white)
                                .frame(width: 8, height: 8)
                                .overlay {
                                    Text("\(Int(meal.calories))")
                                        .frame(width: 20)
                                        .foregroundColor(Color.mint)
                                        .font(.system(size: 8, weight: .medium))
                                        .offset(y: -15)
                                }
                        }
                    }
                }
                .chartXScale(range: .plotDimension(padding: 20.0))
                .chartYScale(range: .plotDimension(padding: 20.0))
                .chartScrollableAxes(.horizontal)
                .frame(width:340,height: 250)
                .padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(.gray, lineWidth: 2)
                            .fill(.white)
                            .frame(width:350,height: 300)
                            .offset(y:-20)
                        Text("Trends")
                            .font(.system(size: 21, weight: .light))
                            .foregroundColor(Color.gray)
                            .frame(width: 160, height: 58)
                            .offset(x:-130,y:-142)
                    }
                )
            }
            else {
                Text("No data recorded")
                    .font(.system(size: 20))
                    .frame(width: 300)
                    .foregroundColor(Color.gray)
                    
                    .background(
                        RoundedRectangle(cornerRadius: 15.0)
                            .frame(width: 300, height: 300)
                            .foregroundColor(Color.gray).brightness(0.4)
                    )
                    .padding(100)
            }
        }
        .padding()
    }
}

// Home view containing a greeting and a chart of calorie data./
struct HomeView: View {
    let caloriesData = [300.0, 500.0, 600.0, 400.0, 700.0, 650.0, 200.0, 300.0, 550.0]
    let maxCalories = 900.0
    @ObservedObject var userViewModel = UserViewModel()
    @StateObject var mealLogViewModel = MealLogViewModel(userViewModel: UserViewModel())
    
    var body: some View {
        VStack {
            Label("MealMed", systemImage: "cross.circle")
                .foregroundColor(.mint)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 1)

            Text("Welcome back \(userViewModel.user.name)")
                .font(.headline)
                .fontWeight(.regular)
                .foregroundColor(Color.gray).brightness(0.1)
            
            Spacer(minLength: 0)
            LineChartView()
            
            VStack {
                Text("Reminders").font(.system(size: 20).weight(.medium))
                    .foregroundColor(Color.white)
                    .background(
                        Group {
                            if !userViewModel.medications.isEmpty {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .frame(width: 1000, height: 45, alignment: .center)
                                    .foregroundColor(Color.mint).brightness(0.1)
                            }
                            else {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .frame(width: 1000, height: 45, alignment: .center)
                                    .foregroundColor(Color.gray).brightness(0.1)
                            }
                        }
                    )
                
                List(userViewModel.medications) { medication in
                    VStack(alignment: .leading) {
                        Text(medication.medicationName)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text("\(medication.medicationDosage) at \(medication.medicationTime, formatter: DateFormatter.shortTime), \(medication.medicationReminderTiming.rawValue)")
                    }
                }
            }

        }
        .onAppear(perform: refreshData)
    }
    
    // Refresh data on view appearance to ensure it's up-to-date
    private func refreshData() {
           userViewModel.objectWillChange.send()
           mealLogViewModel.objectWillChange.send()
       }
}

//preview
#Preview {
    ContentView()
}

