//
//  PainAreasView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI

struct PainAreasView: View {
    //    @EnvironmentObject var metaData: MetaData
    //    @Environment(\.modelContext) private var modelContext
    //    @Query private var thisMonthRecords: [CalendarDate]
    @State var painAreas = [PainArea]()
    //    @State var painAreas = [PainArea(x: 25, y: 200)]
    @State var demo: PainArea?
    
    var body: some View {
        ZStack(alignment: .center){
            Color.clear
            HStack {
                Image("Skeleton")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 500)
            }.onTapGesture{ location in
                print("Tapped at \(location)")
                addPoint(at: location)
                print(painAreas)
            }
            ForEach(painAreas){ painPoint in
                Circle()
                    .scaledToFit()
                    .frame(width: 15)
                    .foregroundColor(.red)
                    .position(x:CGFloat(painPoint.coordinateX + 105), y: CGFloat(painPoint.coordinateY))
            }
        }
        .aspectRatio(2.68, contentMode: .fit)
    }
    
    func addPoint(at location: CGPoint){
        painAreas.append(PainArea(x: Float(location.x), y: Float(location.y)))
    }
}

#Preview {
    RecordSymptomsScreen().environmentObject(MetaData())
}
