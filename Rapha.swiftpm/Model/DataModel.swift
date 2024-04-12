//
//  DataModel.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class CalendarDate{
    var symptoms: Symptoms?
    var medication: Medication?
    var labResults: LabResults?
    var symptomsFilled: Bool{
        guard symptoms != nil else {
            return false
        }
        return true
    }
    var medFilled: Bool{
        guard medication != nil else {
            return false
        }
        return true
    }
    var labResultsFilled: Bool{
        guard labResults != nil else {
            return false
        }
        return true
    }
    
    init(){}
}

@available(iOS 17, *)
@Model
class Symptoms{
    var date: Date
    var painAreas: [PainArea]?
    var qnsBASDAI: [String : Float] = ["Q1": 0,
                     "Q2": 0,
                     "Q3": 0,
                     "Q4": 0,
                     "Q5": 0,
                     "Q6": 0]
    var numPainAreas: Int{
        if let pins = painAreas{
            return pins.count
        }else{
            return 0
        }
    }
    var scoreBASDAI: Float{
        var sumOneToFour: Float = (qnsBASDAI["Q1"] ?? 0) + (qnsBASDAI["Q2"] ?? 0) + (qnsBASDAI["Q3"] ?? 0) + (qnsBASDAI["Q4"] ?? 0)
        var sumFiveAndSix: Float = (qnsBASDAI["Q5"] ?? 0) + (qnsBASDAI["Q6"] ?? 0)
         return (sumOneToFour + sumFiveAndSix / 2) / 5
    }
    var notes: String?
    init(){}
}

@available(iOS 17, *)
@Model
class Medication{
    var date: Date
    var amgevitaTaken = false
    var notes: String?
    init(){}
}

@available(iOS 17, *)
@Model
class LabResults{
    var date: Date
    var inflammation: [String: Float] = ["ESR": 0,
                                         "CRP": 0]
    init(){}
}


class PainArea{
    var coordinates: CGPoint = CGPoint(x: 0, y: 0)
    var notes: String = ""
}
