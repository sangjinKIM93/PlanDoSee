//
//  KeypadModifier.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/28.
//

import SwiftUI

struct KeypadDoneModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        #if os(iOS)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                        to: nil, from: nil, for: nil)
                        #endif
                    } label: {
                        Text("Done")
                    }
                }
            }
    }
}

extension View {
    func keypadDoneDismiss() -> some View {
        modifier(KeypadDoneModifier())
    }
}
