//
//  OneThingViewModel.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/09/28.
//

import Foundation
import SwiftUI

class OneThingViewModel: ObservableObject {
    let realmRepository = RealmRepository<OneThing>()
    let firebaseRepository = FireStoreRepository.shared
    
    @AppStorage("user_id") var userId = ""
    
    func saveOneThing(goal: String, isOnAlarm: Bool, alarmDate: String) {
        let oneThing = OneThing(goal: goal,
                                isOnAlarm: isOnAlarm,
                                alarmDate: alarmDate)
        
        if let prevOneThing = getOneThingRealm() {
            realmRepository.delete(item: prevOneThing)
        }
        realmRepository.add(item: oneThing)
        
        // 네트워크 저장
        firebaseRepository.saveOneThing(oneThing: oneThing, userId: userId)
    }
    
    func getOneThing(completion: @escaping (OneThing?) -> Void) {
        self.getOneThingAPI { oneThing in
            completion(oneThing)
        } failure: { [weak self] in
            guard let self = self,
                  let oneThing = self.getOneThingRealm() else {
                completion(nil)
                return
            }
            completion(oneThing)
        }
    }
    
    func getOneThingRealm() -> OneThing? {
        return realmRepository.getItem().first
    }
    
    func getOneThingAPI(
        success: @escaping (OneThing) -> Void,
        failure: @escaping () -> Void
    ) {
        firebaseRepository.getOneThing(
            userId: userId,
            success: { oneThing in
                success(oneThing)
            }, failure: {
                failure()
            }
        )
    }
}
