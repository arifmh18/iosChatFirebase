//
//  DetailChatController.swift
//  Chat Firebase
//
//  Created by Muhammad Arif Hidayatulloh on 29/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import Firebase

class DetailChatController: UIViewController {

    @IBOutlet weak var detailChat_list: UICollectionView!
    @IBOutlet weak var detailChat_contentChat: UITextField!
    
    var dataChat = [ChatModel]()
    var email = ""
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.email = Auth.auth().currentUser?.email ?? ""
        // Do any additional setup after loading the view.
        let cell = UINib(nibName: "ChatDetailCell", bundle: nil)
        let cellSend = UINib(nibName: "ChatDetailSendCell", bundle: nil)
        
        ref = Database.database().reference()
        
        detailChat_list.register(cell, forCellWithReuseIdentifier: "cellReceived")
        detailChat_list.register(cellSend, forCellWithReuseIdentifier: "cellSend")
        detailChat_list.delegate = self
        detailChat_list.dataSource = self

        getData()
    }
    
    func getData(){
        let postsRef = ref.child("ruangChat")
        
        dataChat = []
        postsRef.observe(.value, with: { (snapshot) in
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
            self.updateCollectionContentInset()
            self.scrollToBottom()
        })
    }
    
    func updateCollectionContentInset() {
        let contentSize = self.detailChat_list.collectionViewLayout.collectionViewContentSize
        var contentInsetTop = self.detailChat_list.bounds.size.height

            contentInsetTop -= contentSize.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
        }
        self.detailChat_list.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
    func scrollToBottom() {

        guard !dataChat.isEmpty else { return }

        let lastIndex = dataChat.count - 1

        self.detailChat_list.scrollToItem(at: IndexPath(item: lastIndex, section: 0), at: .centeredVertically, animated: true)

    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let text = detailChat_contentChat.text ?? ""
        let email = Auth.auth().currentUser?.email ?? ""
        let postObject = [
            "email":email,
            "text": text,
            "timestamp": [".sv":"timestamp"]
            ] as [String:Any]
        ref.child("ruangChat").childByAutoId().setValue(postObject)
        detailChat_contentChat.text = ""
    }
}

extension DetailChatController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataChat.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = self.dataChat[indexPath.item]
        if data.email == self.email {
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
