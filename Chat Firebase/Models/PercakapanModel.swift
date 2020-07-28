//
//  PercakapanModel.swift
//  Chat Firebase
//
//  Created by algostudio on 22/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import Foundation

struct Percakapan {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: PesanTerakhir
}

struct PesanTerakhir {
    let date: String
    let text: String
    let isRead: Bool
}
