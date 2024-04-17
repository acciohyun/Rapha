//
//  RecordSymptomsScreen.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI
import SwiftData

struct RecordSymptomsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State var currentCalendarData: CalendarDate?
    @Query var allRecords: [CalendarDate]
    var currentDate: Date
    
    var body: some View {
        Text("Current date:  \(currentDate)")
        List {
            if let symptoms = currentCalendarData?.symptoms{
                Section {
                    VStack(alignment: .leading){
                        PainAreasView(currentDate: currentDate)
                    }
                } header: {
                    HStack {
                        Text("Pain areas")
                        Spacer()
                        Text("2")
                    }
                }
                Section {
                    ChooseBASDAIView(currentDate: currentDate)
                } header: {
                    HStack {
                        Text("BASDAI")
                        Spacer()
                        Text("2")
                    }
                }
                Section{
                    //textinput
                }header:{
                    Text("Notes:")
                }
            }
            
        }.onAppear(){
            currentCalendarData = allRecords.filter({ $0.date.startOfDay == currentDate.startOfDay}).first
            if let existingData = currentCalendarData{}else{
                currentCalendarData = CalendarDate(date: currentDate)
                modelContext.container.mainContext.insert(currentCalendarData!)
                do {
                    try modelContext.save()
                }catch{
                    print("not saved: error")
                }
                print("\(allRecords)")
            }
            if let symptoms = currentCalendarData?.symptoms{}else{
                print("created symptoms")
                currentCalendarData?.symptoms = Symptoms(date: currentCalendarData!)
            }
        }
        .navigationTitle("Symptoms")
//        Button("Save"){
//            try? modelContext.save()
//        }
    }
}

//#Preview {
//    RecordSymptomsScreen().environmentObject(MetaData())
//}
