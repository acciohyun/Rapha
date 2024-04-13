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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CalendarDate.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            CalendarScreen().environmentObject(DummyData()).environmentObject(MetaData())
        }.modelContainer(sharedModelContainer)
    }
}
