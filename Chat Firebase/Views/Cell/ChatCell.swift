//
//  ChatCell.swift
//  Chat Firebase
//
//  Created by algostudio on 22/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var cell_imageAvatar: UIImageView!
    @IBOutlet weak var cell_userName: UILabel!
    @IBOutlet weak var cell_lastMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
