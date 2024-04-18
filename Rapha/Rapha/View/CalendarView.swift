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
    @State var calendarView: UICalendarView?
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.calendarView = view
        }
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        view.selectionBehavior = dateSelection
        dateSelection.selectedDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
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
//            print("savedRecords: \(savedRecords.count)")
            return savedRecords
        }
        
        init(parent: CalendarView, savedRecords: Binding<[CalendarDate]>, selectedDate: Binding<Date>) {
            self.parent = parent
            self._savedRecords = savedRecords
            self._selectedDate = selectedDate
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let record = savedRecords.filter{$0.date.startOfDay == dateComponents.date?.startOfDay}
//            print("B: \(savedRecords.count)")
            if record.isEmpty{return nil}
//            print("item: \(record[0].date)")
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
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
        
        @MainActor
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
//            print("C: \(savedRecords.count)")
//            print("C - computed records: \(savedRecords.count)")
            if let selectedDate = Calendar.current.date(from: dateComponents!)?.startOfDay{
                DispatchQueue.main.async{
                    self.selectedDate = selectedDate
                }
            }
        }
        
    }
}
