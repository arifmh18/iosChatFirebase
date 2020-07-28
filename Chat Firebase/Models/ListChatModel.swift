//
//  ListChatModel.swift
//  Chat Firebase
//
//  Created by Muhammad Arif Hidayatulloh on 28/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import Foundation

class ListChatModel{
    var id : String
    var content : String
    var sender : String
    var text : String
    var timestamp : String
    
    init(id:String, content:String, sender:String, text:String, timestamp:String) {
        self.id = id
        self.content = content
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
    }
}
