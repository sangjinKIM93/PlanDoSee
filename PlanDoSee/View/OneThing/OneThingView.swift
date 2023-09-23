//
//  OneThingView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/21.
//

import SwiftUI

struct OneThingView: View {
    @StateObject private var goalText = DebounceObject()
    @State private var showDatePicker: Bool = false
    @State private var alarmDate: Date = Date()
    @State private var isOnAlarm: Bool = false
    @State private var goalRepeatText: String = ""
    @AppStorage("user_id") var userId = ""
    
    var body: some View {
        // 1. 목표 설정 화면
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 20)
            Group {
                Text("집중할 단 한가지 목표는 무엇인가요?")
                Spacer().frame(height: 10)
                TextField("목표를 적어주세요.", text: $goalText.text)
                    .font(.system(size: 16))
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.gray, lineWidth: 1)
                    )
                    .onChange(of: goalText.debouncedText, perform: { newValue in
                        saveOneThing()
                    })
            }
            
            Spacer().frame(height: 30)
            
            // 2. 목표 쓰기
            Group {
                Text("목표 쓰기")
                    .font(.system(size: 14))
                    .padding(.bottom, 10)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $goalRepeatText)
                        .font(.system(size: 12))
                        .padding()
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray, lineWidth: 1)
                        )
                    if goalRepeatText.isEmpty {
                        Text("목표를 반복해서 적어봐요.")
                            .font(.system(size: 12))
                            .padding()
                            .foregroundColor(.gray.opacity(0.5))
                            .allowsHitTesting(false)
                    }
                }
            }
            
            Spacer().frame(height: 30)
            
            // 3. 알림 설정
            Group {
                Text("알림 설정")
                    .font(.system(size: 14))
                    .padding(.bottom, 10)
                HStack(alignment: .center, spacing: 0) {
                    Text("매일")
                    DatePicker("", selection: $alarmDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .scaleEffect(CGSize(width: 0.8, height: 0.8))
                        .onChange(of: alarmDate) { date in
                            if isOnAlarm {
                                NotificationManager.shared.requestNotification(
                                    date: date,
                                    goalText: goalText.text
                                )
                            }
                            saveOneThing()
                        }
                    Text("에 리마인드 알림 보내기")
                    Spacer()
                    Toggle("", isOn: $isOnAlarm)
                        .frame(maxWidth: 50)
                        .scaleEffect(CGSize(width: 0.8, height: 0.8))
                    Spacer().frame(width: 10)
                }
                .font(.system(size: 14))
            }

            Spacer()
        }
        .onChange(of: isOnAlarm) { isOn in
            if isOn {
                NotificationManager.shared.requestNotification(
                    date: alarmDate,
                    goalText: goalText.text
                )
            } else {
                NotificationManager.shared.dismissNotification()
            }
            saveOneThing()
        }
        .onAppear {
            getOneThing { oneThing in
                goalText.text = oneThing.goal
                isOnAlarm = oneThing.isOnAlarm
                alarmDate = oneThing.alarmDate.toDate() ?? Date()
            } failure: {
                //
            }
        }
        // OneThingModel 하나 만들어서 파베에 저장하기
        
        
        // 3. 목표 쓰기 화면
    }
    
    func saveOneThing() {
        let oneThingModel = OneThing(
            goal: goalText.text,
            isOnAlarm: isOnAlarm,
            alarmDate: alarmDate.toString(DateStyle.storeId.rawValue)
        )
        FireStoreRepository.shared.saveOneThing(oneThing: oneThingModel, userId: userId)
    }
    
    func getOneThing(
        success: @escaping (OneThing) -> Void,
        failure: @escaping () -> Void
    ) {
        FireStoreRepository.shared.getOneThing(
            userId: userId,
            success: { oneThing in
                success(oneThing)
            }, failure: {
                failure()
            }
        )
    }
}

struct OneThingView_Previews: PreviewProvider {
    static var previews: some View {
        OneThingView()
    }
}