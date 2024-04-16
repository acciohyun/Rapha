//
//  RecordCategoryCellView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftUI
import SwiftData

struct RecordCategoryCellView: View {
    @EnvironmentObject var dummyData: DummyData
    @EnvironmentObject var metaData: MetaData
    @State var recordCategory: CategoryOfRecord
    @Query var allRecords: [CalendarDate]
    @State var thisDateRecord: CalendarDate?
    @State var symptomsData: Symptoms?
    
    var body: some View {
        NavigationLink(value: recordCategory.name){
            HStack{
                Image(systemName: "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                VStack(alignment: .leading){
                    Text(recordCategory.name)
                    if let subtitle = recordCategory.moreInfo{
                        Text(subtitle)
                    }
                }
            }
        }.onAppear(){
            thisDateRecord = allRecords.filter({$0.date.startOfDay == metaData.chosenDate.startOfDay}).first
            if let thisDateRecord{
                if let symptoms = thisDateRecord.symptoms{
                    symptomsData = symptoms
                }else{
                    symptomsData = Symptoms(date: thisDateRecord)
                }
            }else{
                thisDateRecord = CalendarDate(date: metaData.chosenDate)
                symptomsData = Symptoms(date: thisDateRecord!)
            }
        }
        .navigationDestination(for: String.self){ record in
            switch record{
            case "Symptoms":
                RecordSymptomsScreen(symptomData: symptomsData!).environmentObject(metaData)
            default:
                RecordSymptomsScreen(symptomData: symptomsData!).environmentObject(metaData)
            }
        }
    }
}
