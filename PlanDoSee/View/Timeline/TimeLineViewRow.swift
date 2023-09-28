//
//  TimeLineViewRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import SwiftUI

struct TimeLineViewRow: View {
    @State var timeLine: TimeLine
    @Binding var currentDay: Date
    var endEditing: ((TimeLine, Date) -> Void)?
    
    @State var text = ""
    @State var isEditing = false
    @State var dynamicHeight: CGFloat = 15
    @StateObject private var debounceObject = DebounceObject()
    @FocusState private var timeLineRowFocused: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Text(timeLine.hour)
                .frame(width: 25, alignment: .leading)
                #if os(iOS)
                .padding(.top, 5)
                #endif
            VStack(spacing: 5) {
                TextEditor(text: $debounceObject.text)
                    .focused($timeLineRowFocused)
                    #if os(macOS)
                    .scrollDisabled(true)
                    #endif
                    .font(.system(size: 16))
                    .frame(minHeight: 15)
                    .fixedSize(horizontal: false, vertical: true)
                    .scrollIndicators(.never)
                    .lineSpacing(5)
                    .onChange(of: debounceObject.debouncedText, perform: { value in
                        timeLine.content = value
                        endEditing?(TimeLine(hour: timeLine.hour, content: value), currentDay)
                    })
                    
                Rectangle()
                    .stroke(.gray.opacity(0.5),
                            style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
                    .frame(height: 0.5)
            }
            
        }
        .hAlign(.leading)
        #if os(iOS)
        .padding(.horizontal, 4)
        #elseif os(macOS)
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        #endif
        .onAppear {
            debounceObject.isInitialText = true
            debounceObject.text = timeLine.content
        }
        // 타이머로 서버에 저장하는 기능
//        .onChange(of: timeLineRowFocused) { isFocused in
//            if isFocused {
//                debounceObject.startTimer()
//            } else {
//                debounceObject.stopTimer()
//                timeLine.content = debounceObject.text
//                endEditing?(timeLine, currentDay)
//            }
//        }
//        .onChange(of: currentDay) { [currentDay] newValue in
//            debounceObject.stopTimer()
//
//            if timeLineRowFocused
//                && !debounceObject.text.isEmpty {
//                timeLine.content = debounceObject.text
//                endEditing?(timeLine, currentDay)
//            }
//        }
//        .onReceive(debounceObject.$prevText) { text in
//            guard !text.isEmpty else { return }
//            timeLine.content = debounceObject.text
//            endEditing?(timeLine, currentDay)
//        }
    }
}

//struct TimeLineViewRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeLineViewRow(hour: <#Date#>)
//    }
//}
