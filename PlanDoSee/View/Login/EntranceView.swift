//
//  LoginView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/22.
//

import SwiftUI

struct EntranceView: View {
    @StateObject private var loginData = LoginViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    #if os(macOS)
    var screen = NSScreen.main?.visibleFrame
    #endif
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                #if os(macOS)
                Color(colorScheme == .dark ? .black : .white)
//                    .frame(height: screen!.height)
//                    .frame(minWidth: screen!.width / 3.5, maxWidth: .infinity)
                #endif
                
                HStack(spacing: 0) {
                    
                    if loginData.isNewUser {
                        SignUpView()
                            .environmentObject(loginData)
                            #if os(macOS)
                            .frame(width: screen!.width / 4)
                            #elseif os(iOS)
                            .keypadDoneDismiss()
                            #endif
                    } else {
                        LoginView()
                            .environmentObject(loginData)
                            #if os(macOS)
                            .frame(width: screen!.width / 4)
                            #elseif os(iOS)
                            .keypadDoneDismiss()
                            #endif
                    }
                    // 사이드 이미지
                    //                #if os(macOS)
                    //                Image("forest")
                    //                    .resizable()
                    //                    .frame(height: screen!.height)
                    //                    .frame(minWidth: screen!.width / 3.5, maxWidth: .infinity)
                    //                #endif
                }
                .frame(maxWidth: .infinity)
            }
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
