//
//  ContentView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentDay: Date = .init()
    @State private var todoList: [Task] = [Task()]
    
    var body: some View {
        VStack {
            Text(Date().toString("MMM YYYY"))
                .hAlign(.leading)
                .padding(.top, 15)
            
            WeekRow()

            HStack {
                VStack {
                    List {
                        Section(footer: TodoListFooter(todoList: $todoList)) {
                            ForEach(todoList, id: \.self) { task in
                                TaskRow(task: task)
                            }
                            
                        }
                        
                    }
                }
                VStack {
                    List {
                        TimelineView()
                    }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func TimelineView() -> some View {
        VStack {
            let hours = Calendar.current.hours
            let adjustedHours = Array(hours[6..<hours.count]) + Array(hours[0..<6])
            ForEach(adjustedHours, id: \.self) { hour in
                TimeLineViewRow(hour)
            }
        }
    }
    
    @ViewBuilder
    func TimeLineViewRow(_ hour: Date) -> some View {
        HStack(alignment: .top) {
            Text(hour.toString("HH"))
                .frame(width: 25, alignment: .leading)
            VStack() {
                // 여러개의 textEditor에 대응하기 위해서는 각각의 데이터 스트림이 있어야해
                SJTextEditor()
                Rectangle()
                    .stroke(.gray.opacity(0.5),
                            style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
                    .frame(height: 0.5)
            }
            
        }
        .hAlign(.leading)
        .padding(.vertical, 15)
    }
    
    @ViewBuilder
    func WeekRow() -> some View {
        HStack(spacing: 0) {
            ForEach(Calendar.current.currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                VStack(spacing: 6) {
                    Text(weekDay.string.prefix(3))
                        .font(.system(size: 12))
                    Text(weekDay.date.toString("dd"))
                        .font(.system(size: 16))
                        .fontWeight(status ? .semibold : .regular)
                }
                .foregroundColor(status ? .blue : .gray)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    currentDay = weekDay.date
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, -15)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
