//
//  TimeLineViewRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import SwiftUI

struct TimeLineViewRow: View {
    var hour: Date
    
    var body: some View {
        HStack(alignment: .top) {
            Text(hour.toString("HH"))
                .frame(width: 25, alignment: .leading)
            VStack() {
                // 여러개의 textEditor에 대응하기 위해서는 각각의 데이터 스트림이 있어야해
                SJTextEditor()
                Rectangle()
                    .stroke(.gray.opacity(0.5),
                            style: StrokeStyle(lineWidth: 0.5, lineCap: .butt, lineJoin: .bevel, dash: [5], dashPhase: 5))
                    .frame(height: 0.5)
            }
            
        }
        .hAlign(.leading)
        .padding(.vertical, 15)
    }
}

//struct TimeLineViewRow_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeLineViewRow(hour: <#Date#>)
//    }
//}
