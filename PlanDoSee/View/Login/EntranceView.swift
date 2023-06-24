//
//  LoginView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/22.
//

import SwiftUI

struct EntranceView: View {
    @StateObject private var loginData = LoginViewModel()
    
    var body: some View {

        HStack(spacing: 0) {
            
            if loginData.isNewUser {
                SignUpView()
                    .environmentObject(loginData)
            } else {
                LoginView()
                    .environmentObject(loginData)
            }
            
        }
        .frame(minWidth: 400, minHeight: 600)
        .overlay {
            ZStack {
                if loginData.isLoading {
                    LoadingView()
                }
            }
        }
        .alert(isPresented: $loginData.error) {
            Alert(title: Text("Message"), message: Text(loginData.errorMsg), dismissButton: .destructive(Text("OK"), action: {
                withAnimation {
                    loginData.isLoading = false
                }
            }))
        }
        .ignoresSafeArea()
    }
}

struct EntranceView_Previews: PreviewProvider {
    static var previews: some View {
        EntranceView()
    }
}
