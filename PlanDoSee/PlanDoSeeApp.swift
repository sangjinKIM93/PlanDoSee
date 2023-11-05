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
    
    @State private var currentDay: Date = .init()
    @AppStorage("login_status") var status = false
    @ObservedObject var networkManager = NetworkManager()
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        FirebaseApp.configure()
        setTabbarAppearance()
    }
    var body: some Scene {
        WindowGroup {
            if status {
#if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    PlanDoSeeView(currentDay: $currentDay)
                } else {
                    PlanDoSeeiOSView()
                        .overlay(alignment: .top) {
                            if !networkManager.isConnected {
                                iOSNetworkToastView()
                            }
                        }
                }
#elseif os(macOS)
                PlanDoSeeMacosView()
                    .overlay(alignment: .top) {
                        if !networkManager.isConnected {
                            iOSNetworkToastView()
                        }
                    }
#else
                println("OMG, it's that mythical new Apple product!!!")
#endif
                
            } else {
                EntranceView()
                #if os(macOS)
                .frame(minWidth: 860, minHeight: 700)
                #endif
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("inactive")
            } else if newPhase == .active {
                networkManager.startMonitoring()
                print("active")
            } else if newPhase == .background {
                networkManager.stopMonitoring()
                print("background")
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
