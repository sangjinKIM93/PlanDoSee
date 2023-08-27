//
//  LoginView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/22.
//

import SwiftUI

struct EntranceView: View {
    @StateObject private var loginData = LoginViewModel()
    
    #if os(macOS)
    var screen = NSScreen.main?.visibleFrame
    #endif
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                
                if loginData.isNewUser {
                    SignUpView()
                        .environmentObject(loginData)
                } else {
                    LoginView()
                        .environmentObject(loginData)
                }
                #if os(macOS)
                Image("forest")
                    .resizable()
                    .frame(width: (screen!.width / 1.8) / 2)
                #endif
            }
            #if os(iOS)
            .frame(minWidth: 400, minHeight: 600)
            #elseif os(macOS)
            .frame(width: screen!.width / 1.8, height: screen!.height - 100)
            #endif
            .frame(width: proxy.size.width)
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
}

struct EntranceView_Previews: PreviewProvider {
    static var previews: some View {
        EntranceView()
    }
}
