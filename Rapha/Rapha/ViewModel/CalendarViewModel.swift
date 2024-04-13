//
//  CalendarView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/12/24.
//

import Foundation
import SwiftUI

struct CalendarViewModel: UIViewRepresentable{
    let interval: DateInterval //how far in the past and future
    @ObservedObject var dummyData: DummyData
    @ObservedObject var metaData: MetaData
    func makeUIView(context: Context) -> some UIView {
        let view = UICalendarView()
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        print("dateSelection: \(dateSelection)")
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        view.selectionBehavior = dateSelection
        dateSelection.selectedDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        return view
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, dummyData: _dummyData, metaData: _metaData)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
        
        //this is the CalendarViewDelegate
        var parent: CalendarViewModel
        @ObservedObject var dummyData: DummyData
        @ObservedObject var metaData: MetaData
        init(parent: CalendarViewModel, dummyData: ObservedObject<DummyData>, metaData: ObservedObject<MetaData>) {
            self.parent = parent
            self._dummyData = dummyData
            self._metaData = metaData
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            //what we use to create icons or decorations
            let record = dummyData.allRecords.filter{$0.date.startOfDay == dateComponents.date?.startOfDay}
            if record.isEmpty{return nil}
            return .image(UIImage(systemName: "star"), color: .red)            //filter items to find the same date as the datecomponent
            // based on items, return a view (if the records exist, show this)
        }
        
        @MainActor
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            // action when date is selected
            print("\(dateComponents?.date?.startOfDay ?? Date())")
            metaData.chosenDate = dateComponents?.date?.startOfDay ?? Date()
        }
        
    }
}
