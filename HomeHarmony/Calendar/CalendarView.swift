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
        VStack(alignment: .leading, spacing: 15) {
            VStack(spacing: 15) {
                HStack {
                    Button {
                        self.date = date.startOfPreviousMonth
                    } label: {
                        Image(systemName: "arrow.backward")
                            .bold()
                    }
                    
                    Spacer()
                    
                    Text(date.getMonth)
                        .font(.custom("Sansita-ExtraBold", size: 32))
                    
                    Spacer()
                    
                    Button {
                        self.date = date.startOfNextMonth
                    } label: {
                        Image(systemName: "arrow.forward")
                            .bold()
                    }
                }
                
                HStack {
                    ForEach(daysOfWeek.indices, id: \.self) { index in
                        Text(daysOfWeek[index])
                            .font(.custom("Sansita-Regular", size: 20))
                            .frame(maxWidth: .infinity)
                            .opacity(0.5)
                    }
                }
            }
            .foregroundStyle(.white)
            .padding()
            .background(Color("slate"))
            .cornerRadius(10)
                
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
                    }
                }
            }
            .padding(.horizontal)
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
        VStack(spacing: 10) {
            Text("Schedule")
                .font(.custom("Sansita-ExtraBold", size: 32))
            
            VStack(spacing: 15) {
                Text("\(day.formatted(.dateTime.day()))")
                    .font(.custom("Sansita-Bold", size: 15))
                
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
            .padding(.vertical, 10)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, minHeight: 40)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(
                        Date.now.startOfDay == day.startOfDay
                        ? Color("lightBlue")
                        : .white)
            )
        }
    }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(sheetOpen: .constant(false), showCalendarDetail: .constant(nil), dateSelected: .constant(nil), dayToTask: [DateComponents:[Int]]())
    }
}
