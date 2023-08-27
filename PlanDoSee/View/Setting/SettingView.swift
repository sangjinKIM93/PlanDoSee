//
//  SettingView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/25.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List {
            LogoutButtonView()
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
