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
    @Binding var recordCopyClass: RecordCopy
    
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
        Coordinator(parent: self, savedRecords: $recordCopyClass, selectedDate: $selectedDate)
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        print("Update")
        print("A: \(recordsSaved.count)")
        uiView.reloadInputViews()
        uiView.invalidateIntrinsicContentSize()
        uiView.reloadDecorations(forDateComponents: recordCopyClass.allRecords.map{Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: $0.date)}, animated: true)
    }
    
    func updateView() {
        calendarView?.reloadInputViews()
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate{
        
        //this is the CalendarViewDelegate
        var parent: CalendarView
        @Binding var savedRecordsCopy: RecordCopy
        private var filteredRecords: [CalendarDate]?
        let calculations = RecordsModel()
        @Binding var selectedDate: Date
        
        
        init(parent: CalendarView, savedRecords: Binding<RecordCopy>, selectedDate: Binding<Date>) {
            self.parent = parent
            self._savedRecordsCopy = savedRecords
            self._selectedDate = selectedDate
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            print("decorator: \(savedRecordsCopy.allRecords.count)")
            let record = savedRecordsCopy.allRecords.filter{$0.date.startOfDay == dateComponents.date?.startOfDay}
            if record.isEmpty{return nil}
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
            print("select: \(savedRecordsCopy.allRecords.count)")
            if let date = dateComponents{
                if let selectedDate = Calendar.current.date(from: dateComponents!)?.startOfDay{
                    DispatchQueue.main.async{
                        self.selectedDate = selectedDate
                    }
                }
            }
        }
    }
}
