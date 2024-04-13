//
//  DateExtensions.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation

extension Date{
    var startOfDay: Date{
        Calendar.current.startOfDay(for:self)
    }
}
