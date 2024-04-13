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
    //    @Query(filter: #Predicate<CalendarDate>
    //           {$0.date.month == 4 && $0.date.year == 2024})
    //    var thisMonthRecords: [CalendarDate]
    @Query private var thisMonthRecords: [CalendarDate]
    //    let dummyEvent: CalendarDate?
    
    var body: some View {
        NavigationStack{
            VStack {
                CalendarViewModel(interval: DateInterval(start: .distantPast, end: .distantFuture), dummyData: dummyData, metaData: metaData)
                List(metaData.categoriesOfRecords){ recordCategory in
                    RecordCategoryCellView(recordCategory: recordCategory).environmentObject(dummyData).environmentObject(metaData)
                }
            }.onAppear(){
                let newDummyEvent1 = CalendarDate(date: Date())
                let newDummyMed = Medication(date: newDummyEvent1)
                newDummyMed.amgevitaTaken = true
                newDummyEvent1.medication = newDummyMed
                modelContext.insert(newDummyEvent1)
                print("dummy")
                print(thisMonthRecords)
            }
        }
    }
}

#Preview {
    CalendarScreen().environmentObject(DummyData()).environmentObject(MetaData())
        .modelContainer(for: CalendarDate.self, inMemory: true)
}
