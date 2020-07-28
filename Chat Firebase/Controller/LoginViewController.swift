//
//  LoginViewController.swift
//  Chat Firebase
//
//  Created by algostudio on 20/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginMasuk: UIButton!
    
    @IBOutlet weak var loginSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(register))
        // Do any additional setup after loading the view.
        
        loginMasuk.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "MainChat", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "listChat") as! ListChatViewController
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func login(){
        guard let mail = loginEmail.text,
            let password = loginPassword.text,
            !mail.isEmpty,
            !password.isEmpty else {
                alertError()
            return
        }
        
        Auth.auth().signIn(withEmail: mail, password: password) { (authResult, error) in
            guard let result = authResult, error == nil else {
                print("Login Error")
                return
            }
            
            let user = result.user
            print("Berhasil Login Dengan User \(user)")
        }
    }
    
    func alertError(){
        let alert = UIAlertController(title: "Maaf", message: "Silahkan Isi Semua Dengan Benar", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        present(alert, animated: true)
    }

    @objc func register(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "register") as! RegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}
