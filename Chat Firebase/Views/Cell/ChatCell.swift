//
//  ChatCell.swift
//  Chat Firebase
//
//  Created by algostudio on 22/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import Kingfisher

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
    
    func setData(data: ListChatModel){
        let thumb = URL(string: data.avatar)
        
        self.cell_userName.text = data.nama
        self.cell_lastMessage.text = data.text
        self.cell_imageAvatar.kf.setImage(with: thumb)
    }
}
