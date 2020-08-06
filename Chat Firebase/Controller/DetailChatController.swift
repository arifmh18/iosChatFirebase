//
//  DetailChatController.swift
//  Chat Firebase
//
//  Created by Muhammad Arif Hidayatulloh on 29/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class DetailChatController: UIViewController {

    @IBOutlet weak var detailChat_contentChat: UITextField!
    @IBOutlet weak var detailChat_list: UITableView!
    
    var dataChat = [ChatModel]()
    var email = ""
    var currentEmail = ""
    var currentEmailRaw = ""
    var idRoom = ""
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = email
        
        self.currentEmailRaw = Auth.auth().currentUser?.email ?? ""
        print(currentEmailRaw)
        self.currentEmail = currentEmailRaw.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        // Do any additional setup after loading the view.
        let cell = UINib(nibName: "ChatTableCell", bundle: nil)
        let cellSend = UINib(nibName: "ChatTableSendCell", bundle: nil)
        
        ref = Database.database().reference()
        
        detailChat_list.register(cell, forCellReuseIdentifier: "cellTable")
        detailChat_list.register(cellSend, forCellReuseIdentifier: "cellTableSend")
        detailChat_list.delegate = self
        detailChat_list.dataSource = self

        getData()
    }
    
    func getData(){
        
        ref.child("ListChat").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild("\(self.currentEmail)/\(self.email)"){
                let data = snapshot.childSnapshot(forPath: "\(self.currentEmail)/\(self.email)")
                self.idRoom = data.childSnapshot(forPath: "idRoomChat").value as? String ?? ""
                self.loadDataChat(id: self.idRoom)
            } else {
                let postObject = [
                    "idRoomChat":self.randomString(length: 15),
                    "timestamp": [".sv":"timestamp"]
                    ] as [String:Any]
                self.ref.child("ListChat/\(self.currentEmail)/\(self.email)").setValue(postObject)
                self.ref.child("ListChat/\(self.email)/\(self.currentEmail)").setValue(postObject)
            }
        }
    }
    
    func loadDataChat(id:String){
        let chatRef = ref.child("Percakapan/\(id)")
        chatRef.observe(.value, with: { (snapshot) in
            var chatData = [ChatModel]()
            for child in snapshot.children {
                let dataSnapshop = child as? DataSnapshot
                let dataCore = dataSnapshop?.value as? [String:Any]
                let email = dataCore?["email"] as! String
                let text = dataCore?["text"] as! String
                let timeStamp = dataCore?["timestamp"] as! Double
                let chat = ChatModel(email: email, text: text, timestamp: timeStamp)
                chatData.append(chat)
            }
            self.dataChat = chatData
            self.detailChat_list.reloadData()
            self.scrollToBottom()
        })
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func scrollToBottom() {

        guard !dataChat.isEmpty else { return }

        let lastIndex = dataChat.count - 1

        let indexPath = NSIndexPath(item: lastIndex, section: 0)
        detailChat_list.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)

    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let text = detailChat_contentChat.text ?? ""
        let email = Auth.auth().currentUser?.email ?? ""
        let postObject = [
            "email":email,
            "text": text,
            "timestamp": [".sv":"timestamp"]
            ] as [String:Any]
        ref.child("Percakapan/\(self.idRoom)").childByAutoId().setValue(postObject)
        detailChat_contentChat.text = ""
    }
}

extension DetailChatController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.dataChat[indexPath.item]
        if data.email == self.currentEmailRaw {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTableSend", for: indexPath) as! ChatTableCell
            cell.setData(data: data)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTable", for: indexPath) as! ChatTableCell
            cell.setData(data: data)
            return cell
        }
    }
    
}
extension DetailChatController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataChat.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = self.dataChat[indexPath.item]
        if data.email == self.currentEmailRaw {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellSend", for: indexPath) as! ChatDetailCell
            cell.setData(data: data)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellReceived", for: indexPath) as! ChatDetailCell
            cell.setData(data: data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 12, height: 100)
    }
}
