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
                RecordsListView(currentDate: $currentDate)
            }
        }.onChange(of: allRecords){
            recordCopyClass.allRecords = allRecords
            do{
                try modelContext.save()
            }catch{
                print("Error: Cannot save")
            }
            if let view{
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

