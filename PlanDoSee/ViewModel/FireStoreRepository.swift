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
                } catch {
                    print("FireStore get decode Error: \(error.localizedDescription)")
                }
            }
            
            success(tasks)
        }
    }
}
