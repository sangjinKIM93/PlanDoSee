//
//  ContentView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import SwiftUI

struct PlanDoSeeView: View {
    
    @State private var currentDay: Date = .init()
    @State private var todoList: [Task] = [Task()]
    @State private var timeLines: [TimeLine] = []
    @State private var seeText: String = ""
    
    @AppStorage("login_status") var status = false
    @AppStorage("user_id") var userId = ""
    
    let interactor = PlanDoSeeInteractor()
    
    init() {
        timeLines = dummyTimeLines()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(Date().toString("MMM YYYY"))
                    .hAlign(.leading)
                    .padding(.top, 15)
                
                Button {
                    status = false
                    userId = ""
                } label: {
                    Text("logOut")
                }
            }
            
            WeekRow(currentDay: $currentDay)

            HStack {
                VStack {
                    List {
                        Section(footer: TodoListFooter(todoList: $todoList)) {
                            ForEach(todoList, id: \.self) { task in
                                TaskRow(task: task) { task in
                                    saveTodo(task: task)
                                }
                            }
                            
                        }
                        
                    }
                }
                VStack {
                    List() {
                        ForEach(timeLines, id: \.self) { timeline in
                            TimeLineViewRow(timeLine: timeline) {  timeline in
                                saveTimeline(timeLine: timeline)
                            }
                        }
                    }
                }
            }
            TextEditor(text: $seeText)
                .frame(height: 150)
                .font(.system(size: 16))
        }
        .padding()
        .onAppear {
            getTodo { tasks in
                todoList = tasks
            }
            getTimeLines { list in
                if list.isEmpty {
                    timeLines = dummyTimeLines()
                } else {
                    timeLines = resetTimeLines(list)
                }
            }
        }
        .onChange(of: currentDay, perform: { newValue in
            getTodo { tasks in
                todoList = tasks
            }
            getTimeLines { list in
                if list.isEmpty {
                    timeLines = dummyTimeLines()
                } else {
                    timeLines = resetTimeLines(list)
                }
            }
        })
    }
    
    private func binding(for task: Task) -> Binding<Task> {
        guard let taskIndex = todoList.firstIndex(where: {$0.id == task.id}) else {
            fatalError("Can't find scrum in array")
        }
        return $todoList[taskIndex]
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

// MARK: side effects
extension PlanDoSeeView {
    func saveTodo(task: Task) {
        interactor.saveTodo(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            task: task,
            userId: userId
        )
    }
    
    func getTodo(success: @escaping ([Task]) -> Void) {
        interactor.getTodo(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            userId: userId,
            success: success
        )
    }
    
    func saveTimeline(timeLine: TimeLine) {
        interactor.saveTimeline(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            timeLine: timeLine,
            userId: userId
        )
    }
    
    func getTimeLines(success: @escaping ([TimeLine]) -> Void) {
        interactor.getTimeLine(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            userId: userId,
            success: success
        )
    }
}

struct PlanDoSeeView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDoSeeView()
    }
}
