//
//  CalendarView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CalendarView: UIViewRepresentable{
    let interval: DateInterval //how far in the past and future
    @Environment(\.modelContext) private var modelContext
    @Query var recordsSaved: [CalendarDate]
    @Binding var selectedDate: Date
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        view.selectionBehavior = dateSelection
        dateSelection.selectedDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        context.coordinator.dateSelection(dateSelection, didSelectDate: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: selectedDate))
        return view
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, savedRecords: Binding(get: {recordsSaved}, set: {_ in }), selectedDate: $selectedDate)
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        print("Update")
        print("A: \(recordsSaved.count)")
        uiView.reloadDecorations(forDateComponents: recordsSaved.map{Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: $0.date)}, animated: true)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
        
        //this is the CalendarViewDelegate
        var parent: CalendarView
        @Binding var savedRecords: [CalendarDate]
        private var filteredRecords: [CalendarDate]?
        let calculations = RecordsModel()
        @Binding var selectedDate: Date
        var computedRecords: [CalendarDate]{
            print("savedRecords: \(savedRecords.count)")
            return savedRecords
        }
        
        init(parent: CalendarView, savedRecords: Binding<[CalendarDate]>, selectedDate: Binding<Date>) {
            self.parent = parent
            self._savedRecords = savedRecords
            self._selectedDate = selectedDate
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let record = computedRecords.filter{$0.date.startOfDay == dateComponents.date?.startOfDay}
            print("B: \(computedRecords.count)")
            if record.isEmpty{return nil}
            print("item: \(record[0].date)")
            let renderer = ImageRenderer(content: CalendarCellRecordsView(record: record[0]))
            renderer.scale = 3
            if let uiImage = renderer.uiImage {
                return .image(uiImage)
            }
            return nil
        }
        
        
        func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
            print("change")
            print(previousDateComponents)
        }
        
        @MainActor
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            print("C: \(savedRecords.count)")
            print("C - computed records: \(savedRecords.count)")
            if let selectedDate = Calendar.current.date(from: dateComponents!)?.startOfDay{
                DispatchQueue.main.async{
                    self.selectedDate = selectedDate
                }
                do{
                    filteredRecords = try savedRecords.filter(#Predicate {$0.date.startOfDay == selectedDate})
                }catch{
                    print("Error in seeking record: \(error)")
                    return
                }
//                if filteredRecords!.count > 0{
//                    print("here")
//                    if let chosenRecord = filteredRecords?[0]{
//                        if let symptomsRecord = chosenRecord.symptoms{
//                            let symptomsDataShown = metaData.categoriesOfRecords[0]
//                            if let painAreas = symptomsRecord.painAreas{
//                                painAreas.count > 0 ? symptomsDataShown.moreInfo = "\(painAreas.count) Pain Areas, ": nil
//                            }
//                            let scoreBASDAI = calculations.calculatedBASDAI(qnsBASDAI: symptomsRecord.qnsBASDAI)
//                            if scoreBASDAI > 0{
//                                if symptomsDataShown.moreInfo != nil{
//                                    symptomsDataShown.moreInfo! += "\(scoreBASDAI) BASDAI score"
//                                }else{
//                                    symptomsDataShown.moreInfo = "\(scoreBASDAI) BASDAI score"
//                                }
//                            }
//                        }
//                        if let medicineRecord = chosenRecord.medication{
//                            let medicineDataShown = metaData.categoriesOfRecords[1]
//                            if medicineRecord.amgevitaTaken{
//                                medicineDataShown.moreInfo = "Amgevita Taken"
//                                medicineDataShown.exists = true
//                            }
//                        }
//                        if let labResultRecord = chosenRecord.labResults{
//                            let labDataShown = metaData.categoriesOfRecords[2]
//                            labDataShown.moreInfo = "ESR: \(labResultRecord.inflammation["ESR"] ?? 0), CRP: \(labResultRecord.inflammation["CRP"] ?? 0)"
//                        }
//                    }
//                }else{
//                    for category in metaData.categoriesOfRecords{
//                        category.exists = false
//                        category.moreInfo = nil
//                    }
//                }
            }
        }
        
    }
}
