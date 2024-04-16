//
//  RecordSymptomsScreen.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI
import SwiftData

struct RecordSymptomsScreen: View {
    @EnvironmentObject var metaData: MetaData
    @Environment(\.modelContext) private var modelContext
    @Bindable var symptomData: Symptoms
    
    var body: some View {
        Text("\(metaData.chosenDate)")
        List {
            Section {
                VStack(alignment: .leading){
                    PainAreasView(symptomData: symptomData)
                }
            } header: {
                HStack {
                    Text("Pain areas")
                    Spacer()
                    Text("2")
                }
            }
            Section {
                ChooseBASDAIView(symptomData: symptomData)
            } header: {
                HStack {
                    Text("BASDAI")
                    Spacer()
                    Text("2")
                }
            }
            Section{
                //textinput
            }header:{
                Text("Notes:")
            }
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
               Text("Button")
            })
        }
        .navigationTitle("Symptoms")
    }
}

//#Preview {
//    RecordSymptomsScreen().environmentObject(MetaData())
//}
