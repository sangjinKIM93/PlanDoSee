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
            #if os(iOS)
            NavigationLink {
                WeekSeeList(currentDay: $currentDay)
            } label: {
                HStack {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Sees in week")
                }
                .foregroundColor(Color.accentColor)
            }
            .listRowSeparator(.hidden)
            
            NavigationLink {
                OneThingView()
            } label: {
                HStack {
                    Image(systemName: "1.circle")
                    Text("Write Goal")
                }
                .foregroundColor(Color.accentColor)
            }
            .listRowSeparator(.hidden)
            #endif
            
            LogoutButtonView()
                .listRowSeparator(.hidden)
            
            DeleteAccountButtonView()
                .listRowSeparator(.hidden)            
        }
        #if os(iOS)
        .listStyle(.plain)
        #endif
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(currentDay: .constant(Date()))
    }
}
