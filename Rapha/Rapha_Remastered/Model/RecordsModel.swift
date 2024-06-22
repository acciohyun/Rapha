//
//  RecordsModel.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI
import SwiftData



class RecordsModel: ObservableObject{
    @Environment(\.modelContext) var modelContext
    @Query var allRecords: [CalendarDate]
    
    var records: [CalendarDate]{
        return allRecords
    }
}

enum IndivQnsBASDAIEnum: Int, CaseIterable {
    case q1 = 0
    case q2
    case q3
    case q4
    case q5
    case q6
    
    var mainQns: String {
        switch self{
        case .q1:
            "Level of fatigue"
        case .q2:
            "Level of AS pain"
        case .q3:
            "Other level of pain/swelling"
        case .q4:
            "Level of discomfort"
        case .q5:
            "Level of morning stiffness"
        case .q6:
            "Duration of morning stiffness"
        }
    }
    
    var subQns: String {
        switch self{
        case .q1:
            "Tiredness"
        case .q2:
            "AS neck, back, or hip pain"
        case .q3:
            "In joints other than neck, back, and hips"
        case .q4:
            "Discomfort from area tender to touch"
        case .q5:
            "From the time you wake up"
        case .q6:
            "5 is one hour, 10 is two or more hours"
        }
    }
}
