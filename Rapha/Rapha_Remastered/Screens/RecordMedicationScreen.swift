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
    @State var showingAlert = false
    
    var body: some View {
        Text("\(currentDate.simplifiedDate)")
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
            if currentCalendarData == nil{
                currentCalendarData = CalendarDate(date: currentDate)
                modelContext.container.mainContext.insert(currentCalendarData!)
                do {
                    try modelContext.save()
                }catch{
                    print("Error: Unable to save")
                }
                print("\(allRecords)")
            }
            if (currentCalendarData?.medication) == nil {
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
                showingAlert = true
            } label:{
                Image(systemName: "trash")
            }
        }
        .alert("Delete record", isPresented: $showingAlert) {
            Button("Delete", role: .destructive) {
                if currentCalendarData?.medication != nil {
                    currentCalendarData?.medication = nil
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Once you delete this record, it cannot be retrieved again.")
        }
        .navigationTitle("Medication")
    }
}

