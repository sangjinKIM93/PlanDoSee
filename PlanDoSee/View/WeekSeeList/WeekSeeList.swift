//
//  WeekSeeList.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/09.
//

import SwiftUI

struct WeekSeeList: View {
    var body: some View {
        VStack {
            Text("이번주 회고 모음")
            List {
                Text("이번주 회고 모1")
            }
        }
    }
}

struct WeekSeeList_Previews: PreviewProvider {
    static var previews: some View {
        WeekSeeList()
    }
}
