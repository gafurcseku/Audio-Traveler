//
//  NotificationViewModel.swift
//  Audio Traveler
//
//  Created by Gafur on 29/9/21.
//

import Foundation
import Firebase
import FirebaseFirestore


class NotificationViewModel : ObservableObject {
    @Published var isLoading:Bool = false
    private let db = Firestore.firestore()
    @Published var notificationList:[Notification] = []
    @Published var emptyNotification:Bool = false
   
    
    func getAllNotification(){
        isLoading = true
        db.collection(Constansts.NOTIFICATION)
            .getDocuments { (querySnapshot, err) in
                if let error = err {
                    self.isLoading = false
                    print("Error getting Notification: \(error)")
                }else{
                    var list = [Notification]()
                    
                    for document in querySnapshot!.documents {
                        let Object = Result {
                            try document.data(as: Notification.self)
                        }
                        
                        switch Object {
                        case .success(let NotiList):
                            if var noti = NotiList {
                                print("Notification Model: \(noti)")
                                noti.documentId = document.documentID
                                list.append(noti)
                            }
                        case .failure(let error):
                            print("Error decoding Notification model: \(error)")
                        }
                    }
                    self.isLoading = false
                    if(list.isEmpty)
                    {
                        self.emptyNotification = true
                    }else{
                        self.notificationList = list
                    }
                    
                }
            }
    }
    
    func UpdateNotficationStatus(documentId:String){
        db.collection(Constansts.NOTIFICATION).document(documentId)
            .updateData(["status":true])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
            
        }
        
        
    }
    
    
    func getNotificationCount(complete:@escaping (Int) -> Void){
        db.collection(Constansts.NOTIFICATION)
            .whereField("status", isEqualTo: false)
            .getDocuments { (querySnapshot, err) in
                if let error = err {
                    self.isLoading = false
                    print("Error getting Notification: \(error)")
                }else{
                    complete(querySnapshot?.documents.count ?? 0)
                }
            }
    }
    
}
