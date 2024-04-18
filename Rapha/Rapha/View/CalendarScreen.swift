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
    @State var view: CalendarView?
    
    var body: some View {
        NavigationStack{
            VStack {
                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), selectedDate: $currentDate)
//                if let view{
//                    view
//                }
                RecordsListView(currentDate: $currentDate)
            }
        }.onChange(of: allRecords){
//            if let view{
//                print("reload")
//                view.updateView()
//            }
            print("allRecords changed")
            //fired when allRecords changes
        }.onAppear(){
            view = CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), selectedDate: $currentDate)
            print(modelContext.sqliteCommand)
        }
    }
}

#Preview {
    CalendarScreen().modelContainer(for: CalendarDate.self)
}

//data persists after month change
//data persists after exiting existing symptoms page
// data is lost after existing existing medicine page
