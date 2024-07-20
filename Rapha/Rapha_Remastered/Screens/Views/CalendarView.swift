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
    let interval = DateInterval(start: .distantPast, end: .now)
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
        uiView.reloadInputViews()
        uiView.invalidateIntrinsicContentSize()
        var currentYear = Calendar.current.component(.year, from: selectedDate)
        var currentMonth = Calendar.current.component(.month, from: selectedDate)
        
        var forThisMonth = recordCopyClass.allRecords.map{Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: $0.date)}.filter{$0.year == currentYear && $0.month == currentMonth}
        
        if !forThisMonth.isEmpty{
            uiView.reloadDecorations(forDateComponents: forThisMonth, animated: true)
        }
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
            let record = savedRecordsCopy.allRecords.filter{$0.date.startOfDay == dateComponents.date?.startOfDay}
            if record.isEmpty{return nil}
            let renderer = ImageRenderer(content: CalendarCellRecordsView(record: record[0]))
            renderer.scale = 3
            if let uiImage = renderer.uiImage {
                return .image(uiImage)
            }
            return nil
        }
        
        @MainActor
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents{
                if let selectedDate = Calendar.current.date(from: dateComponents!)?.startOfDay{
                    self.selectedDate = selectedDate
                }
            }
        }
    }
}
