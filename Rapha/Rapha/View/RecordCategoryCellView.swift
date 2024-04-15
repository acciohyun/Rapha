//
//  RecordCategoryCellView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftUI

struct RecordCategoryCellView: View {
    @EnvironmentObject var dummyData: DummyData
    @EnvironmentObject var metaData: MetaData
    @State var recordCategory: CategoryOfRecord
    
    var body: some View {
        NavigationLink(value: recordCategory.name){
            HStack{
                Image(systemName: "circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                VStack(alignment: .leading){
                    Text(recordCategory.name)
                    if let subtitle = recordCategory.moreInfo{
                        Text(subtitle)
                    }
                }
            }
        }.navigationDestination(for: String.self){ record in
            switch record{
            case "Symptoms":
                RecordSymptomsScreen().environmentObject(metaData)
            default:
                RecordSymptomsScreen().environmentObject(metaData)
            }
        }
    }
}
