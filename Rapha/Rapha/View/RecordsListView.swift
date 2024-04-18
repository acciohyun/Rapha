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
        var id: Self{
            return self
        }
        case symptoms = "Symptoms"
        case medication = "Medication"
        case labResults = "Lab Results"
    }
    
    var body: some View {
        
        List{
            ForEach(RecordType.allCases){ record in
                NavigationLink(value: record){
                    HStack{
                        Image(systemName: "circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10)
                        VStack(alignment: .leading){
                            Text(record.rawValue)
                            switch record{
                            case .symptoms:
                                if (currentCalendarData?.symptoms) != nil{
                                    Text("symptoms: ")
                                }
                            case .medication:
                                if (currentCalendarData?.medication) != nil{
                                    Text("medication: ")
                                }
                            case .labResults:
                                if (currentCalendarData?.labResults) != nil{
                                    Text("results: ")
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: currentDate){
            updateView()
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
                RecordLabResultsView(currentDate: currentDate)
            }
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
