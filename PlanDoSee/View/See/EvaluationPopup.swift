//
//  EvaluationPopup.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/07/30.
//

import SwiftUI

enum EvaluationType: String {
    case good
    case soso
    case bad
    case none
}

struct EvaluationPopup: View {
    
    @Binding var presentAlert: Bool
    var successAction: (() -> ())?
    var middleAction: (() -> ())?
    var failAction: (() -> ())?
    
    let verticalButtonsHeight: CGFloat = 80
    
    var body: some View {
        if presentAlert {
            ZStack {
                // faded background
                Color.black.opacity(0.75)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        presentAlert = false
                    }
                VStack(spacing: 0) {
                    // alert title
                    Text("오늘 하루 수고했어요👍")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(height: 25)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                        .padding(.horizontal, 16)
                    
                    // alert message
                    Text("오늘 하루 목표 달성률은 몇 %인가요?")
                        .frame(height: 25)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .minimumScaleFactor(0.5)
                    
                    Divider()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 0.5)
                        .padding(.all, 0)
                    
                    VStack(spacing: 0) {
                        PercentButton(title: "80% 이상", action: successAction)
                        PercentButton(title: "60~80%", action: middleAction)
                        PercentButton(title: "60% 이하", action: failAction)
                    }
                    .padding([.horizontal, .bottom], 0)
                }
                .frame(width: 270)
                .frame(minHeight: 150)
                .background(
                    Color.white
                )
                .cornerRadius(4)
            }
        }
        
    }
    
    func PercentButton(title: String, action: (() -> Void)?) -> some View {
        Button {
            action?()
            presentAlert = false
        } label: {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
}
