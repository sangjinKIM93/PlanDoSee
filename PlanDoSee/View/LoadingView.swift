//
//  LoadingView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
            
            ProgressView()
                .frame(width: 70, height: 70)
                .cornerRadius(10)
                .background(Color.white)
                .colorScheme(.light)
        }
        .ignoresSafeArea()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
