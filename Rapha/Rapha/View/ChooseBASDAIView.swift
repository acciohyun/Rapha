//
//  ChooseBASDAIView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI

struct ChooseBASDAIView: View {
    @EnvironmentObject var metaData: MetaData
    @Environment(\.modelContext) var modelContext
    let record = RecordsModel()
//    @Query private var thisMonthRecords: [CalendarDate]
    var body: some View {
        Text("list here")
//        List(record.qnsBASDAI){_ in
//
//        }
    }
}

#Preview {
    RecordSymptomsScreen().environmentObject(MetaData())
}
