//
//  CalendarScreen.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CalendarScreen: View {
//    @EnvironmentObject var metaData: MetaData
    @Environment(\.modelContext) var modelContext
    @Query private var allRecords: [CalendarDate]
    @State var currentDate: Date = Date()
    @State var currentCalendarData: CalendarDate?
//    @Bindable var record = RecordsModel().records
    
    var body: some View {
        NavigationStack{
            VStack {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), selectedDate: $currentDate)
                RecordsListView(currentDate: $currentDate)
            }
        }
    }
}

//#Preview {
//    CalendarScreen().environmentObject(DummyData()).environmentObject(MetaData())
//}
