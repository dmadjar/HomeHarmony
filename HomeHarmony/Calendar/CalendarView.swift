//
//  CalendarView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/30/24.
//

import SwiftUI

struct CalendarView: View {
    @State private var color: Color = .blue
    @State private var date: Date = Date.now
    
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days = [Date]()
    
    var body: some View {
        VStack {
            LabeledContent("Calendar Color") {
                ColorPicker("", selection: $color, supportsOpacity: false)
            }
            
            LabeledContent("Date/Time") {
                DatePicker("", selection: $date)
            }
            
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Text("\(day.formatted(.dateTime.day()))")
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        Date.now.startOfDay == day.startOfDay 
                                        ? .red.opacity(0.3)
                                        : color.opacity(0.3))
                            )
                    }
                }
            }
        }
        .padding()
        .onAppear {
            self.days = date.calendarDisplayDays
        }
        .onChange(of: date) {
            self.days = date.calendarDisplayDays
        }
    }
}

#Preview {
    CalendarView()
}
