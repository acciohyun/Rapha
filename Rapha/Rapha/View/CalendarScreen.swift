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
    @EnvironmentObject var metaData: MetaData
    @Environment(\.modelContext) var modelContext
    @Query private var allRecords: [CalendarDate]
    @State var currentDate: Date = Date()
    @State var currentCalendarData: CalendarDate?
    
    var body: some View {
        NavigationStack{
            VStack {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), metaData: metaData, selectedDate: $currentDate)
                List(metaData.categoriesOfRecords){ recordCategory in
                    RecordCategoryCellView(recordCategory: recordCategory).environmentObject(metaData)
                }
            }.onChange(of: currentDate){ oldValue, newValue in
                currentCalendarData = allRecords.filter({ $0.date.startOfDay == newValue.startOfDay}).first
                print("onchange: \(currentDate)")
            }
        }
    }
}

#Preview {
    CalendarScreen().environmentObject(DummyData()).environmentObject(MetaData())
}
