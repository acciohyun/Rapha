//
//  DataModel.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftData

@Model
class CalendarDate{
    
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
    var qnsBASDAI: [Int : Float] = [0: 0,
                                    1: 0,
                                    2: 0,
                                    3: 0,
                                    4: 0,
                                    5: 0]
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
    var inflammation: [String: String] = ["ESR": "0",
                                         "CRP": "0"]
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


class CategoryOfRecord: Identifiable{
    let name: String
    @Published var exists: Bool = false
    @Published var moreInfo: String?
    var id: String { name }
    
    init(name: String){
        self.name = name
    }
}

class RecordCopy: ObservableObject{
    @Published var allRecords = [CalendarDate]()
}
