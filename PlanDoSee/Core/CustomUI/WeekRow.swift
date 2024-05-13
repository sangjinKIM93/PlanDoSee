//
//  WeekRow.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/24.
//

import SwiftUI

struct WeekRow: View {
    
    @Binding var currentWeek: [WeekDay]
    @Binding var currentDay: Date
    @Binding var showProgressView: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "chevron.left")
                .foregroundColor(.gray)
                .onTapGesture {
                    goToBeforeWeek()
                }
            ForEach(currentWeek) { weekDay in
                let status = Calendar.current.isDate(weekDay.date, inSameDayAs: currentDay)
                VStack(spacing: 6) {
                    Text(weekDay.string.prefix(3))
                        .font(.system(size: 12))
                    Text(weekDay.date.toString("dd"))
                        .font(.system(size: 16))
                        .fontWeight(status ? .semibold : .regular)
                }
                .foregroundColor(status ? .blue : .gray)
                .hAlign(.center)
                .contentShape(Rectangle())
                .onTapGesture {
                    showProgressView = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        showProgressView = false
                        currentDay = weekDay.date
                    }
                }
                .overlay(content: {
                    EvaluationImage(type: weekDay.evaluation)
                        .opacity(0.3)
                        .font(.system(size: 45))
                        .allowsHitTesting(false)
                })
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .onTapGesture {
                    goToNextWeek()
                }
        }
        .padding(.vertical, 10)
        #if os(iOS)
        .padding(.horizontal, 0)
        #elseif os(macOS)
        .padding(.horizontal, 15)
        #endif
    }
    
    func goToBeforeWeek() {
        let beforeWeek = Calendar.current.beforeWeek(date: currentDay)
        currentWeek = beforeWeek
        
        if let lastDay = beforeWeek.last {
            currentDay = lastDay.date
        }
    }
    
    func goToNextWeek() {
        let nextWeek = Calendar.current.nextWeek(date: currentDay)
        currentWeek = nextWeek
        
        if let firstDay = nextWeek.first {
            currentDay = firstDay.date
        }
    }
    
    @ViewBuilder
    func EvaluationImage(type: EvaluationType) -> some View {
        switch type {
        case .good:
            Image(systemName: "circle")
                .foregroundColor(.blue)
        case .soso:
            Image(systemName: "triangle")
                .foregroundColor(.yellow)
        case .bad:
            Image(systemName: "xmark")
                .foregroundColor(.red)
        case .none:
            Spacer()
        }
    }
}
