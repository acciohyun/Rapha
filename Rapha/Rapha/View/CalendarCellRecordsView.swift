//
//  CalendarCellRecordsView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI

struct CalendarCellRecordsView: View {
    let record: CalendarDate
    var body: some View {
        HStack(spacing: 3){
            if let symptoms = record.symptoms{
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7)
                    .foregroundColor(.symptoms)
            }
            if let medication = record.medication{
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7)
                    .foregroundColor(.medication)
            }
            if let labResults = record.labResults{
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7)
                    .foregroundColor(.labResult)
            }
        }.onAppear(){
            if let symptoms = record.symptoms{
                print(symptoms)
            }
            if let labResults = record.labResults{
                print(labResults)
            }
        }
    }
}
