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
    @State var recordCopyClass = RecordCopy()
    
    var body: some View {
        NavigationStack{
            VStack {
                if let view{
                    view
                }
//                CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), selectedDate: $currentDate, allRecordsCopy: $recordCopyClass.allRecords)
                RecordsListView(currentDate: $currentDate)
            }
        }.onChange(of: allRecords){
            recordCopyClass.allRecords = allRecords
            do{
                try modelContext.save()
            }catch{
                print("cannot save")
            }
            if let view{
                print("reload")
                view.updateView()
            }
        }.onAppear(){
            recordCopyClass.allRecords = allRecords
            view = CalendarView(interval: DateInterval(start: .distantPast, end: .distantFuture), selectedDate: $currentDate, recordCopyClass: $recordCopyClass)
            print(modelContext.sqliteCommand)
        }
    }
}

#Preview {
    CalendarScreen().modelContainer(for: CalendarDate.self)
}

// To solve the reload issue, create a state variable array of the month's data
// send in this state variable as binding to CalendarView
