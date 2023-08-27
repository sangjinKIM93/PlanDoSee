//
//  LoginView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/22.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginData: LoginViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome to PlanDoSee Diary.")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 20)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("switchCase@gmail.com", text: $loginData.userName)
                    .frame(height: 15)
                    .frame(maxWidth: 400)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.13))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .autocorrectionDisabled()
//                    .autocapitalization(.none)
                
                Spacer()
                    .frame(height: 20)
                
                Text("Password")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                SecureField("*******", text: $loginData.password)
                    .frame(height: 15)
                    .frame(maxWidth: 400)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.13))
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            
            Spacer()
                .frame(height: 50)
            
            Button {
                loginData.loginUser()
            } label: {
                Text("Login")
                    .frame(height: 15)
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
            .disabled(loginData.userName == "" || loginData.password == "")
            .opacity((loginData.userName == "" || loginData.password == "") ? 0.6: 1)
            .buttonStyle(.borderless)
            
            Button {
                print("signup clicked")
                withAnimation {
                    loginData.isNewUser.toggle()
                }
            } label: {
                Text("Sign up")
                    .frame(height: 15)
                    .frame(maxWidth: .infinity)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()
            .contentShape(Rectangle())
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .buttonStyle(.borderless)
        }
        .textFieldStyle(.plain)
        .padding()
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
        .background(Color.black)
//        .ignoresSafeArea()
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(loginData: LoginViewModel())
//    }
//}
