//
//  RegisterViewController.swift
//  Chat Firebase
//
//  Created by algostudio on 21/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var registerNamaLengkap: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerAlamat: UITextField!
    
    @IBOutlet weak var registerDaftar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Register"
        
        registerDaftar.addTarget(self, action: #selector(register), for: .touchUpInside)
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
                
                DatabaseManagement.shared.insertUser(with: ChatUser(
                    namaLengkap: name,
                    emailAddress: email,
                    streetAddress: address))
                
                self.navigationController?.popViewController(animated: true)
            }

        }
        
    }
    
    func alertError(message:String = "Silahkan Isi Formulir dengan benar"){
        let alert = UIAlertController(title: "Maaf", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
