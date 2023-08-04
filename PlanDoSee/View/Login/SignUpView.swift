//
//  SignUpView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/22.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var loginData: LoginViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Welcome to PlanDoSee Diary.")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Spacer()
                .frame(height: 20)
            
            Button {
                withAnimation {
                    loginData.isNewUser.toggle()
                }
            } label: {
                Label {
                    Text("Back")
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "chevron.left")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

            }

            
            Spacer()
                .frame(height: 20)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Email")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("switchCase@gmail.com", text: $loginData.registerUserName)
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
                
                SecureField("*******", text: $loginData.registerPassword)
                    .frame(height: 15)
                    .frame(maxWidth: 400)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.13))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                
                Spacer()
                    .frame(height: 20)
                
                Text("Re-Enter Password")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                SecureField("*******", text: $loginData.reEnterPassword)
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
                loginData.signupUser()
            } label: {
                Text("Sign up")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(height: 15)
            .frame(maxWidth: 400)
            .padding()
            .contentShape(Rectangle())
            .background(Color.blue)
            .cornerRadius(8)
            .buttonStyle(.borderless)
            .disabled(loginData.registerUserName == "" || loginData.registerPassword == "" || loginData.reEnterPassword == "")
            .opacity((loginData.registerUserName == "" || loginData.registerPassword == "" || loginData.reEnterPassword == "") ? 0.6: 1)
        }
        .textFieldStyle(.plain)
        .padding()
        .padding(.horizontal)
        .frame(maxHeight: .infinity)
        .background(Color.black)
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView(loginData: LoginViewModel())
//    }
//}
