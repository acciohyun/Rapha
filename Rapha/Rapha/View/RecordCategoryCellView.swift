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
        NavigationLink(destination: CalendarScreen()){
            HStack{
                Image(systemName: "circle")
                VStack{
                    Text(recordCategory.name)
                    if let subtitle = recordCategory.moreInfo{
                        Text(subtitle)
                    }
                }
            }
        }
    }
}
