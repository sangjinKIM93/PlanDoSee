//
//  TodoList.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/26.
//

import SwiftUI

struct TodoList: View {
    @State private var todoList: [Task] = [Task()]
    
    @Binding var currentDay: Date
    @AppStorage("user_id") var userId = ""
    
    var body: some View {
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
            .padding(.top, 5)
        }
        .onAppear {
            getTodo { tasks in
                if tasks.isEmpty {
                    todoList = Task().dummyTasks()
                } else {
                    todoList = tasks
                }
            }
        }
        .onChange(of: currentDay) { newValue in
            getTodo { tasks in
                if tasks.isEmpty {
                    todoList = Task().dummyTasks()
                } else {
                    todoList = tasks
                }
            }
        }
    }
}

extension TodoList {
    func saveTodo(task: Task) {
        FireStoreRepository.shared.saveTodo(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            task: task,
            userId: userId
        )
    }
    
    func deleteTodo(task: Task) {
        FireStoreRepository.shared.deleteTodo(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            task: task,
            userId: userId
        )
    }
    
    func getTodo(success: @escaping ([Task]) -> Void) {
        FireStoreRepository.shared.getTodo(
            date: currentDay.toString(DateStyle.storeId.rawValue),
            userId: userId,
            success: success
        )
    }
}
