//
//  DataModel.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftData

@Model
class CalendarDate: ObservableObject{
  
    @Attribute(.unique) var date: Date
    var symptoms: Symptoms?
    var medication: Medication?
    var labResults: LabResults?
    
    @Relationship(deleteRule: .cascade, inverse: \Symptoms.date)
    @Relationship(deleteRule: .cascade, inverse: \Medication.date)
    @Relationship(deleteRule: .cascade, inverse: \LabResults.date)
    
//    var symptomsFilled: Bool{
//        guard symptoms != nil else {
//            return false
//        }
//        return true
//    }
//    var medFilled: Bool{
//        guard medication != nil else {
//            return false
//        }
//        return true
//    }
//    var labResultsFilled: Bool{
//        guard labResults != nil else {
//            return false
//        }
//        return true
//    }
    
    init(date: Date){
        self.date = date
    }
}

@Model
class Symptoms{
    var date: CalendarDate
    var painAreas: [PainArea]?
    var qnsBASDAI: [String : Float] = ["Q1": 0,
                     "Q2": 0,
                     "Q3": 0,
                     "Q4": 0,
                     "Q5": 0,
                     "Q6": 0]
//    var numPainAreas: Int{
//        if let pins = painAreas{
//            return pins.count
//        }else{
//            return 0
//        }
//    }
//    var scoreBASDAI: Float{
//        let sumOneToFour: Float = (qnsBASDAI["Q1"] ?? 0) + (qnsBASDAI["Q2"] ?? 0) + (qnsBASDAI["Q3"] ?? 0) + (qnsBASDAI["Q4"] ?? 0)
//        let sumFiveAndSix: Float = (qnsBASDAI["Q5"] ?? 0) + (qnsBASDAI["Q6"] ?? 0)
//         return (sumOneToFour + sumFiveAndSix / 2) / 5
//    }
    var notes: String?
    init(date: CalendarDate){
        self.date = date
    }
}

@Model
class Medication{
    var date: CalendarDate
    var amgevitaTaken = false
    var notes: String?
    init(date: CalendarDate){
        self.date = date
    }
}

@Model
class LabResults{
    var date: CalendarDate
    var inflammation: [String: Float] = ["ESR": 0,
                                         "CRP": 0]
    init(date: CalendarDate){
        self.date = date
    }
}

@Model
class PainArea{
    var coordinateX: Float = 0
    var coordinateY: Float = 0
    var notes: String = ""
    init(){}
}

class DummyData: ObservableObject{
    @Published var allRecords = [CalendarDate(date: Date(timeIntervalSince1970: TimeInterval(1712926540))),
                                 CalendarDate(date: Date(timeIntervalSince1970: TimeInterval(1712667376)))]
}

struct CategoryOfRecord: Identifiable{
    let name: String
    var id: String { name }
}

class MetaData: ObservableObject{
    @Published var chosenDate = Date().startOfDay
    @Published var categoriesOfRecords = [CategoryOfRecord(name: "Symptoms"), CategoryOfRecord(name: "Medicine"), CategoryOfRecord(name: "Lab Results")]
}
