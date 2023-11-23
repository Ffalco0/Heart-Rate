//
//  HeartRateApp.swift
//  HeartRate
//
//  Created by Fabio Falco on 15/11/23.
//

import SwiftUI
import SwiftData

@main
struct HeartRateApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
                ContentView()
                    .tabItem {
                        Image(systemName: "book.pages.fill")
                        Text("Journal")
                    }
                MeasureView()
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Measure")
                    }
                StatView()
                    .tabItem {
                        Image(systemName: "chart.xyaxis.line")
                        Text("Analysis")
                    }
            }
        }
        .modelContainer(for:Entry.self)
    }
}
