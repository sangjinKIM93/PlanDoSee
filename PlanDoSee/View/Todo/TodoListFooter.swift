//
//  TodoListFooter.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import SwiftUI

struct TodoListFooter: View {
    @Binding var todoList: [Todo]
    @Binding var currentDay: Date
    var body: some View {
        Button {
            let task = Todo(date: currentDay.toString(DateStyle.storeId.rawValue))
            todoList.append(task)
        } label: {
            HStack {
                Image(systemName: "plus.app.fill")
                    .font(.headline)
                    .foregroundColor(.blue.opacity(0.8))
                Text("Add Todo")
                    .foregroundColor(.blue.opacity(0.8))
                    .font(.headline)
            }
        }
        .buttonStyle(.plain)
        .frame(height: 50)
        .listRowSeparator(.hidden)
    }
}
