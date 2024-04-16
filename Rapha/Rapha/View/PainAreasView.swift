//
//  PainAreasView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI

struct PainAreasView: View {
    @Bindable var symptomData: Symptoms
    
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
                print("Tapped at \(symptomData.painAreas)")
            }
            if let painAreas = symptomData.painAreas{
                ForEach(painAreas){ painPoint in
                    Circle()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.red)
                        .position(x:CGFloat(painPoint.coordinateX + 65), y: CGFloat(painPoint.coordinateY))
                }
            }
        }
        .aspectRatio(2.68, contentMode: .fit)
    }
    
    func addPoint(at location: CGPoint){
        if symptomData.painAreas != nil {
            print("added")
            symptomData.painAreas?.append(PainArea(x: Float(location.x), y: Float(location.y)))
        }else{
            symptomData.painAreas = [PainArea(x: Float(location.x), y: Float(location.y))]
        }
    }
}

//#Preview {
//    RecordSymptomsScreen().environmentObject(MetaData())
//}
