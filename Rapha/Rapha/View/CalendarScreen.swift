//
//  CalendarScreen.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CalendarScreen: View {
    @EnvironmentObject var dummyData: DummyData
    @EnvironmentObject var metaData: MetaData
    var body: some View {
        NavigationStack{
            VStack {
                CalendarViewModel(interval: DateInterval(start: .distantPast, end: .distantFuture), dummyData: dummyData, metaData: metaData)
                List(metaData.categoriesOfRecords){ recordCategory in
                    RecordCategoryCellView(recordCategory: recordCategory).environmentObject(dummyData).environmentObject(metaData)
                }
            }
        }
    }
}

#Preview {
    CalendarScreen().environmentObject(DummyData()).environmentObject(MetaData())
    //        .modelContainer(for: Item.self, inMemory: true)
}
