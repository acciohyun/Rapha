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
    @Bindable var symptomData: Symptoms
    
    var body: some View {
        ForEach(record.qnsCollection){qns in
            HStack {
                VStack{
                    Text(qns.mainQns)
                    Text(qns.subQns)
                }
                //                    Picker(selection: <#T##Binding<Hashable>#>, content: <#T##() -> View#>, label: <#T##() -> View#>)
                Picker("", selection: $symptomData.qnsBASDAI[qns.id]) {
                    ForEach(0..<11, id: \.self) { i in
                        Text("\(i)").tag(Optional(Float(i)))
                    }
                }.id(qns.id)
            }
        }
    }
}

//#Preview {
////    RecordSymptomsScreen().environmentObject(MetaData())
////    ChooseBASDAIView()
//}
