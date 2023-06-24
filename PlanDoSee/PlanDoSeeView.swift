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
    @State private var seeText: String = ""
    
    @AppStorage("login_status") var status = false
    @AppStorage("user_id") var userId = ""
    
    let interactor = PlanDoSeeInteractor()
    
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
                    List {
                        TimeLineView()
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
        }
        .onChange(of: currentDay, perform: { newValue in
            getTodo { tasks in
                todoList = tasks
            }
        })
    }
    
    private func binding(for task: Task) -> Binding<Task> {
        guard let taskIndex = todoList.firstIndex(where: {$0.id == task.id}) else {
            fatalError("Can't find scrum in array")
        }
        return $todoList[taskIndex]
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
}

struct PlanDoSeeView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDoSeeView()
    }
}
