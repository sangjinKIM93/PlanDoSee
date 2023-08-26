//
//  ContentView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/17.
//

import SwiftUI

struct PlanDoSeeView: View {
    
    @State private var currentWeek: [WeekDay] = Calendar.current.currentWeek
    @State private var currentDay: Date = .init()
    @State private var evaluation: EvaluationType = .none
    
    @State private var showingEvaluationAlert: Bool = false
    
    @AppStorage("login_status") var status = false
    @AppStorage("user_id") var userId = ""
    
    let interactor = PlanDoSeeInteractor()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(currentDay.toString("MMM YYYY"))
                        .hAlign(.leading)
                        .padding(.top, 15)
                    
                    Button {
                        status = false
                        userId = ""
                    } label: {
                        Text("logOut")
                    }
                }
                
                WeekRow(currentWeek: $currentWeek,
                        currentDay: $currentDay)
                
                HStack {
                    TodoList(currentDay: $currentDay)
                    TimeLineList(currentDay: $currentDay)
                }
                Spacer().frame(height: 20)
                
                SeeView(showingEvaluationAlert: $showingEvaluationAlert, currentDay: $currentDay)
            }
            .padding()
            .onAppear {
                getEvluation{ dict in
                    let currentWeek = DateMaker().makeCurrentWeek(evaluations: dict, currentDay: currentDay)
                    self.currentWeek = currentWeek
                }
            }
            .onChange(of: currentDay, perform: { newValue in
                getEvluation{ dict in
                    let currentWeek = DateMaker().makeCurrentWeek(evaluations: dict, currentDay: currentDay)
                    self.currentWeek = currentWeek
                }
            })
            
            EvaluationPopup(presentAlert: $showingEvaluationAlert, successAction: {
                saveEvaluation(evaluation: .good)
            }, middleAction: {
                saveEvaluation(evaluation: .soso)
            }, failAction: {
                saveEvaluation(evaluation: .bad)
            })
        }
    }
}

// MARK: side effects
extension PlanDoSeeView {
    func saveEvaluation(
        evaluation: EvaluationType
    ) {
        interactor.saveEvaluation(
            startDayOfWeek: Calendar.current.startDayOfWeek(date: currentDay).toString("yyMMdd"),
            date: currentDay.toString(DateStyle.storeId.rawValue),
            evaluation: evaluation.rawValue,
            userId: userId,
            success: {
                getEvluation { dict in
                    let currentWeek = DateMaker().makeCurrentWeek(evaluations: dict, currentDay: currentDay)
                    self.currentWeek = currentWeek
                }
            }
        )
    }
    
    func getEvluation(
        success: @escaping (([String: String]) -> Void)
    ) {
        interactor.getEvaluations(
            startDayOfWeek: Calendar.current.startDayOfWeek(date: currentDay).toString("yyMMdd"),
            userId: userId,
            success: success
        )
    }
}

struct PlanDoSeeView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDoSeeView()
    }
}
