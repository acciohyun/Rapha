//
//  RecordLabResultsView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/17/24.
//

import SwiftUI
import SwiftData

struct RecordLabResultsScreen: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var currentCalendarData: CalendarDate?
    @Query var allRecords: [CalendarDate]
    var currentDate: Date
    @State var ESR: String = "0"
    @State var CRP: String = "0"
    @State var showingAlert = false
    
    var body: some View {
        Text("\(currentDate.simplifiedDate)")
        List {
            if (currentCalendarData?.labResults) != nil{
                Section{
                    HStack{
                        Text("ESR")
                        Spacer()
                        TextField("ESR", text: $ESR)
                            .keyboardType(.decimalPad)
                    }
                    HStack{
                        Text("CRP")
                        Spacer()
                        TextField("CRP", text: $CRP)
                            .keyboardType(.decimalPad)
                    }
                } header:{
                    Text("Inflammation")
                        .foregroundStyle(.sectionTitle)
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                        .textCase(nil)
                        .offset(x: -15)
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
                    print("Error: Unable to save")
                }
            }
            if (currentCalendarData?.labResults) == nil {
                currentCalendarData?.labResults = LabResults(date: currentCalendarData!)
            }
            if let orgValue = currentCalendarData?.labResults?.inflammation{
                ESR = orgValue["ESR"]!
                CRP = orgValue["CRP"]!
            }
        }
        .onChange(of: ESR){
            if let results = currentCalendarData?.labResults{
                results.inflammation["ESR"] = ESR
            }
        }
        .onChange(of: CRP){
            if let results = currentCalendarData?.labResults{
                results.inflammation["CRP"] = CRP
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
                if let data = currentCalendarData?.labResults{
                    currentCalendarData?.labResults = nil
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Once you delete this record, it cannot be retrieved again.")
        }
        .navigationTitle("Lab Results")
    }
}
