//
//  ContentView.swift
//  FitnessTracker
//
//  Created by oguzhangumus on 1.12.2024.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        Group {
            if firebaseManager.isLoading {
                ProgressView()
            } else if firebaseManager.currentUser != nil {
                MainTabView()
            } else {
                AuthView()
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            ExercisesView()
                .tabItem {
                    Label("Egzersizler", systemImage: "figure.walk")
                }
            
            MyWorkoutsView()
                .tabItem {
                    Label("Egzersizlerim", systemImage: "list.bullet")
                }
            
            FoodsView()
                .tabItem {
                    Label("Yiyecekler", systemImage: "fork.knife")
                }
            
            MyMealsView()
                .tabItem {
                    Label("Öğünlerim", systemImage: "calendar")
                }
            
            SettingsView()
                .tabItem {
                    Label("Ayarlar", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
