//
//  RaphaApp.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import SwiftUI
import SwiftData

@main
struct Rapha_RemasteredApp: App {
    var body: some Scene {
        WindowGroup {
            CalendarScreen().environmentObject(RecordsModel())
        }.modelContainer(for: CalendarDate.self)
    }
}
