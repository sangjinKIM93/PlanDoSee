//
//  LogoutButtonView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/27.
//

import SwiftUI

struct LogoutButtonView: View {
    @AppStorage("login_status") var loginStatus = true
    @AppStorage("user_id") var userId = ""
    
    @State private var showingLogoutAlert = false
    
    var body: some View {
        Button {
            showingLogoutAlert = true
        } label: {
            #if os(macOS)
            Image(systemName: "rectangle.portrait.and.arrow.forward")
            #elseif os(iOS)
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                Text("로그아웃")
            }
            .foregroundColor(Color.accentColor)
            #endif
        }
        .buttonStyle(.plain)
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("\(userId)님 로그아웃 하시겠습니까?"),
                primaryButton: .destructive(Text("로그아웃")) {
                    loginStatus = false
                    userId = ""
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
}
