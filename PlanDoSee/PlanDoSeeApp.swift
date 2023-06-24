//
//  PlanDoSeeApp.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import FirebaseCore
import SwiftUI

@main
struct PlanDoSeeApp: App {
    
    @AppStorage("login_status") var status = false
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if status {
                PlanDoSeeView()
            } else {
                EntranceView()
            }
        }
    }
}
