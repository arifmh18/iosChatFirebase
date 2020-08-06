//
//  DatabaseManagement.swift
//  Chat Firebase
//
//  Created by algostudio on 21/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManagement{
    static let shared = DatabaseManagement()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

extension DatabaseManagement{
    public func userExists(with email:String, completion: @escaping((Bool) -> Void) ){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child("users/\(safeEmail)").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
            
        }
    }
    
    public func insertUser(with user: ChatUser){
        database.child("users/\(user.safeEmail)").setValue([
            "nameFull":user.namaLengkap,
            "streetAddress":user.streetAddress,
            "email":user.emailAddress,
            "avatar":user.avatar
        ])
    }
}
struct ChatUser {
    let namaLengkap: String
    let emailAddress: String
    let avatar : String
    let streetAddress: String
    
    var safeEmail: String{
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String {
        //afraz9-gmail-com_profile_picture.png
        return "\(safeEmail)_profile_picture.png"
    }
}
