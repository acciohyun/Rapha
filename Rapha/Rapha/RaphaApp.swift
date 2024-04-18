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
            Symptoms.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @MainActor
    let previewContainer: ModelContainer = {
        do {
            let container = try ModelContainer(
                for: CalendarDate.self,  configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            let newDummyEvent1 = CalendarDate(date: Date())
            let newDummyMed = Medication(date: newDummyEvent1)
            let newDummySymp = Symptoms(date: newDummyEvent1)
            newDummySymp.painAreas = [PainArea(x: 0, y: 0)]
            let newDummyLab = LabResults(date: newDummyEvent1)
            newDummyMed.amgevitaTaken = true
            newDummyEvent1.medication = newDummyMed
            newDummyEvent1.symptoms = newDummySymp
            newDummyEvent1.labResults = newDummyLab
            container.mainContext.insert(newDummyEvent1)
            try? container.mainContext.save()
            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()

    var body: some Scene {
        WindowGroup {
            CalendarScreen().environmentObject(RecordsModel())
        }.modelContainer(for: CalendarDate.self)
    }
}
