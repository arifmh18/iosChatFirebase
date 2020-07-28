//
//  ListChatViewController.swift
//  Chat Firebase
//
//  Created by algostudio on 21/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import Firebase

class ListChatViewController: UIViewController {

    var ref: DatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        getData()
    }
    
    func getData(){
        let userID = Auth.auth().currentUser?.uid
        ref.child("user").observeSingleEvent(of: .childAdded, with: { (snapshot) in
          // Get user value
            let value = snapshot.value as? [String: AnyObject] ?? [:]
//          let username = value?["username"] as? String ?? ""

            print(value)
          // ...
          }) { (error) in
            print(error.localizedDescription)
        }
    }
}
