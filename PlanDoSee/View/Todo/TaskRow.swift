//
//  TaskRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import SwiftUI

struct TaskRow: View {
    
    @State var task: Task
    @Binding var currentDay: Date
    @StateObject private var debounceObject = DebounceObject()
    @FocusState private var taskRowFocused: Bool
    
    var deleteData: ((Task) -> Void)?
    var saveData: ((Task, Date) -> Void)?
    var didTapEnter: (() -> Void)?
    
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
                saveData?(task, currentDay)
            })
            
            Spacer(minLength: 10)
            
            TextField("todo list", text: $debounceObject.text)
                .font(.system(size: 16))
                .frame(height: 40)
                .focused($taskRowFocused)
                .foregroundColor(task.isCompleted ? .gray : .primary)
//                .onChange(of: debounceObject.debouncedText, perform: { newValue in
//                    task.title = newValue
//                    saveData?(task)
//                })
                .onSubmit {
                    didTapEnter?()
                }
            
            Image(systemName: "x.square")
                .foregroundColor(.gray.opacity(0.5))
                .onTapGesture {
                    deleteData?(task)
                }
        }
        .onAppear {
            debounceObject.isInitialText = true
            debounceObject.text = task.title
            if task.title.isEmpty {
                taskRowFocused = true
            }
        }
        .onChange(of: task.isCompleted) { isCompleted in
            if isCompleted {
//                NSApp.keyWindow?.makeFirstResponder(nil)
            }
        }
        .onChange(of: taskRowFocused) { isFocused in
            if isFocused && !debounceObject.text.isEmpty {
                debounceObject.startTimer()
            } else {
                debounceObject.stopTimer()
                task.title = debounceObject.text
                saveData?(task, currentDay)
            }
        }
        .onChange(of: currentDay) { [currentDay] newValue in
            debounceObject.stopTimer()
            
            if taskRowFocused
                && !debounceObject.text.isEmpty {
                task.title = debounceObject.text
                saveData?(task, currentDay)
            }
        }
        .onReceive(debounceObject.$prevText) { text in
            guard !text.isEmpty else { return }
            task.title = debounceObject.text
            saveData?(task, currentDay)
        }
    }
}

//struct TaskRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskRow(task: Task(title: ""))
//    }
//}
