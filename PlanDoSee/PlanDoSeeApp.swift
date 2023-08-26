//
//  PlanDoSeeApp.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import FirebaseCore
import SwiftUI
import UIKit

@main
struct PlanDoSeeApp: App {
    
    @AppStorage("login_status") var status = false
    
    init() {
        FirebaseApp.configure()
        setTabbarAppearance()
    }
    var body: some Scene {
        WindowGroup {
            if status {
                #if os(iOS)
                PlanDoSeeiOSView()
                #elseif os(macOS)
                PlanDoSeeView()
                #else
                println("OMG, it's that mythical new Apple product!!!")
                #endif
                
            } else {
                EntranceView()
            }
        }
    }
    
    func setTabbarAppearance() {
        let appearance = UITabBar.appearance()
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.isTranslucent = false
        appearance.backgroundColor = UIColor.systemBackground
//        appearance.scrollEdgeAppearance = UITabBarAppearance()
    }
}
