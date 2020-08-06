//
//  ListChatModel.swift
//  Chat Firebase
//
//  Created by Muhammad Arif Hidayatulloh on 28/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import Foundation

class ListChatModel{
    var nama : String
    var avatar : String
    var text : String
    var timestamp : String
    
    init(nama:String, avatar:String, text:String, timestamp:String) {
        self.nama = nama
        self.avatar = avatar
        self.text = text
        self.timestamp = timestamp
    }
}
