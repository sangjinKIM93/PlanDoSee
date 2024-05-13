//
//  DeleteAccountButtonView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/10/03.
//

import SwiftUI
import FirebaseAuth

struct DeleteAccountButtonView: View {
    @AppStorage("login_status") var loginStatus = true
    @AppStorage("user_id") var userId = ""
    
    @State private var showingLogoutAlert = false
    
    var body: some View {
        Button {
            showingLogoutAlert = true
        } label: {
            HStack {
                Image(systemName: "minus.square")
                Text("Delete Account")
            }
            .foregroundColor(Color.accentColor)
            #if os(macOS)
            .font(.system(.title2))
            #endif
        }
        .buttonStyle(.plain)
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("Are you sure you want to delete account, \(userId)?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteUser()
                    loginStatus = false
                    userId = ""
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }
    }
    
    func deleteUser() {
        Auth.auth().currentUser?.delete(completion: { err in
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
        })
    }
}
