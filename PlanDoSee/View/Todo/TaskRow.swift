//
//  TaskRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import SwiftUI

struct TaskRow: View {
    
    @State var task: Task
    @StateObject private var debounceObject = DebounceObject(skipFirst: true)
    
    var endEditing: ((Task) -> Void)?
    
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
            .onChange(of: task.isCompleted, perform: { newValue in
                task.isCompleted = newValue
                endEditing?(task)
            })
            
            Spacer(minLength: 0)
            
            TextField("todo list", text: $debounceObject.text)
            .font(.system(size: 16))
            .frame(height: 40)
            .foregroundColor(task.isCompleted ? .gray : .primary)
            .onChange(of: debounceObject.debouncedText, perform: { newValue in
                task.title = newValue
                endEditing?(task)
            })
        }
        .onAppear {
            debounceObject.text = task.title
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(task: Task(title: ""))
    }
}
