//
//  PlanDoSeeiOSView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/08/03.
//

import SwiftUI

struct PlanDoSeeiOSView: View {
    @State private var currentWeek: [WeekDay] = Calendar.current.currentWeek
    @State private var currentDay: Date = .init()
    
    @State private var evaluation: EvaluationType = .none
    @State private var showingEvaluationAlert: Bool = false
    @State private var showDateChangeProgressView: Bool = false
    
    @AppStorage("login_status") var status = false
    @AppStorage("user_id") var userId = ""
    
    var body: some View {
        ZStack {
            VStack {
                WeekRow(currentWeek: $currentWeek,
                        currentDay: $currentDay,
                        showProgressView: $showDateChangeProgressView)
                
                TabView {
                    TodoList(currentDay: $currentDay)
                    .tabItem {
                        Image(systemName: "list.bullet")
                                  Text("Plan")
                    }
                    
                    TimeLineList(currentDay: $currentDay)
                    .tabItem {
                        Image(systemName: "calendar.day.timeline.left")
                                  Text("Do")
                    }
                    
                    VStack {
                        SeeView(showingEvaluationAlert: $showingEvaluationAlert, currentDay: $currentDay)
                        Spacer()
                    }
                    .tabItem {
                        Image(systemName: "note")
                        Text("See")
                    }
                    
                    SettingView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Setting")
                    }
                }
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
            }, noAction: {
                saveEvaluation(evaluation: .none)
            })
            
            if showDateChangeProgressView {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
    }
}

// MARK: side effects
extension PlanDoSeeiOSView {
    func saveEvaluation(
        evaluation: EvaluationType
    ) {
        FireStoreRepository.shared.saveEvaluation(
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
        FireStoreRepository.shared.getEvaluation(
            startDayOfWeek: Calendar.current.startDayOfWeek(date: currentDay).toString("yyMMdd"),
            userId: userId,
            success: success
        )
    }
}

//struct PlanDoSeeiOSView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanDoSeeiOSView()
//    }
//}
