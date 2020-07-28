//
//  ProfileModel.swift
//  Chat Firebase
//
//  Created by algostudio on 22/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import Foundation

enum ProfileModelType{
    case info, logout
}

struct ProfileModel {
    let viewModelType :ProfileModelType
    let title : String
    let handler: (() -> Void)?
}
