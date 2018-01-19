//
//  PlaylistCell.swift
//  FlickTunes
//
//  Created by Shuhei Hasegawa on 2017/08/21.
//  Copyright © 2017年 Shuhei Hasegawa. All rights reserved.
//

import UIKit

class PlaylistCell: UITableViewCell {

    @IBOutlet var artworkImage1: UIImageView!
    @IBOutlet var artworkImage2: UIImageView!
    @IBOutlet var artworkImage3: UIImageView!
    @IBOutlet var artworkImage4: UIImageView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        artworkImage1.layer.cornerRadius = 10.0
        artworkImage2.layer.cornerRadius = 10.0
        artworkImage3.layer.cornerRadius = 10.0
        artworkImage4.layer.cornerRadius = 10.0
    }

    func configureWithData(_ data: NSDictionary) {
        if let post = data["post"] as? NSDictionary, let user = post["user"] as? NSDictionary {
            mainLabel.text = user["name"] as? String
            artworkImage1.image = UIImage(named: mainLabel.text!.replacingOccurrences(of: " ", with: "_"))
        }
    }

    func changeStylToBlack() {
        artworkImage1?.layer.cornerRadius = 30.0
        artworkImage2?.layer.cornerRadius = 30.0
        artworkImage3?.layer.cornerRadius = 30.0
        artworkImage4?.layer.cornerRadius = 30.0
        
        mainLabel.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
        mainLabel.textColor = .white
        backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
    }
}
