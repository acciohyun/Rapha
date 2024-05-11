//
//  Item.swift
//  Rapha_Remastered
//
//  Created by Hyun Lee on 4/29/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
