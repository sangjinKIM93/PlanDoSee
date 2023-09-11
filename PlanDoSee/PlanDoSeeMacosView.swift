//
//  PlanDoSeeMacosView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/09.
//

import SwiftUI

enum MacTabType {
    case plandosee
    case weekSeeList
}

struct PlanDoSeeMacosView: View {
    
    @State private var tab: MacTabType = .plandosee
    @State private var currentDay: Date = .init()
    
    var body: some View {
        NavigationSplitView {
            List {
                Spacer().frame(height: 10)
                
                Image(systemName: tab == .plandosee ? "checklist.checked"  : "checklist")
                    .font(.system(size: 30))
                    .onTapGesture {
                        tab = .plandosee
                    }
                
                Spacer().frame(height: 10)
                
                Image(systemName: tab == .weekSeeList ? "list.bullet.rectangle.fill" : "list.bullet.rectangle")
                    .font(.system(size: 30))
                    .onTapGesture {
                        tab = .weekSeeList
                    }
            }
//            .frame(maxWidth: 70, maxHeight: .infinity)
        } detail: {
            switch tab {
            case .plandosee:
                PlanDoSeeView(currentDay: $currentDay)
            case .weekSeeList:
                WeekSeeList(currentDay: $currentDay)
            }
        }
    }
}

struct PlanDoSeeMacosView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDoSeeMacosView()
    }
}
