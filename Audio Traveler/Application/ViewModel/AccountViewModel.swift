//
//  AccountViewModel.swift
//  Aduio Travelers
//
//  Created by Gafur on 17/9/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AccountViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var isLoading:Bool = false
    
    func createAccount(name:String, email:String,password:String,complete:@escaping (Bool) -> Void) {
        self.isLoading = true
        
        db.collection(Constansts.userBD)
            .whereField("email", isEqualTo: email.lowercased())
            .whereField("password", isEqualTo: password)
            .getDocuments { (querySnapshot, err) in
                if let error = err {
                    self.isLoading = false
                    print("Error getting user login: \(error)")
                }else {
                    if querySnapshot!.documents.count <= 0 {
                        let user = User(name: name, email: email.lowercased(), password: password)
                        let userRef = self.db.collection(Constansts.userBD)
                        do{
                            _ = try userRef.addDocument(from: user)
                            self.isLoading = false
                            complete(true)
                        }catch let error {
                            self.isLoading = false
                            print("Error writing User to Firestore: \(error)")
                            complete(false)
                        }
                    }else{
                        self.isLoading = false
                        /// User Exist or other error
                    }
                }
            }
    }
    
    func userLogin(email:String, password:String,complete:@escaping (Bool) -> Void) {
        self.isLoading = true
        db.collection(Constansts.userBD)
            .whereField("email", isEqualTo: email.lowercased())
            .whereField("password", isEqualTo: password)
            .getDocuments { (querySnapshot, err) in
                self.isLoading = false
                if let error = err {
                    print("Error getting user login: \(error)")
                    complete(false)
                }else {
                    if querySnapshot!.documents.count > 0 {
                        let userId = querySnapshot!.documents[0].data()["id"]
                        Helper.setLoggedIn(to: true)
                        Helper.setUserID(userId as! String)
                        Helper.DebugPrint(userId as! String)
                        complete(true)
                    }else{
                        complete(false)
                    }
                }
            }
    }
}
