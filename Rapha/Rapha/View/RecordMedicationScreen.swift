//
//  RecordMedicationView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/17/24.
//

import SwiftUI
import SwiftData

struct RecordMedicationScreen: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var currentCalendarData: CalendarDate?
    @Query var allRecords: [CalendarDate]
    var currentDate: Date
    @State var medsTaken = false
    
    var body: some View {
        Text("Current date:  \(currentDate)")
        List {
            if (currentCalendarData?.medication) != nil{
                HStack{
                    Text("Amgevita")
                    Toggle(isOn: $medsTaken){
                        
                    }
                }
            }
            
        }.onAppear(){
            currentCalendarData = allRecords.filter({ $0.date.startOfDay == currentDate.startOfDay}).first
            if currentCalendarData != nil{}else{
                currentCalendarData = CalendarDate(date: currentDate)
                modelContext.container.mainContext.insert(currentCalendarData!)
                do {
                    try modelContext.save()
                }catch{
                    print("not saved: error")
                }
                print("\(allRecords)")
            }
            if (currentCalendarData?.medication) != nil{}else{
                print("created medication")
                currentCalendarData?.medication = Medication(date: currentCalendarData!)
            }
            medsTaken = currentCalendarData?.medication?.amgevitaTaken ?? false
        }
        .onChange(of: medsTaken){
            if let meds = currentCalendarData?.medication{
                meds.amgevitaTaken = medsTaken
            }
        }
        .toolbar{
            Button{
                if let data = currentCalendarData?.medication{
                    currentCalendarData?.medication = nil
                    dismiss()
                }
            } label:{
                Image(systemName: "trash")
            }
        }
        .navigationTitle("Medication")
//        Button("Save"){
//            try? modelContext.save()
//        }
    }
}
//
//#Preview {
//    RecordMedicationView()
//}

