//
//  iOSNetworkToastView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/30.
//

import SwiftUI

struct iOSNetworkToastView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 10){
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 20))
                .padding(.leading, 5)
            VStack(alignment: .leading, spacing: 2){
                Text("Check your network connection.")
                    .font(.system(size: 14))
                    .fontWeight(.black)
                Text("If you don't have a network connection, you might not be able to save your data.")
                    .font(.system(size: 12))
                    .lineLimit(nil)
            }
        }
        .padding(.all, 10)
        .foregroundColor(.titleColor)
        .background(Color.tertiaryBackground)
        .cornerRadius(12)
        .padding(.horizontal, 5)
        #if os(iOS)
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : 30)
        #elseif os(macOS)
        .padding(.top, 10)
        #endif
        
    }
}

struct iOSNetworkToastView_Previews: PreviewProvider {
    static var previews: some View {
        iOSNetworkToastView()
    }
}
