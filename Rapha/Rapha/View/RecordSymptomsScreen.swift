//
//  RecordSymptomsScreen.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI


struct RecordSymptomsScreen: View {
    @EnvironmentObject var metaData: MetaData
    @Environment(\.modelContext) private var modelContext
    //    @Query private var thisMonthRecords: [CalendarDate]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                Text("\(metaData.chosenDate)")
                HStack {
                    Text("Pain areas")
                    Spacer()
                    Text("2")
                }
                PainAreasView()
                HStack {
                    Text("BASDAI")
                    Spacer()
                    Text("2")
                }
            }.navigationTitle("Symptoms")
        }
    }
}

#Preview {
    RecordSymptomsScreen().environmentObject(MetaData())
}
