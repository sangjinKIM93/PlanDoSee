//
//  WeekSeeItemView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/11.
//

import SwiftUI

struct WeekSeeItemView: View {
    
    var date: Date
    var text: String
    
    var body: some View {
        VStack {
            Text(date.toString("MM.dd"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18))
            Spacer().frame(height: 10)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 16))
                .lineSpacing(5)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.gray, lineWidth: 1)
                )
        }
        .padding()
        
    }
}

struct WeekSeeItemView_Previews: PreviewProvider {
    static var previews: some View {
        WeekSeeItemView(date: Date(), text: "testtetet")
    }
}
