//
//  TaskRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/18.
//

import SwiftUI

struct TaskRow: View {
    
    @State var task: Todo
    @Binding var currentDay: Date
    @StateObject private var debounceObject = DebounceObject()
    @FocusState private var taskRowFocused: Bool
    
    var deleteData: ((Todo) -> Void)?
    var saveData: ((Todo, Date) -> Void)?
    var putOffData: ((Todo, Date) -> Void)?
    var didTapEnter: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .center) {
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
            .buttonStyle(.plain)
            #if os(iOS)
            .frame(height: 30)
            #elseif os(macOS)
            .frame(height: 40)
            #endif
            .onChange(of: task.isCompleted, perform: { newValue in
                task.isCompleted = newValue
                saveData?(task, currentDay)
            })
            
            Spacer(minLength: 5)
            
            TextField("todo list", text: $debounceObject.text)
                .font(.system(size: 16))
                #if os(iOS)
                .frame(height: 30)
                #elseif os(macOS)
                .frame(height: 40)
                #endif
                .focused($taskRowFocused)
                .foregroundColor(task.isCompleted ? .gray : .primary)
                .onChange(of: debounceObject.debouncedText, perform: { newValue in
                    task.title = newValue
                    saveData?(task, currentDay)
                })
                .onSubmit {
                    didTapEnter?()
                }
            
            Image(systemName: "arrowshape.turn.up.right")
                .foregroundColor(.gray.opacity(0.5))
                .onTapGesture {
                    putOffData?(task, currentDay)
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
        // timer로 저장하는 기능
//        .onChange(of: taskRowFocused) { isFocused in
//            guard !debounceObject.text.isEmpty else {
//                debounceObject.stopTimer()
//                return
//            }
//            if isFocused {
//                debounceObject.startTimer()
//            } else {
//                debounceObject.stopTimer()
//                task.title = debounceObject.text
//                saveData?(task, currentDay)
//            }
//        }
//        .onReceive(debounceObject.$prevText) { text in
//            guard !text.isEmpty else { return }
//            task.title = debounceObject.text
//            saveData?(task, currentDay)
//        }
        .onChange(of: currentDay) { [currentDay] newValue in
            debounceObject.stopTimer()
            
            if taskRowFocused
                && !debounceObject.text.isEmpty {
                task.title = debounceObject.text
                saveData?(task, currentDay)
            }
        }
    }
}

//struct TaskRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskRow(task: Task(title: ""))
//    }
//}
