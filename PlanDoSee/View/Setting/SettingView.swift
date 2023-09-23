//
//  SettingView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/25.
//

import SwiftUI

struct SettingView: View {
    
    @Binding var currentDay: Date
    
    var body: some View {
        List {
            NavigationLink {
                WeekSeeList(currentDay: $currentDay)
            } label: {
                HStack {
                    Image(systemName: "list.bullet.rectangle")
                    Text("한주 회고 리스트")
                }
                .foregroundColor(Color.accentColor)
            }
            .listRowSeparator(.hidden)
            
            NavigationLink {
                OneThingView()
            } label: {
                HStack {
                    Image(systemName: "1.circle")
                    Text("목표 쓰기 ")
                }
                .foregroundColor(Color.accentColor)
            }
            .listRowSeparator(.hidden)
            
            LogoutButtonView()
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(currentDay: .constant(Date()))
    }
}
