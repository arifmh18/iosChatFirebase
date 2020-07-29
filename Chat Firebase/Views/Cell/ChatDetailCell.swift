//
//  ChatDetailCell.swift
//  Chat Firebase
//
//  Created by Muhammad Arif Hidayatulloh on 29/07/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit

class ChatDetailCell: UICollectionViewCell {

    @IBOutlet weak var chat_username: UILabel!
    @IBOutlet weak var chat_text: UILabel!
    @IBOutlet weak var chat_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data: ChatModel){
        self.chat_username.text = data.email
        self.chat_text.text = data.text
        
        if let timeResult = (data.timestamp as? Double) {
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
            self.chat_time.text = localDate
        }
    }
}
