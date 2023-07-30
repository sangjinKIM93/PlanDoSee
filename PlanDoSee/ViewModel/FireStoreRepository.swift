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
        do {
           try db.collection(userId).document("plan")
                .collection(date).document(task.id.uuidString)
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
        db.collection(userId).document("plan")
            .collection(date).document(task.id.uuidString)
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
        success: @escaping (([Task]) -> Void)
    ) {
        let docRef = db.collection(userId).document("plan")
            .collection(date)
        var tasks: [Task] = []
        
        docRef.getDocuments { querySnapshot, error in
            guard error == nil else {
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
        date: String,
        see: String,
        userId: String
    ) {
        db.collection(userId).document("see")
            .collection(date).document(date)
            .setData(["data": see])
            { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
    }
    
    func getSee(
        date: String,
        userId: String,
        success: @escaping ((String) -> Void)
    ) {
        let docRef = db.collection(userId).document("see")
            .collection(date)
        
        docRef.getDocuments { querySnapshot, error in
            guard error == nil else {
                print("Error getting documents: \(error?.localizedDescription)")
                return
            }
            if let document = querySnapshot?.documents.first,
               let seeData = document["data"] as? String {
                success(seeData)
            }
        }
    }
}
