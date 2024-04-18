//
//  ChooseBASDAIView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/15/24.
//

import Foundation
import SwiftUI
import SwiftData

struct ChooseBASDAIView: View {
    @State var symptomData: Symptoms?
    @Environment(\.modelContext) var modelContext
    @Query var allRecords: [CalendarDate]
    let record = RecordsModel()
    var currentDate: Date
    @State var ans = [Int](repeating: 0, count: 10)
    
    
    var body: some View {
        ForEach(record.qnsCollection){qns in
            HStack(){
                VStack(alignment: .leading){
                    Text(qns.mainQns)
                    Text(qns.subQns)
                        .foregroundStyle(.subtitle)
                        .font(.system(size: 15))
                }.frame()
                Spacer()
                Picker("", selection: $ans[qns.id]) {
                    ForEach(0..<11, id: \.self) { i in
                        Text("\(i)").tag(Optional(Float(i)))
                    }
                }.id(qns.id).frame(width: 50)
                
                
            }
        }.onAppear(){
            symptomData = allRecords.filter({ $0.date.startOfDay == currentDate.startOfDay}).first?.symptoms
            for i in 0..<ans.count{
                ans[i] = Int(symptomData?.qnsBASDAI[i] ?? 0)
            }
        }
        .onChange(of: ans){
            if let data = symptomData{
                for i in 0..<ans.count{
                    data.qnsBASDAI[i] = Float(ans[i])
                }
                symptomData?.qnsBASDAI = data.qnsBASDAI
            }
            do {
                print("saved")
                try modelContext.save()
            }catch{
                print("not saved: error")
            }
        }
    }
}
