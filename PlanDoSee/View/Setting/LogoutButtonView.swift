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
                Text("Sign out")
            }
            .foregroundColor(Color.accentColor)
            #endif
        }
        .buttonStyle(.plain)
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("Are you sure you want to sign out, \(userId)?"),
                primaryButton: .destructive(Text("sign out")) {
                    loginStatus = false
                    userId = ""
                },
                secondaryButton: .cancel(Text("cancel"))
            )
        }
    }
}
