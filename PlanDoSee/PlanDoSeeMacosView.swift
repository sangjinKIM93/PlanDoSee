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
    
    var body: some View {
        HSplitView {
            List {
                Image(systemName: tab == .plandosee ? "checklist.checked"  : "checklist")
                    .font(.system(size: 30))
                    .onTapGesture {
                        tab = .plandosee
                    }
                
                Image(systemName: tab == .weekSeeList ? "list.bullet.rectangle.fill" : "list.bullet.rectangle")
                    .font(.system(size: 30))
                    .onTapGesture {
                        tab = .weekSeeList
                    }
            }
            .frame(maxWidth: 100, maxHeight: .infinity)
            
            switch tab {
            case .plandosee:
                PlanDoSeeView()
                    .padding()
            case .weekSeeList:
                WeekSeeList()
            }
        }
    }
}

struct PlanDoSeeMacosView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDoSeeMacosView()
    }
}
