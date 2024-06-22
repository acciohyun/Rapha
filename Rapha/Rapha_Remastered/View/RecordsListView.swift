//
//  RecordCategoryCellView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftUI
import SwiftData

struct RecordsListView: View {
    @Query var allRecords: [CalendarDate]
    @State var thisDateRecord: CalendarDate?
    @State var symptomsData: Symptoms?
    @State var medicationData: Medication?
    @State var labResultsData: LabResults?

    @State var currentCalendarData: CalendarDate?
    @Binding var currentDate: Date
    private enum RecordType: String, Hashable, CaseIterable, Identifiable{
        var id: String{
            return self.rawValue
        }
        case symptoms = "Symptoms"
        case medication = "Medication"
        case labResults = "Lab Results"
    }
    
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
                return "0" // "Err"
            }
        }
        return "0" //"Err" for debugging purposes
    }
    
    var body: some View {
        
        List{
            ForEach(RecordType.allCases){ record in
                NavigationLink(value: record){
                    HStack{
                        switch record{
                        case .symptoms:
                            symptomsView(record)
                        case .medication:
                            Image(systemName: currentCalendarData?.medication == nil ? "circle" : "circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10)
                                .foregroundColor(.medication)
                            VStack(alignment: .leading){
                                Text(record.rawValue)
                                if let meds = currentCalendarData?.medication{
                                    Text(meds.amgevitaTaken ? "Amgevita taken" : "Amgevita not taken")
                                        .foregroundStyle(.subtitle)
                                        .font(.system(size: 15))
                                }
                            }.padding(.leading, 7)
                        case .labResults:
                            Image(systemName: currentCalendarData?.labResults == nil ? "circle" : "circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10)
                                .foregroundColor(.labResult)
                            VStack(alignment: .leading){
                                Text(record.rawValue)
                                if let lab = currentCalendarData?.labResults{
                                    Text("ESR: \(lab.inflammation["ESR"] ?? "0"), CRP: \(lab.inflammation["CRP"] ?? "0")")
                                        .foregroundStyle(.subtitle)
                                        .font(.system(size: 15))
                                }
                            }.padding(.leading, 7)
                        }
                    }
                }
            }
        }
        .onChange(of: currentDate){
            updateView() //unclear: updateCurrentCalendarData
        }.onAppear(){
            updateView()
        }
        .navigationDestination(for: RecordType.self){ record in
            switch record{
            case .symptoms:
                RecordSymptomsScreen(currentDate: currentDate)
            case .medication:
                RecordMedicationScreen(currentDate: currentDate)
            case .labResults:
                RecordLabResultsScreen(currentDate: currentDate)
            }
        }
    }
    
//    @ViewBuilder
//    var symptomsView: some View {
//        Image(systemName: currentCalendarData?.symptoms == nil ? "circle" : "circle.fill")
//            .resizable()
//            .scaledToFit()
//            .frame(width: 10)
//            .foregroundColor(.symptoms)
//        VStack(alignment: .leading){
//            Text(record.rawValue)
//            if let symptoms = currentCalendarData?.symptoms{
//                Text("\(symptoms.painAreas?.count ?? 0) Pain areas, \(calculatedBASDAI) BASDAI")
//                    .foregroundStyle(.subtitle)
//                    .font(.system(size: 15))
//            }
//        }.padding(.leading, 7)
//    }
    
    private func symptomsView(_ record: RecordType) -> some View{
        HStack{
            Image(systemName: currentCalendarData?.symptoms == nil ? "circle" : "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10)
                .foregroundColor(.symptoms)
            VStack(alignment: .leading){
                Text(record.rawValue)
                if let symptoms = currentCalendarData?.symptoms{
                    Text("\(symptoms.painAreas?.count ?? 0) Pain areas, \(calculatedBASDAI) BASDAI")
                        .foregroundStyle(.subtitle)
                        .font(.system(size: 15))
                }
            }.padding(.leading, 7)
        }
    }
    
    func updateView(){
        currentCalendarData = allRecords.filter({ $0.date.startOfDay == currentDate.startOfDay}).first
        if currentCalendarData != nil{
        }else{
            currentCalendarData = CalendarDate(date: currentDate)
        }
        symptomsData = currentCalendarData?.symptoms
        medicationData = currentCalendarData?.medication
        labResultsData = currentCalendarData?.labResults
    }
}

#Preview {
    CalendarScreen().modelContainer(for: CalendarDate.self)
}
