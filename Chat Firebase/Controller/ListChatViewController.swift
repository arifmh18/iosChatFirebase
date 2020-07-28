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

    @IBOutlet weak var chat_list: UITableView!
    var dataChat = [
        ListChatModel(id: "1", content: "Content1", sender: "sender1", text: "text content 1", timestamp: "10 menit yang lalu"),
        ListChatModel(id: "2", content: "Content2", sender: "sender2", text: "text content 2", timestamp: "12 menit yang lalu"),
        ListChatModel(id: "3", content: "Content3", sender: "sender3", text: "text content 3", timestamp: "13 menit yang lalu"),
        ListChatModel(id: "4", content: "Content4", sender: "sender4", text: "text content 4", timestamp: "14 menit yang lalu")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        getData()
    }
    
    func getData(){
        let cell = UINib(nibName: "ChatCell", bundle: nil)
        
        chat_list.register(cell, forCellReuseIdentifier: "chatCell")
        
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
        
        chat_list.delegate = self
        chat_list.dataSource = self
        DispatchQueue.main.async {
            self.chat_list.reloadData()
        }
    }
}

extension ListChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.dataChat[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        cell.setData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
