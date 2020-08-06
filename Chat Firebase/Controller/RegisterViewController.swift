//
//  RegisterViewController.swift
//  Chat Firebase
//
//  Created by algostudio on 21/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerNamaLengkap: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerAlamat: UITextField!
    @IBOutlet weak var registerAvatar: UIImageView!
    
    @IBOutlet weak var registerDaftar: UIButton!
    
    var dataImage : UIImage? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Register"
        
        registerDaftar.addTarget(self, action: #selector(register), for: .touchUpInside)
        let tapAvatar = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        self.registerAvatar.addGestureRecognizer(tapAvatar)
    }
    
    @objc func pickImage(){
        ImagePickerManager().pickImage(self) { (image) in
            self.registerAvatar.image = image
            self.dataImage = image
        }
    }
    
    @objc func register(){
        guard let name = registerNamaLengkap.text,
            let email = registerEmail.text,
            let password = registerPassword.text,
            let address = registerAlamat.text,
            !name.isEmpty,
            !password.isEmpty,
            !email.isEmpty,
            !address.isEmpty,
            password.count >= 6
        else {
            alertError()
            return
        }
        
        DatabaseManagement.shared.userExists(with: email) { (exists) in
            guard !exists else {
                self.alertError(message: "Email sudah terpakai")
                return
            }

             Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                guard let result = authResult, error == nil else {
                    print("Error Create User")
                    return
                }
                
                guard let data = self.dataImage?.jpegData(compressionQuality: 0.5) else { return }
                
                let storageRef = Storage.storage().reference()
                let dbRef = Database.database().reference()
                
                let riversRef = storageRef.child("users/\(self.randomString(length: 15)).jpg")

                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                
                riversRef.putData(data, metadata: metaData) { (metadata, error) in
                    guard let metadata = metadata else {
                        return
                    }
                    riversRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        DatabaseManagement.shared.insertUser(with: ChatUser(
                            namaLengkap: name,
                            emailAddress: email, avatar: "\(downloadURL)",
                            streetAddress: address))
                        
                        let storyboard = UIStoryboard(name: "MainChat", bundle: nil)
                        let deadlineTime = DispatchTime.now() + .seconds(1)
                        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        
                            let allControllers = NSMutableArray(array: self.navigationController!.viewControllers)
                            allControllers.removeObject(at: allControllers.count - 3)
                            self.navigationController!.setViewControllers(allControllers as [AnyObject] as! [UIViewController], animated: false)
                        }
                        let vc = storyboard.instantiateViewController(withIdentifier: "listChat") as! ListChatViewController
                        self.navigationController!.pushViewController(vc, animated: true)

                        
                    }
                }
            }

        }
        
    }
    
    func alertError(message:String = "Silahkan Isi Formulir dengan benar"){
        let alert = UIAlertController(title: "Maaf", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    

}
