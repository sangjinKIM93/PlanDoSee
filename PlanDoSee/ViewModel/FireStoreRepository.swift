//
//  FireStoreRepository.swift
//  PlanDoSee
//
//  Created by 김상진 on 2023/06/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FireStoreRepository {
    static let shared = FireStoreRepository()
    
    let db = Firestore.firestore()
    
    private init() {}
    
    // PLAN
    func saveTodo(
        date: String,
        task: Task,
        userId: String
    ) {
        guard !userId.isEmpty else {
            return
        }
        do {
           try db.collection(userId).document("plan")
                .collection(date).document(task.timeStamp)
                .setData(from: task) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        } catch {
            print("FireStore Save Error: \(error.localizedDescription)")
        }

    }
    
    func deleteTodo(
        date: String,
        task: Task,
        userId: String
    ) {
        guard !userId.isEmpty else {
            return
        }
        db.collection(userId).document("plan")
            .collection(date).document(task.timeStamp)
            .delete() { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully deleted!")
                }
            }
    }
    
    func getTodo(
        date: String,
        userId: String,
        success: @escaping (([Task]) -> Void),
        failure: @escaping (() -> Void)
    ) {
        guard !userId.isEmpty else {
            return
        }
        let docRef = db.collection(userId).document("plan")
            .collection(date)
        var tasks: [Task] = []
        
        docRef.getDocuments { querySnapshot, error in
            guard error == nil else {
                failure()
                print("Error getting documents: \(error?.localizedDescription)")
                return 
            }
            for document in querySnapshot!.documents {
                do {
                    let task: Task = try Task.decode(dictionary: document.data())
                    tasks.append(task)
                    print("Get Todo")
                } catch {
                    print("FireStore get decode Error: \(error.localizedDescription)")
                }
            }
            
            success(tasks)
        }
    }
    
    // DO
    func saveTimeline(
        date: String,
        timeLine: TimeLine,
        userId: String
    ) {
        guard !userId.isEmpty else {
            return
        }
        do {
            try db.collection(userId).document("do")
                .collection(date).document(timeLine.hour)
                .setData(from: timeLine) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
        } catch {
            print("FireStore Save Error: \(error.localizedDescription)")
        }
    }
    
    func getTiemline(
        date: String,
        userId: String,
        success: @escaping (([TimeLine]) -> Void)
    ) {
        guard !userId.isEmpty else {
            return
        }
        let docRef = db.collection(userId).document("do")
            .collection(date)
        var timelines: [TimeLine] = []
        
        docRef.getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            for document in querySnapshot!.documents {
                do {
                    let timeLine: TimeLine = try TimeLine.decode(dictionary: document.data())
                    timelines.append(timeLine)
                    print("Get Timeline")
                } catch {
                    print("FireStore get decode Error: \(error.localizedDescription)")
                }
            }
            
            success(timelines)
        }
    }
    
    // SEE
    func saveSee(
        week: String,
        seeModel: SeeModel,
        userId: String
    ) {
        guard !userId.isEmpty else {
            return
        }
        do {
            try db.collection(userId).document("see")
                .collection(week).document(seeModel.date)
                .setData(from: seeModel)
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        } catch {
            print("FireStore Save Error: \(error.localizedDescription)")
        }
    }
    
    func getSee(
        week: String,
        date: String,
        userId: String,
        success: @escaping (([SeeModel]) -> Void),
        failure: @escaping (() -> Void)
    ) {
        guard !userId.isEmpty else {
            return
        }
        let docRef = db.collection(userId).document("see")
            .collection(week)
        var seeModels: [SeeModel] = []
        
        docRef.getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error?.localizedDescription)")
                failure()
                return
            }
            for document in querySnapshot!.documents {
                do {
                    let seeModel: SeeModel = try SeeModel.decode(dictionary: document.data())
                    seeModels.append(seeModel)
                    print("Get SeeModel")
                } catch {
                    print("FireStore get decode Error: \(error.localizedDescription)")
                }
            }
            
            success(seeModels)
        }
    }
    
    // Evaluation
    func saveEvaluation(
        startDayOfWeek: String,
        date: String,
        evaluation: String,
        userId: String,
        success: @escaping (() -> Void)
    ) {
        guard !userId.isEmpty else {
            return
        }
        db.collection(userId).document("evaluation")
            .collection(startDayOfWeek).document(date)
            .setData(["data" : evaluation])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    success()
                }
            }
    }
    
    func getEvaluation(
        startDayOfWeek: String,
        userId: String,
        success: @escaping (([String: String]) -> Void)
    ) {
        guard !userId.isEmpty else {
            return
        }
        let docRef = db.collection(userId).document("evaluation")
            .collection(startDayOfWeek)
        
        docRef.getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            guard let querySnapshot = querySnapshot else {
                return
            }
            var dict = [String: String]()
            for document in querySnapshot.documents {
                if let evaluation = document["data"] as? String {
                    dict[document.documentID] = evaluation
                }
            }
            success(dict)
        }
    }
    
    // WeekSee
    func saveWeekSee(
        month: String,
        week: String,
        seeModel: SeeModel,
        userId: String
    ) {
        guard !userId.isEmpty else {
            return
        }
        do {
            try db.collection(userId).document("weeksee")
                .collection(month).document(week)
                .setData(from: seeModel)
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        } catch {
            print("FireStore Save Error: \(error.localizedDescription)")
        }
    }
    
    func getWeekSee(
        month: String,
        week: String,
        date: String,
        userId: String,
        success: @escaping (([SeeModel]) -> Void),
        failure: @escaping (() -> Void)
    ) {
        guard !userId.isEmpty else {
            return
        }
        let docRef = db.collection(userId).document("weeksee")
            .collection(month)
        var seeModels: [SeeModel] = []
        
        docRef.getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error?.localizedDescription)")
                failure()
                return
            }
            for document in querySnapshot!.documents {
                do {
                    let seeModel: SeeModel = try SeeModel.decode(dictionary: document.data())
                    seeModels.append(seeModel)
                    print("Get WeekSeeModel")
                } catch {
                    print("FireStore get decode Error: \(error.localizedDescription)")
                }
            }
            
            success(seeModels)
        }
    }
    
    // OneThing
    func saveOneThing(
        oneThing: OneThing,
        userId: String
    ) {
        guard !userId.isEmpty else {
            return
        }
        do {
            try db.collection(userId).document("onething")
                .setData(from: oneThing)
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        } catch {
            print("FireStore Save Error: \(error.localizedDescription)")
        }
    }
    
    func getOneThing(
        userId: String,
        success: @escaping ((OneThing) -> Void),
        failure: @escaping (() -> Void)
    ) {
        guard !userId.isEmpty else {
            return
        }
        let docRef = db.collection(userId).document("onething")
        
        docRef.getDocument { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error?.localizedDescription)")
                failure()
                return
            }
            guard let data = querySnapshot?.data() else {
                failure()
                return
            }
            
            do {
                let oneThing: OneThing = try OneThing.decode(dictionary: data)
                success(oneThing)
                print("Get OneThing")
            } catch {
                print("FireStore get decode Error: \(error.localizedDescription)")
                failure()
            }
            
            
        }
    }
}
