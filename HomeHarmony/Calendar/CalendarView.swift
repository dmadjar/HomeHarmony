//
//  CalendarView.swift
//  HomeHarmony
//
//  Created by Daniel Madjar on 3/30/24.
//

import SwiftUI

struct CalendarView: View {
   
    @State private var date: Date = Date.now
    
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days = [Date]()
   
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
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
                    .font(.title)
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
                        VStack {
                            Text("\(day.formatted(.dateTime.day()))")
                            
                            Circle()
                                .frame(width: 5, height: 5)
                        }
                        .padding(.vertical, 10)
                        .fontWeight(.bold)
                        .foregroundStyle(.secondary)
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
        .padding()
        .onAppear {
            self.days = date.calendarDisplayDays
        }
        .onChange(of: date) {
            self.days = date.calendarDisplayDays
        }
    }
}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(color: .blue)
    }
}
