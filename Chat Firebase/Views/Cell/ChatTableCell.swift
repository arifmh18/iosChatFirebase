//
//  ChatTableCell.swift
//  Chat Firebase
//
//  Created by algostudio on 04/08/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import Kingfisher

class ChatTableCell: UITableViewCell {

    @IBOutlet weak var cellContent: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellHeightImage: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:ChatModel){
        if data.type == "text" {
            self.cellContent.text = data.text
            self.cellImage.isHidden = true
            self.cellContent.isHidden = false
            self.cellHeightImage.constant = countHeightText(text: data.text, width: Int(self.cellContent.frame.size.width), height: 0) + 16
        } else {
            self.cellContent.isHidden = true
            self.cellImage.isHidden = false
            
            let thumb = URL(string: data.text)
            self.cellImage.isHidden = false
            self.cellImage.kf.setImage(with: thumb)
            self.cellHeightImage.constant = self.cellImage.frame.size.width
        }
    }
    
    func countHeightText(text:String, width:Int, height:Int) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.text = text
        label.font = UIFont(name: "Helvetica", size: 12.0)
        label.sizeToFit()
        return label.frame.height
    }
}
