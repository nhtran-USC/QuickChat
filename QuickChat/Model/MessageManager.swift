//
//  MessageManager.swift
//  QuickChat
//
//  Created by Nguyen Tran on 7/14/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class MessageManager {
    static let shared = MessageManager()
    var messages:[Message]
    var numberOfMessage:Int
    
    private init() {
        messages = [Message]()
        numberOfMessage = messages.count
    }
    
    func loadMessages(_ closure: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("messages").order(by: "date").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.data())")
                    if let body = document.data()["body"] as? String,
                       let sender = document.data()["sender"] as? String
                       
                    {
                        let newMess = Message(sender: sender, message: body)
                        MessageManager.shared.messages.append(newMess)
                        MessageManager.shared.numberOfMessage = MessageManager.shared.messages.count
                    }
                }
            }
            
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    func addListenerToMessage(_ closure: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("messages").order(by: "date").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            let latestDoc = documents.last!
            if let body = latestDoc.data()["body"] as? String,
               let sender = latestDoc.data()["sender"] as? String

            {
                let newMess = Message(sender: sender, message: body)
                MessageManager.shared.messages.append(newMess)
                MessageManager.shared.numberOfMessage = MessageManager.shared.messages.count
            }
//            print("doc from listener: \(documents.last!.data())")
            
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    func sendMessages(body: String, sender: String) {
        // Add a new document with a generated id.
        var ref:DocumentReference? = nil
        ref = Firestore.firestore().collection("messages").addDocument(data: [
            "body": body,
            "sender": sender,
            "date": NSDate().timeIntervalSince1970
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
