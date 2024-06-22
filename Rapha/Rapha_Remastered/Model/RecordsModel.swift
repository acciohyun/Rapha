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
    
    func calculatedBASDAI(qnsBASDAI: [String : Float] ) -> Float{
        let sumOneToFour: Float = (qnsBASDAI["Q1"] ?? 0) + (qnsBASDAI["Q2"] ?? 0) + (qnsBASDAI["Q3"] ?? 0) + (qnsBASDAI["Q4"] ?? 0)
        let sumFiveAndSix: Float = (qnsBASDAI["Q5"] ?? 0) + (qnsBASDAI["Q6"] ?? 0)
//        var sum: Float = 0
//        for i in 1...6 {
//            if let value = qnsBASDAI["Q\(i)"] {
//                sum += value
//            }
//        }
//        return sum / 5
        return (sumOneToFour + sumFiveAndSix / 2) / 5
    }
    
    let qnsCollection = [IndivQnsBASDAI(qnsNum: 0, mainQns: "Level of fatigue", subQns: "Tiredness"),
                         IndivQnsBASDAI(qnsNum: 1, mainQns: "Level of AS pain", subQns: "AS neck, back, or hip pain"),
                         IndivQnsBASDAI(qnsNum: 2, mainQns: "Other level of pain/swelling", subQns: "In joints other than neck, back, and hips"),
                         IndivQnsBASDAI(qnsNum: 3, mainQns: "Level of discomfort", subQns: "Discomfort from area tender to touch"),
                         IndivQnsBASDAI(qnsNum: 4, mainQns: "Level of morning stiffness", subQns: "From the time you wake up"),
                         IndivQnsBASDAI(qnsNum: 5, mainQns: "Duration of morning stiffness", subQns: "5 is one hour, 10 is two or more hours")]
    
    var records: [CalendarDate]{
        print("observed: \(allRecords)")
        return allRecords
    }
}

enum IndivQnsBASDAIEnum: Int, CaseIterable {
    case q1 = 1
    case q2
    case q3
    case q4
    case q5
    case q6
    
    var mainQns: String {
//        switch self {
//            "qn"
//        }
        return ""
    }
    
    var subQns: String {
//        switch self {
//            "subQns"
//        }
        return ""
    }
}

struct IndivQnsBASDAI: Identifiable, Hashable{
    var id: Int
    var mainQns: String
    var subQns: String
    
    init(qnsNum: Int, mainQns: String, subQns: String){
        self.id = qnsNum
        self.mainQns = mainQns
        self.subQns = subQns
    }
    
}
