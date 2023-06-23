//
//  LoginViewModel.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/21.
//

import Foundation
import FirebaseAuth
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var userName = ""
    @Published var password = ""
    
    @Published var isNewUser = false
    @Published var registerUserName = ""
    @Published var registerPassword = ""
    @Published var reEnterPassword = ""
    
    @Published var isLoading = false
    
    @Published var errorMsg = ""
    @Published var error = false
    
    @AppStorage("login_status") var status = false
    
    func loginUser() {
        withAnimation{ isLoading = true }
        
        Auth.auth().signIn(withEmail: userName, password: password) { [self] (result, err) in
            
            if let error = err {
                errorMsg = error.localizedDescription
                self.error.toggle()
                return
            }

            guard let _ = result else {
                errorMsg = "Please try again Later"
                error.toggle()
                return
            }
            
            withAnimation {
                errorMsg = "Login Success"
                error.toggle()
                status = true
            }
        }
    }
    
    func signupUser() {
        if registerPassword == reEnterPassword {
            
            withAnimation {
                isLoading = true
            }
            
            Auth.auth().createUser(withEmail: registerUserName, password: registerPassword) { [self] (result, err) in
                if let error = err {
                    errorMsg = error.localizedDescription
                    self.error.toggle()
                    return
                }

                guard let _ = result else {
                    errorMsg = "Please try again Later"
                    error.toggle()
                    return
                }
                
                withAnimation {
                    isNewUser = false
                    errorMsg = "Sign Up Success"
                    error.toggle()
                }
            }
        } else {
            errorMsg = "Password Mismatch"
            error.toggle()
        }
    }
}
