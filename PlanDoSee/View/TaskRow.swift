//
//  TaskRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import SwiftUI

struct TaskRow: View {
    
    @State var task: Task
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            .frame(height: 40)
            
            Spacer(minLength: 0)
            
            TextField("todo list", text: .init(get: {
                return task.title
            }, set: { value in
                task.title = value
            }))
            .font(.system(size: 16))
            .frame(height: 40)
            .foregroundColor(task.isCompleted ? .gray : .primary)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: Task(title: "", isCompleted: false))
    }
}
