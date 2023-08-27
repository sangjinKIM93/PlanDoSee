//
//  TimeLineList.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/26.
//

import SwiftUI

struct TimeLineList: View {
    @State private var timeLines: [TimeLine] = []
    
    @Binding var currentDay: Date
    @AppStorage("user_id") var userId = ""
    
    init(currentDay: Binding<Date>) {
        _currentDay = currentDay
        timeLines = dummyTimeLines()
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Do")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollViewReader { proxy in
                List() {
                    ForEach(timeLines, id: \.self) { timeline in
                        TimeLineViewRow(timeLine: timeline) {  timeline in
                            saveTimeline(timeLine: timeline)
                        }
                        .id(timeline)
                        #if os(iOS)
                        .listRowSeparator(.hidden)
                        #endif
                    }
                }
                #if os(iOS)
                .listStyle(.plain)
                #endif
                .onChange(of: timeLines, perform: { newValue in
                    let target = timeLines.first { $0.hour == String(Calendar.current.currentHour) }
                    proxy.scrollTo(target, anchor: .top)
                })
            }
        }
        .onAppear {
            getTimeLines { list in
                if list.isEmpty {
                    timeLines = dummyTimeLines()
                } else {
                    timeLines = resetTimeLines(list)
                }
            }
        }
        .onChange(of: currentDay) { newValue in
            getTimeLines { list in
                if list.isEmpty {
                    timeLines = dummyTimeLines()
                } else {
                    timeLines = resetTimeLines(list)
                }
            }
        }
    }
}

extension TimeLineList {
    func saveTimeline(timeLine: TimeLine) {
        FireStoreRepository.shared.saveTimeline(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            timeLine: timeLine,
            userId: userId
        )
    }
    
    func getTimeLines(success: @escaping ([TimeLine]) -> Void) {
        FireStoreRepository.shared.getTiemline(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            userId: userId,
            success: success
        )
    }
    
    private func dummyTimeLines() -> [TimeLine] {
        let timelines = Calendar.current.hours
            .map { hour in
                let hourString = hour.toString("HH")
                return TimeLine(hour: hourString, content: "")
            }
        
        return timelines
    }
    
    private func resetTimeLines(_ list: [TimeLine]) -> [TimeLine] {
        var timelines: [TimeLine] = []
        for hour in Calendar.current.hours {
            let hourString = hour.toString("HH")
            let timeLine = TimeLine(
                hour: hourString,
                content: list.first{$0.hour == hourString}.map{$0.content} ?? ""
            )
            timelines.append(timeLine)
        }
        return timelines
    }
}