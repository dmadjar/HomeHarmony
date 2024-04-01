//
//  CalendarView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/30/24.
//

import SwiftUI

struct CalendarView: View {
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @Binding var sheetOpen: Bool
    @Binding var showCalendarDetail: ActiveSheet?
    @Binding var dateSelected: Date?
    
    @State private var date: Date = Date.now
    @State private var days = [Date]()
    
    let dayToTask: [DateComponents : [Int]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Schedule")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
                .frame(height: 5)
            
            HStack {
                Button {
                    self.date = date.startOfPreviousMonth
                } label: {
                    Image(systemName: "arrow.backward")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(5)
                }
                
                Spacer()
                
                Text(date.getMonth)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    self.date = date.startOfNextMonth
                } label: {
                    Image(systemName: "arrow.forward")
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .foregroundColor(.white)
                        .background(.black)
                        .cornerRadius(5)
                }
            }
            
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .frame(maxWidth: .infinity)
                }
            }
            
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Button {
                            self.dateSelected = day
                            self.showCalendarDetail = .showCalendarDetail
                            self.sheetOpen = true
                        } label: {
                            CalendarButtonView(dayToTask: dayToTask, day: day)
                        }
                        .padding(.vertical, 10)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(
                                    Date.now.startOfDay == day.startOfDay
                                    ? .red.opacity(0.3)
                                    : .white)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black.opacity(0.15), lineWidth: 2)
                        )
                    }
                }
            }
        }
        .onAppear {
            self.days = date.calendarDisplayDays
        }
        .onChange(of: date) {
            self.days = date.calendarDisplayDays
        }
    }
}

struct CalendarButtonView: View {
    let dayToTask: [DateComponents : [Int]]
    let day: Date
    
    var body: some View {
        VStack {
            Text("\(day.formatted(.dateTime.day()))")
                .foregroundStyle(.black.opacity(0.75))
            
            HStack(spacing: 2) {
                if dayToTask[Calendar.current.dateComponents([.year, .month, .day], from: day)] == nil {
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundStyle(.clear)
                } else {
                    ForEach(Array(dayToTask.keys), id: \.self) { key in
                        ForEach(Array(zip(dayToTask[key]!.indices, dayToTask[key]!)), id: \.0) { index, progress in
                            
                            if Calendar.current.date(from: key)!.startOfDay == day {
                                Circle()
                                    .frame(width: 5, height: 5)
                                    .foregroundStyle(progressColor(progress: progress))
                            }
                        }
                    }
                }
            }
        }
    }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(sheetOpen: .constant(false), showCalendarDetail: .constant(nil), dateSelected: .constant(nil), dayToTask: [DateComponents:[Int]]())
    }
}
