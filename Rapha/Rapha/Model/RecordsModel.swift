//
//  RecordsModel.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI

struct RecordsModel{
    func calculatedBASDAI(qnsBASDAI: [String : Float] ) -> Float{
        let sumOneToFour: Float = (qnsBASDAI["Q1"] ?? 0) + (qnsBASDAI["Q2"] ?? 0) + (qnsBASDAI["Q3"] ?? 0) + (qnsBASDAI["Q4"] ?? 0)
        let sumFiveAndSix: Float = (qnsBASDAI["Q5"] ?? 0) + (qnsBASDAI["Q6"] ?? 0)
        return (sumOneToFour + sumFiveAndSix / 2) / 5
    }  
}
