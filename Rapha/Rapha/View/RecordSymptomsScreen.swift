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
                        Text("Pain areas")
                            .foregroundStyle(.sectionTitle)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .textCase(nil)
                            .offset(x: -15)
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
                }
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
                    print("Saved")
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
            notes = currentCalendarData?.symptoms?.notes ?? ""
        }
        .onChange(of: notes){
            if currentCalendarData?.symptoms != nil{
                currentCalendarData?.symptoms?.notes = notes
            }
        }
        .toolbar{
            Button{
                if let data = currentCalendarData?.symptoms{
                    currentCalendarData?.symptoms = nil
                    dismiss()
                }
            } label:{
                Image(systemName: "trash")
            }
        }
        .navigationTitle("Symptoms")
    }
//    mutating func calculatedBASDAI() -> Float{
//        if let qnsAns = currentCalendarData?.symptoms?.qnsBASDAI{
//            let sumOneToFour: Float = (qnsAns[0] ?? 0) + (qnsAns[1] ?? 0) + (qnsAns[2] ?? 0) + (qnsAns[3] ?? 0)
//            let sumFiveAndSix: Float = (qnsAns[4] ?? 0) + (qnsAns[5] ?? 0)
//            return (sumOneToFour + sumFiveAndSix / 2) / 5
//        }
//        return Float(0)
//    }
}

//#Preview {
//    RecordSymptomsScreen(currentDate: Date())
//}
