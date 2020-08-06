//
//  ChatTableCell.swift
//  Chat Firebase
//
//  Created by algostudio on 04/08/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit

class ChatTableCell: UITableViewCell {

    @IBOutlet weak var cellContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:ChatModel){
        self.cellContent.text = data.text ?? ""
    }
}
