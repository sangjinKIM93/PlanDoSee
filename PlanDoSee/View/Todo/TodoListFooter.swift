//
//  TodoListFooter.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import SwiftUI

struct TodoListFooter: View {
    @Binding var todoList: [Task]
    var body: some View {
        Button {
            let task = Task()
            todoList.append(task)
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("목표 추가")
            }
        }
        .frame(height: 50)
    }
}
