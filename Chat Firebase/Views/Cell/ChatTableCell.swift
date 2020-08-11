//
//  ChatTableCell.swift
//  Chat Firebase
//
//  Created by algostudio on 04/08/20.
//  Copyright © 2020 algostudio. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit
import GoogleMaps

class ChatTableCell: UITableViewCell {

    @IBOutlet weak var cellContent: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellHeightImage: NSLayoutConstraint!
    @IBOutlet weak var cellMapkit: MKMapView!
    var lng = 0.0
    var lat = 0.0
    
    @IBOutlet weak var cellMapView: GMSMapView!
    
    fileprivate let locationManager: CLLocationManager = {
           let manager = CLLocationManager()
           manager.requestWhenInUseAuthorization()
           return manager
        }()
    
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
            self.cellMapkit.isHidden = true
            self.cellMapView.isHidden = true
            self.cellHeightImage.constant = countHeightText(text: data.text, width: Int(self.cellContent.frame.size.width), height: 0) + 16
        } else if data.type == "attchment"{
            self.cellContent.isHidden = true
            self.cellImage.isHidden = false
            self.cellMapkit.isHidden = true
            self.cellMapView.isHidden = true
            let thumb = URL(string: data.text)
            self.cellImage.isHidden = false
            self.cellImage.kf.setImage(with: thumb)
            self.cellHeightImage.constant = self.cellImage.frame.size.width
        } else {
            let location = data.text
            let locArr = location.split{$0 == " "}.map(String.init)
            lat = Double(locArr[0]) ?? 0.0
            lng = Double(locArr[1]) ?? 0.0

            // Creates a marker in the center of the map.
            cellMapView.mapType = .normal
            cellMapView.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            marker.isDraggable = false
            marker.map = cellMapView

            self.cellContent.isHidden = true
            self.cellImage.isHidden = true
            self.cellMapkit.isHidden = true
            self.cellMapView.isHidden = false
            cellMapkit.showsUserLocation = true
            cellMapkit.showsCompass = true
            cellMapkit.showsScale = true
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
