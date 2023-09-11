//
//  WeekSeeList.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/09.
//

import SwiftUI

struct WeekSeeList: View {
    
    @State private var sees: [SeeModel] = []
    @AppStorage("user_id") var userId = ""
    
    var body: some View {
        VStack {
            Text("이번주 See")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .font(.headline)
            List {
                ForEach(sees, id: \.self) { seeModel in
                    WeekSeeItemView(date: seeModel.date, text: seeModel.content)
                }
            }
        }
        .onAppear {
            // data 갱신
        }
    }
}

struct WeekSeeList_Previews: PreviewProvider {
    static var previews: some View {
        WeekSeeList()
    }
}
