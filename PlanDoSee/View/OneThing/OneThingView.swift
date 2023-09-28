//
//  OneThingView.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/21.
//

import SwiftUI

struct OneThingView: View {
    @StateObject private var viewModel = OneThingViewModel()
    @StateObject private var goalText = DebounceObject()
    @State private var showDatePicker: Bool = false
    @State private var alarmDate: Date = Date()
    @State private var isOnAlarm: Bool = false
    @State private var goalRepeatText: String = ""
    
    var body: some View {
        // 1. 목표 설정 화면
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 20)
                Group {
                    Text("What's the goal you're going to focus on?")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    Spacer().frame(height: 10)
                    TextField("Write your goal.", text: $goalText.text)
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
                    Text("Write down your goals repeatedly.")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
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
                    }
#if os(iOS)
                    .keypadDoneDismiss()
#endif
                }
                
                Spacer().frame(height: 30)
                
                // 3. 알림 설정
                Group {
                    Text("Notification settings")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    HStack(alignment: .center, spacing: 0) {
                        Text("Send a daily reminder at")
                        DatePicker("", selection: $alarmDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .environment(\.locale, Locale.init(identifier: "en"))
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
                        Spacer()
                        Toggle("", isOn: $isOnAlarm)
                            .frame(maxWidth: 50)
                            .scaleEffect(CGSize(width: 0.8, height: 0.8))
                        Spacer().frame(width: 10)
                    }
                    .font(.system(size: 14))
                }
                .listRowSeparator(.hidden)
                
                Spacer()
            }
            .padding(.horizontal, 16)
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
            viewModel.getOneThing { oneThing in
                guard let oneThing = oneThing else {
                    return
                }
                reloadData(oneThing)
            }
        }
    }
    
    func saveOneThing() {
        viewModel.saveOneThing(
            goal: goalText.text,
            isOnAlarm: isOnAlarm,
            alarmDate: alarmDate.toString(DateStyle.storeId.rawValue)
        )
    }
    
    func reloadData(_ oneThing: OneThing) {
        goalText.text = oneThing.goal
        alarmDate = oneThing.alarmDate.toDate() ?? Date()
        isOnAlarm = oneThing.isOnAlarm
    }
}

struct OneThingView_Previews: PreviewProvider {
    static var previews: some View {
        OneThingView()
    }
}
