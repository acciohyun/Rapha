//
//  RaphaApp.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import SwiftUI
import SwiftData

@main
struct RaphaApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
//        .modelContainer(sharedModelContainer)
    }
}
