//
//  TodoList.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/26.
//

import SwiftUI

struct TodoList: View {
    @StateObject private var viewModel = TodoListViewModel()
    @State private var todoList: [Todo] = []
    
    @Binding var currentDay: Date
    @Binding var loading: Bool
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
                                Task {
                                    await deleteTodo(task: task)
                                    todoList = todoList.filter { $0.id != task.id }
                                }
                            },
                            saveData: { (task, date) in
                                Task {
                                    await saveTodo(task: task, date: date)
                                }
                            },
                            putOffData: { (task, date) in
                                putOffTodoUntillTommorow(task: task, date: date) 
                            },
                            didTapEnter: {
                                todoList.append(Todo(date: currentDay.toString(DateStyle.storeId.rawValue)))
                            }
                        )
                        .listRowSeparator(.hidden)
                    }
                    
                }
                
            }
            .listStyle(.plain)
        }
        .onAppear {
            refreshData()
        }
        .onChange(of: currentDay) { newValue in
            refreshData()
        }
    }
}

extension TodoList {
    func saveTodo(task: Todo, date: Date) async {
        await viewModel.saveTodo(
            task: task,
            date: date.toString(DateStyle.storeId.rawValue)
        )
    }
    
    func deleteTodo(task: Todo) async {
        await viewModel.deleteTodo(
            task: task,
            date: currentDay.toString(DateStyle.storeId.rawValue)
        )
    }
    
    func getTodo(success: @escaping ([Todo]) -> Void) {
        viewModel.getTask(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            completion: success
        )
    }
    
    func putOffTodoUntillTommorow(task: Todo, date: Date) {
        Task {
            await deleteTodo(task: task)
            await saveTodo(task: task, date: date.addDays(add: 1))
            
            refreshData()
        }
    }
    
    func refreshData() {
        loading = true
        getTodo { tasks in
            if tasks.isEmpty {
                todoList = Todo.dummyTasks(date: currentDay.toString(DateStyle.storeId.rawValue))
            } else {
                todoList = tasks
            }
            loading = false
        }
    }
}
