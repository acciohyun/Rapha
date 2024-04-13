//
//  CalendarView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CalendarViewModel: UIViewRepresentable{
    let interval: DateInterval //how far in the past and future
//    @ObservedObject var dummyData: DummyData
    @ObservedObject var metaData: MetaData
    @Environment(\.modelContext) private var modelContext
    @Query private var recordsSaved: [CalendarDate]
//    @Query var chosenRecord: [CalendarDate]
    
    func makeUIView(context: Context) -> some UIView {
        let view = UICalendarView()
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        view.selectionBehavior = dateSelection
        dateSelection.selectedDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        return view
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, metaData: _metaData, recordsSaved: recordsSaved)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
        
        //this is the CalendarViewDelegate
        var parent: CalendarViewModel
        @ObservedObject var metaData: MetaData
        @State var recordsSaved: [CalendarDate]
        private var filteredRecords: [CalendarDate]?
        
        init(parent: CalendarViewModel, metaData: ObservedObject<MetaData>, recordsSaved: [CalendarDate]) {
            self.parent = parent
            self._metaData = metaData
            self.recordsSaved = recordsSaved
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {

            let record = recordsSaved.filter{$0.date.startOfDay == dateComponents.date?.startOfDay}
            if record.isEmpty{return nil}
            return .image(UIImage(systemName: "star"), color: .red)
        }
        
        
        func calendarView(_ calendarView: UICalendarView, didChangeVisibleDateComponentsFrom previousDateComponents: DateComponents) {
            print("change")
            print(previousDateComponents)
        }
        
        @MainActor
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let selectedDate = dateComponents?.date?.startOfDay{
                print("\(selectedDate)")
                metaData.chosenDate = selectedDate
                //change the metadata for symptoms and etc
                do{
                    filteredRecords = try recordsSaved.filter(#Predicate {$0.date.startOfDay == selectedDate})
                }catch{
                    print("Error in seeking record: \(error)")
                    return
                }
                if filteredRecords!.count > 0{
                    print("here")
                    if let chosenRecord = filteredRecords?[0]{
                        if let symptomsRecord = chosenRecord.symptoms{
                            
                        }
                        if let medicineRecord = chosenRecord.medication{
                            var medicineDataShown = metaData.categoriesOfRecords[1]
                            if medicineRecord.amgevitaTaken{
                                medicineDataShown.moreInfo = "Amgevita Taken"
                                medicineDataShown.exists = true
                            }
                        }
                        if let labResultRecord = chosenRecord.labResults{
                            
                        }
                    }
                }else{
                    for category in metaData.categoriesOfRecords{
                        category.exists = false
                        category.moreInfo = nil
                    }
                }
            }
        }
        
    }
}
