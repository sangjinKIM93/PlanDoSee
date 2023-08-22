//
//  TimeLineViewRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import SwiftUI

struct TimeLineViewRow: View {
    @State var timeLine: TimeLine
    var endEditing: ((TimeLine) -> Void)?
    
    @State var text = ""
    @State var isEditing = false
    @State var dynamicHeight: CGFloat = 15
    @StateObject private var debounceObject = DebounceObject(skipFirst: true)
    
    var body: some View {
        HStack(alignment: .top) {
            Text(timeLine.hour)
                .frame(width: 25, alignment: .leading)
                #if os(iOS)
                .padding(.top, 5)
                #endif
            VStack(spacing: 0) {
                TextEditor(text: $debounceObject.text)
                    #if os(macOS)
                    .scrollDisabled(true)
                    #endif
                    .font(.system(size: 14))
                    .frame(minHeight: 15)
                    .fixedSize(horizontal: false, vertical: true)
                    .scrollIndicators(.never)
                    .onChange(of: debounceObject.debouncedText, perform: { value in
                        timeLine.content = value
                        endEditing?(TimeLine(hour: timeLine.hour, content: value))
                    })
                    
                Rectangle()
                    .stroke(.gray.opacity(0.5),
                            style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
                    .frame(height: 0.5)
            }
            
        }
        .hAlign(.leading)
        .padding(.vertical, 15)
        .onAppear {
            debounceObject.text = timeLine.content
        }
    }
}

//struct TimeLineViewRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeLineViewRow(hour: <#Date#>)
//    }
//}
