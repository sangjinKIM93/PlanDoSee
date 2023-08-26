//
//  SettingView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/25.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("login_status") var loginStatus = true
    @AppStorage("user_id") var userId = ""
    
    @State private var showingLogoutAlert = false
    
    var body: some View {
        List {
            Button {
                showingLogoutAlert = true
            } label: {
                Text("로그아웃")
                    .foregroundColor(Color.accentColor)
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("로그아웃 하시겠습니까?"),
                    primaryButton: .destructive(Text("로그아웃")) {
                        loginStatus = false
                        userId = ""
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
        }
        .listStyle(.inset)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
