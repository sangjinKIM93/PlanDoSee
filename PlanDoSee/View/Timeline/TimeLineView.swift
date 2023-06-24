//
//  TimeLineView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import SwiftUI

struct TimeLineView: View {
    var body: some View {
        VStack {
            let hours = Calendar.current.hours
            let adjustedHours = Array(hours[6..<hours.count]) + Array(hours[0..<6])
            ForEach(adjustedHours, id: \.self) { hour in
                TimeLineViewRow(hour: hour)
            }
        }
    }
}

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLineView()
    }
}
