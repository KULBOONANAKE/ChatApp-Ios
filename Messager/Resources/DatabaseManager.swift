//
//  DatabaseManager.swift
//  Messager
//
//  Created by Kul Boonanake on 19/2/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://messengerkul-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    
}

//MARK: - Account ManageMent

extension DatabaseManager {
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void) ){
        
        var selfEmail = email.replacingOccurrences(of: ".", with: "-")
        selfEmail = selfEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(selfEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// inserts new user to database
    public func insertUser(with user: ChatAppUser){
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
        ])
    }
}


struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    //    let profilePictureUrl: String
}
