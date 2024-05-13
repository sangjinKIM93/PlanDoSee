//
//  FocusTimer.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/02.
//

import Combine
import Foundation

public final class FocusTimer: ObservableObject {
    @Published var isFocused: Bool = false
    @Published var prevText: String = ""
    @Published var newText: String = ""
    @Published var saveText: String = ""
    
    private var timer: Timer?
    
    init() {
//        startTimer()
    }
    
    func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.checkData()
        }
        
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func checkData() {
        print("타이머 로직 실행")
        print("\(prevText), \(newText)")
        if prevText != newText {
            prevText = newText
            saveText = newText
        } else {
            return
        }
    }
}
