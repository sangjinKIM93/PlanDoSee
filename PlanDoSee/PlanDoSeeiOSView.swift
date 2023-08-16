//
//  PlanDoSeeiOSView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/03.
//

import SwiftUI

struct PlanDoSeeiOSView: View {
    @State private var currentWeek: [WeekDay] = Calendar.current.currentWeek
    @State private var currentDay: Date = .init()
    @State private var todoList: [Task] = [Task()]
    @State private var timeLines: [TimeLine] = []
    @State private var evaluation: EvaluationType = .none
    @StateObject private var seeText = DebounceObject(skipFirst: true)
    @State private var showingEvaluationAlert: Bool = false
    
    @AppStorage("login_status") var status = false
    @AppStorage("user_id") var userId = ""
    
    let interactor = PlanDoSeeInteractor()
    
    init() {
        timeLines = dummyTimeLines()
    }
    
    var body: some View {
        ZStack {
            VStack {
//                HStack {
//                    Text(currentDay.toString("MMM YYYY"))
//                        .hAlign(.leading)
//                        .padding(.top, 15)
//
//                    Button("오늘 하루 평가하기") {
//                        showingEvaluationAlert = true
//                    }
//                    Button {
//                        status = false
//                        userId = ""
//                    } label: {
//                        Text("logOut")
//                    }
//                }
//
//                // 이번주 정보를 다 가져와서 넣어줘야한다.
                WeekRow(currentWeek: $currentWeek,
                        currentDay: $currentDay)
                
                TabView {
                    VStack(spacing: 10) {
                        Text("Plan")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        List {
                            Section(footer: TodoListFooter(todoList: $todoList)) {
                                ForEach(todoList, id: \.self) { task in
                                    TaskRow(
                                        task: task,
                                        deleteData: { task in
                                            deleteTodo(task: task)
                                            todoList = todoList.filter { $0.id != task.id }
                                        },
                                        saveData: { task in
                                            saveTodo(task: task)
                                        },
                                        didTapEnter: {
                                            todoList.append(Task())
                                        }
                                    )
                                    .listRowSeparator(.hidden)
                                }
                                
                            }
                            
                        }
                        .listStyle(.plain)
                    }
                    .tabItem {
                        Image(systemName: "list.bullet")
                                  Text("Plan")
                    }
                    
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
                                    .listRowSeparator(.hidden)
                                }
                            }
                            .listStyle(.plain)
                            .onChange(of: timeLines, perform: { newValue in
                                let target = timeLines.first { $0.hour == String(Calendar.current.currentHour) }
                                proxy.scrollTo(target, anchor: .top)
                            })
                        }
                    }
                    .tabItem {
                        Image(systemName: "calendar.day.timeline.left")
                                  Text("Do")
                    }
                    
                    VStack {
                        SeeView(seeText: seeText, showingEvaluationAlert: $showingEvaluationAlert) { content in
                            saveSee(see: content)
                        }
                        Spacer()
                    }
                    .tabItem {
                        Image(systemName: "note")
                                  Text("See")
                    }
                }
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
                getSee { see in
                    seeText.text = see
                } failure: {
                    seeText.text = ""
                }
                
                getEvluation{ dict in
                    let currentWeek = DateMaker().makeCurrentWeek(evaluations: dict, currentDay: currentDay)
                    self.currentWeek = currentWeek
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
                getSee { see in
                    seeText.text = see
                } failure: {
                    seeText.text = ""
                }
                
                getEvluation{ dict in
                    let currentWeek = DateMaker().makeCurrentWeek(evaluations: dict, currentDay: currentDay)
                    self.currentWeek = currentWeek
                }
            })
            
            EvaluationPopup(presentAlert: $showingEvaluationAlert, successAction: {
                saveEvaluation(evaluation: .good)
            }, middleAction: {
                saveEvaluation(evaluation: .soso)
            }, failAction: {
                saveEvaluation(evaluation: .bad)
            })
        }
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
extension PlanDoSeeiOSView {
    func saveTodo(task: Task) {
        interactor.saveTodo(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            task: task,
            userId: userId
        )
    }
    
    func deleteTodo(task: Task) {
        interactor.deleteTodo(
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
    
    func saveSee(see: String) {
        interactor.saveSee(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            see: see,
            userId: userId
        )
    }
    
    func getSee(
        success: @escaping (String) -> Void,
        failure: @escaping () -> Void
    ) {
        interactor.getSee(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            userId: userId,
            success: success,
            failure: failure
        )
    }
    
    func saveEvaluation(
        evaluation: EvaluationType
    ) {
        interactor.saveEvaluation(
            startDayOfWeek: Calendar.current.startDayOfWeek(date: currentDay).toString("yyMMdd"),
            date: currentDay.toString(DateStyle.storeId.rawValue),
            evaluation: evaluation.rawValue,
            userId: userId
        )
    }
    
    func getEvluation(
        success: @escaping (([String: String]) -> Void)
    ) {
        interactor.getEvaluations(
            startDayOfWeek: Calendar.current.startDayOfWeek(date: currentDay).toString("yyMMdd"),
            userId: userId,
            success: success
        )
    }
}

//struct PlanDoSeeiOSView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanDoSeeiOSView()
//    }
//}
