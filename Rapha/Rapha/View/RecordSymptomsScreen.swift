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
    @EnvironmentObject var metaData: MetaData
    @Environment(\.modelContext) private var modelContext
//    @Bindable var symptomData: Symptoms
//    @Binding var currentCalendarData: CalendarDate
    @State var currentCalendarData: CalendarDate?
    @Query var allRecords: [CalendarDate]
    var currentDate: Date
    
    var body: some View {
//        Text("\(metaData.chosenDate)")
        Text("Current date:  \(currentDate)")
        List {
            Section {
                VStack(alignment: .leading){
//                    PainAreasView(symptomData: symptomData)
                }
            } header: {
                HStack {
                    Text("Pain areas")
                    Spacer()
                    Text("2")
                }
            }
            Section {
//                ChooseBASDAIView(symptomData: symptomData)
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
            
//            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//               Text("Button")
//            })
        }.onAppear(){
            currentCalendarData = allRecords.filter({ $0.date.startOfDay == currentDate.startOfDay}).first
            if let existingData = currentCalendarData{}else{
                currentCalendarData = CalendarDate(date: currentDate)
                modelContext.container.mainContext.insert(currentCalendarData!)
                print("\(allRecords)")
            }
            if let symptoms = currentCalendarData?.symptoms{}else{
                currentCalendarData?.symptoms = Symptoms(date: currentCalendarData!)
            }
        }
        .navigationTitle("Symptoms")
    }
}

//#Preview {
//    RecordSymptomsScreen().environmentObject(MetaData())
//}
