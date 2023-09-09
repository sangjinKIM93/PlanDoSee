//
//  PlanDoSeeApp.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import FirebaseCore
import SwiftUI
#if os(iOS)
import UIKit
#endif

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
                if UIDevice.current.userInterfaceIdiom == .pad {
                    PlanDoSeeView()
                } else {
                    PlanDoSeeiOSView()
                }
                #elseif os(macOS)
                PlanDoSeeMacosView()
                #else
                println("OMG, it's that mythical new Apple product!!!")
                #endif
                
            } else {
                EntranceView()
            }
        }
    }
    
    func setTabbarAppearance() {
        #if os(iOS)
        let appearance = UITabBar.appearance()
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        appearance.isTranslucent = false
        appearance.backgroundColor = UIColor.systemBackground
        #endif
    }
}
