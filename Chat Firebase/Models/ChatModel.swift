//
//  ChatModel.swift
//  Chat Firebase
//
//  Created by algostudio on 22/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import Foundation

class ChatModel {
    var email : String
    var text : String
    var timestamp : Double
    
    init(email:String, text:String, timestamp:Double) {
        self.email = email
        self.text = text
        self.timestamp = timestamp
    }
}
