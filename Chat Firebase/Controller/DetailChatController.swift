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
import FirebaseStorage
import CoreLocation
import GoogleMaps

class DetailChatController: UIViewController {

    @IBOutlet weak var detailChat_contentChat: UITextField!
    @IBOutlet weak var detailChat_list: UITableView!
    @IBOutlet weak var detailChat_indicator: UIActivityIndicatorView!
    @IBOutlet weak var detailChat_attachment: UIButton!
    @IBOutlet weak var detailChat_location: UIButton!
    
    var dataChat = [ChatModel]()
    var email = ""
    var currentEmail = ""
    var currentEmailRaw = ""
    var idRoom = ""
    var ref: DatabaseReference!
    var storageRef : StorageReference!
    var locationManager = CLLocationManager()
    var lat = 0.0
    var lng = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = email
        
        self.detailChat_indicator.isHidden = true
        self.currentEmailRaw = Auth.auth().currentUser?.email ?? ""
        self.currentEmail = currentEmailRaw.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        // Do any additional setup after loading the view.
        let cell = UINib(nibName: "ChatTableCell", bundle: nil)
        let cellSend = UINib(nibName: "ChatTableSendCell", bundle: nil)
        GMSServices.provideAPIKey("AIzaSyCI6L1ff2BdRRiO_-ghFiYKX-58iOGD2Bk")
        
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        detailChat_list.register(cell, forCellReuseIdentifier: "cellTable")
        detailChat_list.register(cellSend, forCellReuseIdentifier: "cellTableSend")
        detailChat_attachment.addTarget(self, action: #selector(getImage), for: .touchUpInside)
        detailChat_list.delegate = self
        detailChat_list.dataSource = self

        getData()
        
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
           lat = currentLoc.coordinate.latitude
           lng = currentLoc.coordinate.longitude
        }
    }
    
    @objc func getImage(){
        ImagePickerManager().pickImage(self) { (image) in
            self.detailChat_indicator.isHidden = true
            let pathImage = self.storageRef.child("chat/\(self.randomString(length: 20)).jpg")
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            guard let data = image.jpegData(compressionQuality: 0.5) else { return }
            
            pathImage.putData(data, metadata: metaData) { (metaData, error) in
                guard let metadata = metaData else {
                    return
                }
                pathImage.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    let email = Auth.auth().currentUser?.email ?? ""
                    let postObject = [
                        "email":email,
                        "text": "\(downloadURL)",
                        "type":"attchment",
                        "timestamp": [".sv":"timestamp"]
                        ] as [String:Any]
                    self.ref.child("Percakapan/\(self.idRoom)").childByAutoId().setValue(postObject)
                    self.detailChat_indicator.isHidden = true
                }
            }
        }
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
                let type = dataCore?["type"] as! String
                let timeStamp = dataCore?["timestamp"] as! Double
                let chat = ChatModel(email: email, text: text, type: type, timestamp: timeStamp)
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
            "type":"text",
            "timestamp": [".sv":"timestamp"]
            ] as [String:Any]
        ref.child("Percakapan/\(self.idRoom)").childByAutoId().setValue(postObject)
        detailChat_contentChat.text = ""
    }
    
    @IBAction func sendLocation(_ sender: Any) {
        let email = Auth.auth().currentUser?.email ?? ""
        let postObject = [
            "email":email,
            "text": "\(lat) \(lng)",
            "type":"location",
            "timestamp": [".sv":"timestamp"]
            ] as [String:Any]
        ref.child("Percakapan/\(self.idRoom)").childByAutoId().setValue(postObject)
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
