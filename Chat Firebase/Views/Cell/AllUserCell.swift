//
//  AllUserCell.swift
//  Chat Firebase
//
//  Created by Muhammad Arif Hidayatulloh on 06/08/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseDatabase

protocol AllUserDelegate : AnyObject{
    func reqFriendlist(data: ListChatModel)
}

class AllUserCell: UITableViewCell {

    @IBOutlet weak var allUser_image: UIImageView!
    @IBOutlet weak var allUser_name: UILabel!
    @IBOutlet weak var allUser_email: UILabel!
    @IBOutlet weak var allUser_add: UIButton!
    
    var dataUser : ListChatModel? = nil
    var currentEmail = ""
    var emailSafe = ""
    var ref : DatabaseReference!
    
    weak var delegate : AllUserDelegate? = nil
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(data: ListChatModel){
        let thumb = URL(string: data.avatar)
        
        let email = data.text
        currentEmail = Auth.auth().currentUser?.email ?? ""
        allUser_name.text = data.nama
        allUser_email.text = email
        allUser_image.kf.setImage(with: thumb)
        
        let emailCurrentSafe = safeMail(mail: currentEmail)
        emailSafe = safeMail(mail: email)
        
        ref = Database.database().reference()
        let path = ref.child("roomFriend")
        let pathFriend = "\(emailCurrentSafe)/\(emailSafe)"
        print("\(emailCurrentSafe)/\(emailSafe)")
        path.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(pathFriend){
                self.allUser_add.isHidden = true
                self.allUser_add.isEnabled = false
            } else {
                self.allUser_add.isHidden = false
                self.allUser_add.isEnabled = true
            }
        }
        self.allUser_add.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
    }
    
    @objc func addFriend(){
        ref.child("users").observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.childSnapshot(forPath: self.emailSafe)
            let avatar = data.childSnapshot(forPath: "avatar").value as? String ?? ""
            let email = data.childSnapshot(forPath: "email").value as? String ?? ""
            let nameFull = data.childSnapshot(forPath: "nameFull").value as? String ?? ""
            let streetAddress = data.childSnapshot(forPath: "streetAddress").value as? String ?? ""
            let user = ListChatModel(nama: nameFull, avatar: avatar, text: email, timestamp: streetAddress)
            print(user)
            self.dataUser = user
            self.delegate?.reqFriendlist(data: self.dataUser!)
        }
    }
    
    func safeMail(mail:String) -> String {
        var safeEmail = mail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
