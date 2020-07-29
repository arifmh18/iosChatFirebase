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
        ListChatModel(id: "1", content: "Content1", sender: "Ruang Percakapan", text: "Silahkan Masuk Untuk Diskusi", timestamp: "10 menit yang lalu")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        getData()
    }
    
    func getData(){
        let cell = UINib(nibName: "ChatCell", bundle: nil)
        
        chat_list.register(cell, forCellReuseIdentifier: "chatCell")
                
        ref.child("posts").observe(.value) { (snapshot) in
            for child in snapshot.children {
                print("print \(child)")
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "MainChat", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "detailChat") as! DetailChatController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
