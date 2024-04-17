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
    @Environment(\.modelContext) var modelContext
    @Query var allRecords: [CalendarDate]
    @State var currentDate: Date = Date()
    @State var currentCalendarData: CalendarDate?
    
    var body: some View {
        NavigationStack{
            VStack {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), selectedDate: $currentDate)
                RecordsListView(currentDate: $currentDate)
            }
        }.onChange(of: allRecords){
            print("allRecords changed")
            //fired when allRecords changes
            
        }
    }
}

//#Preview {
//    CalendarScreen().environmentObject(DummyData()).environmentObject(MetaData())
//}

//data persists after month change
//data persists after exiting existing symptoms page
// data is lost after existing existing medicine page
