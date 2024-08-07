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
    
    private var imageColor: Color {
        if let _ = record.symptoms {
            return .symptoms
        } else if let _ = record.medication {
            return .medication
        }
        return .labResult
    }
    
    var body: some View {
        HStack(spacing: 3){
            if record.symptoms != nil{
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7)
                    .foregroundColor(.symptoms)
            }
            if record.medication != nil{
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7)
                    .foregroundColor(.medication)
            }
            if record.labResults != nil{
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
