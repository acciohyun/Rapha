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

    init(date: Date){
        self.date = date
    }
}

@Model
class Symptoms{
    let type = "Symptoms"
    var date: CalendarDate
    var painAreas: [PainArea]?
    var qnsBASDAI: [String : Float] = ["Q1": 0,
                                       "Q2": 0,
                                       "Q3": 0,
                                       "Q4": 0,
                                       "Q5": 0,
                                       "Q6": 0]
    var notes: String?
    init(date: CalendarDate){
        self.date = date
    }
}

@Model
class Medication{
    let type = "Medication"
    var date: CalendarDate
    var amgevitaTaken = false
    var notes: String?
    init(date: CalendarDate){
        self.date = date
    }
}

@Model
class LabResults{
    let type = "Lab Results"
    var date: CalendarDate
    var inflammation: [String: Float] = ["ESR": 0,
                                         "CRP": 0]
    init(date: CalendarDate){
        self.date = date
    }
}

@Model
class PainArea: ObservableObject{
    var coordinateX: Float = 0
    var coordinateY: Float = 0
    var notes: String = ""
    init(x: Float, y: Float){
        self.coordinateX = x
        self.coordinateY = y
    }
}

class DummyData: ObservableObject{
    @Published var allRecords = [CalendarDate(date: Date(timeIntervalSince1970: TimeInterval(1712926540))),
                                 CalendarDate(date: Date(timeIntervalSince1970: TimeInterval(1712667376)))]
}

class CategoryOfRecord: Identifiable{
    let name: String
    @Published var exists: Bool = false
    @Published var moreInfo: String?
    var id: String { name }
    
    init(name: String){
        self.name = name
    }
}

@MainActor
class MetaData: ObservableObject{
    @Published var chosenDate = Date().startOfDay
    enum Categories: Int{
        case symptomsRecord
        case medicineRecord
        case labResultsRecord
    }
    @Published var categoriesOfRecords: [CategoryOfRecord] = [CategoryOfRecord(name: "Symptoms"),
                                                              CategoryOfRecord(name: "Medicine"),
                                                              CategoryOfRecord(name: "Lab Results")]
}
