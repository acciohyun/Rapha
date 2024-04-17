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
        let symptomRecordType = RecordType.symptoms
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
                                if let symptoms = currentCalendarData?.symptoms{
                                    Text("symptoms: ")
                                }
                            default:
                                Text("no data")
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: currentDate){ oldValue, newValue in
            currentCalendarData = allRecords.filter({ $0.date.startOfDay == newValue.startOfDay}).first
            print("onchange: \(currentDate)")
            print("data: \(currentCalendarData)")
            if let currentCalendarData{
                
            }else{
                currentCalendarData = CalendarDate(date: currentDate)
            }
            symptomsData = currentCalendarData?.symptoms
        }
        .navigationDestination(for: RecordType.self){ record in
            switch record{
            case .symptoms:
                RecordSymptomsScreen(currentDate: currentDate)
            default:
                RecordSymptomsScreen(currentDate: currentDate)
            }
        }
    }
}
