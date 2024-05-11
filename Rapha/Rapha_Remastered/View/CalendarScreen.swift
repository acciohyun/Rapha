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
//    @State var view: CalendarView?
    @State var recordCopyClass = RecordCopy()
    
    var body: some View {
        NavigationStack{
            VStack {
                CalendarView(interval: DateInterval(start: .distantPast, end: .now), selectedDate: $currentDate, recordCopyClass: $recordCopyClass)
                RecordsListView(currentDate: $currentDate)
            }
//            .toolbar{
//                Button("Today"){
////                    currentDate = Date()
//                }
//            }
        }.onChange(of: allRecords){
            recordCopyClass.allRecords = allRecords
            do{
                try modelContext.save()
            }catch{
                print("Error: Cannot save")
            }
        }.onAppear(){
            recordCopyClass.allRecords = allRecords
        }
    }
}

