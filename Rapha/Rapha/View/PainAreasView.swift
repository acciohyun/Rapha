//
//  PainAreasView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI
import SwiftData

struct PainAreasView: View {
    @State var symptomData: Symptoms?
    @Environment(\.modelContext) private var modelContext
    @Query var allRecords: [CalendarDate]
    var currentDate: Date
    
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
            }
            if let painAreas = symptomData?.painAreas{
                ForEach(painAreas){ painPoint in
                    Circle()
                        .scaledToFit()
                        .frame(width: 15)
                        .foregroundColor(.red)
                        .position(x:CGFloat(painPoint.coordinateX + 65), y: CGFloat(painPoint.coordinateY))
                }
            }
        }.onAppear(){
            symptomData = allRecords.filter({ $0.date.startOfDay == currentDate.startOfDay}).first?.symptoms
            if let painAreas = symptomData?.painAreas{
                print("svaed count: \(painAreas.count)")
            }
            print("todays: records\(allRecords)")
        }
        .aspectRatio(2.68, contentMode: .fit)
    }
    
    func addPoint(at location: CGPoint){
        if symptomData?.painAreas != nil {
            print("added")
            symptomData!.painAreas?.append(PainArea(x: Float(location.x), y: Float(location.y)))
        }else{
            symptomData!.painAreas = [PainArea(x: Float(location.x), y: Float(location.y))]
        }
        do {
            print("saved")
            try modelContext.save()
        }catch{
            print("not saved: error")
        }
        print("\(symptomData!.painAreas!.count)")
    }
}

//#Preview {
//    RecordSymptomsScreen().environmentObject(MetaData())
//}
