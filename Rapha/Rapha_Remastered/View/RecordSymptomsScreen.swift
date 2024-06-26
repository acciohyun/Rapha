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
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var currentCalendarData: CalendarDate?
    @Query var allRecords: [CalendarDate]
    @State var notes: String = ""
    @State var showingAlert = false
    
    var currentDate: Date
    var calculatedBASDAI: String{
        var formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        if let qnsAns = currentCalendarData?.symptoms?.qnsBASDAI{
            let sumOneToFour: Float = (qnsAns[0] ?? 0) + (qnsAns[1] ?? 0) + (qnsAns[2] ?? 0) + (qnsAns[3] ?? 0)
            let sumFiveAndSix: Float = (qnsAns[4] ?? 0) + (qnsAns[5] ?? 0)
            let result = (sumOneToFour + sumFiveAndSix / 2) / 5
            if let resultStr = formatter.string(for: result){
                return resultStr
            }else{
                return "0"
            }
        }
        return "0"
    }
    
    var body: some View {
        Text("\(currentDate.simplifiedDate)")
        List {
            if let symptoms = currentCalendarData?.symptoms{
                Section {
                    VStack(alignment: .leading){
                        PainAreasView(currentDate: currentDate)
                    }
                } header: {
                    HStack {
                        VStack(alignment: .leading){
                            Text("Pain areas")
                                .foregroundStyle(.sectionTitle)
                                .fontWeight(.semibold)
                                .font(.system(size: 20))
                                .textCase(nil)
                            Text("Click to indicate your areas of discomfort")
                                .textCase(nil)
                        }.offset(x: -15)
                        Spacer()
                        ZStack{
                            Circle()
                                .scaledToFit()
                                .frame(width: 37)
                                .foregroundColor(.accent)
                            Text("\(symptoms.painAreas?.count ?? 0)")
                                .foregroundStyle(.white)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }.offset(x: 15)
                    }
                    
                }.listRowBackground(Color.painBackground)
                Section {
                    ChooseBASDAIView(currentDate: currentDate)
                } header: {
                    HStack {
                        Text("BASDAI")
                            .foregroundStyle(.sectionTitle)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .offset(x: -15)
                        Spacer()
                        ZStack{
                            Circle()
                                .scaledToFit()
                                .frame(width: 37)
                                .foregroundColor(.accent)
                            Text("\(calculatedBASDAI)")
                                .foregroundStyle(.white)
                                .font(.system(size: 16))
                                .fontWeight(.bold)
                        }.offset(x: 15)
                    }
                }
                Section{
                    TextField("Enter any notes", text: $notes, axis: .vertical).lineLimit(5...10)
                }header:{
                    Text("Notes")
                        .foregroundStyle(.sectionTitle)
                        .fontWeight(.semibold)
                        .textCase(nil)
                        .font(.system(size: 20))
                        .offset(x: -15)
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
            }
            if let symptoms = currentCalendarData?.symptoms{}else{
                currentCalendarData?.symptoms = Symptoms(date: currentCalendarData!)
            }
            notes = currentCalendarData?.symptoms?.notes ?? ""
        }
        .onChange(of: notes){
            if currentCalendarData?.symptoms != nil{
                currentCalendarData?.symptoms?.notes = notes
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
                if let data = currentCalendarData?.symptoms{
                    currentCalendarData?.symptoms = nil
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Once you delete this record, it cannot be retrieved again.")
        }
        .navigationTitle("Symptoms")
    }
}

