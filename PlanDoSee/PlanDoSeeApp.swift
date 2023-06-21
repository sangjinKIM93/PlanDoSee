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
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
