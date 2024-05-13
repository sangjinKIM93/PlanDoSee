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
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                Text("Sign out")
            }
            .foregroundColor(Color.accentColor)
            #if os(macOS)
            .font(.system(.title2))
            #endif
        }
        .buttonStyle(.plain)
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("Are you sure you want to sign out, \(userId)?"),
                primaryButton: .destructive(Text("Sign out")) {
                    loginStatus = false
                    userId = ""
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
}
