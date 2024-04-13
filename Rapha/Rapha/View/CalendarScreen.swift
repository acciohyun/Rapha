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
    @EnvironmentObject var dummyData: DummyData
    @EnvironmentObject var metaData: MetaData
    @Environment(\.modelContext) private var modelContext
    @Query private var thisMonthRecords: [CalendarDate]
    
    var body: some View {
        NavigationStack{
            VStack {
                CalendarViewModel(interval: DateInterval(start: .distantPast, end: .distantFuture), dummyData: dummyData, metaData: metaData).modelContainer(for: CalendarDate.self, inMemory: true)
                List(metaData.categoriesOfRecords){ recordCategory in
                    RecordCategoryCellView(recordCategory: recordCategory).environmentObject(dummyData).environmentObject(metaData)
                }
            }.onAppear(){
                print(thisMonthRecords)
            }
        }
    }
}

#Preview {
    CalendarScreen().environmentObject(DummyData()).environmentObject(MetaData())
        .modelContainer(for: CalendarDate.self, inMemory: true)
}
