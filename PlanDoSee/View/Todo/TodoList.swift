//
//  TodoList.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/26.
//

import SwiftUI

struct TodoList: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var todoList: [Task] = []
    
    @Binding var currentDay: Date
    @AppStorage("user_id") var userId = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Plan")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                #if os(iOS)
                .padding(.horizontal, 16)
                #endif
            List {
                Section(footer: TodoListFooter(todoList: $todoList, currentDay: $currentDay)) {
                    ForEach(todoList, id: \.self) { task in
                        TaskRow(
                            task: task,
                            currentDay: $currentDay,
                            deleteData: { task in
                                deleteTodo(task: task)
                                todoList = todoList.filter { $0.id != task.id }
                            },
                            saveData: { (task, date) in
                                saveTodo(task: task, date: date)
                            },
                            didTapEnter: {
                                todoList.append(Task(date: currentDay.toString(DateStyle.storeId.rawValue)))
                            }
                        )
                        .listRowSeparator(.hidden)
                    }
                    
                }
                
            }
            .listStyle(.plain)
        }
        .onAppear {
            getTodo { tasks in
                if tasks.isEmpty {
                    todoList = Task.dummyTasks(date: currentDay.toString(DateStyle.storeId.rawValue))
                } else {
                    todoList = tasks
                }
            }
        }
        .onChange(of: currentDay) { newValue in
            getTodo { tasks in
                if tasks.isEmpty {
                    todoList = Task.dummyTasks(date: currentDay.toString(DateStyle.storeId.rawValue))
                } else {
                    todoList = tasks
                }
            }
        }
    }
}

extension TodoList {
    func saveTodo(task: Task, date: Date) {
        viewModel.saveTodo(
            task: task,
            date: date.toString(DateStyle.storeId.rawValue)
        )
    }
    
    func deleteTodo(task: Task) {
        viewModel.deleteTodo(
            task: task,
            date: currentDay.toString(DateStyle.storeId.rawValue)
        )
    }
    
    func getTodo(success: @escaping ([Task]) -> Void) {
        viewModel.getTask(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            completion: success
        )
    }
}
