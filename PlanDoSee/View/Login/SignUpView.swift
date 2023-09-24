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
                .foregroundColor(.titleColor)
            
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
                        .font(.body)
                        .foregroundColor(.gray)
                }

            }

            
            Spacer()
                .frame(height: 20)
            
            VStack(alignment: .leading, spacing: 6) {
                Group {
                    Text("Email")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    TextField("switchCase@gmail.com", text: $loginData.registerUserName)
                        .frame(height: 15)
                        .frame(maxWidth: 400)
                        .padding(.vertical, 10)
                        .foregroundColor(.titleColor)
                        .autocorrectionDisabled()
#if os(iOS)
                        .autocapitalization(.none)
#endif
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 50)
                        .background(.gray.opacity(0.5))
                }
                
                Spacer()
                    .frame(height: 20)
                
                Group {
                    Text("Password")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    SecureField("*******", text: $loginData.registerPassword)
                        .frame(height: 15)
                        .frame(maxWidth: 400)
                        .padding(.vertical, 10)
                        .foregroundColor(.titleColor)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 50)
                        .background(.gray.opacity(0.5))
                }
                
                Spacer()
                    .frame(height: 20)
                
                Group {
                    Text("Re-Enter Password")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    SecureField("*******", text: $loginData.reEnterPassword)
                        .frame(height: 15)
                        .frame(maxWidth: 400)
                        .padding(.vertical, 10)
                        .foregroundColor(.titleColor)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(.gray.opacity(0.5))
                }
            }
            
            Spacer()
                .frame(height: 50)
            
            Button {
                loginData.signupUser()
            } label: {
                Text("Sign up")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(height: 15)
                    .frame(maxWidth: .infinity)
            }
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
        .background(.background)
        .onTapGesture {
            #if os(iOS)
            self.endTextEditing()
            #endif
        }
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView(loginData: LoginViewModel())
//    }
//}
