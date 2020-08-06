//
//  ListChatViewController.swift
//  Chat Firebase
//
//  Created by algostudio on 21/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ListChatViewController: UIViewController {

    var ref: DatabaseReference!
    var resultSearchController = UISearchController()
    var filteredTableData = [ListChatModel]()
    var dataAllUser = [ListChatModel]()
    var dataFriend = [ListChatModel]()
    var currentMailSafe = ""

    @IBOutlet weak var chat_list: UITableView!
    var currentEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOut))
        navigationItem.title = Auth.auth().currentUser?.email ?? ""
        
        ref = Database.database().reference()
        let cell = UINib(nibName: "ChatCell", bundle: nil)
        let cellAllUser = UINib(nibName: "AllUserCell", bundle: nil)
        
        chat_list.register(cell, forCellReuseIdentifier: "chatCell")
        chat_list.register(cellAllUser, forCellReuseIdentifier: "cellUser")

        let currentMail = Auth.auth().currentUser?.email ?? ""
        currentMailSafe = currentMail.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")

        getData()
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeThatFits(CGSize(width: CGFloat(self.view.frame.size.width - 50), height: 50.0))
            controller.dimsBackgroundDuringPresentation = false
            self.chat_list.tableHeaderView = controller.searchBar

            return controller
        })()

    }
    
    @objc func logOut() {
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
        
            let allControllers = NSMutableArray(array: self.navigationController!.viewControllers)
            allControllers.removeObject(at: allControllers.count - 2)
            self.navigationController!.setViewControllers(allControllers as [AnyObject] as! [UIViewController], animated: false)
        }
        let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.navigationController!.pushViewController(vc, animated: true)

    }
    
    func getData(){
        ref.child("users").observe(.value) { (snapshot) in
            var listData = [ListChatModel]()
            for child in snapshot.children {
                let dataSnapshop = child as? DataSnapshot
                let dataCore = dataSnapshop?.value as? [String:Any]
                
                let nama = dataCore?["nameFull"] as? String ?? ""
                let avatar = dataCore?["avatar"] as? String ?? ""
                let email = dataCore?["email"] as? String ?? ""
                let currentEmail = Auth.auth().currentUser?.email ?? ""
                let user = ListChatModel(nama: nama, avatar: avatar, text: email, timestamp: "")
                if email == currentEmail { }
                else {
                    listData.append(user)
                }
                
            }
            self.dataAllUser = listData
//            self.dataFriend = listData
            self.chat_list.reloadData()
        }
        
        ref.child("roomFriend/\(currentMailSafe)").observe(.value) { (snapshot) in
            var listData = [ListChatModel]()
            for child in snapshot.children {
                let dataSnapshop = child as? DataSnapshot
                let dataCore = dataSnapshop?.value as? [String:Any]
                
                let nama = dataCore?["nameFull"] as? String ?? ""
                let avatar = dataCore?["avatar"] as? String ?? ""
                let email = dataCore?["email"] as? String ?? ""
                let currentEmail = Auth.auth().currentUser?.email ?? ""
                let user = ListChatModel(nama: nama, avatar: avatar, text: email, timestamp: "")
                if email == currentEmail { }
                else {
                    listData.append(user)
                }
                
            }
            self.dataFriend = listData
            self.chat_list.reloadData()
        }

        chat_list.delegate = self
        chat_list.dataSource = self
        DispatchQueue.main.async {
            self.chat_list.reloadData()
        }
    }
}

extension ListChatViewController : UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, AllUserDelegate {
    func reqFriendlist(data: ListChatModel) {
        let mail = data.text.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
        ref.child("roomFriend/\(currentMailSafe)/\(mail)").setValue([
            "nameFull":data.nama,
            "streetAddress":data.timestamp,
            "email":data.text,
            "avatar":data.avatar
        ])
        chat_list.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)

        var temp : [ListChatModel] = []
//        for i in 0 ..< product.count{
//            if (product[i].name?.lowercased().contains(searchController.searchBar.text!.lowercased()) ?? false) {
//                temp.append(product[i])
//            }
//        }
        self.filteredTableData = temp
        self.chat_list.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.isActive {
            return self.dataAllUser.count
        } else {
            return self.dataFriend.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (resultSearchController.isActive) {
            let data = self.dataAllUser[indexPath.item]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellUser", for: indexPath) as! AllUserCell
            cell.setData(data: data)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
            let data = self.dataFriend[indexPath.item]
            cell.setData(data: data)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (resultSearchController.isActive) {
            resultSearchController.isActive = false
            let data = self.dataAllUser[indexPath.item]
            let email = data.text.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
            let storyboard = UIStoryboard(name: "MainChat", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "detailChat") as! DetailChatController
            vc.email = email
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let data = self.dataFriend[indexPath.item]
            let email = data.text.replacingOccurrences(of: ".", with: "-").replacingOccurrences(of: "@", with: "-")
            let storyboard = UIStoryboard(name: "MainChat", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "detailChat") as! DetailChatController
            vc.email = email
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
