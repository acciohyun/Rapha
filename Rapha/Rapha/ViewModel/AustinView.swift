////
//  AustinTestView.swift
//  Rapha
//
//  Created by Hyun Lee on 4/16/24.
//

import SwiftUI
import SwiftData

struct AustinTestView: View {
    @State var currentDate: Date = Date()
    @Query var calendarDateList: [CalendarDate]
    @State var currentCalendarData: CalendarDate?

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("", selection: $currentDate)
                    .datePickerStyle(.graphical)
//                CalendarViewModel(selectedDate: $currentDate)
                List {
                    if let symptom = currentCalendarData?.symptoms {
                        NavigationLink {
                            RecordSymptomsScreen(symptomData: symptom)
                        } label: {
                            Text("symtom")
                        }
                    }

                }
            }
        }
        .onChange(of: currentDate) { oldValue, newValue in
            currentCalendarData = calendarDateList.filter({ $0.date.startOfDay == newValue.startOfDay}).first
        }
    }
}

//#Preview {
//    AustinTestView()
//}
